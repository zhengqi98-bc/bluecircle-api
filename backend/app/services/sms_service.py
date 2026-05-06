"""SMS notification service (placeholder)."""


async def send_sms(
    phone_numbers: list[str],
    message: str,
) -> dict:
    """Send SMS notifications.

    NOTE: This is a placeholder. In production, integrate with an SMS gateway:
      - Twilio: https://www.twilio.com/docs/sms
      - Alibaba Cloud SMS: https://www.alibabacloud.com/product/sms
      - Tencent Cloud SMS: https://cloud.tencent.com/product/sms
      - Or local provider API

    Args:
        phone_numbers: List of phone numbers (E.164 format recommended)
        message: SMS text (max 160 chars for single message, 70 for Unicode)

    Returns:
        dict: {success: bool, error: str|None}
    """
    if not phone_numbers:
        return {"success": False, "error": "No phone numbers"}

    # TODO: Integrate with actual SMS gateway
    # Example with Twilio:
    #   from twilio.rest import Client
    #   client = Client(account_sid, auth_token)
    #   for number in phone_numbers:
    #       client.messages.create(body=message, from_='+1234567890', to=number)

    return {
        "success": False,
        "error": "SMS gateway not configured. Set SMS_PROVIDER and credentials in .env",
    }
