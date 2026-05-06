"""Reports API router — /api/v1/reports"""

from typing import Optional
from fastapi import APIRouter, Depends, Query, HTTPException
from fastapi.responses import HTMLResponse, StreamingResponse
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
import io
import zipfile

from app.database import get_db
from app.models.report import Report
from app.models.user import User
from app.schemas.report import ReportCreate, ReportOut, ReportListOut
from app.auth.dependencies import require_user, get_current_user
from app.services.report_generator import generate_report
from app.services.export_service import get_export, EXPORT_FORMATS, EXPORT_TYPES

router = APIRouter(prefix="/reports", tags=["Reports"])


@router.get("/", response_model=ReportListOut)
async def list_reports(
    report_type: Optional[str] = Query(None, description="Filter by type"),
    turtle_id: Optional[str] = Query(None),
    status: Optional[str] = Query(None),
    limit: int = Query(20, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
    user: User = Depends(require_user),
):
    """List user's reports with optional filters."""
    query = select(Report).where(Report.created_by == user.id)

    if report_type:
        query = query.where(Report.report_type == report_type)
    if turtle_id:
        query = query.where(Report.turtle_id == turtle_id)
    if status:
        query = query.where(Report.status == status)

    # Count
    count_q = select(func.count()).select_from(query.subquery())
    total = (await db.execute(count_q)).scalar() or 0

    # Paginate
    query = query.order_by(Report.created_at.desc()).offset(offset).limit(limit)
    result = await db.execute(query)
    reports = result.scalars().all()

    return ReportListOut(
        items=[ReportOut.model_validate(r) for r in reports],
        total=total,
    )


@router.post("/", response_model=ReportOut, status_code=201)
async def create_report(
    body: ReportCreate,
    db: AsyncSession = Depends(get_db),
    user: User = Depends(require_user),
):
    """Generate a new report."""
    report = Report(
        title=body.title,
        report_type=body.report_type,
        turtle_id=body.turtle_id,
        params=body.params,
        status="generating",
        created_by=user.id,
    )
    db.add(report)
    await db.flush()

    # Generate content
    report = await generate_report(db, report)
    await db.flush()
    await db.refresh(report)

    return ReportOut.model_validate(report)


@router.get("/{report_id}", response_model=ReportOut)
async def get_report(
    report_id: str,
    db: AsyncSession = Depends(get_db),
):
    """Get a single report by ID (public read)."""
    report = await db.get(Report, report_id)
    if not report:
        raise HTTPException(status_code=404, detail="Report not found")
    return ReportOut.model_validate(report)


@router.get("/{report_id}/download")
async def download_report(
    report_id: str,
    format: str = Query("html", description="html | csv | pdf"),
    db: AsyncSession = Depends(get_db),
    user: User = Depends(require_user),
):
    """Download report in requested format."""
    report = await db.get(Report, report_id)
    if not report:
        raise HTTPException(status_code=404, detail="Report not found")
    if report.status != "completed":
        raise HTTPException(status_code=400, detail="Report not yet completed")

    if format == "html":
        return HTMLResponse(content=report.html_content)

    try:
        content, content_type, filename = await get_export(
            db, "report", format, report_html=report.html_content
        )
        return StreamingResponse(
            io.BytesIO(content),
            media_type=content_type,
            headers={"Content-Disposition": f'attachment; filename="{filename}"'}
        )
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.delete("/{report_id}", status_code=204)
async def delete_report(
    report_id: str,
    db: AsyncSession = Depends(get_db),
    user: User = Depends(require_user),
):
    """Delete a report (owner only)."""
    report = await db.get(Report, report_id)
    if not report:
        raise HTTPException(status_code=404, detail="Report not found")
    if report.created_by != user.id:
        raise HTTPException(status_code=403, detail="Not your report")
    await db.delete(report)
    await db.flush()


# ── Data Export Endpoints ────────────────────────────────────────────

@router.get("/export/tracks")
async def export_tracks(
    format: str = Query("csv", description="csv | excel"),
    turtle_id: Optional[str] = Query(None),
    db: AsyncSession = Depends(get_db),
    user: User = Depends(require_user),
):
    """Export track points as CSV or Excel."""
    if format not in ("csv", "excel"):
        raise HTTPException(status_code=400, detail=f"Format must be csv or excel, got '{format}'")

    try:
        content, content_type, filename = await get_export(db, "tracks", format, turtle_id=turtle_id)
        return StreamingResponse(
            io.BytesIO(content),
            media_type=content_type,
            headers={"Content-Disposition": f'attachment; filename="{filename}"'}
        )
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/export/turtles")
async def export_turtles(
    format: str = Query("csv"),
    db: AsyncSession = Depends(get_db),
    user: User = Depends(require_user),
):
    """Export turtle registry as CSV."""
    if format != "csv":
        raise HTTPException(status_code=400, detail="Turtles export only supports CSV")

    content, content_type, filename = await get_export(db, "turtles", "csv")
    return StreamingResponse(
        io.BytesIO(content),
        media_type=content_type,
        headers={"Content-Disposition": f'attachment; filename="{filename}"'}
    )


@router.get("/export/alerts")
async def export_alerts(
    format: str = Query("csv"),
    db: AsyncSession = Depends(get_db),
    user: User = Depends(require_user),
):
    """Export alerts as CSV."""
    if format != "csv":
        raise HTTPException(status_code=400, detail="Alerts export only supports CSV")

    content, content_type, filename = await get_export(db, "alerts", "csv")
    return StreamingResponse(
        io.BytesIO(content),
        media_type=content_type,
        headers={"Content-Disposition": f'attachment; filename="{filename}"'}
    )


@router.post("/export/batch")
async def batch_download(
    report_ids: list[str],
    format: str = Query("html", description="html | pdf"),
    db: AsyncSession = Depends(get_db),
    user: User = Depends(require_user),
):
    """Batch download multiple reports as ZIP file."""
    if not report_ids:
        raise HTTPException(status_code=400, detail="No report IDs provided")
    if len(report_ids) > 20:
        raise HTTPException(status_code=400, detail="Maximum 20 reports per batch")

    zip_buf = io.BytesIO()
    with zipfile.ZipFile(zip_buf, "w", zipfile.ZIP_DEFLATED) as zf:
        for rid in report_ids:
            report = await db.get(Report, rid)
            if not report:
                continue
            if report.status != "completed":
                continue

            if format == "html":
                zf.writestr(f"{rid}.html", report.html_content)
            elif format == "pdf":
                try:
                    content, _, _ = await get_export(db, "report", "pdf", report_html=report.html_content)
                    zf.writestr(f"{rid}.pdf", content)
                except Exception:
                    continue

    zip_buf.seek(0)
    return StreamingResponse(
        zip_buf,
        media_type="application/zip",
        headers={
            "Content-Disposition": 'attachment; filename="bluecircle_reports_batch.zip"'
        }
    )
