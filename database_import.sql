--
-- PostgreSQL database dump
--


-- Dumped from database version 15.17
-- Dumped by pg_dump version 15.17

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: bluecircle
--

-- *not* creating schema, since initdb creates it



--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: bluecircle
--



SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alerts; Type: TABLE; Schema: public; Owner: bluecircle
--

CREATE TABLE public.alerts (
    id integer NOT NULL,
    turtle_id character varying(20),
    alert_type character varying(30) NOT NULL,
    severity character varying(10) NOT NULL,
    title text NOT NULL,
    description text,
    lat numeric(9,6),
    lng numeric(9,6),
    metadata jsonb,
    status character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    resolved_at timestamp with time zone
);



--
-- Name: alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: bluecircle
--

CREATE SEQUENCE public.alerts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bluecircle
--

ALTER SEQUENCE public.alerts_id_seq OWNED BY public.alerts.id;


--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: bluecircle
--

CREATE TABLE public.api_keys (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    key_hash character varying(64) NOT NULL,
    name character varying(100),
    rate_limit integer NOT NULL,
    is_active boolean NOT NULL,
    last_used_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);



--
-- Name: dataset_files; Type: TABLE; Schema: public; Owner: bluecircle
--

CREATE TABLE public.dataset_files (
    id integer NOT NULL,
    dataset_id integer NOT NULL,
    filename character varying(255) NOT NULL,
    file_path text NOT NULL,
    file_size_bytes bigint,
    format character varying(10),
    download_count integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);



--
-- Name: dataset_files_id_seq; Type: SEQUENCE; Schema: public; Owner: bluecircle
--

CREATE SEQUENCE public.dataset_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: dataset_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bluecircle
--

ALTER SEQUENCE public.dataset_files_id_seq OWNED BY public.dataset_files.id;


--
-- Name: datasets; Type: TABLE; Schema: public; Owner: bluecircle
--

CREATE TABLE public.datasets (
    id integer NOT NULL,
    name character varying(300) NOT NULL,
    subtitle character varying(500),
    species character varying(100),
    region character varying(200),
    period character varying(100),
    data_scope character varying(100),
    formats character varying[],
    category character varying(30),
    doi character varying(100),
    is_published boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);



--
-- Name: datasets_id_seq; Type: SEQUENCE; Schema: public; Owner: bluecircle
--

CREATE SEQUENCE public.datasets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bluecircle
--

ALTER SEQUENCE public.datasets_id_seq OWNED BY public.datasets.id;


--
-- Name: hardware_applications; Type: TABLE; Schema: public; Owner: bluecircle
--

CREATE TABLE public.hardware_applications (
    id integer NOT NULL,
    applicant_name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    institution character varying(255) NOT NULL,
    phone character varying(30),
    project_title character varying(255) NOT NULL,
    project_description text DEFAULT ''::text NOT NULL,
    target_species character varying(100) NOT NULL,
    target_count integer DEFAULT 1 NOT NULL,
    region character varying(255) DEFAULT ''::character varying NOT NULL,
    latitude numeric(9,6),
    longitude numeric(9,6),
    device_type character varying(50) DEFAULT 'gps_tag'::character varying NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    start_date character varying(10),
    end_date character varying(10),
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    reviewer_id uuid,
    reviewer_notes text,
    tracking_number character varying(100),
    shipped_at timestamp with time zone,
    expected_return character varying(10),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);



--
-- Name: hardware_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: bluecircle
--

CREATE SEQUENCE public.hardware_applications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: hardware_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bluecircle
--

ALTER SEQUENCE public.hardware_applications_id_seq OWNED BY public.hardware_applications.id;


--
-- Name: notification_logs; Type: TABLE; Schema: public; Owner: bluecircle
--

CREATE TABLE public.notification_logs (
    id integer NOT NULL,
    rule_id integer,
    alert_id integer,
    channel character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'sent'::character varying NOT NULL,
    recipient character varying(255) NOT NULL,
    subject character varying(255),
    error_message text,
    sent_at timestamp with time zone DEFAULT now()
);



--
-- Name: notification_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: bluecircle
--

CREATE SEQUENCE public.notification_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: notification_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bluecircle
--

ALTER SEQUENCE public.notification_logs_id_seq OWNED BY public.notification_logs.id;


--
-- Name: notification_rules; Type: TABLE; Schema: public; Owner: bluecircle
--

CREATE TABLE public.notification_rules (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    alert_types jsonb,
    severity_min character varying(10) DEFAULT 'medium'::character varying NOT NULL,
    turtle_id character varying(20),
    email_enabled boolean DEFAULT false,
    email_recipients jsonb,
    webhook_enabled boolean DEFAULT false,
    webhook_url character varying(500),
    webhook_secret character varying(100),
    sms_enabled boolean DEFAULT false,
    sms_recipients jsonb,
    is_active boolean DEFAULT true,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: notification_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: bluecircle
--

CREATE SEQUENCE public.notification_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: notification_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bluecircle
--

ALTER SEQUENCE public.notification_rules_id_seq OWNED BY public.notification_rules.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: bluecircle
--

CREATE TABLE public.reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(255) NOT NULL,
    report_type character varying(30) NOT NULL,
    turtle_id character varying(20),
    params jsonb,
    status character varying(20) DEFAULT 'completed'::character varying NOT NULL,
    html_content text DEFAULT ''::text NOT NULL,
    file_path character varying(500),
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone
);



--
-- Name: track_points; Type: TABLE; Schema: public; Owner: bluecircle
--

CREATE TABLE public.track_points (
    "time" timestamp with time zone NOT NULL,
    turtle_id character varying(20) NOT NULL,
    lat numeric(9,6) NOT NULL,
    lng numeric(9,6) NOT NULL,
    battery_pct numeric(4,1),
    speed_kmh numeric(5,2),
    depth_m numeric(5,1),
    temperature_c numeric(4,1),
    source character varying(20) NOT NULL
);



--
-- Name: trial_applications; Type: TABLE; Schema: public; Owner: bluecircle
--

CREATE TABLE public.trial_applications (
    id integer NOT NULL,
    user_id uuid,
    institution character varying(255) NOT NULL,
    contact_name character varying(100),
    contact_email character varying(255) NOT NULL,
    contact_phone character varying(50),
    target_species character varying(100),
    preferred_device character varying(100),
    quantity integer NOT NULL,
    duration_months integer NOT NULL,
    project_brief text,
    status character varying(20) NOT NULL,
    reviewer_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);



--
-- Name: trial_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: bluecircle
--

CREATE SEQUENCE public.trial_applications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: trial_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bluecircle
--

ALTER SEQUENCE public.trial_applications_id_seq OWNED BY public.trial_applications.id;


--
-- Name: turtles; Type: TABLE; Schema: public; Owner: bluecircle
--

CREATE TABLE public.turtles (
    id character varying(20) NOT NULL,
    name character varying(100) NOT NULL,
    name_en character varying(100),
    species character varying(50) NOT NULL,
    species_en character varying(50),
    sex character varying(1),
    age_class character varying(20),
    origin character varying(200),
    origin_en character varying(200),
    carapace_length_cm numeric(5,1),
    photo_url text,
    device_id character varying(50),
    last_lat numeric(9,6),
    last_lng numeric(9,6),
    last_battery_pct numeric(4,1),
    last_speed_kmh numeric(5,2),
    last_depth_m numeric(5,1),
    last_seen_at timestamp with time zone,
    is_active boolean NOT NULL,
    risk_level character varying(10),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);



--
-- Name: users; Type: TABLE; Schema: public; Owner: bluecircle
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    institution character varying(255),
    role character varying(20) NOT NULL,
    is_active boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_approved boolean DEFAULT false
);



--
-- Name: alerts id; Type: DEFAULT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.alerts ALTER COLUMN id SET DEFAULT nextval('public.alerts_id_seq'::regclass);


--
-- Name: dataset_files id; Type: DEFAULT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.dataset_files ALTER COLUMN id SET DEFAULT nextval('public.dataset_files_id_seq'::regclass);


--
-- Name: datasets id; Type: DEFAULT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.datasets ALTER COLUMN id SET DEFAULT nextval('public.datasets_id_seq'::regclass);


--
-- Name: hardware_applications id; Type: DEFAULT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.hardware_applications ALTER COLUMN id SET DEFAULT nextval('public.hardware_applications_id_seq'::regclass);


--
-- Name: notification_logs id; Type: DEFAULT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.notification_logs ALTER COLUMN id SET DEFAULT nextval('public.notification_logs_id_seq'::regclass);


--
-- Name: notification_rules id; Type: DEFAULT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.notification_rules ALTER COLUMN id SET DEFAULT nextval('public.notification_rules_id_seq'::regclass);


--
-- Name: trial_applications id; Type: DEFAULT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.trial_applications ALTER COLUMN id SET DEFAULT nextval('public.trial_applications_id_seq'::regclass);


--
-- Data for Name: alerts; Type: TABLE DATA; Schema: public; Owner: bluecircle
--

COPY public.alerts (id, turtle_id, alert_type, severity, title, description, lat, lng, metadata, status, created_at, resolved_at) FROM stdin;
1	BC-XS-2401	fishing	high	Illegal fishing detected near Luna	\N	16.970000	112.320000	null	open	2026-05-03 23:16:06.515127+08	\N
2	BC-XS-2401	fishing	high	Test	\N	\N	\N	null	open	2026-05-03 23:20:44.803223+08	\N
3	BC-XS-2401	fishing	critical	Integration test alert	\N	16.970000	112.320000	null	resolved	2026-05-03 23:26:19.249811+08	2026-05-03 23:26:19.27496+08
4	BC-XS-2401	collision	high	Cross-phase test	\N	\N	\N	null	open	2026-05-03 23:26:19.610712+08	\N
5	BC-XS-2401	fishing	critical	Integration test alert	\N	16.970000	112.320000	null	resolved	2026-05-03 23:27:04.494938+08	2026-05-03 23:27:04.517493+08
6	BC-XS-2401	collision	high	Cross-phase test	\N	\N	\N	null	open	2026-05-03 23:27:04.846958+08	\N
7	BC-XS-2401	test	high	Audit alert	\N	\N	\N	null	resolved	2026-05-03 23:43:18.461561+08	2026-05-03 23:43:18.475642+08
8	BC-XS-2401	test	high	Audit alert	\N	\N	\N	null	resolved	2026-05-03 23:45:22.798597+08	2026-05-03 23:45:22.812236+08
9	BC-CD-2304	test	low	Audit alert	\N	\N	\N	null	resolved	2026-05-04 00:42:14.661115+08	2026-05-04 00:42:14.690446+08
10	BC-CD-2304	test	low	Audit alert	\N	\N	\N	null	resolved	2026-05-04 00:45:05.273994+08	2026-05-04 00:45:05.29185+08
11	BC-CD-2304	test	low	Audit alert	\N	\N	\N	null	resolved	2026-05-04 00:56:46.952233+08	2026-05-04 00:56:46.983292+08
12	BC-CD-2304	test	low	Audit alert	\N	\N	\N	null	resolved	2026-05-04 01:05:30.556222+08	2026-05-04 01:05:30.586097+08
13	BC-CD-2304	test	low	Audit alert	\N	\N	\N	null	resolved	2026-05-04 01:13:33.800121+08	2026-05-04 01:13:33.817093+08
14	BC-CD-2304	test	low	Audit alert	\N	\N	\N	null	resolved	2026-05-04 01:20:07.358311+08	2026-05-04 01:20:07.373866+08
15	BC-XS-2401	low_battery	high	电池电量低警告	海龟 Luna 设备电量仅剩 15%，请关注。	16.970000	112.320000	null	open	2026-05-04 03:28:15.871158+08	\N
16	BC-XS-2401	boundary	medium	越界警告: Luna	海龟 Luna（绿海龟）当前位置 (-16.97, 112.32) 超出已知栖息地范围。可能正在进行长距离迁徙或设备漂移，请核实。	-16.972017	112.324267	\N	open	2026-05-04 03:36:24.906634+08	\N
17	BC-PG-2307	offline	high	设备离线: Papua	海龟 Papua（棱皮龟）已离线 24 小时（超过 24h 阈值）。最后信号: 2026-05-03 10:00 UTC。	-3.500000	135.420000	\N	open	2026-05-04 18:00:02.388473+08	\N
18	BC-XS-2401	offline	high	设备离线: Luna	海龟 Luna（绿海龟）已离线 24 小时（超过 24h 阈值）。最后信号: 2026-05-03 12:30 UTC。	-16.972017	112.324267	\N	open	2026-05-04 20:30:02.445204+08	\N
19	BC-HN-2418	offline	high	设备离线: 文昌	海龟 文昌（绿海龟）已离线 24 小时（超过 24h 阈值）。最后信号: 2026-05-03 14:21 UTC。	19.850000	111.200000	\N	open	2026-05-04 22:30:02.29492+08	\N
20	BC-XS-2421	offline	high	设备离线: Pearl	海龟 Pearl（绿海龟）已离线 24 小时（超过 24h 阈值）。最后信号: 2026-05-03 14:21 UTC。	17.100000	112.450000	\N	open	2026-05-04 22:30:02.29492+08	\N
21	BC-PH-2425	offline	high	设备离线: Palawan	海龟 Palawan（绿海龟）已离线 24 小时（超过 24h 阈值）。最后信号: 2026-05-03 14:21 UTC。	10.320000	118.740000	\N	open	2026-05-04 22:30:02.29492+08	\N
22	BC-CD-2304	offline	high	设备离线: Côn Đảo	海龟 Côn Đảo（棱皮龟）已离线 24 小时（超过 24h 阈值）。最后信号: 2026-05-03 17:20 UTC。	17.500000	113.000000	\N	open	2026-05-05 01:30:01.972797+08	\N
23	BC-HD-2412	offline	high	设备离线: 惠东	海龟 惠东（绿海龟）已离线 24 小时（超过 24h 阈值）。最后信号: 2026-05-03 19:12 UTC。	22.550000	114.890000	\N	open	2026-05-05 03:15:02.679202+08	\N
24	BC-PH-2311	offline	high	设备离线: 望安	海龟 望安（绿海龟）已离线 24 小时（超过 24h 阈值）。最后信号: 2026-05-03 19:12 UTC。	23.370000	119.500000	\N	open	2026-05-05 03:15:02.679202+08	\N
25	BC-RY-2429	offline	high	设备离线: 琉球	海龟 琉球（绿海龟）已离线 24 小时（超过 24h 阈值）。最后信号: 2026-05-03 19:12 UTC。	24.510000	124.180000	\N	open	2026-05-05 03:15:02.679202+08	\N
26	BC-SB-2315	offline	high	设备离线: Selingan	海龟 Selingan（玳瑁）已离线 24 小时（超过 24h 阈值）。最后信号: 2026-05-03 19:12 UTC。	6.170000	118.040000	\N	open	2026-05-05 03:15:02.679202+08	\N
\.


--
-- Data for Name: api_keys; Type: TABLE DATA; Schema: public; Owner: bluecircle
--

COPY public.api_keys (id, user_id, key_hash, name, rate_limit, is_active, last_used_at, created_at) FROM stdin;
4bb58dd7-f6d1-4b75-8812-88cb25b73760	254a67d2-fb72-4e8a-8b1e-b85b6abf9ad3	a3a9829d3bab6cbada7ae878176f67453bb3df3b3b451e41b3d053efdf4b9b04	production-key	100	t	\N	2026-05-03 22:48:27.597854+08
625a7cb1-c3ed-44ad-aaad-b098744ce059	254a67d2-fb72-4e8a-8b1e-b85b6abf9ad3	1d1f326a6a57347b9966db6fe1f608392a565b9d654a72472905a738222f3a52	vps-test	100	t	\N	2026-05-03 22:52:51.736641+08
6910f108-569e-454c-872c-6d2e8ae05938	dcb1be46-706c-4fa8-82e2-30fb8704cf19	8ebdd56f0af2a3d19bbedf256cdad457d588039b9217ff6ecd29a468d809f6d0	audit-key-1	100	t	\N	2026-05-03 22:59:51.153386+08
fd083270-eca1-4db0-b9a5-a18a09c4b6a1	dcb1be46-706c-4fa8-82e2-30fb8704cf19	c1792dac72bc99e91e3d1365ea79a81e78dedf90ff26a31a2dad1b5bebd8f879	audit-key-2	50	f	\N	2026-05-03 22:59:51.160207+08
238afeaa-c949-4822-9723-6869e719c241	20bc171a-e381-4743-84e2-ebf01b06f89a	1ae778249f7cccdfb20aa16bc317eb1f11f319d2c68d7fd9edfbd6591c8fdd0b	audit-key-1	100	t	\N	2026-05-03 23:03:24.996078+08
59429240-8ea9-4f54-a686-532a9da4f29d	20bc171a-e381-4743-84e2-ebf01b06f89a	1656b6874e97c9f339c1eecb2c96558c95d6221dc84d9112ce26973b4eea29c6	audit-key-2	50	f	\N	2026-05-03 23:03:25.003313+08
f6506648-1785-49a8-b7f6-dfe85e039758	8d99d7d3-8b28-4a60-8f0c-668469b68d6b	95494b7d76682a874f97a63d00f22fca272d297099994cff212b28e1b0ff3419	audit-key-1	100	t	\N	2026-05-03 23:03:57.306429+08
54ee7e92-155f-4d89-9ed8-a416ff595572	8d99d7d3-8b28-4a60-8f0c-668469b68d6b	be3878fde58a6bc52a7ce69bddfb8bef04fefb99e8ae573e0a535a9b4dc96b99	audit-key-2	50	f	\N	2026-05-03 23:03:57.313772+08
f560ddff-b98f-4a61-a10c-fc843e0432db	0547d021-d923-47cf-a8a6-c103d097225d	cd6985f60d5a2ea27e286c7d7267dbddaa54bfa30cbaf4ad4227d6b16d89f8d6	full-test-key	100	f	\N	2026-05-03 23:26:18.890768+08
3fba7a91-4090-48f5-a917-d37332e0e2ad	1f688f79-d228-4a64-bd7e-7a749e4f7a03	ad2477079788efbbfcc059372a6c4fb95a687ce535d0e6fadb3833621d916f54	u3-key	100	t	\N	2026-05-03 23:26:19.916276+08
f9a37be6-3336-4f70-bb02-0363f5c0fb70	b3128ace-7961-4f44-947e-6004e829e406	20cd600bb8f5a9c8a5b5d769f5b735e67f8cc283a8dbc89ed1a789beb8c677c7	dbcheck	100	t	\N	2026-05-03 23:27:03.234811+08
261c3014-fe7c-4792-aed5-3646d73abde9	6bedf9df-20e5-4d3b-ad82-8226538639f9	6f07ac592ce7529f93fe3e210d6798ae2fe36c11a00ec589c89fd333d83bfdd5	full-test-key	100	f	\N	2026-05-03 23:27:04.150465+08
55263be1-342a-4a42-aa01-f811940871a4	4c3fbd4c-0eaf-4857-8af1-bd46766d233f	c3b8fa4fffb90b0c52a97a1f707103f86cfb43e0c761a391f69f78758547db07	u3-key	100	t	\N	2026-05-03 23:27:05.157676+08
311c0f7e-0dd1-4988-9e03-9cf303fbd8aa	2bc3a48d-aa1e-4802-b6b9-c62a1d70085e	69d8effcd7656faa8b243b172c045f46032400cc2c8c544618336a54725bcc7f	audit	100	f	\N	2026-05-03 23:43:18.131131+08
7d9ae88d-c7ce-464f-92cf-1ac79a5957ca	24804828-da4d-4f69-b6d1-2ea67245f3c8	4d26bc6e583ccbcbd39b31347dc205b1bc1428b468042922acded3577231be63	audit	100	f	\N	2026-05-03 23:45:22.46574+08
519b3893-3e73-47c9-a3d6-56af46bf6431	0d5a9a9b-05e9-490d-9277-32e875cad209	2b513823eb1dd3bbb65ba3286efbedfae0381f6d98954ce3deb54099e74e6ec8	audit-key	100	t	\N	2026-05-04 00:41:45.699222+08
36696ecf-e999-4caf-b222-611a5dd7fe87	64e3b750-ffef-468e-ba9f-510be74db15c	8ba7833418414d885e7a680f4991b09588adb721c0f792241e5303b8cfe125b4	audit-key	100	t	\N	2026-05-04 00:42:14.623562+08
3b956214-fe41-4023-be2c-a72dc2621ce7	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	d6874e202b21df9d91672198bb71a5aed641c1faac475cda03fc8044187b22e7	test-key2	100	t	\N	2026-05-04 00:44:41.442358+08
65cd6f58-de08-4732-bc1e-895d8084f38a	024e899b-c8cb-487e-95e0-fd2233d59b3b	1fae2038c8ce2aa84ac46e5627bab845ef19b6d5f6378972221ee4a053449d47	audit-key	100	t	\N	2026-05-04 00:45:05.150132+08
7a6e88e8-d187-4baa-844a-629c5ab40663	fc46d2d8-22a5-4135-a3ea-73654adc589e	319f426794dfffd51a145dcdbd4c9210f95a2ca237a4bae52177ca17e80aeaf5	audit-key	100	t	\N	2026-05-04 00:56:46.864587+08
90f8532c-f683-4fa7-821a-c4ac4a588d63	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	8bbfea083f66bf6b8e17351bad14e26f34e88e96ce49fa673a6a78ea324975c1	ingest-test	100	t	\N	2026-05-04 01:02:51.86374+08
5c4b85ec-a471-4cac-b88a-976facafbac8	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	d4402566adfec16a88cd1e7283f8485081c73e7daafeffb65548771a739c00b5	ingest2	100	t	\N	2026-05-04 01:04:05.592407+08
59469b3a-b94b-424d-873b-5b2ee3e046da	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	0e51bb9eb8836e8d5b0d9a2158883bfec151564c894d4003cb562478783640a9	ingest3	100	t	\N	2026-05-04 01:04:28.588874+08
f4fda8e0-e337-4a80-933c-122adfaee6fe	e89d9a77-a8b6-4b98-944e-fa82c082e3ad	a3aef29a7564611c1c7e039da68dfd575ebbbf4410a4f8055ad0cd958429b89a	audit-key	100	t	\N	2026-05-04 01:05:30.479357+08
635451eb-a9de-4fdc-b97c-3a823bc6bd0a	e89d9a77-a8b6-4b98-944e-fa82c082e3ad	684fe40e461712d17abcb0467d49b696c486546b46003584e4aa285abc4dc011	audit-ingest	100	t	\N	2026-05-04 01:05:32.455852+08
917786e9-199b-4946-89b3-9f72bc0ea2a4	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	52ce17140e3bd34566040d2c8acedb5f993eabdbf87c51254b30948fa418a101	ingest-debug	100	t	\N	2026-05-04 01:06:13.347689+08
83474d84-ce0f-4c50-a049-1744ba819ca7	2f1b9881-5529-4d85-ae81-ab856d6a5ede	f25481eb9a646f35de0c1c7c0851f73e6c5abeb426fad1075e7c26e0cb6bc1de	audit-key	100	t	\N	2026-05-04 01:13:33.734881+08
5fb9c05a-0bfd-41e3-ad46-52308dc42f40	2f1b9881-5529-4d85-ae81-ab856d6a5ede	0ef10d7b949e7f49141ca5c86e7cf12373d24d479bb8c005baa0d6978dd0c5ca	audit-ingest	100	t	\N	2026-05-04 01:13:35.558969+08
d8a5670b-7830-401a-857b-b6e03e5b0451	2f0b0b7f-9d19-49da-8062-899e870200bc	c62419c60885ecde6fea64673f60732a5ecabe43551ba14edcd2b86d9ac8d034	audit-key	100	t	\N	2026-05-04 01:20:07.297894+08
06212566-f7b9-455d-84b5-621862fe80f3	2f0b0b7f-9d19-49da-8062-899e870200bc	6e5a69bb0e26a998c6c05110df4235da9cddfb0e3aeae2c5f74c99ca40a78285	audit-ingest	100	t	\N	2026-05-04 01:20:09.333623+08
\.


--
-- Data for Name: dataset_files; Type: TABLE DATA; Schema: public; Owner: bluecircle
--

COPY public.dataset_files (id, dataset_id, filename, file_path, file_size_bytes, format, download_count, created_at) FROM stdin;
\.


--
-- Data for Name: datasets; Type: TABLE DATA; Schema: public; Owner: bluecircle
--

COPY public.datasets (id, name, subtitle, species, region, period, data_scope, formats, category, doi, is_published, created_at) FROM stdin;
1	🐢 Luna Migration Track 2026	BC-XS-2401 · 西沙—海南—西沙	绿海龟	南海	2025-10—今	187天·47k点	{CSV,GeoJSON}	track	\N	t	2026-05-03 22:21:53.055111+08
2	🌊 SCS Leatherback 2023	南海棱皮龟群体追踪	棱皮龟	南海	2023-01—12	365天·210k点	{CSV,NetCDF}	track	\N	t	2026-05-03 22:21:53.055111+08
3	🌡 SCS Temp × Turtle Behavior	南海水温与行为关联分析	绿海龟	南海	2022-03—2023-09	18月·520k点	{NetCDF,CSV}	env	\N	t	2026-05-03 22:21:53.055111+08
4	🚢 Vessel Collision Risk — SCS	南海船龟碰撞风险数据集	绿海龟	南海	2023-06—2024-06	12月·89k点	{GeoJSON}	env	\N	t	2026-05-03 22:21:53.055111+08
5	🌿 西沙海草床觅食模式	Xisha Seagrass Foraging Patterns	绿海龟	西沙、海南近海	2025-01—2025-08	8月·76k点	{CSV}	track	\N	t	2026-05-03 22:21:53.055111+08
6	📡 Multi-species SCS Nesting Survey	南海多物种筑巢海滩调查	多物种	南海沿岸	2021-05—2024-05	3年·1.2M点	{CSV,GeoJSON}	track	\N	t	2026-05-03 22:21:53.055111+08
7	🤖 AI Migration Model Training v3	AI 迁徙预测模型训练数据	多物种	全球	2019—2023	5年·8.4M点	{CSV,NetCDF}	track	\N	t	2026-05-03 22:21:53.055111+08
8	🌏 Indo-Pacific Leatherback Migration	西太平洋棱皮龟长距离迁徙	棱皮龟	西太平洋	2022-01—2024-06	30月·410k点	{CSV,NetCDF}	track	\N	t	2026-05-03 22:21:53.055111+08
9	🌙 SCS Night Diving Patterns	南海夜间潜水行为模式	绿海龟	南海	2023-03—2024-03	12月·230k点	{CSV,GeoJSON}	track	\N	t	2026-05-03 22:21:53.055111+08
10	🌊 SST × Chlorophyll SCS 2024	南海海表温度与叶绿素	多物种	南海	2024-01—12	12月·620k点	{NetCDF}	env	\N	t	2026-05-03 22:21:53.055111+08
11	🏝 Con Dao Nesting Beach Survey	昆岛筑巢海滩长期监测	棱皮龟	越南昆岛	2018—2024	7年·1.8M点	{CSV,GeoJSON}	track	\N	t	2026-05-03 22:21:53.055111+08
12	🌿 Seagrass Habitat Mapping	南海海草床栖息地制图	绿海龟	南海	2022-01—2023-12	24月·340k点	{GeoJSON,NetCDF}	env	\N	t	2026-05-03 22:21:53.055111+08
13	🛰 Sentinel-2 × Turtle Tracking	卫星遥感与海龟追踪关联	多物种	全球	2020—2024	5年·2.3M点	{NetCDF,GeoJSON}	env	\N	t	2026-05-03 22:21:53.055111+08
14	🔬 Genetic Diversity — Chelonia mydas	绿海龟种群遗传多样性	绿海龟	南海	2019—2023	5年·8.9k样本	{CSV}	track	\N	t	2026-05-03 22:21:53.055111+08
15	📍 SCS Foraging Hotspot Analysis	南海觅食热点区域分析	绿海龟	南海	2023-06—2024-06	12月·156k点	{GeoJSON}	track	\N	t	2026-05-03 22:21:53.055111+08
16	⚡ Bycatch Risk — Vietnam Coast	越南近海误捕风险评估	棱皮龟	越南近海	2022—2024	3年·42k点	{CSV,GeoJSON}	env	\N	t	2026-05-03 22:21:53.055111+08
17	🏖 Wang-an Island Hatch Success	望安岛孵化成功率监测	绿海龟	台湾澎湖	2020—2024	5年·3.2k巢	{CSV}	track	\N	t	2026-05-03 22:21:53.055111+08
18	🌪 Typhoon Impact on Migration	台风对海龟迁徙路线影响	多物种	西北太平洋	2018—2024	7年·890k点	{CSV,NetCDF}	env	\N	t	2026-05-03 22:21:53.055111+08
19	🐚 Hawksbill Sabah Coral Reef Use	玳瑁珊瑚礁利用模式	玳瑁	沙巴海域	2021—2024	4年·178k点	{GeoJSON,CSV}	track	\N	t	2026-05-03 22:21:53.055111+08
20	📈 Population Trend Model	南海海龟种群趋势模型	多物种	南海	2015—2025	11年·5.2M点	{CSV,NetCDF}	env	\N	t	2026-05-03 22:21:53.055111+08
21	🎣 Fishery Interaction — Palawan	巴拉望渔龟交互数据集	绿海龟	菲律宾	2022-05—2024-05	24月·67k点	{CSV}	track	\N	t	2026-05-03 22:21:53.055111+08
22	🌴 Xisha Rookery Phenology	西沙产卵场物候记录	绿海龟	西沙群岛	2016—2024	9年·12k巢	{CSV,GeoJSON}	track	\N	t	2026-05-03 22:21:53.055111+08
23	🔊 Acoustic Telemetry — Huidong	惠东声学遥测数据集	绿海龟	广东惠东	2023-01—2024-12	24月·94k点	{CSV}	track	\N	t	2026-05-03 22:21:53.055111+08
24	🌐 Ocean Currents × Turtle Drift	海流与幼龟漂移模拟	多物种	西太平洋	2019—2023	5年·1.4M点	{NetCDF,GeoJSON}	env	\N	t	2026-05-03 22:21:53.055111+08
\.


--
-- Data for Name: hardware_applications; Type: TABLE DATA; Schema: public; Owner: bluecircle
--

COPY public.hardware_applications (id, applicant_name, email, institution, phone, project_title, project_description, target_species, target_count, region, latitude, longitude, device_type, quantity, start_date, end_date, status, reviewer_id, reviewer_notes, tracking_number, shipped_at, expected_return, created_at, updated_at) FROM stdin;
1	张海洋	zhang@ocean.cn	海洋研究所	13800138000	南海绿海龟迁徙追踪	追踪南海绿海龟的迁徙路线，收集海洋环境数据。	绿海龟	5	南中国海	16.500000	112.000000	gps_tag	5	2026-06-01	2027-05-31	pending	\N	\N	\N	\N	\N	2026-05-04 00:29:38.231019+08	2026-05-04 00:29:38.231019+08
2	李保育	li@marine.org	海洋保育协会	\N	棱皮龟深度行为研究	研究棱皮龟潜水行为与水温关系	棱皮龟	3	东海	\N	\N	depth_sensor	3	\N	\N	pending	\N	\N	\N	\N	\N	2026-05-04 00:29:38.253666+08	2026-05-04 00:29:38.253666+08
4	公众测试	public@test.com	公民科学	\N	公众海龟观察	test	玳瑁	1	西沙群岛	\N	\N	satellite_tag	1	\N	\N	pending	\N	\N	\N	\N	\N	2026-05-04 00:29:39.146546+08	2026-05-04 00:29:39.146546+08
6	李保育	li@marine.org	海洋保育协会	\N	棱皮龟深度行为研究	研究棱皮龟潜水行为与水温关系	棱皮龟	3	东海	\N	\N	depth_sensor	3	\N	\N	pending	\N	\N	\N	\N	\N	2026-05-04 00:30:12.629712+08	2026-05-04 00:30:12.629712+08
5	张海洋	rpt@test.com	海洋研究所	13800138000	南海绿海龟迁徙追踪	更新：追踪南海绿海龟迁徙 + 产卵场定位	绿海龟	5	南中国海	16.500000	112.000000	gps_tag	6	2026-06-01	2027-05-31	pending	\N	\N	\N	\N	\N	2026-05-04 00:30:12.61518+08	2026-05-04 00:30:12.640074+08
8	公众测试	public@test.com	公民科学	\N	公众海龟观察	test	玳瑁	1	西沙群岛	\N	\N	satellite_tag	1	\N	\N	pending	\N	\N	\N	\N	\N	2026-05-04 00:30:13.233304+08	2026-05-04 00:30:13.233304+08
10	李保育	li@marine.org	海洋保育协会	\N	棱皮龟深度行为研究	研究棱皮龟潜水行为与水温关系	棱皮龟	3	东海	\N	\N	depth_sensor	3	\N	\N	pending	\N	\N	\N	\N	\N	2026-05-04 00:30:31.356924+08	2026-05-04 00:30:31.356924+08
9	张海洋	rpt@test.com	海洋研究所	13800138000	南海绿海龟迁徙追踪	更新：追踪南海绿海龟迁徙 + 产卵场定位	绿海龟	5	南中国海	16.500000	112.000000	gps_tag	6	2026-06-01	2027-05-31	pending	\N	\N	\N	\N	\N	2026-05-04 00:30:31.344673+08	2026-05-04 00:30:31.366698+08
20	Audit User	audit-p15-manseqcy@test.com	Audit Institute	\N	Audit Hardware Project	Updated audit description	Green Turtle	2	South China Sea	\N	\N	gps_tag	2	\N	\N	shipped	141ad63f-fca4-468c-81f6-0bc6cc9215da	Audit approved	AUDIT-SF-001	2026-05-04 00:56:48.86927+08	\N	2026-05-04 00:56:48.760189+08	2026-05-04 00:56:48.865527+08
11	张海洋	rpt@test.com	海洋研究所	13800138000	南海绿海龟迁徙追踪	更新：追踪南海绿海龟迁徙 + 产卵场定位	绿海龟	5	南中国海	16.500000	112.000000	gps_tag	6	2026-06-01	2027-05-31	shipped	141ad63f-fca4-468c-81f6-0bc6cc9215da	项目合理，批准GPS标签	SF1234567890	2026-05-04 00:30:57.599095+08	2027-06-01	2026-05-04 00:30:56.986412+08	2026-05-04 00:30:57.596674+08
12	李保育	li@marine.org	海洋保育协会	\N	棱皮龟深度行为研究	研究棱皮龟潜水行为与水温关系	棱皮龟	3	东海	\N	\N	depth_sensor	3	\N	\N	rejected	141ad63f-fca4-468c-81f6-0bc6cc9215da	信息不完整	\N	\N	\N	2026-05-04 00:30:56.999325+08	2026-05-04 00:30:57.60499+08
16	Audit User	audit-p15-fflcimgo@test.com	Audit Institute	\N	Audit Hardware Project	Updated audit description	Green Turtle	2	South China Sea	\N	\N	gps_tag	2	\N	\N	shipped	141ad63f-fca4-468c-81f6-0bc6cc9215da	Audit approved	AUDIT-SF-001	2026-05-04 00:42:16.618169+08	\N	2026-05-04 00:42:16.586332+08	2026-05-04 00:42:16.616658+08
15	Web Test	web@test.com	Web Institute	\N	Web Test	Testing	Turtle	1	Area	\N	\N	gps_tag	1	\N	\N	approved	141ad63f-fca4-468c-81f6-0bc6cc9215da	\N	\N	\N	\N	2026-05-04 00:36:55.112611+08	2026-05-04 22:11:00.369934+08
14	公众测试	public@test.com	公民科学	\N	公众海龟观察	test	玳瑁	1	西沙群岛	\N	\N	satellite_tag	1	\N	\N	approved	141ad63f-fca4-468c-81f6-0bc6cc9215da	\N	\N	\N	\N	2026-05-04 00:30:57.624216+08	2026-05-04 22:11:02.200568+08
18	Audit User	audit-p15-sdwihqmb@test.com	Audit Institute	\N	Audit Hardware Project	Updated audit description	Green Turtle	2	South China Sea	\N	\N	gps_tag	2	\N	\N	shipped	141ad63f-fca4-468c-81f6-0bc6cc9215da	Audit approved	AUDIT-SF-001	2026-05-04 00:45:07.300423+08	\N	2026-05-04 00:45:07.268402+08	2026-05-04 00:45:07.29906+08
22	Audit User	audit-p15-wlsimokq@test.com	Audit Institute	\N	Audit Hardware Project	Updated audit description	Green Turtle	2	South China Sea	\N	\N	gps_tag	2	\N	\N	shipped	141ad63f-fca4-468c-81f6-0bc6cc9215da	Audit approved	AUDIT-SF-001	2026-05-04 01:05:32.430597+08	\N	2026-05-04 01:05:32.378496+08	2026-05-04 01:05:32.428057+08
24	Audit User	audit-p15-wwdhiwha@test.com	Audit Institute	\N	Audit Hardware Project	Updated audit description	Green Turtle	2	South China Sea	\N	\N	gps_tag	2	\N	\N	shipped	141ad63f-fca4-468c-81f6-0bc6cc9215da	Audit approved	AUDIT-SF-001	2026-05-04 01:13:35.538969+08	\N	2026-05-04 01:13:35.509349+08	2026-05-04 01:13:35.537754+08
26	Audit User	audit-p15-czpwpzpi@test.com	Audit Institute	\N	Audit Hardware Project	Updated audit description	Green Turtle	2	South China Sea	\N	\N	gps_tag	2	\N	\N	shipped	141ad63f-fca4-468c-81f6-0bc6cc9215da	Audit approved	AUDIT-SF-001	2026-05-04 01:20:09.312923+08	\N	2026-05-04 01:20:09.282872+08	2026-05-04 01:20:09.311429+08
\.


--
-- Data for Name: notification_logs; Type: TABLE DATA; Schema: public; Owner: bluecircle
--

COPY public.notification_logs (id, rule_id, alert_id, channel, status, recipient, subject, error_message, sent_at) FROM stdin;
1	1	15	email	failed	researcher@example.com	电池电量低警告	[Errno 111] Connection refused	2026-05-04 03:28:15.881757+08
2	1	15	webhook	sent	https://httpbin.org/post	电池电量低警告	\N	2026-05-04 03:28:15.881757+08
\.


--
-- Data for Name: notification_rules; Type: TABLE DATA; Schema: public; Owner: bluecircle
--

COPY public.notification_rules (id, name, description, alert_types, severity_min, turtle_id, email_enabled, email_recipients, webhook_enabled, webhook_url, webhook_secret, sms_enabled, sms_recipients, is_active, created_by, created_at, updated_at) FROM stdin;
1	Test Rule	\N	["low_battery", "offline"]	medium	\N	t	["researcher@example.com"]	t	https://httpbin.org/post	\N	f	null	t	\N	2026-05-04 03:28:15.827326+08	2026-05-04 03:28:15.827326+08
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: bluecircle
--

COPY public.reports (id, title, report_type, turtle_id, params, status, html_content, file_path, created_by, created_at, completed_at) FROM stdin;
cfb688fc-4956-42d4-8dce-fc05959890a5	舰队总览2026Q2	fleet_overview	\N	null	failed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>Report Error — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>Report Error</h1>\n    <div class="sub"></div>\n  </div>\n  <div class="body">\n<p style="color:#f06060;">⚠ Generation failed: local variable 't' referenced before assignment</p>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:11 UTC\n  </div>\n</div>\n</body>\n</html>	\N	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	2026-05-04 00:11:08.470672+08	\N
f558c3e2-65ac-45f8-ac0f-2ab2084d6287	Activity: BC-CD-2304	turtle_activity	BC-CD-2304	null	failed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>Report Error — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>Report Error</h1>\n    <div class="sub"></div>\n  </div>\n  <div class="body">\n<p style="color:#f06060;">⚠ Generation failed: invalid format string</p>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:11 UTC\n  </div>\n</div>\n</body>\n</html>	\N	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	2026-05-04 00:11:08.502647+08	\N
a7c92525-fe54-4dac-8a02-58dfe0eae51a	舰队总览2026Q2	fleet_overview	\N	null	failed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>Report Error — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>Report Error</h1>\n    <div class="sub"></div>\n  </div>\n  <div class="body">\n<p style="color:#f06060;">⚠ Generation failed: local variable 't' referenced before assignment</p>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:14 UTC\n  </div>\n</div>\n</body>\n</html>	\N	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	2026-05-04 00:14:13.143746+08	\N
030dd7be-8de5-4c35-829b-757fb64ca25b	Activity: BC-CD-2304	turtle_activity	BC-CD-2304	null	failed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>Report Error — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>Report Error</h1>\n    <div class="sub"></div>\n  </div>\n  <div class="body">\n<p style="color:#f06060;">⚠ Generation failed: invalid format string</p>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:14 UTC\n  </div>\n</div>\n</body>\n</html>	\N	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	2026-05-04 00:14:13.160859+08	\N
814ada38-8fd2-487e-bba1-c125718e09d6	舰队总览2026Q2	fleet_overview	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>舰队总览报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>舰队总览报告</h1>\n    <div class="sub">共 10 只海龟 &middot; 3 个物种</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">海龟总数</div></div>\n  <div class="stat-card"><div class="value">10</div><div class="label">活跃海龟</div></div>\n  <div class="stat-card"><div class="value">3</div><div class="label">物种数</div></div>\n  <div class="stat-card"><div class="value">1,500</div><div class="label">轨迹总点数</div></div>\n  <div class="stat-card"><div class="value">8</div><div class="label">预警总数</div></div>\n  <div class="stat-card"><div class="value">4</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟舰队</h2>\n<table>\n  <tr><th>ID</th><th>名称</th><th>物种</th><th>性别</th><th>来源地</th><th>最后位置</th><th>电量</th><th>状态</th></tr>\n  <tr><td><strong>BC-CD-2304</strong></td><td>Côn Đảo</td><td>棱皮龟</td><td>F</td><td>越南昆岛</td><td>8.71, 106.61</td><td>62.0%</td><td>🟢</td></tr><tr><td><strong>BC-HD-2412</strong></td><td>惠东</td><td>绿海龟</td><td>F</td><td>广东惠东</td><td>22.55, 114.89</td><td>91.0%</td><td>🟢</td></tr><tr><td><strong>BC-HN-2418</strong></td><td>文昌</td><td>绿海龟</td><td>M</td><td>海南岛东岸</td><td>19.85, 111.20</td><td>77.0%</td><td>🟢</td></tr><tr><td><strong>BC-PG-2307</strong></td><td>Papua</td><td>棱皮龟</td><td>F</td><td>巴布亚</td><td>—</td><td>58.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2311</strong></td><td>望安</td><td>绿海龟</td><td>F</td><td>台湾澎湖望安岛</td><td>23.37, 119.50</td><td>71.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2425</strong></td><td>Palawan</td><td>绿海龟</td><td>F</td><td>菲律宾巴拉望</td><td>10.32, 118.74</td><td>65.0%</td><td>🟢</td></tr><tr><td><strong>BC-RY-2429</strong></td><td>琉球</td><td>绿海龟</td><td>F</td><td>琉球群岛</td><td>24.51, 124.18</td><td>79.0%</td><td>🟢</td></tr><tr><td><strong>BC-SB-2315</strong></td><td>Selingan</td><td>玳瑁</td><td>F</td><td>沙巴海龟群岛海洋公园</td><td>6.17, 118.04</td><td>43.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2401</strong></td><td>Luna</td><td>绿海龟</td><td>F</td><td>西沙七连屿北岛</td><td>16.97, 112.32</td><td>82.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2421</strong></td><td>Pearl</td><td>绿海龟</td><td>F</td><td>西沙北岛</td><td>17.10, 112.45</td><td>77.0%</td><td>🟢</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:15 UTC\n  </div>\n</div>\n</body>\n</html>	\N	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	2026-05-04 00:15:35.642632+08	2026-05-04 00:15:35.660755+08
04929ae1-942d-4e39-b30b-de007fe1763c	Activity: BC-CD-2304	turtle_activity	BC-CD-2304	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>海龟活动报告: Côn Đảo — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>海龟活动报告: Côn Đảo</h1>\n    <div class="sub">Report ID: 04929ae1-942d-4e39-b30b-de007fe1763c &middot; 棱皮龟</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">150</div><div class="label">轨迹点</div></div>\n  <div class="stat-card"><div class="value">0.8</div><div class="label">平均速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">8.8</div><div class="label">平均深度 (m)</div></div>\n  <div class="stat-card"><div class="value">26.7°C</div><div class="label">平均水温</div></div>\n  <div class="stat-card"><div class="value">2.3</div><div class="label">最大速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">20.8</div><div class="label">最大深度 (m)</div></div>\n  <div class="stat-card"><div class="value">0</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟信息</h2>\n<table>\n  <tr><th width="140">ID</th><td>BC-CD-2304</td></tr>\n  <tr><th>名称</th><td>Côn Đảo (Côn Đảo)</td></tr>\n  <tr><th>物种</th><td>棱皮龟 (Leatherback)</td></tr>\n  <tr><th>性别</th><td>F</td></tr>\n  <tr><th>来源地</th><td>越南昆岛</td></tr>\n  <tr><th>甲长</th><td>148.0 cm</td></tr>\n  <tr><th>最新位置</th><td>8.7100, 106.6100</td></tr>\n  <tr><th>设备电量</th><td>62.0%</td></tr>\n  <tr><th>风险等级</th><td>high</td></tr>\n  <tr><th>预警总数</th><td>0（活跃: 0）</td></tr>\n</table>\n<h2>📍 最近轨迹（前 20 条，共 150）</h2>\n<table>\n  <tr><th>时间</th><th>坐标</th><th>速度</th><th>深度</th><th>水温</th></tr>\n  <tr><td>2026-05-03 10:54</td><td>9.2114, 107.6053</td><td>0.8</td><td>12.1</td><td>26.0°C</td></tr><tr><td>2026-05-03 06:03</td><td>9.2682, 107.6053</td><td>0.7</td><td>14.8</td><td>26.9°C</td></tr><tr><td>2026-05-03 00:43</td><td>9.2971, 107.4541</td><td>0.9</td><td>2.6</td><td>25.7°C</td></tr><tr><td>2026-05-02 20:27</td><td>9.2967, 107.4133</td><td>0.9</td><td>7.6</td><td>26.6°C</td></tr><tr><td>2026-05-02 14:51</td><td>9.1556, 107.5599</td><td>0.4</td><td>10.8</td><td>27.5°C</td></tr><tr><td>2026-05-02 10:46</td><td>9.3751, 107.4057</td><td>1.1</td><td>6.8</td><td>29.5°C</td></tr><tr><td>2026-05-02 06:01</td><td>9.2134, 107.5375</td><td>1.4</td><td>12.2</td><td>27.8°C</td></tr><tr><td>2026-05-02 00:34</td><td>9.1806, 107.4023</td><td>0.6</td><td>3.3</td><td>29.2°C</td></tr><tr><td>2026-05-01 19:37</td><td>9.3786, 107.5250</td><td>0.7</td><td>4.5</td><td>25.5°C</td></tr><tr><td>2026-05-01 15:07</td><td>9.3918, 107.3210</td><td>—</td><td>19.3</td><td>26.0°C</td></tr><tr><td>2026-05-01 10:32</td><td>9.3517, 107.4310</td><td>1.2</td><td>8.5</td><td>28.1°C</td></tr><tr><td>2026-05-01 06:03</td><td>9.1977, 107.5627</td><td>0.7</td><td>4.0</td><td>26.4°C</td></tr><tr><td>2026-05-01 01:12</td><td>9.3090, 107.5561</td><td>0.1</td><td>3.8</td><td>28.6°C</td></tr><tr><td>2026-04-30 20:11</td><td>9.3663, 107.4381</td><td>0.5</td><td>8.9</td><td>27.2°C</td></tr><tr><td>2026-04-30 14:59</td><td>9.1740, 107.3890</td><td>—</td><td>2.9</td><td>24.3°C</td></tr><tr><td>2026-04-30 10:40</td><td>9.1292, 107.5594</td><td>1.7</td><td>15.5</td><td>25.2°C</td></tr><tr><td>2026-04-30 05:13</td><td>9.2593, 107.4634</td><td>0.5</td><td>11.6</td><td>29.6°C</td></tr><tr><td>2026-04-30 00:46</td><td>9.3302, 107.4323</td><td>0.5</td><td>3.5</td><td>24.6°C</td></tr><tr><td>2026-04-29 20:30</td><td>9.1192, 107.3447</td><td>0.6</td><td>7.6</td><td>30.3°C</td></tr><tr><td>2026-04-29 15:37</td><td>9.3193, 107.4460</td><td>1.3</td><td>—</td><td>25.0°C</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:15 UTC\n  </div>\n</div>\n</body>\n</html>	\N	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	2026-05-04 00:15:35.679866+08	2026-05-04 00:15:35.693429+08
39b88948-9f74-45a3-81a7-5f13cc252b08	舰队总览2026Q2	fleet_overview	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>舰队总览报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>舰队总览报告</h1>\n    <div class="sub">共 10 只海龟 &middot; 3 个物种</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">海龟总数</div></div>\n  <div class="stat-card"><div class="value">10</div><div class="label">活跃海龟</div></div>\n  <div class="stat-card"><div class="value">3</div><div class="label">物种数</div></div>\n  <div class="stat-card"><div class="value">1,500</div><div class="label">轨迹总点数</div></div>\n  <div class="stat-card"><div class="value">8</div><div class="label">预警总数</div></div>\n  <div class="stat-card"><div class="value">4</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟舰队</h2>\n<table>\n  <tr><th>ID</th><th>名称</th><th>物种</th><th>性别</th><th>来源地</th><th>最后位置</th><th>电量</th><th>状态</th></tr>\n  <tr><td><strong>BC-CD-2304</strong></td><td>Côn Đảo</td><td>棱皮龟</td><td>F</td><td>越南昆岛</td><td>8.71, 106.61</td><td>62.0%</td><td>🟢</td></tr><tr><td><strong>BC-HD-2412</strong></td><td>惠东</td><td>绿海龟</td><td>F</td><td>广东惠东</td><td>22.55, 114.89</td><td>91.0%</td><td>🟢</td></tr><tr><td><strong>BC-HN-2418</strong></td><td>文昌</td><td>绿海龟</td><td>M</td><td>海南岛东岸</td><td>19.85, 111.20</td><td>77.0%</td><td>🟢</td></tr><tr><td><strong>BC-PG-2307</strong></td><td>Papua</td><td>棱皮龟</td><td>F</td><td>巴布亚</td><td>—</td><td>58.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2311</strong></td><td>望安</td><td>绿海龟</td><td>F</td><td>台湾澎湖望安岛</td><td>23.37, 119.50</td><td>71.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2425</strong></td><td>Palawan</td><td>绿海龟</td><td>F</td><td>菲律宾巴拉望</td><td>10.32, 118.74</td><td>65.0%</td><td>🟢</td></tr><tr><td><strong>BC-RY-2429</strong></td><td>琉球</td><td>绿海龟</td><td>F</td><td>琉球群岛</td><td>24.51, 124.18</td><td>79.0%</td><td>🟢</td></tr><tr><td><strong>BC-SB-2315</strong></td><td>Selingan</td><td>玳瑁</td><td>F</td><td>沙巴海龟群岛海洋公园</td><td>6.17, 118.04</td><td>43.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2401</strong></td><td>Luna</td><td>绿海龟</td><td>F</td><td>西沙七连屿北岛</td><td>16.97, 112.32</td><td>82.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2421</strong></td><td>Pearl</td><td>绿海龟</td><td>F</td><td>西沙北岛</td><td>17.10, 112.45</td><td>77.0%</td><td>🟢</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:16 UTC\n  </div>\n</div>\n</body>\n</html>	\N	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	2026-05-04 00:16:38.949329+08	2026-05-04 00:16:38.9543+08
0cb71cea-6019-4f58-9ef1-9715a0900f39	Activity: BC-CD-2304	turtle_activity	BC-CD-2304	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>海龟活动报告: Côn Đảo — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>海龟活动报告: Côn Đảo</h1>\n    <div class="sub">Report ID: 0cb71cea-6019-4f58-9ef1-9715a0900f39 &middot; 棱皮龟</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">150</div><div class="label">轨迹点</div></div>\n  <div class="stat-card"><div class="value">0.8</div><div class="label">平均速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">8.8</div><div class="label">平均深度 (m)</div></div>\n  <div class="stat-card"><div class="value">26.7°C</div><div class="label">平均水温</div></div>\n  <div class="stat-card"><div class="value">2.3</div><div class="label">最大速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">20.8</div><div class="label">最大深度 (m)</div></div>\n  <div class="stat-card"><div class="value">0</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟信息</h2>\n<table>\n  <tr><th width="140">ID</th><td>BC-CD-2304</td></tr>\n  <tr><th>名称</th><td>Côn Đảo (Côn Đảo)</td></tr>\n  <tr><th>物种</th><td>棱皮龟 (Leatherback)</td></tr>\n  <tr><th>性别</th><td>F</td></tr>\n  <tr><th>来源地</th><td>越南昆岛</td></tr>\n  <tr><th>甲长</th><td>148.0 cm</td></tr>\n  <tr><th>最新位置</th><td>8.7100, 106.6100</td></tr>\n  <tr><th>设备电量</th><td>62.0%</td></tr>\n  <tr><th>风险等级</th><td>high</td></tr>\n  <tr><th>预警总数</th><td>0（活跃: 0）</td></tr>\n</table>\n<h2>📍 最近轨迹（前 20 条，共 150）</h2>\n<table>\n  <tr><th>时间</th><th>坐标</th><th>速度</th><th>深度</th><th>水温</th></tr>\n  <tr><td>2026-05-03 10:54</td><td>9.2114, 107.6053</td><td>0.8</td><td>12.1</td><td>26.0°C</td></tr><tr><td>2026-05-03 06:03</td><td>9.2682, 107.6053</td><td>0.7</td><td>14.8</td><td>26.9°C</td></tr><tr><td>2026-05-03 00:43</td><td>9.2971, 107.4541</td><td>0.9</td><td>2.6</td><td>25.7°C</td></tr><tr><td>2026-05-02 20:27</td><td>9.2967, 107.4133</td><td>0.9</td><td>7.6</td><td>26.6°C</td></tr><tr><td>2026-05-02 14:51</td><td>9.1556, 107.5599</td><td>0.4</td><td>10.8</td><td>27.5°C</td></tr><tr><td>2026-05-02 10:46</td><td>9.3751, 107.4057</td><td>1.1</td><td>6.8</td><td>29.5°C</td></tr><tr><td>2026-05-02 06:01</td><td>9.2134, 107.5375</td><td>1.4</td><td>12.2</td><td>27.8°C</td></tr><tr><td>2026-05-02 00:34</td><td>9.1806, 107.4023</td><td>0.6</td><td>3.3</td><td>29.2°C</td></tr><tr><td>2026-05-01 19:37</td><td>9.3786, 107.5250</td><td>0.7</td><td>4.5</td><td>25.5°C</td></tr><tr><td>2026-05-01 15:07</td><td>9.3918, 107.3210</td><td>—</td><td>19.3</td><td>26.0°C</td></tr><tr><td>2026-05-01 10:32</td><td>9.3517, 107.4310</td><td>1.2</td><td>8.5</td><td>28.1°C</td></tr><tr><td>2026-05-01 06:03</td><td>9.1977, 107.5627</td><td>0.7</td><td>4.0</td><td>26.4°C</td></tr><tr><td>2026-05-01 01:12</td><td>9.3090, 107.5561</td><td>0.1</td><td>3.8</td><td>28.6°C</td></tr><tr><td>2026-04-30 20:11</td><td>9.3663, 107.4381</td><td>0.5</td><td>8.9</td><td>27.2°C</td></tr><tr><td>2026-04-30 14:59</td><td>9.1740, 107.3890</td><td>—</td><td>2.9</td><td>24.3°C</td></tr><tr><td>2026-04-30 10:40</td><td>9.1292, 107.5594</td><td>1.7</td><td>15.5</td><td>25.2°C</td></tr><tr><td>2026-04-30 05:13</td><td>9.2593, 107.4634</td><td>0.5</td><td>11.6</td><td>29.6°C</td></tr><tr><td>2026-04-30 00:46</td><td>9.3302, 107.4323</td><td>0.5</td><td>3.5</td><td>24.6°C</td></tr><tr><td>2026-04-29 20:30</td><td>9.1192, 107.3447</td><td>0.6</td><td>7.6</td><td>30.3°C</td></tr><tr><td>2026-04-29 15:37</td><td>9.3193, 107.4460</td><td>1.3</td><td>—</td><td>25.0°C</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:16 UTC\n  </div>\n</div>\n</body>\n</html>	\N	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	2026-05-04 00:16:38.966278+08	2026-05-04 00:16:38.974894+08
76a1defc-0121-4fb0-bbc3-91f62681cf82	舰队总览2026Q2	fleet_overview	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>舰队总览报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>舰队总览报告</h1>\n    <div class="sub">共 10 只海龟 &middot; 3 个物种</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">海龟总数</div></div>\n  <div class="stat-card"><div class="value">10</div><div class="label">活跃海龟</div></div>\n  <div class="stat-card"><div class="value">3</div><div class="label">物种数</div></div>\n  <div class="stat-card"><div class="value">1,500</div><div class="label">轨迹总点数</div></div>\n  <div class="stat-card"><div class="value">8</div><div class="label">预警总数</div></div>\n  <div class="stat-card"><div class="value">4</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟舰队</h2>\n<table>\n  <tr><th>ID</th><th>名称</th><th>物种</th><th>性别</th><th>来源地</th><th>最后位置</th><th>电量</th><th>状态</th></tr>\n  <tr><td><strong>BC-CD-2304</strong></td><td>Côn Đảo</td><td>棱皮龟</td><td>F</td><td>越南昆岛</td><td>8.71, 106.61</td><td>62.0%</td><td>🟢</td></tr><tr><td><strong>BC-HD-2412</strong></td><td>惠东</td><td>绿海龟</td><td>F</td><td>广东惠东</td><td>22.55, 114.89</td><td>91.0%</td><td>🟢</td></tr><tr><td><strong>BC-HN-2418</strong></td><td>文昌</td><td>绿海龟</td><td>M</td><td>海南岛东岸</td><td>19.85, 111.20</td><td>77.0%</td><td>🟢</td></tr><tr><td><strong>BC-PG-2307</strong></td><td>Papua</td><td>棱皮龟</td><td>F</td><td>巴布亚</td><td>—</td><td>58.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2311</strong></td><td>望安</td><td>绿海龟</td><td>F</td><td>台湾澎湖望安岛</td><td>23.37, 119.50</td><td>71.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2425</strong></td><td>Palawan</td><td>绿海龟</td><td>F</td><td>菲律宾巴拉望</td><td>10.32, 118.74</td><td>65.0%</td><td>🟢</td></tr><tr><td><strong>BC-RY-2429</strong></td><td>琉球</td><td>绿海龟</td><td>F</td><td>琉球群岛</td><td>24.51, 124.18</td><td>79.0%</td><td>🟢</td></tr><tr><td><strong>BC-SB-2315</strong></td><td>Selingan</td><td>玳瑁</td><td>F</td><td>沙巴海龟群岛海洋公园</td><td>6.17, 118.04</td><td>43.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2401</strong></td><td>Luna</td><td>绿海龟</td><td>F</td><td>西沙七连屿北岛</td><td>16.97, 112.32</td><td>82.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2421</strong></td><td>Pearl</td><td>绿海龟</td><td>F</td><td>西沙北岛</td><td>17.10, 112.45</td><td>77.0%</td><td>🟢</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:17 UTC\n  </div>\n</div>\n</body>\n</html>	\N	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	2026-05-04 00:17:59.752282+08	2026-05-04 00:17:59.771482+08
c47962f6-0b39-48ed-9e9a-725ccc1d1655	Activity: BC-CD-2304	turtle_activity	BC-CD-2304	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>海龟活动报告: Côn Đảo — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>海龟活动报告: Côn Đảo</h1>\n    <div class="sub">Report ID: c47962f6-0b39-48ed-9e9a-725ccc1d1655 &middot; 棱皮龟</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">150</div><div class="label">轨迹点</div></div>\n  <div class="stat-card"><div class="value">0.8</div><div class="label">平均速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">8.8</div><div class="label">平均深度 (m)</div></div>\n  <div class="stat-card"><div class="value">26.7°C</div><div class="label">平均水温</div></div>\n  <div class="stat-card"><div class="value">2.3</div><div class="label">最大速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">20.8</div><div class="label">最大深度 (m)</div></div>\n  <div class="stat-card"><div class="value">0</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟信息</h2>\n<table>\n  <tr><th width="140">ID</th><td>BC-CD-2304</td></tr>\n  <tr><th>名称</th><td>Côn Đảo (Côn Đảo)</td></tr>\n  <tr><th>物种</th><td>棱皮龟 (Leatherback)</td></tr>\n  <tr><th>性别</th><td>F</td></tr>\n  <tr><th>来源地</th><td>越南昆岛</td></tr>\n  <tr><th>甲长</th><td>148.0 cm</td></tr>\n  <tr><th>最新位置</th><td>8.7100, 106.6100</td></tr>\n  <tr><th>设备电量</th><td>62.0%</td></tr>\n  <tr><th>风险等级</th><td>high</td></tr>\n  <tr><th>预警总数</th><td>0（活跃: 0）</td></tr>\n</table>\n<h2>📍 最近轨迹（前 20 条，共 150）</h2>\n<table>\n  <tr><th>时间</th><th>坐标</th><th>速度</th><th>深度</th><th>水温</th></tr>\n  <tr><td>2026-05-03 10:54</td><td>9.2114, 107.6053</td><td>0.8</td><td>12.1</td><td>26.0°C</td></tr><tr><td>2026-05-03 06:03</td><td>9.2682, 107.6053</td><td>0.7</td><td>14.8</td><td>26.9°C</td></tr><tr><td>2026-05-03 00:43</td><td>9.2971, 107.4541</td><td>0.9</td><td>2.6</td><td>25.7°C</td></tr><tr><td>2026-05-02 20:27</td><td>9.2967, 107.4133</td><td>0.9</td><td>7.6</td><td>26.6°C</td></tr><tr><td>2026-05-02 14:51</td><td>9.1556, 107.5599</td><td>0.4</td><td>10.8</td><td>27.5°C</td></tr><tr><td>2026-05-02 10:46</td><td>9.3751, 107.4057</td><td>1.1</td><td>6.8</td><td>29.5°C</td></tr><tr><td>2026-05-02 06:01</td><td>9.2134, 107.5375</td><td>1.4</td><td>12.2</td><td>27.8°C</td></tr><tr><td>2026-05-02 00:34</td><td>9.1806, 107.4023</td><td>0.6</td><td>3.3</td><td>29.2°C</td></tr><tr><td>2026-05-01 19:37</td><td>9.3786, 107.5250</td><td>0.7</td><td>4.5</td><td>25.5°C</td></tr><tr><td>2026-05-01 15:07</td><td>9.3918, 107.3210</td><td>—</td><td>19.3</td><td>26.0°C</td></tr><tr><td>2026-05-01 10:32</td><td>9.3517, 107.4310</td><td>1.2</td><td>8.5</td><td>28.1°C</td></tr><tr><td>2026-05-01 06:03</td><td>9.1977, 107.5627</td><td>0.7</td><td>4.0</td><td>26.4°C</td></tr><tr><td>2026-05-01 01:12</td><td>9.3090, 107.5561</td><td>0.1</td><td>3.8</td><td>28.6°C</td></tr><tr><td>2026-04-30 20:11</td><td>9.3663, 107.4381</td><td>0.5</td><td>8.9</td><td>27.2°C</td></tr><tr><td>2026-04-30 14:59</td><td>9.1740, 107.3890</td><td>—</td><td>2.9</td><td>24.3°C</td></tr><tr><td>2026-04-30 10:40</td><td>9.1292, 107.5594</td><td>1.7</td><td>15.5</td><td>25.2°C</td></tr><tr><td>2026-04-30 05:13</td><td>9.2593, 107.4634</td><td>0.5</td><td>11.6</td><td>29.6°C</td></tr><tr><td>2026-04-30 00:46</td><td>9.3302, 107.4323</td><td>0.5</td><td>3.5</td><td>24.6°C</td></tr><tr><td>2026-04-29 20:30</td><td>9.1192, 107.3447</td><td>0.6</td><td>7.6</td><td>30.3°C</td></tr><tr><td>2026-04-29 15:37</td><td>9.3193, 107.4460</td><td>1.3</td><td>—</td><td>25.0°C</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:17 UTC\n  </div>\n</div>\n</body>\n</html>	\N	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	2026-05-04 00:17:59.790612+08	2026-05-04 00:17:59.804068+08
31e326c2-8c78-4520-b497-77f685573370	预警汇总	alert_summary	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>预警统计报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>预警统计报告</h1>\n    <div class="sub">Alert Statistics Report</div>\n  </div>\n  <div class="body">\n\n<h2>🔴 按严重程度</h2>\n<table>\n  <tr><th>级别</th><th>总数</th><th>活跃</th></tr>\n  <tr><td><span class='badge badge-critical'>CRITICAL</span></td><td>2</td><td>0</td></tr><tr><td><span class='badge badge-high'>HIGH</span></td><td>6</td><td>4</td></tr><tr><td><span class='badge badge-medium'>MEDIUM</span></td><td>0</td><td>0</td></tr><tr><td><span class='badge badge-low'>LOW</span></td><td>0</td><td>0</td></tr>\n</table>\n\n<h2>📂 按类型</h2>\n<table>\n  <tr><th>预警类型</th><th>数量</th></tr>\n  <tr><td>fishing</td><td>4</td></tr><tr><td>test</td><td>2</td></tr><tr><td>collision</td><td>2</td></tr>\n</table>\n\n<h2>🐢 预警最多的海龟 (Top 10)</h2>\n<table>\n  <tr><th>海龟 ID</th><th>预警数</th></tr>\n  <tr><td>BC-XS-2401</td><td>8</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:17 UTC\n  </div>\n</div>\n</body>\n</html>	\N	3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	2026-05-04 00:17:59.810447+08	2026-05-04 00:17:59.824475+08
03748bc8-46ac-4754-98e4-c2c6fe9ce5ec	Audit Fleet	fleet_overview	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>舰队总览报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>舰队总览报告</h1>\n    <div class="sub">共 10 只海龟 &middot; 3 个物种</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">海龟总数</div></div>\n  <div class="stat-card"><div class="value">10</div><div class="label">活跃海龟</div></div>\n  <div class="stat-card"><div class="value">3</div><div class="label">物种数</div></div>\n  <div class="stat-card"><div class="value">1,500</div><div class="label">轨迹总点数</div></div>\n  <div class="stat-card"><div class="value">9</div><div class="label">预警总数</div></div>\n  <div class="stat-card"><div class="value">4</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟舰队</h2>\n<table>\n  <tr><th>ID</th><th>名称</th><th>物种</th><th>性别</th><th>来源地</th><th>最后位置</th><th>电量</th><th>状态</th></tr>\n  <tr><td><strong>BC-CD-2304</strong></td><td>Côn Đảo</td><td>棱皮龟</td><td>F</td><td>越南昆岛</td><td>8.71, 106.61</td><td>62.0%</td><td>🟢</td></tr><tr><td><strong>BC-HD-2412</strong></td><td>惠东</td><td>绿海龟</td><td>F</td><td>广东惠东</td><td>22.55, 114.89</td><td>91.0%</td><td>🟢</td></tr><tr><td><strong>BC-HN-2418</strong></td><td>文昌</td><td>绿海龟</td><td>M</td><td>海南岛东岸</td><td>19.85, 111.20</td><td>77.0%</td><td>🟢</td></tr><tr><td><strong>BC-PG-2307</strong></td><td>Papua</td><td>棱皮龟</td><td>F</td><td>巴布亚</td><td>—</td><td>58.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2311</strong></td><td>望安</td><td>绿海龟</td><td>F</td><td>台湾澎湖望安岛</td><td>23.37, 119.50</td><td>71.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2425</strong></td><td>Palawan</td><td>绿海龟</td><td>F</td><td>菲律宾巴拉望</td><td>10.32, 118.74</td><td>65.0%</td><td>🟢</td></tr><tr><td><strong>BC-RY-2429</strong></td><td>琉球</td><td>绿海龟</td><td>F</td><td>琉球群岛</td><td>24.51, 124.18</td><td>79.0%</td><td>🟢</td></tr><tr><td><strong>BC-SB-2315</strong></td><td>Selingan</td><td>玳瑁</td><td>F</td><td>沙巴海龟群岛海洋公园</td><td>6.17, 118.04</td><td>43.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2401</strong></td><td>Luna</td><td>绿海龟</td><td>F</td><td>西沙七连屿北岛</td><td>16.97, 112.32</td><td>82.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2421</strong></td><td>Pearl</td><td>绿海龟</td><td>F</td><td>西沙北岛</td><td>17.10, 112.45</td><td>77.0%</td><td>🟢</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:42 UTC\n  </div>\n</div>\n</body>\n</html>	\N	64e3b750-ffef-468e-ba9f-510be74db15c	2026-05-04 00:42:16.492383+08	2026-05-04 00:42:16.505041+08
98a179eb-0cce-46c4-b146-0d104f74ddc4	Audit Activity	turtle_activity	BC-CD-2304	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>海龟活动报告: Côn Đảo — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>海龟活动报告: Côn Đảo</h1>\n    <div class="sub">Report ID: 98a179eb-0cce-46c4-b146-0d104f74ddc4 &middot; 棱皮龟</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">150</div><div class="label">轨迹点</div></div>\n  <div class="stat-card"><div class="value">0.8</div><div class="label">平均速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">8.8</div><div class="label">平均深度 (m)</div></div>\n  <div class="stat-card"><div class="value">26.7°C</div><div class="label">平均水温</div></div>\n  <div class="stat-card"><div class="value">2.3</div><div class="label">最大速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">20.8</div><div class="label">最大深度 (m)</div></div>\n  <div class="stat-card"><div class="value">0</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟信息</h2>\n<table>\n  <tr><th width="140">ID</th><td>BC-CD-2304</td></tr>\n  <tr><th>名称</th><td>Côn Đảo (Côn Đảo)</td></tr>\n  <tr><th>物种</th><td>棱皮龟 (Leatherback)</td></tr>\n  <tr><th>性别</th><td>F</td></tr>\n  <tr><th>来源地</th><td>越南昆岛</td></tr>\n  <tr><th>甲长</th><td>148.0 cm</td></tr>\n  <tr><th>最新位置</th><td>8.7100, 106.6100</td></tr>\n  <tr><th>设备电量</th><td>62.0%</td></tr>\n  <tr><th>风险等级</th><td>high</td></tr>\n  <tr><th>预警总数</th><td>1（活跃: 0）</td></tr>\n</table>\n<h2>📍 最近轨迹（前 20 条，共 150）</h2>\n<table>\n  <tr><th>时间</th><th>坐标</th><th>速度</th><th>深度</th><th>水温</th></tr>\n  <tr><td>2026-05-03 10:54</td><td>9.2114, 107.6053</td><td>0.8</td><td>12.1</td><td>26.0°C</td></tr><tr><td>2026-05-03 06:03</td><td>9.2682, 107.6053</td><td>0.7</td><td>14.8</td><td>26.9°C</td></tr><tr><td>2026-05-03 00:43</td><td>9.2971, 107.4541</td><td>0.9</td><td>2.6</td><td>25.7°C</td></tr><tr><td>2026-05-02 20:27</td><td>9.2967, 107.4133</td><td>0.9</td><td>7.6</td><td>26.6°C</td></tr><tr><td>2026-05-02 14:51</td><td>9.1556, 107.5599</td><td>0.4</td><td>10.8</td><td>27.5°C</td></tr><tr><td>2026-05-02 10:46</td><td>9.3751, 107.4057</td><td>1.1</td><td>6.8</td><td>29.5°C</td></tr><tr><td>2026-05-02 06:01</td><td>9.2134, 107.5375</td><td>1.4</td><td>12.2</td><td>27.8°C</td></tr><tr><td>2026-05-02 00:34</td><td>9.1806, 107.4023</td><td>0.6</td><td>3.3</td><td>29.2°C</td></tr><tr><td>2026-05-01 19:37</td><td>9.3786, 107.5250</td><td>0.7</td><td>4.5</td><td>25.5°C</td></tr><tr><td>2026-05-01 15:07</td><td>9.3918, 107.3210</td><td>—</td><td>19.3</td><td>26.0°C</td></tr><tr><td>2026-05-01 10:32</td><td>9.3517, 107.4310</td><td>1.2</td><td>8.5</td><td>28.1°C</td></tr><tr><td>2026-05-01 06:03</td><td>9.1977, 107.5627</td><td>0.7</td><td>4.0</td><td>26.4°C</td></tr><tr><td>2026-05-01 01:12</td><td>9.3090, 107.5561</td><td>0.1</td><td>3.8</td><td>28.6°C</td></tr><tr><td>2026-04-30 20:11</td><td>9.3663, 107.4381</td><td>0.5</td><td>8.9</td><td>27.2°C</td></tr><tr><td>2026-04-30 14:59</td><td>9.1740, 107.3890</td><td>—</td><td>2.9</td><td>24.3°C</td></tr><tr><td>2026-04-30 10:40</td><td>9.1292, 107.5594</td><td>1.7</td><td>15.5</td><td>25.2°C</td></tr><tr><td>2026-04-30 05:13</td><td>9.2593, 107.4634</td><td>0.5</td><td>11.6</td><td>29.6°C</td></tr><tr><td>2026-04-30 00:46</td><td>9.3302, 107.4323</td><td>0.5</td><td>3.5</td><td>24.6°C</td></tr><tr><td>2026-04-29 20:30</td><td>9.1192, 107.3447</td><td>0.6</td><td>7.6</td><td>30.3°C</td></tr><tr><td>2026-04-29 15:37</td><td>9.3193, 107.4460</td><td>1.3</td><td>—</td><td>25.0°C</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:42 UTC\n  </div>\n</div>\n</body>\n</html>	\N	64e3b750-ffef-468e-ba9f-510be74db15c	2026-05-04 00:42:16.51447+08	2026-05-04 00:42:16.527398+08
cab8b7e7-c189-4e87-944b-00536a8a3b6d	Audit Alert	alert_summary	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>预警统计报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>预警统计报告</h1>\n    <div class="sub">Alert Statistics Report</div>\n  </div>\n  <div class="body">\n\n<h2>🔴 按严重程度</h2>\n<table>\n  <tr><th>级别</th><th>总数</th><th>活跃</th></tr>\n  <tr><td><span class='badge badge-critical'>CRITICAL</span></td><td>2</td><td>0</td></tr><tr><td><span class='badge badge-high'>HIGH</span></td><td>6</td><td>4</td></tr><tr><td><span class='badge badge-medium'>MEDIUM</span></td><td>0</td><td>0</td></tr><tr><td><span class='badge badge-low'>LOW</span></td><td>1</td><td>0</td></tr>\n</table>\n\n<h2>📂 按类型</h2>\n<table>\n  <tr><th>预警类型</th><th>数量</th></tr>\n  <tr><td>fishing</td><td>4</td></tr><tr><td>test</td><td>3</td></tr><tr><td>collision</td><td>2</td></tr>\n</table>\n\n<h2>🐢 预警最多的海龟 (Top 10)</h2>\n<table>\n  <tr><th>海龟 ID</th><th>预警数</th></tr>\n  <tr><td>BC-XS-2401</td><td>8</td></tr><tr><td>BC-CD-2304</td><td>1</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:42 UTC\n  </div>\n</div>\n</body>\n</html>	\N	64e3b750-ffef-468e-ba9f-510be74db15c	2026-05-04 00:42:16.534049+08	2026-05-04 00:42:16.547671+08
88c01708-6bc0-4a87-a37e-4cef44ad789e	Audit Monthly	monthly_summary	\N	{"date_to": "2026-12-31", "date_from": "2026-01-01"}	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>月度保育摘要报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>月度保育摘要报告</h1>\n    <div class="sub">统计周期: 2026-01-01 ~ 2026-12-31</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">追踪中海龟</div></div>\n  <div class="stat-card"><div class="value">1,500</div><div class="label">新增轨迹点</div></div>\n  <div class="stat-card"><div class="value">9</div><div class="label">期间预警</div></div>\n  <div class="stat-card"><div class="value">5</div><div class="label">已解决预警</div></div>\n</div>\n\n<h2>📋 保育摘要</h2>\n<table>\n  <tr><th width="180">统计周期</th><td>2026-01-01 ~ 2026-12-31</td></tr>\n  <tr><th>追踪海龟数</th><td>10 只</td></tr>\n  <tr><th>新增轨迹数据</th><td>1,500 个定位点</td></tr>\n  <tr><th>期间预警</th><td>9 条</td></tr>\n  <tr><th>已解决预警</th><td>5 条</td></tr>\n  <tr><th>解决率</th><td>56%</td></tr>\n</table>\n\n<p style="margin-top:24px; color:#6b9fd4;">\n  📝 本报告由 Blue Circle 海龟追踪平台自动生成。如需详细数据，请访问\n  <a href="https://data.maskcube.com/" style="color:#2d8cf0;">data.maskcube.com</a>。\n</p>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:42 UTC\n  </div>\n</div>\n</body>\n</html>	\N	64e3b750-ffef-468e-ba9f-510be74db15c	2026-05-04 00:42:16.55449+08	2026-05-04 00:42:16.563606+08
b67141b6-9030-4706-bcc4-080a9a588e5e	Audit Fleet	fleet_overview	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>舰队总览报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>舰队总览报告</h1>\n    <div class="sub">共 10 只海龟 &middot; 3 个物种</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">海龟总数</div></div>\n  <div class="stat-card"><div class="value">10</div><div class="label">活跃海龟</div></div>\n  <div class="stat-card"><div class="value">3</div><div class="label">物种数</div></div>\n  <div class="stat-card"><div class="value">1,500</div><div class="label">轨迹总点数</div></div>\n  <div class="stat-card"><div class="value">10</div><div class="label">预警总数</div></div>\n  <div class="stat-card"><div class="value">4</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟舰队</h2>\n<table>\n  <tr><th>ID</th><th>名称</th><th>物种</th><th>性别</th><th>来源地</th><th>最后位置</th><th>电量</th><th>状态</th></tr>\n  <tr><td><strong>BC-CD-2304</strong></td><td>Côn Đảo</td><td>棱皮龟</td><td>F</td><td>越南昆岛</td><td>8.71, 106.61</td><td>62.0%</td><td>🟢</td></tr><tr><td><strong>BC-HD-2412</strong></td><td>惠东</td><td>绿海龟</td><td>F</td><td>广东惠东</td><td>22.55, 114.89</td><td>91.0%</td><td>🟢</td></tr><tr><td><strong>BC-HN-2418</strong></td><td>文昌</td><td>绿海龟</td><td>M</td><td>海南岛东岸</td><td>19.85, 111.20</td><td>77.0%</td><td>🟢</td></tr><tr><td><strong>BC-PG-2307</strong></td><td>Papua</td><td>棱皮龟</td><td>F</td><td>巴布亚</td><td>—</td><td>58.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2311</strong></td><td>望安</td><td>绿海龟</td><td>F</td><td>台湾澎湖望安岛</td><td>23.37, 119.50</td><td>71.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2425</strong></td><td>Palawan</td><td>绿海龟</td><td>F</td><td>菲律宾巴拉望</td><td>10.32, 118.74</td><td>65.0%</td><td>🟢</td></tr><tr><td><strong>BC-RY-2429</strong></td><td>琉球</td><td>绿海龟</td><td>F</td><td>琉球群岛</td><td>24.51, 124.18</td><td>79.0%</td><td>🟢</td></tr><tr><td><strong>BC-SB-2315</strong></td><td>Selingan</td><td>玳瑁</td><td>F</td><td>沙巴海龟群岛海洋公园</td><td>6.17, 118.04</td><td>43.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2401</strong></td><td>Luna</td><td>绿海龟</td><td>F</td><td>西沙七连屿北岛</td><td>16.97, 112.32</td><td>82.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2421</strong></td><td>Pearl</td><td>绿海龟</td><td>F</td><td>西沙北岛</td><td>17.10, 112.45</td><td>77.0%</td><td>🟢</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:45 UTC\n  </div>\n</div>\n</body>\n</html>	\N	024e899b-c8cb-487e-95e0-fd2233d59b3b	2026-05-04 00:45:07.200626+08	2026-05-04 00:45:07.206266+08
313f9c30-0418-4242-ba9d-050d0c0dee2d	Audit Activity	turtle_activity	BC-CD-2304	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>海龟活动报告: Côn Đảo — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>海龟活动报告: Côn Đảo</h1>\n    <div class="sub">Report ID: 313f9c30-0418-4242-ba9d-050d0c0dee2d &middot; 棱皮龟</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">150</div><div class="label">轨迹点</div></div>\n  <div class="stat-card"><div class="value">0.8</div><div class="label">平均速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">8.8</div><div class="label">平均深度 (m)</div></div>\n  <div class="stat-card"><div class="value">26.7°C</div><div class="label">平均水温</div></div>\n  <div class="stat-card"><div class="value">2.3</div><div class="label">最大速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">20.8</div><div class="label">最大深度 (m)</div></div>\n  <div class="stat-card"><div class="value">0</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟信息</h2>\n<table>\n  <tr><th width="140">ID</th><td>BC-CD-2304</td></tr>\n  <tr><th>名称</th><td>Côn Đảo (Côn Đảo)</td></tr>\n  <tr><th>物种</th><td>棱皮龟 (Leatherback)</td></tr>\n  <tr><th>性别</th><td>F</td></tr>\n  <tr><th>来源地</th><td>越南昆岛</td></tr>\n  <tr><th>甲长</th><td>148.0 cm</td></tr>\n  <tr><th>最新位置</th><td>8.7100, 106.6100</td></tr>\n  <tr><th>设备电量</th><td>62.0%</td></tr>\n  <tr><th>风险等级</th><td>high</td></tr>\n  <tr><th>预警总数</th><td>2（活跃: 0）</td></tr>\n</table>\n<h2>📍 最近轨迹（前 20 条，共 150）</h2>\n<table>\n  <tr><th>时间</th><th>坐标</th><th>速度</th><th>深度</th><th>水温</th></tr>\n  <tr><td>2026-05-03 10:54</td><td>9.2114, 107.6053</td><td>0.8</td><td>12.1</td><td>26.0°C</td></tr><tr><td>2026-05-03 06:03</td><td>9.2682, 107.6053</td><td>0.7</td><td>14.8</td><td>26.9°C</td></tr><tr><td>2026-05-03 00:43</td><td>9.2971, 107.4541</td><td>0.9</td><td>2.6</td><td>25.7°C</td></tr><tr><td>2026-05-02 20:27</td><td>9.2967, 107.4133</td><td>0.9</td><td>7.6</td><td>26.6°C</td></tr><tr><td>2026-05-02 14:51</td><td>9.1556, 107.5599</td><td>0.4</td><td>10.8</td><td>27.5°C</td></tr><tr><td>2026-05-02 10:46</td><td>9.3751, 107.4057</td><td>1.1</td><td>6.8</td><td>29.5°C</td></tr><tr><td>2026-05-02 06:01</td><td>9.2134, 107.5375</td><td>1.4</td><td>12.2</td><td>27.8°C</td></tr><tr><td>2026-05-02 00:34</td><td>9.1806, 107.4023</td><td>0.6</td><td>3.3</td><td>29.2°C</td></tr><tr><td>2026-05-01 19:37</td><td>9.3786, 107.5250</td><td>0.7</td><td>4.5</td><td>25.5°C</td></tr><tr><td>2026-05-01 15:07</td><td>9.3918, 107.3210</td><td>—</td><td>19.3</td><td>26.0°C</td></tr><tr><td>2026-05-01 10:32</td><td>9.3517, 107.4310</td><td>1.2</td><td>8.5</td><td>28.1°C</td></tr><tr><td>2026-05-01 06:03</td><td>9.1977, 107.5627</td><td>0.7</td><td>4.0</td><td>26.4°C</td></tr><tr><td>2026-05-01 01:12</td><td>9.3090, 107.5561</td><td>0.1</td><td>3.8</td><td>28.6°C</td></tr><tr><td>2026-04-30 20:11</td><td>9.3663, 107.4381</td><td>0.5</td><td>8.9</td><td>27.2°C</td></tr><tr><td>2026-04-30 14:59</td><td>9.1740, 107.3890</td><td>—</td><td>2.9</td><td>24.3°C</td></tr><tr><td>2026-04-30 10:40</td><td>9.1292, 107.5594</td><td>1.7</td><td>15.5</td><td>25.2°C</td></tr><tr><td>2026-04-30 05:13</td><td>9.2593, 107.4634</td><td>0.5</td><td>11.6</td><td>29.6°C</td></tr><tr><td>2026-04-30 00:46</td><td>9.3302, 107.4323</td><td>0.5</td><td>3.5</td><td>24.6°C</td></tr><tr><td>2026-04-29 20:30</td><td>9.1192, 107.3447</td><td>0.6</td><td>7.6</td><td>30.3°C</td></tr><tr><td>2026-04-29 15:37</td><td>9.3193, 107.4460</td><td>1.3</td><td>—</td><td>25.0°C</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:45 UTC\n  </div>\n</div>\n</body>\n</html>	\N	024e899b-c8cb-487e-95e0-fd2233d59b3b	2026-05-04 00:45:07.213137+08	2026-05-04 00:45:07.221735+08
b4663afe-8cb6-40f1-9efe-da4218147718	Audit Alert	alert_summary	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>预警统计报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>预警统计报告</h1>\n    <div class="sub">Alert Statistics Report</div>\n  </div>\n  <div class="body">\n\n<h2>🔴 按严重程度</h2>\n<table>\n  <tr><th>级别</th><th>总数</th><th>活跃</th></tr>\n  <tr><td><span class='badge badge-critical'>CRITICAL</span></td><td>2</td><td>0</td></tr><tr><td><span class='badge badge-high'>HIGH</span></td><td>6</td><td>4</td></tr><tr><td><span class='badge badge-medium'>MEDIUM</span></td><td>0</td><td>0</td></tr><tr><td><span class='badge badge-low'>LOW</span></td><td>2</td><td>0</td></tr>\n</table>\n\n<h2>📂 按类型</h2>\n<table>\n  <tr><th>预警类型</th><th>数量</th></tr>\n  <tr><td>test</td><td>4</td></tr><tr><td>fishing</td><td>4</td></tr><tr><td>collision</td><td>2</td></tr>\n</table>\n\n<h2>🐢 预警最多的海龟 (Top 10)</h2>\n<table>\n  <tr><th>海龟 ID</th><th>预警数</th></tr>\n  <tr><td>BC-XS-2401</td><td>8</td></tr><tr><td>BC-CD-2304</td><td>2</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:45 UTC\n  </div>\n</div>\n</body>\n</html>	\N	024e899b-c8cb-487e-95e0-fd2233d59b3b	2026-05-04 00:45:07.228131+08	2026-05-04 00:45:07.236979+08
5d9a6a8c-eee1-4b1d-982a-f2648f1a8631	Audit Monthly	monthly_summary	\N	{"date_to": "2026-12-31", "date_from": "2026-01-01"}	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>月度保育摘要报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>月度保育摘要报告</h1>\n    <div class="sub">统计周期: 2026-01-01 ~ 2026-12-31</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">追踪中海龟</div></div>\n  <div class="stat-card"><div class="value">1,500</div><div class="label">新增轨迹点</div></div>\n  <div class="stat-card"><div class="value">10</div><div class="label">期间预警</div></div>\n  <div class="stat-card"><div class="value">6</div><div class="label">已解决预警</div></div>\n</div>\n\n<h2>📋 保育摘要</h2>\n<table>\n  <tr><th width="180">统计周期</th><td>2026-01-01 ~ 2026-12-31</td></tr>\n  <tr><th>追踪海龟数</th><td>10 只</td></tr>\n  <tr><th>新增轨迹数据</th><td>1,500 个定位点</td></tr>\n  <tr><th>期间预警</th><td>10 条</td></tr>\n  <tr><th>已解决预警</th><td>6 条</td></tr>\n  <tr><th>解决率</th><td>60%</td></tr>\n</table>\n\n<p style="margin-top:24px; color:#6b9fd4;">\n  📝 本报告由 Blue Circle 海龟追踪平台自动生成。如需详细数据，请访问\n  <a href="https://data.maskcube.com/" style="color:#2d8cf0;">data.maskcube.com</a>。\n</p>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:45 UTC\n  </div>\n</div>\n</body>\n</html>	\N	024e899b-c8cb-487e-95e0-fd2233d59b3b	2026-05-04 00:45:07.242951+08	2026-05-04 00:45:07.248169+08
38fef0b0-1aca-403c-9fb4-c1c3fa1d70cb	Audit Fleet	fleet_overview	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>舰队总览报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>舰队总览报告</h1>\n    <div class="sub">共 10 只海龟 &middot; 3 个物种</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">海龟总数</div></div>\n  <div class="stat-card"><div class="value">10</div><div class="label">活跃海龟</div></div>\n  <div class="stat-card"><div class="value">3</div><div class="label">物种数</div></div>\n  <div class="stat-card"><div class="value">1,500</div><div class="label">轨迹总点数</div></div>\n  <div class="stat-card"><div class="value">11</div><div class="label">预警总数</div></div>\n  <div class="stat-card"><div class="value">4</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟舰队</h2>\n<table>\n  <tr><th>ID</th><th>名称</th><th>物种</th><th>性别</th><th>来源地</th><th>最后位置</th><th>电量</th><th>状态</th></tr>\n  <tr><td><strong>BC-CD-2304</strong></td><td>Côn Đảo</td><td>棱皮龟</td><td>F</td><td>越南昆岛</td><td>8.71, 106.61</td><td>62.0%</td><td>🟢</td></tr><tr><td><strong>BC-HD-2412</strong></td><td>惠东</td><td>绿海龟</td><td>F</td><td>广东惠东</td><td>22.55, 114.89</td><td>91.0%</td><td>🟢</td></tr><tr><td><strong>BC-HN-2418</strong></td><td>文昌</td><td>绿海龟</td><td>M</td><td>海南岛东岸</td><td>19.85, 111.20</td><td>77.0%</td><td>🟢</td></tr><tr><td><strong>BC-PG-2307</strong></td><td>Papua</td><td>棱皮龟</td><td>F</td><td>巴布亚</td><td>—</td><td>58.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2311</strong></td><td>望安</td><td>绿海龟</td><td>F</td><td>台湾澎湖望安岛</td><td>23.37, 119.50</td><td>71.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2425</strong></td><td>Palawan</td><td>绿海龟</td><td>F</td><td>菲律宾巴拉望</td><td>10.32, 118.74</td><td>65.0%</td><td>🟢</td></tr><tr><td><strong>BC-RY-2429</strong></td><td>琉球</td><td>绿海龟</td><td>F</td><td>琉球群岛</td><td>24.51, 124.18</td><td>79.0%</td><td>🟢</td></tr><tr><td><strong>BC-SB-2315</strong></td><td>Selingan</td><td>玳瑁</td><td>F</td><td>沙巴海龟群岛海洋公园</td><td>6.17, 118.04</td><td>43.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2401</strong></td><td>Luna</td><td>绿海龟</td><td>F</td><td>西沙七连屿北岛</td><td>16.97, 112.32</td><td>82.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2421</strong></td><td>Pearl</td><td>绿海龟</td><td>F</td><td>西沙北岛</td><td>17.10, 112.45</td><td>77.0%</td><td>🟢</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:56 UTC\n  </div>\n</div>\n</body>\n</html>	\N	fc46d2d8-22a5-4135-a3ea-73654adc589e	2026-05-04 00:56:48.663183+08	2026-05-04 00:56:48.676172+08
8c2616e8-f315-4f04-94a8-38a3ed8e4155	Audit Activity	turtle_activity	BC-CD-2304	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>海龟活动报告: Côn Đảo — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>海龟活动报告: Côn Đảo</h1>\n    <div class="sub">Report ID: 8c2616e8-f315-4f04-94a8-38a3ed8e4155 &middot; 棱皮龟</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">150</div><div class="label">轨迹点</div></div>\n  <div class="stat-card"><div class="value">0.8</div><div class="label">平均速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">8.8</div><div class="label">平均深度 (m)</div></div>\n  <div class="stat-card"><div class="value">26.7°C</div><div class="label">平均水温</div></div>\n  <div class="stat-card"><div class="value">2.3</div><div class="label">最大速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">20.8</div><div class="label">最大深度 (m)</div></div>\n  <div class="stat-card"><div class="value">0</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟信息</h2>\n<table>\n  <tr><th width="140">ID</th><td>BC-CD-2304</td></tr>\n  <tr><th>名称</th><td>Côn Đảo (Côn Đảo)</td></tr>\n  <tr><th>物种</th><td>棱皮龟 (Leatherback)</td></tr>\n  <tr><th>性别</th><td>F</td></tr>\n  <tr><th>来源地</th><td>越南昆岛</td></tr>\n  <tr><th>甲长</th><td>148.0 cm</td></tr>\n  <tr><th>最新位置</th><td>8.7100, 106.6100</td></tr>\n  <tr><th>设备电量</th><td>62.0%</td></tr>\n  <tr><th>风险等级</th><td>high</td></tr>\n  <tr><th>预警总数</th><td>3（活跃: 0）</td></tr>\n</table>\n<h2>📍 最近轨迹（前 20 条，共 150）</h2>\n<table>\n  <tr><th>时间</th><th>坐标</th><th>速度</th><th>深度</th><th>水温</th></tr>\n  <tr><td>2026-05-03 10:54</td><td>9.2114, 107.6053</td><td>0.8</td><td>12.1</td><td>26.0°C</td></tr><tr><td>2026-05-03 06:03</td><td>9.2682, 107.6053</td><td>0.7</td><td>14.8</td><td>26.9°C</td></tr><tr><td>2026-05-03 00:43</td><td>9.2971, 107.4541</td><td>0.9</td><td>2.6</td><td>25.7°C</td></tr><tr><td>2026-05-02 20:27</td><td>9.2967, 107.4133</td><td>0.9</td><td>7.6</td><td>26.6°C</td></tr><tr><td>2026-05-02 14:51</td><td>9.1556, 107.5599</td><td>0.4</td><td>10.8</td><td>27.5°C</td></tr><tr><td>2026-05-02 10:46</td><td>9.3751, 107.4057</td><td>1.1</td><td>6.8</td><td>29.5°C</td></tr><tr><td>2026-05-02 06:01</td><td>9.2134, 107.5375</td><td>1.4</td><td>12.2</td><td>27.8°C</td></tr><tr><td>2026-05-02 00:34</td><td>9.1806, 107.4023</td><td>0.6</td><td>3.3</td><td>29.2°C</td></tr><tr><td>2026-05-01 19:37</td><td>9.3786, 107.5250</td><td>0.7</td><td>4.5</td><td>25.5°C</td></tr><tr><td>2026-05-01 15:07</td><td>9.3918, 107.3210</td><td>—</td><td>19.3</td><td>26.0°C</td></tr><tr><td>2026-05-01 10:32</td><td>9.3517, 107.4310</td><td>1.2</td><td>8.5</td><td>28.1°C</td></tr><tr><td>2026-05-01 06:03</td><td>9.1977, 107.5627</td><td>0.7</td><td>4.0</td><td>26.4°C</td></tr><tr><td>2026-05-01 01:12</td><td>9.3090, 107.5561</td><td>0.1</td><td>3.8</td><td>28.6°C</td></tr><tr><td>2026-04-30 20:11</td><td>9.3663, 107.4381</td><td>0.5</td><td>8.9</td><td>27.2°C</td></tr><tr><td>2026-04-30 14:59</td><td>9.1740, 107.3890</td><td>—</td><td>2.9</td><td>24.3°C</td></tr><tr><td>2026-04-30 10:40</td><td>9.1292, 107.5594</td><td>1.7</td><td>15.5</td><td>25.2°C</td></tr><tr><td>2026-04-30 05:13</td><td>9.2593, 107.4634</td><td>0.5</td><td>11.6</td><td>29.6°C</td></tr><tr><td>2026-04-30 00:46</td><td>9.3302, 107.4323</td><td>0.5</td><td>3.5</td><td>24.6°C</td></tr><tr><td>2026-04-29 20:30</td><td>9.1192, 107.3447</td><td>0.6</td><td>7.6</td><td>30.3°C</td></tr><tr><td>2026-04-29 15:37</td><td>9.3193, 107.4460</td><td>1.3</td><td>—</td><td>25.0°C</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:56 UTC\n  </div>\n</div>\n</body>\n</html>	\N	fc46d2d8-22a5-4135-a3ea-73654adc589e	2026-05-04 00:56:48.685136+08	2026-05-04 00:56:48.697686+08
79fe97ad-07b7-4a84-a6c4-ad44cccae918	Audit Alert	alert_summary	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>预警统计报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>预警统计报告</h1>\n    <div class="sub">Alert Statistics Report</div>\n  </div>\n  <div class="body">\n\n<h2>🔴 按严重程度</h2>\n<table>\n  <tr><th>级别</th><th>总数</th><th>活跃</th></tr>\n  <tr><td><span class='badge badge-critical'>CRITICAL</span></td><td>2</td><td>0</td></tr><tr><td><span class='badge badge-high'>HIGH</span></td><td>6</td><td>4</td></tr><tr><td><span class='badge badge-medium'>MEDIUM</span></td><td>0</td><td>0</td></tr><tr><td><span class='badge badge-low'>LOW</span></td><td>3</td><td>0</td></tr>\n</table>\n\n<h2>📂 按类型</h2>\n<table>\n  <tr><th>预警类型</th><th>数量</th></tr>\n  <tr><td>test</td><td>5</td></tr><tr><td>fishing</td><td>4</td></tr><tr><td>collision</td><td>2</td></tr>\n</table>\n\n<h2>🐢 预警最多的海龟 (Top 10)</h2>\n<table>\n  <tr><th>海龟 ID</th><th>预警数</th></tr>\n  <tr><td>BC-XS-2401</td><td>8</td></tr><tr><td>BC-CD-2304</td><td>3</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:56 UTC\n  </div>\n</div>\n</body>\n</html>	\N	fc46d2d8-22a5-4135-a3ea-73654adc589e	2026-05-04 00:56:48.703976+08	2026-05-04 00:56:48.716858+08
8acf5642-b3a0-4f60-9e20-7478f1068250	Audit Monthly	monthly_summary	\N	{"date_to": "2026-12-31", "date_from": "2026-01-01"}	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>月度保育摘要报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>月度保育摘要报告</h1>\n    <div class="sub">统计周期: 2026-01-01 ~ 2026-12-31</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">追踪中海龟</div></div>\n  <div class="stat-card"><div class="value">1,500</div><div class="label">新增轨迹点</div></div>\n  <div class="stat-card"><div class="value">11</div><div class="label">期间预警</div></div>\n  <div class="stat-card"><div class="value">7</div><div class="label">已解决预警</div></div>\n</div>\n\n<h2>📋 保育摘要</h2>\n<table>\n  <tr><th width="180">统计周期</th><td>2026-01-01 ~ 2026-12-31</td></tr>\n  <tr><th>追踪海龟数</th><td>10 只</td></tr>\n  <tr><th>新增轨迹数据</th><td>1,500 个定位点</td></tr>\n  <tr><th>期间预警</th><td>11 条</td></tr>\n  <tr><th>已解决预警</th><td>7 条</td></tr>\n  <tr><th>解决率</th><td>64%</td></tr>\n</table>\n\n<p style="margin-top:24px; color:#6b9fd4;">\n  📝 本报告由 Blue Circle 海龟追踪平台自动生成。如需详细数据，请访问\n  <a href="https://data.maskcube.com/" style="color:#2d8cf0;">data.maskcube.com</a>。\n</p>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 16:56 UTC\n  </div>\n</div>\n</body>\n</html>	\N	fc46d2d8-22a5-4135-a3ea-73654adc589e	2026-05-04 00:56:48.723255+08	2026-05-04 00:56:48.731699+08
683c6899-3c20-43e0-9a3b-92682ce1288d	Audit Fleet	fleet_overview	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>舰队总览报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>舰队总览报告</h1>\n    <div class="sub">共 10 只海龟 &middot; 3 个物种</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">海龟总数</div></div>\n  <div class="stat-card"><div class="value">10</div><div class="label">活跃海龟</div></div>\n  <div class="stat-card"><div class="value">3</div><div class="label">物种数</div></div>\n  <div class="stat-card"><div class="value">1,504</div><div class="label">轨迹总点数</div></div>\n  <div class="stat-card"><div class="value">12</div><div class="label">预警总数</div></div>\n  <div class="stat-card"><div class="value">4</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟舰队</h2>\n<table>\n  <tr><th>ID</th><th>名称</th><th>物种</th><th>性别</th><th>来源地</th><th>最后位置</th><th>电量</th><th>状态</th></tr>\n  <tr><td><strong>BC-CD-2304</strong></td><td>Côn Đảo</td><td>棱皮龟</td><td>F</td><td>越南昆岛</td><td>8.71, 106.61</td><td>62.0%</td><td>🟢</td></tr><tr><td><strong>BC-HD-2412</strong></td><td>惠东</td><td>绿海龟</td><td>F</td><td>广东惠东</td><td>22.60, 114.90</td><td>90.0%</td><td>🟢</td></tr><tr><td><strong>BC-HN-2418</strong></td><td>文昌</td><td>绿海龟</td><td>M</td><td>海南岛东岸</td><td>19.85, 111.20</td><td>77.0%</td><td>🟢</td></tr><tr><td><strong>BC-PG-2307</strong></td><td>Papua</td><td>棱皮龟</td><td>F</td><td>巴布亚</td><td>—</td><td>58.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2311</strong></td><td>望安</td><td>绿海龟</td><td>F</td><td>台湾澎湖望安岛</td><td>23.40, 119.60</td><td>71.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2425</strong></td><td>Palawan</td><td>绿海龟</td><td>F</td><td>菲律宾巴拉望</td><td>10.32, 118.74</td><td>65.0%</td><td>🟢</td></tr><tr><td><strong>BC-RY-2429</strong></td><td>琉球</td><td>绿海龟</td><td>F</td><td>琉球群岛</td><td>24.51, 124.18</td><td>79.0%</td><td>🟢</td></tr><tr><td><strong>BC-SB-2315</strong></td><td>Selingan</td><td>玳瑁</td><td>F</td><td>沙巴海龟群岛海洋公园</td><td>6.17, 118.04</td><td>43.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2401</strong></td><td>Luna</td><td>绿海龟</td><td>F</td><td>西沙七连屿北岛</td><td>17.12, 112.65</td><td>85.5%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2421</strong></td><td>Pearl</td><td>绿海龟</td><td>F</td><td>西沙北岛</td><td>17.10, 112.45</td><td>77.0%</td><td>🟢</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 17:05 UTC\n  </div>\n</div>\n</body>\n</html>	\N	e89d9a77-a8b6-4b98-944e-fa82c082e3ad	2026-05-04 01:05:32.217801+08	2026-05-04 01:05:32.231587+08
cbb83ef2-1f15-4981-a1c1-b0f0ebc09674	Audit Activity	turtle_activity	BC-CD-2304	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>海龟活动报告: Côn Đảo — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>海龟活动报告: Côn Đảo</h1>\n    <div class="sub">Report ID: cbb83ef2-1f15-4981-a1c1-b0f0ebc09674 &middot; 棱皮龟</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">150</div><div class="label">轨迹点</div></div>\n  <div class="stat-card"><div class="value">0.8</div><div class="label">平均速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">8.8</div><div class="label">平均深度 (m)</div></div>\n  <div class="stat-card"><div class="value">26.7°C</div><div class="label">平均水温</div></div>\n  <div class="stat-card"><div class="value">2.3</div><div class="label">最大速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">20.8</div><div class="label">最大深度 (m)</div></div>\n  <div class="stat-card"><div class="value">0</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟信息</h2>\n<table>\n  <tr><th width="140">ID</th><td>BC-CD-2304</td></tr>\n  <tr><th>名称</th><td>Côn Đảo (Côn Đảo)</td></tr>\n  <tr><th>物种</th><td>棱皮龟 (Leatherback)</td></tr>\n  <tr><th>性别</th><td>F</td></tr>\n  <tr><th>来源地</th><td>越南昆岛</td></tr>\n  <tr><th>甲长</th><td>148.0 cm</td></tr>\n  <tr><th>最新位置</th><td>8.7100, 106.6100</td></tr>\n  <tr><th>设备电量</th><td>62.0%</td></tr>\n  <tr><th>风险等级</th><td>high</td></tr>\n  <tr><th>预警总数</th><td>4（活跃: 0）</td></tr>\n</table>\n<h2>📍 最近轨迹（前 20 条，共 150）</h2>\n<table>\n  <tr><th>时间</th><th>坐标</th><th>速度</th><th>深度</th><th>水温</th></tr>\n  <tr><td>2026-05-03 10:54</td><td>9.2114, 107.6053</td><td>0.8</td><td>12.1</td><td>26.0°C</td></tr><tr><td>2026-05-03 06:03</td><td>9.2682, 107.6053</td><td>0.7</td><td>14.8</td><td>26.9°C</td></tr><tr><td>2026-05-03 00:43</td><td>9.2971, 107.4541</td><td>0.9</td><td>2.6</td><td>25.7°C</td></tr><tr><td>2026-05-02 20:27</td><td>9.2967, 107.4133</td><td>0.9</td><td>7.6</td><td>26.6°C</td></tr><tr><td>2026-05-02 14:51</td><td>9.1556, 107.5599</td><td>0.4</td><td>10.8</td><td>27.5°C</td></tr><tr><td>2026-05-02 10:46</td><td>9.3751, 107.4057</td><td>1.1</td><td>6.8</td><td>29.5°C</td></tr><tr><td>2026-05-02 06:01</td><td>9.2134, 107.5375</td><td>1.4</td><td>12.2</td><td>27.8°C</td></tr><tr><td>2026-05-02 00:34</td><td>9.1806, 107.4023</td><td>0.6</td><td>3.3</td><td>29.2°C</td></tr><tr><td>2026-05-01 19:37</td><td>9.3786, 107.5250</td><td>0.7</td><td>4.5</td><td>25.5°C</td></tr><tr><td>2026-05-01 15:07</td><td>9.3918, 107.3210</td><td>—</td><td>19.3</td><td>26.0°C</td></tr><tr><td>2026-05-01 10:32</td><td>9.3517, 107.4310</td><td>1.2</td><td>8.5</td><td>28.1°C</td></tr><tr><td>2026-05-01 06:03</td><td>9.1977, 107.5627</td><td>0.7</td><td>4.0</td><td>26.4°C</td></tr><tr><td>2026-05-01 01:12</td><td>9.3090, 107.5561</td><td>0.1</td><td>3.8</td><td>28.6°C</td></tr><tr><td>2026-04-30 20:11</td><td>9.3663, 107.4381</td><td>0.5</td><td>8.9</td><td>27.2°C</td></tr><tr><td>2026-04-30 14:59</td><td>9.1740, 107.3890</td><td>—</td><td>2.9</td><td>24.3°C</td></tr><tr><td>2026-04-30 10:40</td><td>9.1292, 107.5594</td><td>1.7</td><td>15.5</td><td>25.2°C</td></tr><tr><td>2026-04-30 05:13</td><td>9.2593, 107.4634</td><td>0.5</td><td>11.6</td><td>29.6°C</td></tr><tr><td>2026-04-30 00:46</td><td>9.3302, 107.4323</td><td>0.5</td><td>3.5</td><td>24.6°C</td></tr><tr><td>2026-04-29 20:30</td><td>9.1192, 107.3447</td><td>0.6</td><td>7.6</td><td>30.3°C</td></tr><tr><td>2026-04-29 15:37</td><td>9.3193, 107.4460</td><td>1.3</td><td>—</td><td>25.0°C</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 17:05 UTC\n  </div>\n</div>\n</body>\n</html>	\N	e89d9a77-a8b6-4b98-944e-fa82c082e3ad	2026-05-04 01:05:32.241021+08	2026-05-04 01:05:32.311215+08
9ce3b745-1400-4a18-8ec3-969eb03e9240	Audit Alert	alert_summary	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>预警统计报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>预警统计报告</h1>\n    <div class="sub">Alert Statistics Report</div>\n  </div>\n  <div class="body">\n\n<h2>🔴 按严重程度</h2>\n<table>\n  <tr><th>级别</th><th>总数</th><th>活跃</th></tr>\n  <tr><td><span class='badge badge-critical'>CRITICAL</span></td><td>2</td><td>0</td></tr><tr><td><span class='badge badge-high'>HIGH</span></td><td>6</td><td>4</td></tr><tr><td><span class='badge badge-medium'>MEDIUM</span></td><td>0</td><td>0</td></tr><tr><td><span class='badge badge-low'>LOW</span></td><td>4</td><td>0</td></tr>\n</table>\n\n<h2>📂 按类型</h2>\n<table>\n  <tr><th>预警类型</th><th>数量</th></tr>\n  <tr><td>test</td><td>6</td></tr><tr><td>fishing</td><td>4</td></tr><tr><td>collision</td><td>2</td></tr>\n</table>\n\n<h2>🐢 预警最多的海龟 (Top 10)</h2>\n<table>\n  <tr><th>海龟 ID</th><th>预警数</th></tr>\n  <tr><td>BC-XS-2401</td><td>8</td></tr><tr><td>BC-CD-2304</td><td>4</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 17:05 UTC\n  </div>\n</div>\n</body>\n</html>	\N	e89d9a77-a8b6-4b98-944e-fa82c082e3ad	2026-05-04 01:05:32.317854+08	2026-05-04 01:05:32.330573+08
3cc60438-c76b-478f-aa18-a624e9224a9d	Audit Monthly	monthly_summary	\N	{"date_to": "2026-12-31", "date_from": "2026-01-01"}	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>月度保育摘要报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>月度保育摘要报告</h1>\n    <div class="sub">统计周期: 2026-01-01 ~ 2026-12-31</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">追踪中海龟</div></div>\n  <div class="stat-card"><div class="value">1,504</div><div class="label">新增轨迹点</div></div>\n  <div class="stat-card"><div class="value">12</div><div class="label">期间预警</div></div>\n  <div class="stat-card"><div class="value">8</div><div class="label">已解决预警</div></div>\n</div>\n\n<h2>📋 保育摘要</h2>\n<table>\n  <tr><th width="180">统计周期</th><td>2026-01-01 ~ 2026-12-31</td></tr>\n  <tr><th>追踪海龟数</th><td>10 只</td></tr>\n  <tr><th>新增轨迹数据</th><td>1,504 个定位点</td></tr>\n  <tr><th>期间预警</th><td>12 条</td></tr>\n  <tr><th>已解决预警</th><td>8 条</td></tr>\n  <tr><th>解决率</th><td>67%</td></tr>\n</table>\n\n<p style="margin-top:24px; color:#6b9fd4;">\n  📝 本报告由 Blue Circle 海龟追踪平台自动生成。如需详细数据，请访问\n  <a href="https://data.maskcube.com/" style="color:#2d8cf0;">data.maskcube.com</a>。\n</p>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 17:05 UTC\n  </div>\n</div>\n</body>\n</html>	\N	e89d9a77-a8b6-4b98-944e-fa82c082e3ad	2026-05-04 01:05:32.336989+08	2026-05-04 01:05:32.345227+08
8264c214-e5c9-47a0-ada2-9403f1538ce6	Audit Fleet	fleet_overview	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>舰队总览报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>舰队总览报告</h1>\n    <div class="sub">共 10 只海龟 &middot; 3 个物种</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">海龟总数</div></div>\n  <div class="stat-card"><div class="value">10</div><div class="label">活跃海龟</div></div>\n  <div class="stat-card"><div class="value">3</div><div class="label">物种数</div></div>\n  <div class="stat-card"><div class="value">1,508</div><div class="label">轨迹总点数</div></div>\n  <div class="stat-card"><div class="value">13</div><div class="label">预警总数</div></div>\n  <div class="stat-card"><div class="value">4</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟舰队</h2>\n<table>\n  <tr><th>ID</th><th>名称</th><th>物种</th><th>性别</th><th>来源地</th><th>最后位置</th><th>电量</th><th>状态</th></tr>\n  <tr><td><strong>BC-CD-2304</strong></td><td>Côn Đảo</td><td>棱皮龟</td><td>F</td><td>越南昆岛</td><td>17.50, 113.00</td><td>88.0%</td><td>🟢</td></tr><tr><td><strong>BC-HD-2412</strong></td><td>惠东</td><td>绿海龟</td><td>F</td><td>广东惠东</td><td>22.70, 115.00</td><td>90.0%</td><td>🟢</td></tr><tr><td><strong>BC-HN-2418</strong></td><td>文昌</td><td>绿海龟</td><td>M</td><td>海南岛东岸</td><td>19.85, 111.20</td><td>77.0%</td><td>🟢</td></tr><tr><td><strong>BC-PG-2307</strong></td><td>Papua</td><td>棱皮龟</td><td>F</td><td>巴布亚</td><td>—</td><td>58.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2311</strong></td><td>望安</td><td>绿海龟</td><td>F</td><td>台湾澎湖望安岛</td><td>23.50, 119.70</td><td>71.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2425</strong></td><td>Palawan</td><td>绿海龟</td><td>F</td><td>菲律宾巴拉望</td><td>10.32, 118.74</td><td>65.0%</td><td>🟢</td></tr><tr><td><strong>BC-RY-2429</strong></td><td>琉球</td><td>绿海龟</td><td>F</td><td>琉球群岛</td><td>24.51, 124.18</td><td>79.0%</td><td>🟢</td></tr><tr><td><strong>BC-SB-2315</strong></td><td>Selingan</td><td>玳瑁</td><td>F</td><td>沙巴海龟群岛海洋公园</td><td>6.17, 118.04</td><td>43.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2401</strong></td><td>Luna</td><td>绿海龟</td><td>F</td><td>西沙七连屿北岛</td><td>19.00, 114.00</td><td>99.9%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2421</strong></td><td>Pearl</td><td>绿海龟</td><td>F</td><td>西沙北岛</td><td>17.10, 112.45</td><td>77.0%</td><td>🟢</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 17:13 UTC\n  </div>\n</div>\n</body>\n</html>	\N	2f1b9881-5529-4d85-ae81-ab856d6a5ede	2026-05-04 01:13:35.444758+08	2026-05-04 01:13:35.450056+08
f993bf26-0db5-4430-8456-f27dfa481ac2	Audit Activity	turtle_activity	BC-CD-2304	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>海龟活动报告: Côn Đảo — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>海龟活动报告: Côn Đảo</h1>\n    <div class="sub">Report ID: f993bf26-0db5-4430-8456-f27dfa481ac2 &middot; 棱皮龟</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">151</div><div class="label">轨迹点</div></div>\n  <div class="stat-card"><div class="value">0.8</div><div class="label">平均速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">8.8</div><div class="label">平均深度 (m)</div></div>\n  <div class="stat-card"><div class="value">26.7°C</div><div class="label">平均水温</div></div>\n  <div class="stat-card"><div class="value">2.3</div><div class="label">最大速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">20.8</div><div class="label">最大深度 (m)</div></div>\n  <div class="stat-card"><div class="value">0</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟信息</h2>\n<table>\n  <tr><th width="140">ID</th><td>BC-CD-2304</td></tr>\n  <tr><th>名称</th><td>Côn Đảo (Côn Đảo)</td></tr>\n  <tr><th>物种</th><td>棱皮龟 (Leatherback)</td></tr>\n  <tr><th>性别</th><td>F</td></tr>\n  <tr><th>来源地</th><td>越南昆岛</td></tr>\n  <tr><th>甲长</th><td>148.0 cm</td></tr>\n  <tr><th>最新位置</th><td>17.5000, 113.0000</td></tr>\n  <tr><th>设备电量</th><td>88.0%</td></tr>\n  <tr><th>风险等级</th><td>high</td></tr>\n  <tr><th>预警总数</th><td>5（活跃: 0）</td></tr>\n</table>\n<h2>📍 最近轨迹（前 20 条，共 151）</h2>\n<table>\n  <tr><th>时间</th><th>坐标</th><th>速度</th><th>深度</th><th>水温</th></tr>\n  <tr><td>2026-05-03 17:05</td><td>17.5000, 113.0000</td><td>2.0</td><td>10.0</td><td>27.0°C</td></tr><tr><td>2026-05-03 10:54</td><td>9.2114, 107.6053</td><td>0.8</td><td>12.1</td><td>26.0°C</td></tr><tr><td>2026-05-03 06:03</td><td>9.2682, 107.6053</td><td>0.7</td><td>14.8</td><td>26.9°C</td></tr><tr><td>2026-05-03 00:43</td><td>9.2971, 107.4541</td><td>0.9</td><td>2.6</td><td>25.7°C</td></tr><tr><td>2026-05-02 20:27</td><td>9.2967, 107.4133</td><td>0.9</td><td>7.6</td><td>26.6°C</td></tr><tr><td>2026-05-02 14:51</td><td>9.1556, 107.5599</td><td>0.4</td><td>10.8</td><td>27.5°C</td></tr><tr><td>2026-05-02 10:46</td><td>9.3751, 107.4057</td><td>1.1</td><td>6.8</td><td>29.5°C</td></tr><tr><td>2026-05-02 06:01</td><td>9.2134, 107.5375</td><td>1.4</td><td>12.2</td><td>27.8°C</td></tr><tr><td>2026-05-02 00:34</td><td>9.1806, 107.4023</td><td>0.6</td><td>3.3</td><td>29.2°C</td></tr><tr><td>2026-05-01 19:37</td><td>9.3786, 107.5250</td><td>0.7</td><td>4.5</td><td>25.5°C</td></tr><tr><td>2026-05-01 15:07</td><td>9.3918, 107.3210</td><td>—</td><td>19.3</td><td>26.0°C</td></tr><tr><td>2026-05-01 10:32</td><td>9.3517, 107.4310</td><td>1.2</td><td>8.5</td><td>28.1°C</td></tr><tr><td>2026-05-01 06:03</td><td>9.1977, 107.5627</td><td>0.7</td><td>4.0</td><td>26.4°C</td></tr><tr><td>2026-05-01 01:12</td><td>9.3090, 107.5561</td><td>0.1</td><td>3.8</td><td>28.6°C</td></tr><tr><td>2026-04-30 20:11</td><td>9.3663, 107.4381</td><td>0.5</td><td>8.9</td><td>27.2°C</td></tr><tr><td>2026-04-30 14:59</td><td>9.1740, 107.3890</td><td>—</td><td>2.9</td><td>24.3°C</td></tr><tr><td>2026-04-30 10:40</td><td>9.1292, 107.5594</td><td>1.7</td><td>15.5</td><td>25.2°C</td></tr><tr><td>2026-04-30 05:13</td><td>9.2593, 107.4634</td><td>0.5</td><td>11.6</td><td>29.6°C</td></tr><tr><td>2026-04-30 00:46</td><td>9.3302, 107.4323</td><td>0.5</td><td>3.5</td><td>24.6°C</td></tr><tr><td>2026-04-29 20:30</td><td>9.1192, 107.3447</td><td>0.6</td><td>7.6</td><td>30.3°C</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 17:13 UTC\n  </div>\n</div>\n</body>\n</html>	\N	2f1b9881-5529-4d85-ae81-ab856d6a5ede	2026-05-04 01:13:35.456808+08	2026-05-04 01:13:35.464604+08
9b2851dd-328f-45d8-be17-5528514494ae	Audit Alert	alert_summary	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>预警统计报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>预警统计报告</h1>\n    <div class="sub">Alert Statistics Report</div>\n  </div>\n  <div class="body">\n\n<h2>🔴 按严重程度</h2>\n<table>\n  <tr><th>级别</th><th>总数</th><th>活跃</th></tr>\n  <tr><td><span class='badge badge-critical'>CRITICAL</span></td><td>2</td><td>0</td></tr><tr><td><span class='badge badge-high'>HIGH</span></td><td>6</td><td>4</td></tr><tr><td><span class='badge badge-medium'>MEDIUM</span></td><td>0</td><td>0</td></tr><tr><td><span class='badge badge-low'>LOW</span></td><td>5</td><td>0</td></tr>\n</table>\n\n<h2>📂 按类型</h2>\n<table>\n  <tr><th>预警类型</th><th>数量</th></tr>\n  <tr><td>test</td><td>7</td></tr><tr><td>fishing</td><td>4</td></tr><tr><td>collision</td><td>2</td></tr>\n</table>\n\n<h2>🐢 预警最多的海龟 (Top 10)</h2>\n<table>\n  <tr><th>海龟 ID</th><th>预警数</th></tr>\n  <tr><td>BC-XS-2401</td><td>8</td></tr><tr><td>BC-CD-2304</td><td>5</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 17:13 UTC\n  </div>\n</div>\n</body>\n</html>	\N	2f1b9881-5529-4d85-ae81-ab856d6a5ede	2026-05-04 01:13:35.470815+08	2026-05-04 01:13:35.479756+08
a7a07ecb-c4a4-40ae-b59a-6a9b296b9b4d	Audit Monthly	monthly_summary	\N	{"date_to": "2026-12-31", "date_from": "2026-01-01"}	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>月度保育摘要报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>月度保育摘要报告</h1>\n    <div class="sub">统计周期: 2026-01-01 ~ 2026-12-31</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">追踪中海龟</div></div>\n  <div class="stat-card"><div class="value">1,508</div><div class="label">新增轨迹点</div></div>\n  <div class="stat-card"><div class="value">13</div><div class="label">期间预警</div></div>\n  <div class="stat-card"><div class="value">9</div><div class="label">已解决预警</div></div>\n</div>\n\n<h2>📋 保育摘要</h2>\n<table>\n  <tr><th width="180">统计周期</th><td>2026-01-01 ~ 2026-12-31</td></tr>\n  <tr><th>追踪海龟数</th><td>10 只</td></tr>\n  <tr><th>新增轨迹数据</th><td>1,508 个定位点</td></tr>\n  <tr><th>期间预警</th><td>13 条</td></tr>\n  <tr><th>已解决预警</th><td>9 条</td></tr>\n  <tr><th>解决率</th><td>69%</td></tr>\n</table>\n\n<p style="margin-top:24px; color:#6b9fd4;">\n  📝 本报告由 Blue Circle 海龟追踪平台自动生成。如需详细数据，请访问\n  <a href="https://data.maskcube.com/" style="color:#2d8cf0;">data.maskcube.com</a>。\n</p>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 17:13 UTC\n  </div>\n</div>\n</body>\n</html>	\N	2f1b9881-5529-4d85-ae81-ab856d6a5ede	2026-05-04 01:13:35.485987+08	2026-05-04 01:13:35.490945+08
8902e4e6-f006-4e3a-a99c-7e1760511159	Audit Fleet	fleet_overview	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>舰队总览报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>舰队总览报告</h1>\n    <div class="sub">共 10 只海龟 &middot; 3 个物种</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">海龟总数</div></div>\n  <div class="stat-card"><div class="value">10</div><div class="label">活跃海龟</div></div>\n  <div class="stat-card"><div class="value">3</div><div class="label">物种数</div></div>\n  <div class="stat-card"><div class="value">1,511</div><div class="label">轨迹总点数</div></div>\n  <div class="stat-card"><div class="value">14</div><div class="label">预警总数</div></div>\n  <div class="stat-card"><div class="value">4</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟舰队</h2>\n<table>\n  <tr><th>ID</th><th>名称</th><th>物种</th><th>性别</th><th>来源地</th><th>最后位置</th><th>电量</th><th>状态</th></tr>\n  <tr><td><strong>BC-CD-2304</strong></td><td>Côn Đảo</td><td>棱皮龟</td><td>F</td><td>越南昆岛</td><td>17.50, 113.00</td><td>88.0%</td><td>🟢</td></tr><tr><td><strong>BC-HD-2412</strong></td><td>惠东</td><td>绿海龟</td><td>F</td><td>广东惠东</td><td>22.70, 115.00</td><td>90.0%</td><td>🟢</td></tr><tr><td><strong>BC-HN-2418</strong></td><td>文昌</td><td>绿海龟</td><td>M</td><td>海南岛东岸</td><td>19.85, 111.20</td><td>77.0%</td><td>🟢</td></tr><tr><td><strong>BC-PG-2307</strong></td><td>Papua</td><td>棱皮龟</td><td>F</td><td>巴布亚</td><td>—</td><td>58.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2311</strong></td><td>望安</td><td>绿海龟</td><td>F</td><td>台湾澎湖望安岛</td><td>23.50, 119.70</td><td>71.0%</td><td>🟢</td></tr><tr><td><strong>BC-PH-2425</strong></td><td>Palawan</td><td>绿海龟</td><td>F</td><td>菲律宾巴拉望</td><td>10.32, 118.74</td><td>65.0%</td><td>🟢</td></tr><tr><td><strong>BC-RY-2429</strong></td><td>琉球</td><td>绿海龟</td><td>F</td><td>琉球群岛</td><td>24.51, 124.18</td><td>79.0%</td><td>🟢</td></tr><tr><td><strong>BC-SB-2315</strong></td><td>Selingan</td><td>玳瑁</td><td>F</td><td>沙巴海龟群岛海洋公园</td><td>6.17, 118.04</td><td>43.0%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2401</strong></td><td>Luna</td><td>绿海龟</td><td>F</td><td>西沙七连屿北岛</td><td>19.00, 114.00</td><td>99.9%</td><td>🟢</td></tr><tr><td><strong>BC-XS-2421</strong></td><td>Pearl</td><td>绿海龟</td><td>F</td><td>西沙北岛</td><td>17.10, 112.45</td><td>77.0%</td><td>🟢</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 17:20 UTC\n  </div>\n</div>\n</body>\n</html>	\N	2f0b0b7f-9d19-49da-8062-899e870200bc	2026-05-04 01:20:09.217316+08	2026-05-04 01:20:09.223161+08
8aee5f3d-239d-42a3-9196-955956e2d6e5	Audit Activity	turtle_activity	BC-CD-2304	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>海龟活动报告: Côn Đảo — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>海龟活动报告: Côn Đảo</h1>\n    <div class="sub">Report ID: 8aee5f3d-239d-42a3-9196-955956e2d6e5 &middot; 棱皮龟</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">152</div><div class="label">轨迹点</div></div>\n  <div class="stat-card"><div class="value">0.8</div><div class="label">平均速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">8.8</div><div class="label">平均深度 (m)</div></div>\n  <div class="stat-card"><div class="value">26.7°C</div><div class="label">平均水温</div></div>\n  <div class="stat-card"><div class="value">2.3</div><div class="label">最大速度 (km/h)</div></div>\n  <div class="stat-card"><div class="value">20.8</div><div class="label">最大深度 (m)</div></div>\n  <div class="stat-card"><div class="value">0</div><div class="label">活跃预警</div></div>\n</div>\n<h2>🐢 海龟信息</h2>\n<table>\n  <tr><th width="140">ID</th><td>BC-CD-2304</td></tr>\n  <tr><th>名称</th><td>Côn Đảo (Côn Đảo)</td></tr>\n  <tr><th>物种</th><td>棱皮龟 (Leatherback)</td></tr>\n  <tr><th>性别</th><td>F</td></tr>\n  <tr><th>来源地</th><td>越南昆岛</td></tr>\n  <tr><th>甲长</th><td>148.0 cm</td></tr>\n  <tr><th>最新位置</th><td>17.5000, 113.0000</td></tr>\n  <tr><th>设备电量</th><td>88.0%</td></tr>\n  <tr><th>风险等级</th><td>high</td></tr>\n  <tr><th>预警总数</th><td>6（活跃: 0）</td></tr>\n</table>\n<h2>📍 最近轨迹（前 20 条，共 152）</h2>\n<table>\n  <tr><th>时间</th><th>坐标</th><th>速度</th><th>深度</th><th>水温</th></tr>\n  <tr><td>2026-05-03 17:13</td><td>17.5000, 113.0000</td><td>2.0</td><td>10.0</td><td>27.0°C</td></tr><tr><td>2026-05-03 17:05</td><td>17.5000, 113.0000</td><td>2.0</td><td>10.0</td><td>27.0°C</td></tr><tr><td>2026-05-03 10:54</td><td>9.2114, 107.6053</td><td>0.8</td><td>12.1</td><td>26.0°C</td></tr><tr><td>2026-05-03 06:03</td><td>9.2682, 107.6053</td><td>0.7</td><td>14.8</td><td>26.9°C</td></tr><tr><td>2026-05-03 00:43</td><td>9.2971, 107.4541</td><td>0.9</td><td>2.6</td><td>25.7°C</td></tr><tr><td>2026-05-02 20:27</td><td>9.2967, 107.4133</td><td>0.9</td><td>7.6</td><td>26.6°C</td></tr><tr><td>2026-05-02 14:51</td><td>9.1556, 107.5599</td><td>0.4</td><td>10.8</td><td>27.5°C</td></tr><tr><td>2026-05-02 10:46</td><td>9.3751, 107.4057</td><td>1.1</td><td>6.8</td><td>29.5°C</td></tr><tr><td>2026-05-02 06:01</td><td>9.2134, 107.5375</td><td>1.4</td><td>12.2</td><td>27.8°C</td></tr><tr><td>2026-05-02 00:34</td><td>9.1806, 107.4023</td><td>0.6</td><td>3.3</td><td>29.2°C</td></tr><tr><td>2026-05-01 19:37</td><td>9.3786, 107.5250</td><td>0.7</td><td>4.5</td><td>25.5°C</td></tr><tr><td>2026-05-01 15:07</td><td>9.3918, 107.3210</td><td>—</td><td>19.3</td><td>26.0°C</td></tr><tr><td>2026-05-01 10:32</td><td>9.3517, 107.4310</td><td>1.2</td><td>8.5</td><td>28.1°C</td></tr><tr><td>2026-05-01 06:03</td><td>9.1977, 107.5627</td><td>0.7</td><td>4.0</td><td>26.4°C</td></tr><tr><td>2026-05-01 01:12</td><td>9.3090, 107.5561</td><td>0.1</td><td>3.8</td><td>28.6°C</td></tr><tr><td>2026-04-30 20:11</td><td>9.3663, 107.4381</td><td>0.5</td><td>8.9</td><td>27.2°C</td></tr><tr><td>2026-04-30 14:59</td><td>9.1740, 107.3890</td><td>—</td><td>2.9</td><td>24.3°C</td></tr><tr><td>2026-04-30 10:40</td><td>9.1292, 107.5594</td><td>1.7</td><td>15.5</td><td>25.2°C</td></tr><tr><td>2026-04-30 05:13</td><td>9.2593, 107.4634</td><td>0.5</td><td>11.6</td><td>29.6°C</td></tr><tr><td>2026-04-30 00:46</td><td>9.3302, 107.4323</td><td>0.5</td><td>3.5</td><td>24.6°C</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 17:20 UTC\n  </div>\n</div>\n</body>\n</html>	\N	2f0b0b7f-9d19-49da-8062-899e870200bc	2026-05-04 01:20:09.229793+08	2026-05-04 01:20:09.237698+08
9155832d-69ed-4d0c-baea-f650b9a8dfc4	Audit Alert	alert_summary	\N	null	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>预警统计报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>预警统计报告</h1>\n    <div class="sub">Alert Statistics Report</div>\n  </div>\n  <div class="body">\n\n<h2>🔴 按严重程度</h2>\n<table>\n  <tr><th>级别</th><th>总数</th><th>活跃</th></tr>\n  <tr><td><span class='badge badge-critical'>CRITICAL</span></td><td>2</td><td>0</td></tr><tr><td><span class='badge badge-high'>HIGH</span></td><td>6</td><td>4</td></tr><tr><td><span class='badge badge-medium'>MEDIUM</span></td><td>0</td><td>0</td></tr><tr><td><span class='badge badge-low'>LOW</span></td><td>6</td><td>0</td></tr>\n</table>\n\n<h2>📂 按类型</h2>\n<table>\n  <tr><th>预警类型</th><th>数量</th></tr>\n  <tr><td>test</td><td>8</td></tr><tr><td>fishing</td><td>4</td></tr><tr><td>collision</td><td>2</td></tr>\n</table>\n\n<h2>🐢 预警最多的海龟 (Top 10)</h2>\n<table>\n  <tr><th>海龟 ID</th><th>预警数</th></tr>\n  <tr><td>BC-XS-2401</td><td>8</td></tr><tr><td>BC-CD-2304</td><td>6</td></tr>\n</table>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 17:20 UTC\n  </div>\n</div>\n</body>\n</html>	\N	2f0b0b7f-9d19-49da-8062-899e870200bc	2026-05-04 01:20:09.244256+08	2026-05-04 01:20:09.252931+08
81a0f651-41ac-456c-92f5-b87cffa08207	Audit Monthly	monthly_summary	\N	{"date_to": "2026-12-31", "date_from": "2026-01-01"}	completed	<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>月度保育摘要报告 — Blue Circle</title>\n<style>\n  * { margin:0; padding:0; box-sizing:border-box; }\n  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n         background:#0a1628; color:#e0e8f0; padding:40px; line-height:1.7; }\n  .report { max-width:900px; margin:0 auto; background:#0f1f38; border-radius:12px;\n             border:1px solid #1a3050; overflow:hidden; }\n  .header { background:linear-gradient(135deg, #1a3a5c, #0d2847); padding:32px 40px;\n             border-bottom:3px solid #2d8cf0; }\n  .header h1 { color:#fff; font-size:24px; margin-bottom:4px; }\n  .header .sub { color:#6b9fd4; font-size:14px; }\n  .body { padding:32px 40px; }\n  .footer { padding:20px 40px; border-top:1px solid #1a3050; color:#4a6a8a; font-size:12px; }\n  h2 { color:#2d8cf0; font-size:18px; margin:24px 0 12px; border-bottom:1px solid #1a3050; padding-bottom:8px; }\n  h2:first-child { margin-top:0; }\n  table { width:100%; border-collapse:collapse; margin:12px 0; }\n  th { background:#152a45; color:#6b9fd4; padding:10px 12px; text-align:left; font-size:13px; }\n  td { padding:10px 12px; border-bottom:1px solid #152a45; font-size:14px; }\n  tr:hover td { background:#152a45; }\n  .stat-card { display:inline-block; background:#152a45; border-radius:8px; padding:16px 24px;\n                margin:6px 8px 6px 0; min-width:140px; text-align:center; }\n  .stat-card .value { font-size:28px; font-weight:bold; color:#2d8cf0; }\n  .stat-card .label { font-size:12px; color:#6b9fd4; margin-top:4px; }\n  .badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; }\n  .badge-critical { background:#4a1a1a; color:#f06060; }\n  .badge-high { background:#4a2a1a; color:#f09040; }\n  .badge-medium { background:#3a3a1a; color:#f0c040; }\n  .badge-low { background:#1a3a1a; color:#60d060; }\n  .no-data { color:#4a6a8a; font-style:italic; padding:20px; text-align:center; }\n  .divider { border:none; border-top:1px solid #1a3050; margin:24px 0; }\n</style>\n</head>\n<body>\n<div class="report">\n  <div class="header">\n    <h1>月度保育摘要报告</h1>\n    <div class="sub">统计周期: 2026-01-01 ~ 2026-12-31</div>\n  </div>\n  <div class="body">\n\n<div style="margin-bottom:20px;">\n  <div class="stat-card"><div class="value">10</div><div class="label">追踪中海龟</div></div>\n  <div class="stat-card"><div class="value">1,511</div><div class="label">新增轨迹点</div></div>\n  <div class="stat-card"><div class="value">14</div><div class="label">期间预警</div></div>\n  <div class="stat-card"><div class="value">10</div><div class="label">已解决预警</div></div>\n</div>\n\n<h2>📋 保育摘要</h2>\n<table>\n  <tr><th width="180">统计周期</th><td>2026-01-01 ~ 2026-12-31</td></tr>\n  <tr><th>追踪海龟数</th><td>10 只</td></tr>\n  <tr><th>新增轨迹数据</th><td>1,511 个定位点</td></tr>\n  <tr><th>期间预警</th><td>14 条</td></tr>\n  <tr><th>已解决预警</th><td>10 条</td></tr>\n  <tr><th>解决率</th><td>71%</td></tr>\n</table>\n\n<p style="margin-top:24px; color:#6b9fd4;">\n  📝 本报告由 Blue Circle 海龟追踪平台自动生成。如需详细数据，请访问\n  <a href="https://data.maskcube.com/" style="color:#2d8cf0;">data.maskcube.com</a>。\n</p>\n  </div>\n  <div class="footer">\n    Generated by Blue Circle 海龟追踪平台 &middot; 2026-05-03 17:20 UTC\n  </div>\n</div>\n</body>\n</html>	\N	2f0b0b7f-9d19-49da-8062-899e870200bc	2026-05-04 01:20:09.259374+08	2026-05-04 01:20:09.264555+08
\.


--
-- Data for Name: track_points; Type: TABLE DATA; Schema: public; Owner: bluecircle
--

COPY public.track_points ("time", turtle_id, lat, lng, battery_pct, speed_kmh, depth_m, temperature_c, source) FROM stdin;
2026-05-04 01:04:05.684288+08	BC-XS-2401	17.123000	112.654000	85.5	\N	\N	\N	device
2026-05-04 01:04:28.63399+08	BC-XS-2401	17.123000	112.654000	\N	\N	\N	\N	device
2026-05-04 01:04:28.665274+08	BC-HD-2412	22.600000	114.900000	90.0	\N	\N	\N	device
2026-05-04 01:04:28.66813+08	BC-PH-2311	23.400000	119.600000	\N	2.10	\N	\N	device
2026-05-04 01:05:32.467533+08	BC-CD-2304	17.500000	113.000000	88.0	2.00	10.0	27.0	audit
2026-05-04 01:05:32.482639+08	BC-HD-2412	22.700000	115.000000	90.0	\N	\N	\N	device
2026-05-04 01:05:32.485284+08	BC-PH-2311	23.500000	119.700000	\N	3.00	\N	\N	device
2026-05-04 01:06:13.417467+08	BC-XS-2401	18.999000	113.999000	99.9	\N	\N	\N	device
2026-05-04 01:13:35.56933+08	BC-CD-2304	17.500000	113.000000	88.0	2.00	10.0	27.0	audit
2026-05-04 01:13:35.580732+08	BC-HD-2412	22.700000	115.000000	90.0	\N	\N	\N	device
2026-05-04 01:13:35.583186+08	BC-PH-2311	23.500000	119.700000	\N	3.00	\N	\N	device
2026-05-04 01:20:09.343214+08	BC-CD-2304	17.500000	113.000000	88.0	2.00	10.0	27.0	audit
2026-05-04 01:20:09.354841+08	BC-HD-2412	22.700000	115.000000	90.0	\N	\N	\N	device
2026-05-04 01:20:09.357444+08	BC-PH-2311	23.500000	119.700000	\N	3.00	\N	\N	device
2026-05-04 03:12:53+08	BC-HD-2412	22.550000	114.890000	80.0	\N	\N	\N	spot
2026-05-04 03:12:53+08	BC-PH-2311	23.370000	119.500000	80.0	\N	\N	\N	spot
2026-05-04 03:12:53+08	BC-RY-2429	24.510000	124.180000	20.0	\N	\N	\N	spot
2026-05-04 03:12:53+08	BC-SB-2315	6.170000	118.040000	20.0	\N	\N	\N	spot
2026-05-03 18:00:00+08	BC-PG-2307	-3.500000	135.420000	78.0	\N	42.3	28.5	argos
2026-04-03 23:27:39.139259+08	BC-XS-2401	16.952210	112.466774	96.6	0.75	9.4	28.0	satellite
2026-04-04 03:47:40.662966+08	BC-XS-2401	16.951631	112.179070	100.9	1.04	0.0	29.0	drone
2026-04-04 08:35:43.821892+08	BC-XS-2401	17.075492	112.454534	96.9	1.44	11.9	26.6	satellite
2026-04-04 13:41:22.330018+08	BC-XS-2401	16.907228	112.351151	94.7	0.65	0.0	28.0	drone
2026-04-04 18:31:06.904986+08	BC-XS-2401	17.112260	112.456052	94.0	0.96	3.9	26.9	satellite
2026-04-04 22:56:04.390424+08	BC-XS-2401	17.020533	112.445892	96.2	1.78	10.5	24.2	buoy
2026-04-05 04:32:00.663292+08	BC-XS-2401	17.149221	112.475546	102.5	1.55	10.5	27.9	satellite
2026-04-05 08:57:57.730071+08	BC-XS-2401	16.898456	112.403026	93.9	0.93	3.0	25.7	satellite
2026-04-05 13:28:08.495075+08	BC-XS-2401	16.955752	112.450379	92.9	0.30	2.0	26.4	buoy
2026-04-05 18:00:06.850304+08	BC-XS-2401	16.926133	112.443057	96.5	0.63	3.0	31.2	satellite
2026-04-05 23:09:28.92799+08	BC-XS-2401	16.887695	112.287349	100.4	0.33	0.0	25.4	satellite
2026-04-06 03:49:38.748414+08	BC-XS-2401	17.012911	112.405873	92.4	1.36	2.8	23.4	satellite
2026-04-06 09:09:11.290971+08	BC-XS-2401	16.916267	112.353573	92.2	0.97	21.1	24.9	satellite
2026-04-06 13:31:00.004285+08	BC-XS-2401	17.026342	112.315550	93.3	2.72	15.9	26.3	satellite
2026-04-06 18:04:41.787687+08	BC-XS-2401	17.186512	112.428623	94.4	0.85	8.2	24.7	buoy
2026-04-06 23:19:52.483462+08	BC-XS-2401	16.959989	112.282029	92.7	0.94	3.7	23.2	satellite
2026-04-07 03:40:11.95668+08	BC-XS-2401	16.916312	112.209308	94.5	1.19	1.7	27.5	drone
2026-04-07 08:47:50.094242+08	BC-XS-2401	17.050447	112.355242	99.5	1.18	2.4	24.6	satellite
2026-04-07 14:05:04.70627+08	BC-XS-2401	17.017718	112.471811	95.2	0.81	11.4	25.5	satellite
2026-04-07 18:51:24.359395+08	BC-XS-2401	17.013140	112.480382	95.5	1.32	0.0	28.1	satellite
2026-04-07 23:35:45.046897+08	BC-XS-2401	17.166698	112.235236	90.8	0.99	20.2	25.8	buoy
2026-04-08 03:53:29.554289+08	BC-XS-2401	17.011829	112.290066	94.2	1.37	11.2	27.7	drone
2026-04-08 08:22:58.211137+08	BC-XS-2401	17.163427	112.400438	98.2	0.71	12.8	21.4	satellite
2026-04-08 13:15:18.950659+08	BC-XS-2401	17.039448	112.397772	95.1	0.67	14.0	29.5	satellite
2026-04-08 18:22:40.820268+08	BC-XS-2401	17.160323	112.415863	95.5	0.88	10.3	27.4	buoy
2026-04-08 22:53:57.362738+08	BC-XS-2401	17.095947	112.300373	94.6	0.60	13.5	26.2	buoy
2026-04-09 04:13:55.036113+08	BC-XS-2401	17.142806	112.444162	97.6	0.42	13.2	22.8	buoy
2026-04-09 08:51:37.255436+08	BC-XS-2401	17.101752	112.242606	88.9	0.77	11.7	24.4	drone
2026-04-09 13:57:52.378792+08	BC-XS-2401	17.119813	112.410893	95.4	0.58	13.5	28.3	satellite
2026-04-09 18:41:10.853745+08	BC-XS-2401	17.099799	112.420430	88.8	0.52	0.0	25.9	satellite
2026-04-09 23:06:00.824678+08	BC-XS-2401	17.177247	112.385883	95.8	1.20	11.0	28.4	satellite
2026-04-10 04:20:37.550289+08	BC-XS-2401	17.188370	112.363274	92.9	0.29	12.7	25.8	satellite
2026-04-10 08:45:05.541963+08	BC-XS-2401	17.135087	112.513897	95.4	1.63	16.6	26.7	satellite
2026-04-10 13:18:36.401216+08	BC-XS-2401	17.056912	112.259629	88.5	1.23	7.2	29.3	buoy
2026-04-10 18:24:32.382966+08	BC-XS-2401	17.162715	112.401486	91.5	1.31	8.7	30.4	buoy
2026-04-10 23:04:31.947439+08	BC-XS-2401	17.172511	112.499931	88.1	0.97	1.4	25.3	satellite
2026-04-11 04:10:50.813552+08	BC-XS-2401	17.060175	112.539202	90.7	0.00	13.9	27.8	drone
2026-04-11 09:01:31.56682+08	BC-XS-2401	17.322414	112.406107	92.3	1.20	12.6	24.2	drone
2026-04-11 13:54:39.780768+08	BC-XS-2401	17.150077	112.333211	91.3	0.83	0.0	31.1	satellite
2026-04-11 18:11:26.073805+08	BC-XS-2401	17.314279	112.538627	90.0	0.96	15.2	29.5	buoy
2026-04-11 22:49:13.565092+08	BC-XS-2401	17.233021	112.396325	92.5	1.31	10.8	29.5	satellite
2026-04-12 04:07:40.650214+08	BC-XS-2401	17.232377	112.371164	86.7	0.38	12.9	25.1	satellite
2026-04-12 08:32:55.609711+08	BC-XS-2401	17.363264	112.317150	90.6	1.99	5.8	27.0	satellite
2026-04-12 13:29:40.46025+08	BC-XS-2401	17.210049	112.277886	89.8	0.78	14.8	26.1	satellite
2026-04-12 18:50:11.244274+08	BC-XS-2401	17.336973	112.350142	83.4	0.84	16.7	28.4	buoy
2026-04-12 23:24:10.339508+08	BC-XS-2401	17.324178	112.426186	87.0	0.66	3.3	19.8	drone
2026-04-13 04:26:55.834368+08	BC-XS-2401	17.330455	112.508487	83.2	1.41	10.6	28.4	satellite
2026-04-13 08:44:23.746254+08	BC-XS-2401	17.214266	112.358976	87.3	0.96	0.0	26.7	buoy
2026-04-13 13:41:41.772956+08	BC-XS-2401	17.203232	112.288986	89.0	1.03	5.0	26.4	satellite
2026-04-13 18:01:29.512437+08	BC-XS-2401	17.237229	112.407146	88.5	0.14	6.8	27.3	satellite
2026-04-13 23:08:36.27551+08	BC-XS-2401	17.349424	112.536061	81.8	0.40	3.8	20.8	satellite
2026-04-14 04:24:41.952548+08	BC-XS-2401	17.368064	112.281224	91.3	0.27	11.2	25.6	satellite
2026-04-14 09:19:08.708218+08	BC-XS-2401	17.361997	112.369005	83.8	1.34	6.4	23.7	satellite
2026-04-14 13:38:14.102689+08	BC-XS-2401	17.332478	112.489977	82.6	0.00	4.3	23.3	buoy
2026-04-14 18:18:12.696559+08	BC-XS-2401	17.430942	112.411416	83.4	0.71	2.7	26.1	satellite
2026-04-14 23:10:59.016432+08	BC-XS-2401	17.315151	112.302939	86.7	2.09	5.7	25.1	satellite
2026-04-15 04:27:15.849728+08	BC-XS-2401	17.195696	112.314429	87.3	1.90	16.0	26.0	satellite
2026-04-15 08:23:05.826536+08	BC-XS-2401	17.432821	112.439178	82.7	0.79	12.6	26.0	buoy
2026-04-15 13:54:08.432967+08	BC-XS-2401	17.350864	112.445117	88.3	0.40	6.6	22.8	satellite
2026-04-15 18:07:07.773253+08	BC-XS-2401	17.236811	112.303288	83.8	1.15	4.5	26.6	satellite
2026-04-15 23:19:15.707112+08	BC-XS-2401	17.400976	112.419900	81.2	0.79	14.5	28.4	satellite
2026-04-16 03:44:50.183114+08	BC-XS-2401	17.446688	112.454717	85.7	0.77	11.6	27.6	buoy
2026-04-16 09:11:08.330743+08	BC-XS-2401	17.446474	112.435867	87.9	0.90	19.2	27.7	buoy
2026-04-16 13:52:15.530786+08	BC-XS-2401	17.387660	112.445436	88.0	0.07	8.9	25.0	satellite
2026-04-16 18:02:32.343167+08	BC-XS-2401	17.434553	112.408810	84.1	0.71	8.3	25.9	satellite
2026-04-16 23:26:08.809313+08	BC-XS-2401	17.510105	112.312987	77.8	0.72	6.8	25.1	satellite
2026-04-17 04:09:32.786954+08	BC-XS-2401	17.255403	112.482908	82.6	0.28	9.2	27.0	satellite
2026-04-17 08:20:35.402498+08	BC-XS-2401	17.253163	112.402032	80.8	1.51	10.8	26.7	satellite
2026-04-17 13:27:22.077934+08	BC-XS-2401	17.405660	112.557179	84.4	0.49	7.2	27.0	buoy
2026-04-17 18:53:53.100458+08	BC-XS-2401	17.460865	112.461617	83.3	0.30	11.8	28.5	satellite
2026-04-17 22:54:10.326398+08	BC-XS-2401	17.292350	112.327211	86.3	1.62	0.0	24.5	drone
2026-04-18 04:24:51.022746+08	BC-XS-2401	17.501901	112.443703	76.5	0.54	15.7	27.2	satellite
2026-04-18 09:18:45.869911+08	BC-XS-2401	17.421899	112.512920	84.9	0.37	0.0	30.7	satellite
2026-04-18 14:02:19.208013+08	BC-XS-2401	17.325990	112.353750	81.4	0.00	8.6	28.0	satellite
2026-04-18 18:42:51.727222+08	BC-XS-2401	17.526140	112.411190	78.3	0.36	4.5	27.5	satellite
2026-04-18 23:39:17.020951+08	BC-XS-2401	17.311548	112.594004	84.4	0.46	15.4	27.0	satellite
2026-04-19 03:47:41.138627+08	BC-XS-2401	17.494692	112.617672	74.9	0.92	6.9	26.9	satellite
2026-04-19 08:33:35.302328+08	BC-XS-2401	17.341442	112.482034	75.7	0.78	8.1	21.7	satellite
2026-04-19 14:03:50.862863+08	BC-XS-2401	17.433229	112.433101	79.5	1.26	0.0	21.5	satellite
2026-04-19 18:18:31.286574+08	BC-XS-2401	17.515567	112.531584	74.8	0.59	1.5	26.9	satellite
2026-04-19 23:30:18.65928+08	BC-XS-2401	17.595340	112.416070	80.5	0.88	10.5	25.4	buoy
2026-04-20 04:30:19.277137+08	BC-XS-2401	17.464875	112.386248	76.7	1.96	13.8	24.6	satellite
2026-04-20 09:13:32.788101+08	BC-XS-2401	17.590781	112.592539	81.4	1.40	9.2	26.7	satellite
2026-04-20 14:07:44.227011+08	BC-XS-2401	17.514589	112.410314	79.4	0.00	6.1	32.1	satellite
2026-04-20 18:36:36.527808+08	BC-XS-2401	17.611336	112.567422	77.0	0.58	10.6	26.5	satellite
2026-04-20 23:29:28.987887+08	BC-XS-2401	17.450307	112.404228	73.0	1.29	10.5	28.8	satellite
2026-04-21 04:17:40.811112+08	BC-XS-2401	17.525534	112.366290	78.1	0.64	4.0	27.2	buoy
2026-04-21 08:21:23.679934+08	BC-XS-2401	17.497304	112.396869	80.8	0.56	6.2	27.2	satellite
2026-04-21 13:55:37.367474+08	BC-XS-2401	17.379475	112.568375	75.0	1.42	10.6	27.5	drone
2026-04-21 18:11:13.83431+08	BC-XS-2401	17.624976	112.647490	81.1	1.20	7.0	26.7	satellite
2026-04-21 23:31:34.490786+08	BC-XS-2401	17.605893	112.435259	79.5	0.08	7.5	28.1	satellite
2026-04-22 03:34:26.633383+08	BC-XS-2401	17.520289	112.498963	73.4	0.39	5.0	25.9	satellite
2026-04-22 09:05:06.193503+08	BC-XS-2401	17.528490	112.382172	72.8	1.15	10.0	28.5	buoy
2026-04-22 13:43:22.937201+08	BC-XS-2401	17.486641	112.546443	74.8	0.54	3.7	24.9	satellite
2026-04-22 18:31:27.371057+08	BC-XS-2401	17.585520	112.583779	79.0	1.10	14.2	23.5	satellite
2026-04-22 23:24:25.684764+08	BC-XS-2401	17.594591	112.559485	73.6	1.13	4.3	26.8	satellite
2026-04-23 04:00:16.175929+08	BC-XS-2401	17.567801	112.426368	72.5	1.01	12.2	27.3	satellite
2026-04-23 09:05:18.644448+08	BC-XS-2401	17.465974	112.459970	72.6	0.79	6.7	25.2	satellite
2026-04-23 13:12:09.290164+08	BC-XS-2401	17.624523	112.470156	72.6	0.01	4.5	24.2	satellite
2026-04-23 18:12:31.666706+08	BC-XS-2401	17.638774	112.659826	77.9	1.12	6.9	26.4	satellite
2026-04-23 22:49:16.136406+08	BC-XS-2401	17.624544	112.511890	77.0	0.98	10.5	28.4	satellite
2026-04-24 03:36:59.685227+08	BC-XS-2401	17.692814	112.526857	71.3	0.61	6.9	25.7	satellite
2026-04-24 09:05:13.483606+08	BC-XS-2401	17.440991	112.416557	69.2	1.03	10.5	26.3	drone
2026-04-24 13:18:44.2505+08	BC-XS-2401	17.617067	112.494542	73.0	0.52	11.5	24.4	satellite
2026-04-24 18:25:44.961102+08	BC-XS-2401	17.639018	112.480126	71.6	0.72	1.5	28.4	satellite
2026-04-24 22:57:37.717138+08	BC-XS-2401	17.643513	112.660914	69.0	0.07	13.9	28.3	drone
2026-04-25 03:56:10.564579+08	BC-XS-2401	17.624584	112.533520	72.3	2.25	6.2	23.5	satellite
2026-04-25 09:16:19.026795+08	BC-XS-2401	17.480286	112.672673	68.1	0.06	16.3	26.6	drone
2026-04-25 13:28:00.796907+08	BC-XS-2401	17.501168	112.646629	75.7	0.53	0.0	26.8	drone
2026-04-25 18:49:09.238326+08	BC-XS-2401	17.691712	112.537125	73.0	0.92	8.6	24.0	buoy
2026-04-25 23:35:11.808125+08	BC-XS-2401	17.650943	112.521177	73.3	0.34	8.6	27.2	drone
2026-04-26 03:46:27.010852+08	BC-XS-2401	17.737749	112.625607	67.5	0.30	9.5	24.0	satellite
2026-04-26 08:38:27.917734+08	BC-XS-2401	17.642495	112.469987	66.7	0.94	11.0	23.0	satellite
2026-04-26 13:58:10.570656+08	BC-XS-2401	17.537616	112.454527	74.0	1.29	0.0	23.4	satellite
2026-04-26 18:27:51.774956+08	BC-XS-2401	17.785742	112.430241	66.6	1.62	8.8	28.6	drone
2026-04-26 23:35:42.875673+08	BC-XS-2401	17.694341	112.524270	73.0	0.97	10.9	25.3	satellite
2026-04-27 03:54:32.444418+08	BC-XS-2401	17.556199	112.615681	65.5	0.03	3.6	25.3	drone
2026-04-27 08:58:57.553105+08	BC-XS-2401	17.606700	112.474572	73.3	0.75	6.2	25.4	satellite
2026-04-27 13:20:33.300033+08	BC-XS-2401	17.572281	112.447191	70.0	0.90	15.0	26.0	satellite
2026-04-27 18:30:02.129927+08	BC-XS-2401	17.570504	112.468707	64.5	1.54	0.4	25.3	satellite
2026-04-27 22:49:37.709098+08	BC-XS-2401	17.837372	112.559256	66.0	0.66	5.4	26.7	satellite
2026-04-28 03:38:52.434587+08	BC-XS-2401	17.664614	112.516871	63.3	1.65	1.7	28.7	satellite
2026-04-28 09:07:27.06848+08	BC-XS-2401	17.810212	112.555415	63.3	1.61	2.1	26.8	buoy
2026-04-28 13:54:24.486155+08	BC-XS-2401	17.620432	112.501299	66.7	0.55	2.2	26.9	satellite
2026-04-28 18:22:28.975161+08	BC-XS-2401	17.808226	112.493559	66.3	1.30	3.4	27.9	satellite
2026-04-28 22:48:21.518825+08	BC-XS-2401	17.727095	112.675900	69.3	0.05	6.9	26.1	buoy
2026-04-29 04:10:23.915943+08	BC-XS-2401	17.599285	112.539887	63.6	0.66	11.8	26.4	satellite
2026-04-29 08:58:13.33285+08	BC-XS-2401	17.648115	112.594855	69.9	1.14	7.2	28.6	satellite
2026-04-29 13:44:18.042574+08	BC-XS-2401	17.780622	112.527074	67.4	0.23	5.8	28.5	satellite
2026-04-29 18:04:08.161234+08	BC-XS-2401	17.794600	112.685893	64.5	0.16	1.4	26.5	satellite
2026-04-29 22:58:09.199042+08	BC-XS-2401	17.886495	112.630425	64.5	1.96	5.4	22.9	satellite
2026-04-30 04:11:18.978657+08	BC-XS-2401	17.619197	112.617600	60.3	1.40	10.5	27.5	satellite
2026-04-30 08:32:42.760923+08	BC-XS-2401	17.644594	112.719300	60.7	1.17	9.8	25.8	drone
2026-04-30 13:13:35.935294+08	BC-XS-2401	17.728886	112.683718	66.4	0.56	3.2	23.9	satellite
2026-04-30 17:57:02.229421+08	BC-XS-2401	17.765440	112.692306	66.8	0.67	8.6	27.4	buoy
2026-04-30 23:19:32.349034+08	BC-XS-2401	17.705016	112.642794	66.8	0.34	7.5	27.3	satellite
2026-05-01 04:02:24.491818+08	BC-XS-2401	17.735933	112.485832	65.2	0.54	8.9	26.7	satellite
2026-05-01 08:23:34.49493+08	BC-XS-2401	17.935301	112.597999	66.1	0.87	9.0	28.1	satellite
2026-05-01 13:54:18.809152+08	BC-XS-2401	17.676129	112.581841	65.2	0.97	14.6	22.7	drone
2026-05-01 18:28:12.224898+08	BC-XS-2401	17.841404	112.651584	63.9	0.29	12.3	29.0	buoy
2026-05-01 23:27:24.445258+08	BC-XS-2401	17.794404	112.613205	58.7	0.61	9.3	25.7	satellite
2026-05-02 03:54:58.942634+08	BC-XS-2401	17.766885	112.583664	59.5	0.02	9.6	29.1	satellite
2026-05-02 09:01:12.037442+08	BC-XS-2401	17.840985	112.521660	59.3	0.52	12.3	24.4	drone
2026-05-02 13:31:24.720046+08	BC-XS-2401	17.751687	112.579801	64.6	0.27	6.3	22.7	satellite
2026-05-02 18:44:04.982253+08	BC-XS-2401	17.767677	112.620981	61.8	0.44	6.3	24.4	buoy
2026-05-02 22:53:35.431896+08	BC-XS-2401	17.750296	112.585803	62.3	0.10	16.6	26.1	satellite
2026-05-03 03:36:05.07807+08	BC-XS-2401	17.767349	112.524701	65.1	0.70	22.8	25.4	satellite
2026-05-03 09:14:04.218593+08	BC-XS-2401	17.802269	112.563889	55.9	1.10	11.7	24.0	drone
2026-05-03 13:30:55.521347+08	BC-XS-2401	17.737869	112.587001	57.6	0.32	4.3	28.6	satellite
2026-05-03 18:11:30.846209+08	BC-XS-2401	17.810634	112.508003	59.6	1.03	10.7	26.9	satellite
2026-04-03 23:25:43.152949+08	BC-HD-2412	22.681890	114.822888	102.1	0.21	12.5	26.6	buoy
2026-04-04 04:14:30.240517+08	BC-HD-2412	22.444213	114.800332	101.1	0.00	4.1	26.6	satellite
2026-04-04 09:12:18.597077+08	BC-HD-2412	22.637722	115.018003	96.6	0.97	9.3	25.5	satellite
2026-04-04 13:34:02.491271+08	BC-HD-2412	22.631109	114.788475	101.8	1.22	7.2	24.6	buoy
2026-04-04 18:03:57.562668+08	BC-HD-2412	22.577703	114.880488	96.7	0.98	9.5	27.8	satellite
2026-04-04 23:11:28.898512+08	BC-HD-2412	22.470943	114.863137	94.1	0.00	4.7	26.6	satellite
2026-04-05 03:43:48.488024+08	BC-HD-2412	22.435807	114.984446	99.3	0.38	2.2	23.1	satellite
2026-04-05 08:37:53.956181+08	BC-HD-2412	22.481187	114.848317	97.6	1.39	9.1	27.9	satellite
2026-04-05 13:37:09.075866+08	BC-HD-2412	22.484425	114.810454	98.6	1.14	0.7	24.1	buoy
2026-04-05 18:21:47.89224+08	BC-HD-2412	22.509301	114.745399	94.4	1.28	9.4	27.2	drone
2026-04-05 23:13:12.376949+08	BC-HD-2412	22.479907	115.000603	98.3	1.18	4.2	25.3	drone
2026-04-06 04:26:19.608715+08	BC-HD-2412	22.559156	114.808281	94.6	0.92	2.6	24.9	satellite
2026-04-06 09:02:21.998086+08	BC-HD-2412	22.595096	114.843459	96.2	1.14	12.3	30.5	satellite
2026-04-06 13:26:16.545321+08	BC-HD-2412	22.586286	115.001710	98.5	0.92	5.5	24.7	satellite
2026-04-06 18:14:40.946415+08	BC-HD-2412	22.726300	114.738665	99.6	1.26	13.8	25.1	satellite
2026-04-06 23:28:37.293027+08	BC-HD-2412	22.512825	114.714000	100.7	1.69	0.0	29.5	satellite
2026-04-07 03:37:13.794683+08	BC-HD-2412	22.529556	114.816481	98.2	0.38	11.5	23.2	satellite
2026-04-07 08:44:29.296238+08	BC-HD-2412	22.553112	114.922072	95.4	0.38	5.0	29.5	satellite
2026-04-07 13:51:01.861058+08	BC-HD-2412	22.720159	114.992389	99.8	0.69	6.0	22.3	drone
2026-04-07 18:05:41.350966+08	BC-HD-2412	22.530036	114.828875	90.9	0.77	0.0	26.2	satellite
2026-04-07 22:52:39.602576+08	BC-HD-2412	22.673832	114.855771	94.6	1.06	9.6	24.8	buoy
2026-04-08 03:43:12.136508+08	BC-HD-2412	22.768162	114.914672	93.5	0.05	1.8	27.6	satellite
2026-04-08 08:28:28.278258+08	BC-HD-2412	22.609752	114.862085	91.7	0.80	0.9	27.4	satellite
2026-04-08 13:13:29.281892+08	BC-HD-2412	22.771330	114.858669	94.5	1.24	10.2	27.5	satellite
2026-04-08 18:09:24.760115+08	BC-HD-2412	22.756141	114.865010	94.8	0.65	1.6	29.0	satellite
2026-04-08 23:32:28.41576+08	BC-HD-2412	22.583136	114.941438	89.4	0.96	4.7	27.1	drone
2026-04-09 04:29:00.983696+08	BC-HD-2412	22.780424	114.731346	90.1	1.73	3.5	31.0	satellite
2026-04-09 09:06:51.19478+08	BC-HD-2412	22.848290	114.975536	94.9	1.19	0.0	26.0	satellite
2026-04-09 13:49:12.809078+08	BC-HD-2412	22.652207	114.831819	94.6	1.08	8.1	29.8	satellite
2026-04-09 18:23:22.90721+08	BC-HD-2412	22.868383	114.770543	89.6	0.46	9.6	26.7	satellite
2026-04-09 23:36:13.931833+08	BC-HD-2412	22.880442	114.926715	96.2	1.18	9.3	28.4	buoy
2026-04-10 04:17:29.420083+08	BC-HD-2412	22.880514	114.780759	90.9	1.16	4.9	26.0	drone
2026-04-10 08:37:12.949193+08	BC-HD-2412	22.702917	114.815911	95.9	0.88	12.2	26.9	drone
2026-04-10 13:31:56.526199+08	BC-HD-2412	22.777079	114.826568	90.2	0.39	12.9	22.8	satellite
2026-04-10 18:31:30.818349+08	BC-HD-2412	22.610609	114.909008	87.3	0.75	11.3	26.3	drone
2026-04-10 22:58:14.105724+08	BC-HD-2412	22.864259	114.809661	89.2	1.82	7.5	27.9	buoy
2026-04-11 03:35:55.249703+08	BC-HD-2412	22.662877	114.766086	90.1	1.10	2.2	27.5	satellite
2026-04-11 08:26:59.584876+08	BC-HD-2412	22.859827	114.924472	92.5	0.39	0.0	29.4	buoy
2026-04-11 13:36:36.267737+08	BC-HD-2412	22.782814	114.927699	90.7	0.69	8.2	25.2	satellite
2026-04-11 18:00:36.425281+08	BC-HD-2412	22.871933	114.692112	91.4	1.08	12.0	25.9	satellite
2026-04-11 23:32:51.041216+08	BC-HD-2412	22.938315	114.817756	86.8	0.93	5.4	30.2	drone
2026-04-12 03:32:44.30801+08	BC-HD-2412	22.659987	114.662053	93.9	1.23	6.0	27.6	satellite
2026-04-12 08:46:51.31172+08	BC-HD-2412	22.700376	114.704066	87.1	0.69	13.6	27.8	satellite
2026-04-12 13:40:02.608033+08	BC-HD-2412	22.687529	114.798703	92.5	1.16	15.5	25.2	drone
2026-04-12 18:25:39.773932+08	BC-HD-2412	22.921775	114.948133	83.3	0.98	6.5	29.6	satellite
2026-04-12 23:31:00.752673+08	BC-HD-2412	22.771422	114.814008	85.0	1.86	5.7	24.1	satellite
2026-04-13 04:09:43.099878+08	BC-HD-2412	22.889069	114.866662	83.3	1.07	0.0	25.6	buoy
2026-04-13 09:08:34.714461+08	BC-HD-2412	22.747373	114.713384	92.2	0.48	7.1	28.1	buoy
2026-04-13 13:28:26.786098+08	BC-HD-2412	22.707900	114.654545	88.4	0.82	2.1	26.8	satellite
2026-04-13 18:14:04.627803+08	BC-HD-2412	22.777215	114.869658	88.4	1.58	12.4	25.3	satellite
2026-04-13 23:22:20.802999+08	BC-HD-2412	22.989266	114.663787	83.3	1.06	1.1	25.5	satellite
2026-04-14 03:48:47.273395+08	BC-HD-2412	22.787647	114.829455	87.7	0.64	8.7	23.6	drone
2026-04-14 08:35:50.643908+08	BC-HD-2412	22.984288	114.729537	83.4	0.55	7.3	24.7	satellite
2026-04-14 13:54:31.859885+08	BC-HD-2412	22.784601	114.770746	90.4	0.57	11.0	27.8	satellite
2026-04-14 18:08:41.709392+08	BC-HD-2412	22.981526	114.822062	86.8	0.00	10.0	27.2	drone
2026-04-14 23:39:16.18392+08	BC-HD-2412	22.817732	114.677680	85.6	0.40	1.7	28.6	satellite
2026-04-15 04:19:45.707722+08	BC-HD-2412	22.954314	114.925014	82.2	1.34	4.8	24.7	satellite
2026-04-15 09:18:03.882542+08	BC-HD-2412	23.037682	114.683536	84.9	1.35	9.8	24.8	buoy
2026-04-15 13:51:41.371429+08	BC-HD-2412	22.856587	114.835861	82.1	0.00	16.5	26.6	satellite
2026-04-15 18:26:43.218281+08	BC-HD-2412	22.988377	114.770395	82.6	0.85	20.3	29.2	drone
2026-04-15 23:35:28.429584+08	BC-HD-2412	22.882480	114.760491	80.0	0.54	5.1	24.4	drone
2026-04-16 04:22:01.608326+08	BC-HD-2412	22.956756	114.839969	83.1	1.65	12.3	29.7	drone
2026-04-16 09:00:34.877935+08	BC-HD-2412	23.027576	114.855933	81.7	0.69	11.3	24.6	satellite
2026-04-16 14:03:01.591038+08	BC-HD-2412	22.850522	114.835420	81.5	1.65	0.0	28.9	satellite
2026-04-16 18:49:41.538347+08	BC-HD-2412	23.027888	114.820850	83.5	0.67	11.7	30.9	buoy
2026-04-16 23:00:22.980732+08	BC-HD-2412	22.961527	114.814646	81.4	1.22	8.7	25.6	satellite
2026-04-17 03:59:41.445365+08	BC-HD-2412	22.864693	114.847241	80.8	0.95	8.1	26.0	satellite
2026-04-17 08:58:32.099535+08	BC-HD-2412	22.806557	114.832588	84.1	1.02	2.1	27.5	buoy
2026-04-17 14:06:46.135728+08	BC-HD-2412	22.828633	114.664457	81.1	0.14	12.1	26.8	satellite
2026-04-17 18:01:05.600182+08	BC-HD-2412	22.999954	114.785919	78.1	1.37	5.5	23.1	buoy
2026-04-17 23:35:19.625023+08	BC-HD-2412	22.977313	114.696422	77.1	1.18	10.5	23.1	buoy
2026-04-18 04:12:45.229025+08	BC-HD-2412	22.965216	114.851741	79.6	0.70	8.1	25.1	satellite
2026-04-18 08:43:46.310513+08	BC-HD-2412	22.853106	114.662211	76.3	0.00	10.9	27.0	satellite
2026-04-18 13:55:33.814936+08	BC-HD-2412	22.953227	114.798867	82.7	0.57	7.3	28.8	satellite
2026-04-18 18:35:58.8689+08	BC-HD-2412	23.080983	114.811979	77.8	1.45	15.1	28.8	satellite
2026-04-18 23:19:44.985234+08	BC-HD-2412	23.119682	114.771422	83.0	1.42	3.1	28.7	buoy
2026-04-19 03:51:52.066218+08	BC-HD-2412	23.094327	114.723339	81.5	1.53	20.5	29.9	buoy
2026-04-19 08:41:43.806716+08	BC-HD-2412	23.022449	114.605956	76.1	0.52	1.2	24.8	satellite
2026-04-19 13:59:54.113393+08	BC-HD-2412	22.935450	114.682887	80.5	0.09	5.1	26.1	satellite
2026-04-19 18:53:45.214385+08	BC-HD-2412	23.037575	114.820665	76.7	0.00	3.2	28.2	buoy
2026-04-19 23:08:31.615856+08	BC-HD-2412	22.947253	114.654299	79.9	0.69	7.0	25.7	drone
2026-04-20 03:56:40.934724+08	BC-HD-2412	23.149135	114.775179	75.7	0.86	7.5	28.6	satellite
2026-04-20 08:58:11.993136+08	BC-HD-2412	23.151455	114.666938	78.6	0.61	5.5	28.9	satellite
2026-04-20 13:45:09.30371+08	BC-HD-2412	23.027826	114.634070	82.4	0.24	9.8	26.0	satellite
2026-04-20 18:56:23.170007+08	BC-HD-2412	23.156551	114.682429	79.5	0.76	0.0	26.7	satellite
2026-04-20 23:26:00.16623+08	BC-HD-2412	22.914142	114.655143	79.2	0.39	16.9	27.6	drone
2026-04-21 04:21:19.10087+08	BC-HD-2412	23.159539	114.855647	75.0	0.96	0.0	25.7	drone
2026-04-21 09:09:15.532159+08	BC-HD-2412	23.195226	114.583007	81.3	0.06	8.6	25.1	buoy
2026-04-21 14:07:06.411824+08	BC-HD-2412	22.945756	114.752975	78.9	1.88	0.0	27.7	buoy
2026-04-21 18:34:53.285969+08	BC-HD-2412	23.038725	114.837472	80.2	0.55	6.0	26.0	satellite
2026-04-21 23:19:47.059044+08	BC-HD-2412	22.941254	114.685401	79.2	1.39	13.5	25.5	buoy
2026-04-22 03:47:30.567204+08	BC-HD-2412	23.241992	114.824852	71.2	0.50	7.8	27.4	drone
2026-04-22 09:06:14.529565+08	BC-HD-2412	23.135535	114.761403	74.7	0.64	17.8	30.6	buoy
2026-04-22 13:49:47.873219+08	BC-HD-2412	23.042452	114.773881	72.4	1.07	11.6	25.0	satellite
2026-04-22 18:02:46.623681+08	BC-HD-2412	23.054820	114.793218	77.7	0.92	13.9	27.0	drone
2026-04-22 23:08:21.613797+08	BC-HD-2412	23.094752	114.752536	75.6	1.31	4.6	26.2	satellite
2026-04-23 04:16:08.557232+08	BC-HD-2412	23.031385	114.784363	71.9	1.07	6.6	30.1	satellite
2026-04-23 09:13:13.958646+08	BC-HD-2412	23.123711	114.841539	69.6	0.95	12.0	25.3	satellite
2026-04-23 13:19:32.660397+08	BC-HD-2412	23.176743	114.633679	69.5	2.03	7.5	28.3	drone
2026-04-23 18:06:53.992808+08	BC-HD-2412	23.165717	114.823630	76.6	0.00	13.6	26.8	satellite
2026-04-23 22:50:24.032566+08	BC-HD-2412	23.015615	114.549144	74.2	0.57	17.8	26.8	satellite
2026-04-24 03:58:00.864831+08	BC-HD-2412	23.008298	114.760642	73.6	0.45	13.9	26.6	satellite
2026-04-24 08:24:18.806648+08	BC-HD-2412	23.045609	114.772867	72.4	1.00	8.9	26.7	satellite
2026-04-24 13:20:29.615197+08	BC-HD-2412	23.306642	114.559898	71.3	0.45	16.4	28.6	satellite
2026-04-24 18:14:23.422133+08	BC-HD-2412	23.184418	114.615769	72.9	0.30	13.7	25.3	drone
2026-04-24 23:00:16.729487+08	BC-HD-2412	23.159379	114.614402	75.3	0.37	4.5	23.3	satellite
2026-04-25 04:18:06.726304+08	BC-HD-2412	23.245439	114.793013	76.1	0.25	5.4	26.2	satellite
2026-04-25 08:29:05.160607+08	BC-HD-2412	23.239104	114.822102	69.5	0.50	10.2	23.7	satellite
2026-04-25 13:20:35.050136+08	BC-HD-2412	23.232259	114.787170	71.4	1.51	9.6	23.0	satellite
2026-04-25 18:29:59.057156+08	BC-HD-2412	23.086383	114.559814	68.9	0.15	9.0	31.1	drone
2026-04-25 23:28:31.185883+08	BC-HD-2412	23.186663	114.789672	72.8	0.70	8.8	24.6	buoy
2026-04-26 03:36:21.144581+08	BC-HD-2412	23.068216	114.758171	69.2	0.50	11.8	25.1	satellite
2026-04-26 08:53:15.663628+08	BC-HD-2412	23.191841	114.706441	65.9	1.17	6.4	27.7	satellite
2026-04-26 13:49:38.257389+08	BC-HD-2412	23.174983	114.523098	69.9	0.67	9.0	27.4	satellite
2026-04-26 18:52:19.183871+08	BC-HD-2412	23.264628	114.742599	68.3	0.92	8.0	29.0	satellite
2026-04-26 23:07:49.673672+08	BC-HD-2412	23.091736	114.634225	69.9	0.18	11.1	23.3	satellite
2026-04-27 03:53:41.754684+08	BC-HD-2412	23.136168	114.793254	69.8	1.98	7.1	28.4	satellite
2026-04-27 08:42:05.318135+08	BC-HD-2412	23.277894	114.617608	72.5	0.55	6.3	23.2	drone
2026-04-27 13:47:42.455603+08	BC-HD-2412	23.395814	114.769353	65.4	1.45	17.9	32.4	drone
2026-04-27 18:04:24.100931+08	BC-HD-2412	23.188669	114.575665	63.6	0.59	4.7	27.5	drone
2026-04-27 23:11:24.539787+08	BC-HD-2412	23.371195	114.594943	68.6	0.96	10.4	23.5	satellite
2026-04-28 03:43:24.579345+08	BC-HD-2412	23.242026	114.770027	69.0	1.80	6.9	29.1	drone
2026-04-28 08:25:45.927651+08	BC-HD-2412	23.200526	114.779704	64.3	1.49	7.6	27.5	satellite
2026-04-28 13:33:29.056092+08	BC-HD-2412	23.385037	114.654236	71.9	0.53	0.8	26.7	satellite
2026-04-28 18:10:02.648793+08	BC-HD-2412	23.198835	114.621297	65.5	1.58	9.4	26.2	satellite
2026-04-28 23:34:53.711216+08	BC-HD-2412	23.374898	114.521910	63.9	0.40	9.8	28.5	satellite
2026-04-29 04:19:18.917147+08	BC-HD-2412	23.183760	114.787827	68.7	0.59	19.0	23.0	buoy
2026-04-29 09:07:24.046645+08	BC-HD-2412	23.334086	114.766401	62.2	1.28	15.5	27.4	drone
2026-04-29 13:16:21.310372+08	BC-HD-2412	23.460875	114.506112	65.9	0.84	5.3	26.7	drone
2026-04-29 18:12:30.927229+08	BC-HD-2412	23.266403	114.551293	68.5	0.62	0.0	25.3	satellite
2026-04-29 23:32:12.419724+08	BC-HD-2412	23.242295	114.549511	66.0	0.50	15.6	23.6	satellite
2026-04-30 04:30:25.392366+08	BC-HD-2412	23.402651	114.626606	63.9	0.80	8.0	28.0	satellite
2026-04-30 08:23:07.138199+08	BC-HD-2412	23.194405	114.763330	67.5	1.13	11.2	27.4	drone
2026-04-30 14:02:00.842262+08	BC-HD-2412	23.238345	114.473861	63.0	1.32	2.3	24.5	buoy
2026-04-30 18:48:49.653966+08	BC-HD-2412	23.321682	114.486757	60.5	1.14	6.0	25.1	buoy
2026-04-30 23:06:09.25511+08	BC-HD-2412	23.410697	114.563109	60.4	1.06	10.1	26.9	satellite
2026-05-01 04:25:30.250647+08	BC-HD-2412	23.221342	114.653237	63.6	1.31	10.4	27.5	buoy
2026-05-01 08:57:34.550893+08	BC-HD-2412	23.317291	114.564886	63.9	1.22	8.0	27.7	satellite
2026-05-01 13:56:18.007713+08	BC-HD-2412	23.345290	114.715001	60.2	0.19	9.2	27.3	satellite
2026-05-01 18:28:33.010326+08	BC-HD-2412	23.258571	114.553557	59.4	0.94	12.3	27.4	buoy
2026-05-01 23:22:03.653582+08	BC-HD-2412	23.391210	114.564086	59.1	1.18	6.2	22.8	satellite
2026-05-02 04:05:37.580988+08	BC-HD-2412	23.442012	114.529152	61.8	0.20	16.1	29.0	satellite
2026-05-02 08:34:05.361584+08	BC-HD-2412	23.273356	114.512374	60.5	0.55	4.9	25.5	buoy
2026-05-02 13:30:18.271122+08	BC-HD-2412	23.424330	114.486417	62.1	0.42	10.7	24.3	satellite
2026-05-02 18:28:59.456753+08	BC-HD-2412	23.469271	114.595928	62.0	0.68	9.9	25.6	satellite
2026-05-02 22:44:56.508627+08	BC-HD-2412	23.497433	114.727560	62.7	0.76	3.7	25.7	buoy
2026-05-03 03:38:03.844749+08	BC-HD-2412	23.298056	114.731540	61.6	0.44	7.4	24.6	buoy
2026-05-03 08:51:13.474871+08	BC-HD-2412	23.359381	114.504641	60.6	0.45	3.3	26.2	satellite
2026-05-03 13:35:39.573425+08	BC-HD-2412	23.498180	114.589812	64.4	1.78	6.3	27.1	satellite
2026-05-03 18:35:04.903199+08	BC-HD-2412	23.473847	114.592672	59.6	0.42	12.1	25.8	satellite
2026-04-03 23:40:20.04175+08	BC-HN-2418	19.881987	111.224776	95.7	0.92	8.0	29.8	satellite
2026-04-04 03:39:35.027698+08	BC-HN-2418	19.929099	111.344073	101.8	0.99	10.8	26.5	buoy
2026-04-04 08:30:14.49711+08	BC-HN-2418	19.877509	111.142759	97.1	0.46	15.0	24.0	buoy
2026-04-04 13:58:21.532959+08	BC-HN-2418	19.823437	111.111835	96.3	0.78	11.0	25.1	satellite
2026-04-04 18:40:41.45639+08	BC-HN-2418	19.843586	111.302898	101.2	0.00	17.2	27.8	buoy
2026-04-04 23:41:35.316529+08	BC-HN-2418	19.925697	111.088075	98.0	0.83	11.0	29.2	buoy
2026-04-05 04:28:56.244006+08	BC-HN-2418	19.898208	111.328617	102.7	0.13	0.0	27.1	satellite
2026-04-05 08:26:31.233523+08	BC-HN-2418	19.706643	111.332008	100.9	1.76	9.3	26.2	drone
2026-04-05 13:44:07.736471+08	BC-HN-2418	19.944799	111.151829	99.1	0.00	13.4	26.5	drone
2026-04-05 18:03:09.61233+08	BC-HN-2418	19.915830	111.275073	102.3	0.00	0.7	28.5	satellite
2026-04-05 23:05:41.217433+08	BC-HN-2418	19.939062	111.171742	97.2	0.90	18.8	30.5	satellite
2026-04-06 03:43:40.849191+08	BC-HN-2418	19.903178	111.292612	96.0	1.51	7.4	23.1	buoy
2026-04-06 08:48:04.770377+08	BC-HN-2418	19.763495	111.146067	96.1	1.76	6.0	23.5	satellite
2026-04-06 13:21:39.107131+08	BC-HN-2418	19.752821	111.349807	93.4	0.50	0.1	25.5	satellite
2026-04-06 18:36:45.272507+08	BC-HN-2418	19.860038	111.171195	92.4	0.49	8.1	26.0	drone
2026-04-06 23:01:51.238912+08	BC-HN-2418	19.893149	111.258895	96.2	1.24	9.0	29.6	drone
2026-04-07 04:04:00.176358+08	BC-HN-2418	19.669596	111.324860	97.6	0.12	1.3	24.8	satellite
2026-04-07 08:37:50.290528+08	BC-HN-2418	19.914912	111.215174	91.4	1.19	8.7	25.5	buoy
2026-04-07 13:17:40.592137+08	BC-HN-2418	19.892843	111.366235	91.6	0.20	10.3	26.1	buoy
2026-04-07 18:14:07.421083+08	BC-HN-2418	19.903318	111.314917	91.8	0.28	15.7	28.0	drone
2026-04-07 23:21:08.760059+08	BC-HN-2418	19.928295	111.338263	97.2	0.39	7.5	26.4	drone
2026-04-08 04:00:05.062314+08	BC-HN-2418	19.912020	111.327180	91.8	0.50	5.5	25.9	satellite
2026-04-08 09:20:13.42685+08	BC-HN-2418	19.737328	111.310621	93.5	1.32	9.2	27.9	buoy
2026-04-08 14:02:58.625391+08	BC-HN-2418	19.778658	111.158826	93.0	0.81	9.4	25.6	satellite
2026-04-08 18:28:47.491166+08	BC-HN-2418	19.694444	111.236224	91.4	1.06	6.4	27.1	buoy
2026-04-08 23:08:48.322704+08	BC-HN-2418	19.927792	111.267498	89.8	0.78	15.5	25.9	buoy
2026-04-09 03:56:38.108199+08	BC-HN-2418	19.786512	111.418734	90.6	0.85	8.4	29.1	buoy
2026-04-09 08:48:15.759691+08	BC-HN-2418	19.709741	111.245920	93.8	0.53	6.6	28.7	buoy
2026-04-09 13:17:55.420381+08	BC-HN-2418	19.864413	111.199669	88.0	1.29	7.9	28.8	satellite
2026-04-09 18:36:01.641735+08	BC-HN-2418	19.871149	111.231772	89.4	0.99	3.3	25.0	satellite
2026-04-09 22:53:43.693482+08	BC-HN-2418	19.934414	111.269864	88.9	0.53	3.2	25.6	satellite
2026-04-10 04:04:55.012113+08	BC-HN-2418	19.681210	111.429538	87.7	0.78	8.9	21.2	satellite
2026-04-10 08:56:59.821149+08	BC-HN-2418	19.857597	111.396855	88.5	0.00	4.8	30.0	buoy
2026-04-10 13:14:56.968813+08	BC-HN-2418	19.826117	111.407770	94.1	0.10	12.2	24.9	satellite
2026-04-10 18:17:43.3441+08	BC-HN-2418	19.828170	111.402985	95.6	0.94	6.8	22.7	satellite
2026-04-10 23:14:15.148513+08	BC-HN-2418	19.655743	111.209388	90.9	0.83	12.6	29.0	buoy
2026-04-11 03:42:18.267629+08	BC-HN-2418	19.643614	111.198798	90.4	0.00	5.5	25.8	drone
2026-04-11 08:43:01.925722+08	BC-HN-2418	19.769658	111.458870	88.3	1.01	4.6	31.5	satellite
2026-04-11 13:56:00.138045+08	BC-HN-2418	19.661984	111.491588	92.2	0.93	9.6	27.9	satellite
2026-04-11 18:30:09.256159+08	BC-HN-2418	19.886898	111.414850	84.7	0.26	1.7	27.3	drone
2026-04-11 23:13:24.640623+08	BC-HN-2418	19.877760	111.298532	87.7	0.81	12.0	24.5	satellite
2026-04-12 03:48:50.461002+08	BC-HN-2418	19.716820	111.334518	89.0	0.11	14.8	21.8	buoy
2026-04-12 09:09:39.678252+08	BC-HN-2418	19.755969	111.372936	88.5	1.25	7.0	21.4	satellite
2026-04-12 14:07:30.50587+08	BC-HN-2418	19.821482	111.455510	92.8	1.25	7.8	26.3	satellite
2026-04-12 18:50:52.024383+08	BC-HN-2418	19.830821	111.334570	83.6	0.35	4.0	25.5	drone
2026-04-12 23:29:16.580303+08	BC-HN-2418	19.727370	111.442041	88.3	0.52	9.8	24.4	satellite
2026-04-13 04:18:07.189009+08	BC-HN-2418	19.868553	111.246894	87.0	0.54	8.3	26.9	satellite
2026-04-13 08:29:30.040669+08	BC-HN-2418	19.717351	111.481122	85.0	0.43	10.3	26.5	drone
2026-04-13 13:34:06.18241+08	BC-HN-2418	19.667341	111.323824	87.8	0.53	10.0	28.0	satellite
2026-04-13 18:43:42.909529+08	BC-HN-2418	19.785878	111.506735	86.9	0.39	9.1	24.0	satellite
2026-04-13 23:35:39.658171+08	BC-HN-2418	19.619393	111.441507	81.9	0.72	0.0	29.2	drone
2026-04-14 04:07:05.395636+08	BC-HN-2418	19.860137	111.347600	87.5	0.35	5.7	28.1	satellite
2026-04-14 08:45:26.461611+08	BC-HN-2418	19.718353	111.346369	90.7	0.36	3.4	29.0	satellite
2026-04-14 13:59:32.395058+08	BC-HN-2418	19.828118	111.558669	87.9	0.01	9.3	27.1	drone
2026-04-14 17:57:43.479983+08	BC-HN-2418	19.871672	111.499038	87.2	0.18	14.0	25.7	satellite
2026-04-14 23:22:01.314628+08	BC-HN-2418	19.632618	111.537615	86.9	0.89	1.7	26.0	satellite
2026-04-15 03:46:32.422019+08	BC-HN-2418	19.673149	111.310291	81.2	0.83	2.7	24.0	drone
2026-04-15 09:02:20.01373+08	BC-HN-2418	19.730362	111.526248	80.6	0.31	9.2	26.5	satellite
2026-04-15 13:36:02.510966+08	BC-HN-2418	19.648112	111.467480	87.3	0.77	14.7	25.7	satellite
2026-04-15 18:41:45.365669+08	BC-HN-2418	19.773392	111.503676	80.9	0.84	12.1	27.3	satellite
2026-04-15 22:59:51.057231+08	BC-HN-2418	19.637916	111.407769	80.1	0.57	9.9	26.7	satellite
2026-04-16 04:17:10.804729+08	BC-HN-2418	19.722880	111.482857	83.1	0.86	1.4	24.7	satellite
2026-04-16 08:38:46.010675+08	BC-HN-2418	19.744281	111.491351	83.4	0.00	6.2	23.3	satellite
2026-04-16 13:44:27.1113+08	BC-HN-2418	19.757832	111.595457	85.2	1.36	7.6	25.0	buoy
2026-04-16 18:41:48.842004+08	BC-HN-2418	19.601390	111.306844	85.4	0.68	12.6	28.9	satellite
2026-04-16 23:25:51.342174+08	BC-HN-2418	19.754668	111.511426	84.1	1.62	6.8	24.9	buoy
2026-04-17 04:07:29.110986+08	BC-HN-2418	19.569848	111.377870	81.2	0.57	1.6	27.1	satellite
2026-04-17 08:52:23.574245+08	BC-HN-2418	19.738037	111.347742	84.9	1.25	6.7	26.7	buoy
2026-04-17 13:50:30.380343+08	BC-HN-2418	19.704571	111.519284	85.9	1.09	4.3	28.3	satellite
2026-04-17 18:20:43.19852+08	BC-HN-2418	19.647526	111.495161	83.1	0.64	2.3	27.3	satellite
2026-04-17 22:59:43.872694+08	BC-HN-2418	19.615791	111.611799	77.9	0.30	0.0	26.0	satellite
2026-04-18 04:24:29.529442+08	BC-HN-2418	19.810731	111.589984	78.2	1.38	8.1	26.3	drone
2026-04-18 08:53:01.987216+08	BC-HN-2418	19.740795	111.347389	82.1	0.36	10.5	25.6	satellite
2026-04-18 13:15:31.47357+08	BC-HN-2418	19.776370	111.611198	83.2	0.58	6.0	22.5	satellite
2026-04-18 18:46:39.030957+08	BC-HN-2418	19.568158	111.350137	82.5	2.07	10.9	23.4	satellite
2026-04-18 23:37:40.578755+08	BC-HN-2418	19.589667	111.597054	80.3	1.38	1.2	22.9	drone
2026-04-19 04:09:28.716028+08	BC-HN-2418	19.832310	111.398955	75.6	0.39	13.3	25.9	satellite
2026-04-19 08:38:09.826533+08	BC-HN-2418	19.564084	111.604110	78.6	1.62	7.9	27.8	satellite
2026-04-19 13:56:23.217475+08	BC-HN-2418	19.582370	111.586241	76.6	1.17	0.7	26.4	satellite
2026-04-19 18:29:07.031572+08	BC-HN-2418	19.657303	111.428585	79.1	0.70	13.0	24.9	satellite
2026-04-19 22:53:54.308217+08	BC-HN-2418	19.677929	111.460395	74.3	0.38	6.2	25.8	drone
2026-04-20 03:56:12.818911+08	BC-HN-2418	19.627402	111.375582	79.7	1.36	6.7	25.8	satellite
2026-04-20 08:46:09.956832+08	BC-HN-2418	19.748211	111.666671	83.1	0.46	3.1	29.4	satellite
2026-04-20 13:40:52.528339+08	BC-HN-2418	19.705822	111.614467	74.6	1.16	7.8	26.5	satellite
2026-04-20 18:37:43.993186+08	BC-HN-2418	19.651642	111.639331	76.6	1.49	9.0	26.8	buoy
2026-04-20 23:27:25.761729+08	BC-HN-2418	19.668904	111.495069	73.6	1.02	10.4	28.9	satellite
2026-04-21 04:24:35.164317+08	BC-HN-2418	19.691830	111.591981	79.7	0.20	8.3	24.9	satellite
2026-04-21 09:17:51.532015+08	BC-HN-2418	19.811553	111.668862	79.5	1.06	8.4	27.2	drone
2026-04-21 13:38:17.832444+08	BC-HN-2418	19.688647	111.525455	81.4	0.42	8.3	25.5	satellite
2026-04-21 18:21:32.600926+08	BC-HN-2418	19.526836	111.515848	76.3	0.55	1.6	27.9	satellite
2026-04-21 22:52:01.173243+08	BC-HN-2418	19.818702	111.525781	80.2	0.90	7.6	28.3	satellite
2026-04-22 03:45:52.484975+08	BC-HN-2418	19.667347	111.693426	71.4	1.18	10.1	23.8	satellite
2026-04-22 08:52:52.55714+08	BC-HN-2418	19.596621	111.596426	72.1	0.00	2.8	28.2	buoy
2026-04-22 13:32:14.500438+08	BC-HN-2418	19.681296	111.602757	72.4	1.15	14.8	25.1	drone
2026-04-22 18:27:31.266602+08	BC-HN-2418	19.770314	111.491669	75.2	0.35	3.1	24.6	satellite
2026-04-22 23:13:31.308577+08	BC-HN-2418	19.516706	111.451882	77.7	0.98	5.6	28.5	satellite
2026-04-23 03:37:03.078724+08	BC-HN-2418	19.788945	111.668142	71.4	0.03	3.9	29.2	satellite
2026-04-23 08:31:15.943177+08	BC-HN-2418	19.587215	111.598478	74.5	0.52	8.8	26.0	drone
2026-04-23 13:27:06.751352+08	BC-HN-2418	19.741696	111.646845	74.0	1.01	9.3	24.8	satellite
2026-04-23 18:53:36.145147+08	BC-HN-2418	19.623130	111.462386	77.2	0.79	11.3	26.2	satellite
2026-04-23 22:47:40.019101+08	BC-HN-2418	19.730457	111.612833	73.0	1.08	9.2	22.0	satellite
2026-04-24 04:07:55.58897+08	BC-HN-2418	19.598313	111.586293	75.5	0.36	8.8	24.2	satellite
2026-04-24 09:03:33.936513+08	BC-HN-2418	19.568510	111.461909	68.1	0.91	14.1	24.7	satellite
2026-04-24 14:00:06.264784+08	BC-HN-2418	19.520332	111.695335	72.3	0.82	10.2	23.5	drone
2026-04-24 18:20:13.32391+08	BC-HN-2418	19.545366	111.569905	70.1	0.00	1.6	25.7	satellite
2026-04-24 22:51:19.609588+08	BC-HN-2418	19.587059	111.653781	71.9	0.03	5.2	25.3	satellite
2026-04-25 03:53:41.420506+08	BC-HN-2418	19.537680	111.772394	75.0	0.60	7.7	28.1	satellite
2026-04-25 08:34:35.825272+08	BC-HN-2418	19.555572	111.696838	75.3	0.00	17.0	25.4	satellite
2026-04-25 13:46:42.042992+08	BC-HN-2418	19.779765	111.675140	66.5	0.79	10.1	27.6	satellite
2026-04-25 18:56:06.906652+08	BC-HN-2418	19.616442	111.561133	73.0	1.56	6.9	27.5	buoy
2026-04-25 23:32:02.752772+08	BC-HN-2418	19.677464	111.743080	67.4	1.20	2.8	25.4	satellite
2026-04-26 04:11:39.225211+08	BC-HN-2418	19.635194	111.653743	68.4	0.78	7.4	27.4	satellite
2026-04-26 08:47:33.566993+08	BC-HN-2418	19.681944	111.634890	66.2	0.92	10.9	23.4	satellite
2026-04-26 13:29:29.387217+08	BC-HN-2418	19.733788	111.746225	66.3	0.98	9.6	28.4	satellite
2026-04-26 18:30:46.976175+08	BC-HN-2418	19.643431	111.571898	65.1	1.39	5.0	26.3	drone
2026-04-26 23:41:35.427796+08	BC-HN-2418	19.769620	111.740624	70.7	1.09	3.8	27.4	satellite
2026-04-27 04:07:04.491175+08	BC-HN-2418	19.633172	111.606277	68.2	0.01	6.0	25.9	satellite
2026-04-27 08:27:29.895404+08	BC-HN-2418	19.619693	111.652813	67.6	0.65	4.5	28.7	satellite
2026-04-27 13:23:20.192196+08	BC-HN-2418	19.582432	111.763561	73.3	0.27	1.6	23.1	satellite
2026-04-27 18:15:25.530853+08	BC-HN-2418	19.498253	111.532239	69.3	0.03	10.2	23.6	satellite
2026-04-27 23:07:13.649562+08	BC-HN-2418	19.473350	111.773729	68.1	1.73	0.0	26.8	satellite
2026-04-28 04:01:05.177867+08	BC-HN-2418	19.610992	111.632313	65.7	1.43	6.7	28.6	satellite
2026-04-28 08:24:53.299666+08	BC-HN-2418	19.588851	111.766345	63.6	0.00	6.4	26.5	satellite
2026-04-28 13:17:16.275973+08	BC-HN-2418	19.554927	111.731783	64.8	1.26	16.6	28.7	satellite
2026-04-28 18:43:28.023302+08	BC-HN-2418	19.659621	111.822374	69.0	0.62	4.5	22.6	satellite
2026-04-28 23:24:23.070162+08	BC-HN-2418	19.484303	111.785494	63.0	1.44	8.9	21.8	satellite
2026-04-29 03:53:54.060532+08	BC-HN-2418	19.703913	111.848768	63.1	1.14	10.9	27.8	satellite
2026-04-29 09:08:54.214345+08	BC-HN-2418	19.510290	111.753309	61.1	1.34	1.4	24.5	buoy
2026-04-29 13:33:52.410112+08	BC-HN-2418	19.510468	111.754204	61.2	0.96	6.7	24.2	satellite
2026-04-29 18:08:51.902087+08	BC-HN-2418	19.694552	111.731524	66.6	0.00	12.6	26.1	satellite
2026-04-29 23:26:56.30236+08	BC-HN-2418	19.634816	111.574842	68.7	0.98	3.3	26.3	drone
2026-04-30 04:15:35.624261+08	BC-HN-2418	19.686010	111.756871	69.2	0.53	15.0	27.2	buoy
2026-04-30 09:06:47.318636+08	BC-HN-2418	19.591739	111.842982	61.9	0.48	1.6	26.1	buoy
2026-04-30 13:40:03.834365+08	BC-HN-2418	19.533086	111.638053	69.0	0.71	6.0	25.1	drone
2026-04-30 18:31:18.623722+08	BC-HN-2418	19.693868	111.606865	69.2	0.07	9.7	25.5	buoy
2026-04-30 23:38:27.953028+08	BC-HN-2418	19.596972	111.622653	62.6	0.95	9.5	27.5	buoy
2026-05-01 04:21:17.490827+08	BC-HN-2418	19.613362	111.619526	65.5	0.00	3.7	24.5	satellite
2026-05-01 08:28:47.855816+08	BC-HN-2418	19.518282	111.832356	58.5	0.96	16.4	26.2	drone
2026-05-01 13:12:59.325509+08	BC-HN-2418	19.690827	111.747308	65.5	1.53	5.4	27.1	satellite
2026-05-01 18:26:28.300811+08	BC-HN-2418	19.479368	111.702272	61.8	0.94	5.6	31.7	buoy
2026-05-01 23:06:59.677485+08	BC-HN-2418	19.542569	111.874827	64.2	0.76	10.1	27.0	satellite
2026-05-02 03:42:28.742747+08	BC-HN-2418	19.453754	111.725723	66.3	0.20	18.2	31.2	drone
2026-05-02 08:24:14.461621+08	BC-HN-2418	19.471352	111.896464	65.4	0.87	8.7	30.3	satellite
2026-05-02 13:11:10.273232+08	BC-HN-2418	19.516084	111.716271	61.6	0.77	11.9	27.4	satellite
2026-05-02 18:19:11.722769+08	BC-HN-2418	19.650905	111.725698	65.1	0.82	8.0	22.7	buoy
2026-05-02 23:26:17.09141+08	BC-HN-2418	19.412160	111.902002	64.9	0.00	2.4	28.8	satellite
2026-05-03 04:27:36.436819+08	BC-HN-2418	19.539347	111.759268	62.8	1.13	6.0	24.4	buoy
2026-05-03 08:20:55.244309+08	BC-HN-2418	19.587991	111.835787	61.5	0.52	17.2	25.7	satellite
2026-05-03 13:13:52.693342+08	BC-HN-2418	19.590561	111.792187	58.5	0.07	0.2	27.7	buoy
2026-05-03 18:01:17.944131+08	BC-HN-2418	19.522832	111.800365	62.4	1.27	2.3	24.7	satellite
2026-04-03 22:59:15.015214+08	BC-XS-2421	17.178656	112.400409	104.1	0.44	0.0	27.6	drone
2026-04-04 04:24:09.505454+08	BC-XS-2421	17.068316	112.540520	99.1	0.26	5.2	25.2	satellite
2026-04-04 09:11:21.275049+08	BC-XS-2421	17.005923	112.420901	103.2	0.51	8.7	28.5	buoy
2026-04-04 13:48:11.817871+08	BC-XS-2421	16.973299	112.358418	96.0	0.74	5.9	22.8	satellite
2026-04-04 17:56:28.020548+08	BC-XS-2421	17.083772	112.419246	101.9	0.37	11.3	26.3	satellite
2026-04-04 23:28:03.847071+08	BC-XS-2421	17.229979	112.517641	96.8	0.85	1.1	26.4	satellite
2026-04-05 04:00:08.64588+08	BC-XS-2421	17.045517	112.478632	102.6	1.30	8.3	30.1	drone
2026-04-05 08:37:37.89451+08	BC-XS-2421	17.073806	112.569110	94.0	1.07	2.1	26.4	drone
2026-04-05 13:09:08.809025+08	BC-XS-2421	17.047381	112.497118	94.3	0.60	11.4	30.2	satellite
2026-04-05 18:20:59.519821+08	BC-XS-2421	17.098348	112.493821	92.6	0.43	10.6	23.2	satellite
2026-04-05 23:37:01.740996+08	BC-XS-2421	17.066995	112.388909	98.0	1.68	16.9	27.0	buoy
2026-04-06 04:16:25.42844+08	BC-XS-2421	17.097699	112.352195	92.7	1.11	8.3	26.3	drone
2026-04-06 08:42:42.120498+08	BC-XS-2421	17.066850	112.538210	98.5	1.68	11.2	23.9	satellite
2026-04-06 13:10:29.219121+08	BC-XS-2421	17.011855	112.412785	97.8	1.10	9.7	25.9	satellite
2026-04-06 18:51:03.311769+08	BC-XS-2421	17.246239	112.517267	96.8	0.71	0.7	23.4	satellite
2026-04-06 22:57:16.242732+08	BC-XS-2421	17.036336	112.278344	97.7	0.76	3.6	20.3	drone
2026-04-07 03:36:06.18937+08	BC-XS-2421	17.231250	112.397572	98.5	0.00	8.4	29.4	drone
2026-04-07 08:29:23.309507+08	BC-XS-2421	17.160135	112.433748	96.7	0.94	10.2	26.7	drone
2026-04-07 13:39:09.227491+08	BC-XS-2421	17.158916	112.329067	91.0	1.07	19.6	26.7	drone
2026-04-07 18:04:58.600753+08	BC-XS-2421	17.317408	112.432221	90.3	0.20	9.9	27.0	satellite
2026-04-07 22:58:14.857902+08	BC-XS-2421	17.271074	112.504535	92.6	0.27	2.7	29.1	buoy
2026-04-08 03:32:49.03112+08	BC-XS-2421	17.257977	112.420270	99.3	1.54	0.1	23.0	satellite
2026-04-08 08:53:48.77615+08	BC-XS-2421	17.205705	112.298312	89.6	0.60	7.0	24.8	drone
2026-04-08 13:54:04.832176+08	BC-XS-2421	17.292462	112.508820	92.4	1.84	2.2	26.2	satellite
2026-04-08 18:25:03.980924+08	BC-XS-2421	17.207037	112.287499	91.5	0.50	17.4	21.4	drone
2026-04-08 23:30:38.02386+08	BC-XS-2421	17.253355	112.348097	97.4	1.19	6.8	23.7	satellite
2026-04-09 04:23:46.01122+08	BC-XS-2421	17.214692	112.326282	93.0	1.33	7.1	27.1	satellite
2026-04-09 08:52:16.708263+08	BC-XS-2421	17.098221	112.296708	96.3	0.68	19.1	27.5	buoy
2026-04-09 13:16:47.170239+08	BC-XS-2421	17.088313	112.508953	94.0	0.65	5.5	25.9	satellite
2026-04-09 18:35:52.478854+08	BC-XS-2421	17.330095	112.449429	88.5	0.01	10.5	25.7	drone
2026-04-09 23:35:56.407422+08	BC-XS-2421	17.085577	112.274121	92.1	0.93	5.2	26.7	drone
2026-04-10 03:33:20.970969+08	BC-XS-2421	17.102825	112.320742	89.2	1.34	2.6	21.9	buoy
2026-04-10 08:41:19.915936+08	BC-XS-2421	17.143665	112.354089	95.9	0.55	0.0	30.2	satellite
2026-04-10 13:23:37.388531+08	BC-XS-2421	17.212859	112.306456	95.4	1.06	15.7	26.7	satellite
2026-04-10 18:53:26.784021+08	BC-XS-2421	17.323688	112.372995	92.7	1.05	8.2	25.6	drone
2026-04-10 22:58:00.935817+08	BC-XS-2421	17.188953	112.384791	89.9	0.77	13.5	27.3	satellite
2026-04-11 04:17:31.726947+08	BC-XS-2421	17.393291	112.249685	86.4	1.25	12.7	26.0	satellite
2026-04-11 08:50:37.075689+08	BC-XS-2421	17.148564	112.257537	93.2	0.64	10.0	28.6	buoy
2026-04-11 14:05:21.922478+08	BC-XS-2421	17.174985	112.230439	86.4	0.86	16.7	25.0	satellite
2026-04-11 18:27:52.464592+08	BC-XS-2421	17.190093	112.512789	87.7	0.86	12.2	25.1	buoy
2026-04-11 22:45:24.507493+08	BC-XS-2421	17.267687	112.251444	87.1	0.17	0.0	29.5	buoy
2026-04-12 04:14:18.125423+08	BC-XS-2421	17.262808	112.239280	88.5	1.26	6.8	28.0	satellite
2026-04-12 09:12:56.599458+08	BC-XS-2421	17.261355	112.279908	87.7	0.84	12.3	28.6	drone
2026-04-12 13:21:30.991562+08	BC-XS-2421	17.212300	112.352541	93.3	0.28	7.1	25.8	satellite
2026-04-12 18:48:51.805754+08	BC-XS-2421	17.301307	112.301728	85.7	0.34	7.6	29.4	satellite
2026-04-12 23:32:09.360881+08	BC-XS-2421	17.132574	112.234810	91.9	0.47	5.4	26.9	buoy
2026-04-13 04:18:32.295514+08	BC-XS-2421	17.360555	112.374492	88.0	0.01	8.7	28.3	buoy
2026-04-13 09:03:47.458898+08	BC-XS-2421	17.332923	112.443325	91.6	1.67	13.3	28.1	drone
2026-04-13 13:24:55.372164+08	BC-XS-2421	17.193180	112.391424	88.6	0.45	19.8	23.1	buoy
2026-04-13 18:10:44.874504+08	BC-XS-2421	17.364451	112.262510	91.0	1.10	11.7	27.7	satellite
2026-04-13 22:55:09.202953+08	BC-XS-2421	17.157364	112.358387	84.9	1.14	9.8	29.4	buoy
2026-04-14 03:48:49.861376+08	BC-XS-2421	17.185423	112.429251	83.3	1.21	11.7	26.5	drone
2026-04-14 09:18:39.756341+08	BC-XS-2421	17.292213	112.304638	83.7	0.96	11.6	29.1	drone
2026-04-14 14:00:19.758335+08	BC-XS-2421	17.386221	112.215497	88.6	1.14	3.2	26.9	drone
2026-04-14 17:59:04.290745+08	BC-XS-2421	17.197971	112.372575	83.9	1.14	17.2	24.5	satellite
2026-04-14 23:21:34.965082+08	BC-XS-2421	17.193096	112.195161	82.0	1.06	12.4	28.7	satellite
2026-04-15 03:39:06.953687+08	BC-XS-2421	17.431772	112.404678	89.5	1.54	5.8	26.7	satellite
2026-04-15 08:24:55.684297+08	BC-XS-2421	17.254642	112.361328	89.2	0.58	3.1	26.5	drone
2026-04-15 13:27:40.207271+08	BC-XS-2421	17.198287	112.282285	87.5	0.46	11.8	26.5	satellite
2026-04-15 18:31:57.544888+08	BC-XS-2421	17.419837	112.448577	85.3	1.25	8.1	29.9	buoy
2026-04-15 23:16:52.330492+08	BC-XS-2421	17.423973	112.285793	79.6	1.19	12.7	28.0	buoy
2026-04-16 04:03:21.909202+08	BC-XS-2421	17.293444	112.447975	83.4	1.14	5.0	31.2	buoy
2026-04-16 09:20:03.147537+08	BC-XS-2421	17.496126	112.270145	82.6	1.29	12.9	24.8	satellite
2026-04-16 13:25:23.807253+08	BC-XS-2421	17.394633	112.372395	83.3	1.10	8.7	27.3	drone
2026-04-16 18:15:23.822009+08	BC-XS-2421	17.380771	112.250078	85.3	0.43	10.9	28.4	satellite
2026-04-16 23:38:03.375264+08	BC-XS-2421	17.384962	112.299467	81.6	1.20	10.1	25.7	satellite
2026-04-17 03:52:58.722369+08	BC-XS-2421	17.368607	112.200874	83.1	1.27	11.5	27.7	satellite
2026-04-17 09:00:35.595325+08	BC-XS-2421	17.462669	112.190729	81.8	0.47	11.8	23.5	satellite
2026-04-17 13:14:15.783347+08	BC-XS-2421	17.464085	112.363054	81.2	0.97	4.1	26.0	drone
2026-04-17 18:45:48.079587+08	BC-XS-2421	17.354979	112.171805	80.9	2.06	6.8	25.5	drone
2026-04-17 23:07:33.30114+08	BC-XS-2421	17.250265	112.336665	84.9	0.39	5.7	24.3	satellite
2026-04-18 04:10:22.54594+08	BC-XS-2421	17.258619	112.423073	83.4	1.21	14.1	25.6	satellite
2026-04-18 08:48:31.645475+08	BC-XS-2421	17.504857	112.192488	76.6	0.60	0.4	29.2	satellite
2026-04-18 13:50:36.65493+08	BC-XS-2421	17.502489	112.194335	84.5	0.74	0.9	25.7	satellite
2026-04-18 18:33:08.765063+08	BC-XS-2421	17.274657	112.209962	84.3	0.69	7.8	26.7	buoy
2026-04-18 22:49:07.015986+08	BC-XS-2421	17.392294	112.346411	83.3	1.18	9.2	27.2	satellite
2026-04-19 04:13:15.166175+08	BC-XS-2421	17.409178	112.433125	81.2	1.04	12.2	27.1	buoy
2026-04-19 08:22:58.654717+08	BC-XS-2421	17.397885	112.186191	83.9	0.63	7.3	26.0	drone
2026-04-19 13:33:34.164348+08	BC-XS-2421	17.330134	112.280773	80.4	0.00	5.0	23.2	satellite
2026-04-19 18:30:26.873824+08	BC-XS-2421	17.451330	112.301562	82.4	0.27	5.0	27.4	satellite
2026-04-19 22:46:36.091176+08	BC-XS-2421	17.358641	112.309591	73.7	0.11	9.0	27.3	drone
2026-04-20 04:07:31.694186+08	BC-XS-2421	17.385215	112.208708	74.7	0.57	7.7	28.6	drone
2026-04-20 08:20:56.979654+08	BC-XS-2421	17.424868	112.422552	77.3	0.18	7.9	32.4	buoy
2026-04-20 13:27:24.440385+08	BC-XS-2421	17.390469	112.199678	81.2	0.98	11.2	25.1	satellite
2026-04-20 18:06:59.918175+08	BC-XS-2421	17.340562	112.405140	74.1	0.40	4.1	26.0	satellite
2026-04-20 23:11:24.437597+08	BC-XS-2421	17.362864	112.272364	77.3	0.22	8.9	28.0	satellite
2026-04-21 04:20:16.677755+08	BC-XS-2421	17.363238	112.197433	77.9	0.82	8.4	24.9	drone
2026-04-21 08:50:07.034838+08	BC-XS-2421	17.472661	112.234702	77.1	1.36	0.0	26.4	buoy
2026-04-21 13:32:43.796418+08	BC-XS-2421	17.350042	112.206106	76.5	0.39	1.5	22.1	satellite
2026-04-21 18:35:43.190667+08	BC-XS-2421	17.416800	112.205939	72.8	1.44	12.0	26.8	drone
2026-04-21 23:26:34.939146+08	BC-XS-2421	17.510857	112.405962	78.6	1.24	14.0	27.0	buoy
2026-04-22 04:15:56.882651+08	BC-XS-2421	17.401314	112.310221	72.8	1.86	10.9	27.3	buoy
2026-04-22 08:57:27.786721+08	BC-XS-2421	17.596692	112.183292	75.6	1.25	9.1	25.3	drone
2026-04-22 13:08:29.263912+08	BC-XS-2421	17.526584	112.220476	71.5	0.00	7.6	25.0	drone
2026-04-22 18:21:36.017738+08	BC-XS-2421	17.598873	112.192564	79.7	0.93	11.6	26.1	satellite
2026-04-22 23:27:32.816078+08	BC-XS-2421	17.487173	112.175156	78.1	1.48	15.1	27.4	satellite
2026-04-23 03:53:46.852947+08	BC-XS-2421	17.344456	112.303873	74.2	1.68	10.0	27.6	satellite
2026-04-23 08:39:43.548513+08	BC-XS-2421	17.553560	112.309470	70.4	1.14	11.8	26.3	drone
2026-04-23 13:31:55.291851+08	BC-XS-2421	17.636759	112.356189	78.8	0.57	0.0	26.2	drone
2026-04-23 18:53:08.183585+08	BC-XS-2421	17.528403	112.132054	75.4	0.63	7.9	28.1	satellite
2026-04-23 23:03:05.574903+08	BC-XS-2421	17.532005	112.245224	76.9	1.41	2.6	24.6	buoy
2026-04-24 03:42:11.698235+08	BC-XS-2421	17.416527	112.285176	70.1	1.29	3.1	26.2	satellite
2026-04-24 08:46:06.650047+08	BC-XS-2421	17.546432	112.297901	76.4	0.67	7.4	29.2	satellite
2026-04-24 13:45:53.319422+08	BC-XS-2421	17.471446	112.255278	72.1	0.63	17.3	27.2	buoy
2026-04-24 18:03:28.730104+08	BC-XS-2421	17.552835	112.191199	73.5	1.38	2.5	24.0	satellite
2026-04-24 23:33:09.594162+08	BC-XS-2421	17.410627	112.192325	70.9	1.41	4.9	28.5	drone
2026-04-25 03:36:26.304533+08	BC-XS-2421	17.638620	112.112530	76.1	0.84	10.4	26.0	satellite
2026-04-25 08:39:12.911557+08	BC-XS-2421	17.531667	112.159495	73.4	0.05	11.8	26.3	satellite
2026-04-25 13:32:45.043827+08	BC-XS-2421	17.475048	112.180178	73.4	0.80	6.3	26.6	satellite
2026-04-25 18:32:34.659214+08	BC-XS-2421	17.595821	112.315122	71.1	0.99	6.4	26.2	satellite
2026-04-25 22:44:55.189773+08	BC-XS-2421	17.631341	112.152365	74.9	0.44	6.8	26.1	drone
2026-04-26 03:38:30.016147+08	BC-XS-2421	17.568592	112.284003	69.3	0.57	14.4	26.2	drone
2026-04-26 08:51:57.917338+08	BC-XS-2421	17.482987	112.354987	72.5	1.34	15.3	26.1	satellite
2026-04-26 13:45:32.599014+08	BC-XS-2421	17.503795	112.336932	66.1	0.22	10.2	25.5	satellite
2026-04-26 18:07:59.264951+08	BC-XS-2421	17.457228	112.120036	66.5	0.36	11.5	29.2	buoy
2026-04-26 22:51:52.20698+08	BC-XS-2421	17.440139	112.111043	69.1	0.96	6.8	27.0	satellite
2026-04-27 04:07:37.852939+08	BC-XS-2421	17.488381	112.294555	64.6	0.12	8.4	26.6	buoy
2026-04-27 08:23:01.805229+08	BC-XS-2421	17.592428	112.208269	69.1	0.96	6.8	28.6	buoy
2026-04-27 13:40:29.742279+08	BC-XS-2421	17.690910	112.251237	64.1	1.06	0.0	25.7	satellite
2026-04-27 18:02:17.298599+08	BC-XS-2421	17.711816	112.344636	73.2	0.52	15.3	27.3	satellite
2026-04-27 23:41:51.405225+08	BC-XS-2421	17.555334	112.229458	70.9	0.45	0.0	27.5	buoy
2026-04-28 03:40:48.92436+08	BC-XS-2421	17.443284	112.095024	71.0	1.17	7.6	28.1	satellite
2026-04-28 09:04:43.142183+08	BC-XS-2421	17.737169	112.255698	70.4	0.57	8.8	27.9	satellite
2026-04-28 13:08:25.723786+08	BC-XS-2421	17.534625	112.256475	69.2	0.62	10.6	28.3	satellite
2026-04-28 18:07:23.450077+08	BC-XS-2421	17.730015	112.110493	67.3	1.21	3.4	29.7	satellite
2026-04-28 23:05:54.240871+08	BC-XS-2421	17.721119	112.326388	66.1	0.63	14.9	27.5	drone
2026-04-29 04:07:55.30028+08	BC-XS-2421	17.498389	112.114520	65.6	0.16	10.7	23.4	satellite
2026-04-29 08:34:38.862735+08	BC-XS-2421	17.626144	112.164463	65.3	1.57	7.5	26.9	buoy
2026-04-29 13:52:18.146057+08	BC-XS-2421	17.620223	112.256289	61.2	1.54	22.8	25.4	drone
2026-04-29 18:54:24.284158+08	BC-XS-2421	17.737836	112.176394	60.7	0.14	6.6	25.5	satellite
2026-04-29 23:40:23.834107+08	BC-XS-2421	17.492481	112.097150	70.2	0.76	8.8	29.8	satellite
2026-04-30 04:06:36.629501+08	BC-XS-2421	17.540490	112.080790	68.4	0.19	0.1	25.0	satellite
2026-04-30 08:33:54.942266+08	BC-XS-2421	17.560259	112.313287	61.9	0.87	9.5	25.5	buoy
2026-04-30 13:20:39.170298+08	BC-XS-2421	17.678967	112.135225	66.3	1.16	8.2	24.6	buoy
2026-04-30 18:18:16.378124+08	BC-XS-2421	17.602113	112.239891	60.1	0.57	2.7	26.3	satellite
2026-04-30 23:12:11.596263+08	BC-XS-2421	17.601583	112.068024	63.3	0.47	0.0	25.4	satellite
2026-05-01 04:07:04.492274+08	BC-XS-2421	17.672138	112.309572	66.4	1.30	0.2	27.5	buoy
2026-05-01 08:26:19.399272+08	BC-XS-2421	17.744098	112.034786	66.7	0.96	20.2	26.6	buoy
2026-05-01 13:25:13.365421+08	BC-XS-2421	17.694514	112.066494	67.6	1.01	13.9	26.6	satellite
2026-05-01 17:57:09.763186+08	BC-XS-2421	17.767810	112.140672	67.9	0.91	0.0	27.5	satellite
2026-05-01 22:58:58.56472+08	BC-XS-2421	17.769840	112.305674	66.8	1.68	7.8	25.8	satellite
2026-05-02 03:48:04.558648+08	BC-XS-2421	17.682040	112.207875	65.8	0.00	6.7	29.4	drone
2026-05-02 08:52:33.035579+08	BC-XS-2421	17.691243	112.226296	60.5	0.55	14.1	24.5	drone
2026-05-02 13:51:04.036198+08	BC-XS-2421	17.734639	112.243011	57.9	0.79	4.3	23.2	satellite
2026-05-02 18:45:28.412397+08	BC-XS-2421	17.688149	112.090597	58.4	0.38	5.6	24.7	buoy
2026-05-02 22:44:27.876062+08	BC-XS-2421	17.647417	112.185814	56.9	0.47	11.2	25.0	satellite
2026-05-03 04:11:30.684102+08	BC-XS-2421	17.606693	112.282265	58.2	0.85	12.1	26.0	satellite
2026-05-03 09:08:40.348601+08	BC-XS-2421	17.596781	112.095182	58.6	1.05	7.2	25.8	buoy
2026-05-03 13:59:27.808353+08	BC-XS-2421	17.777993	112.085090	62.4	0.53	11.8	27.8	satellite
2026-05-03 18:28:07.578454+08	BC-XS-2421	17.839808	112.004079	56.8	0.78	0.1	25.8	drone
2026-04-03 23:34:47.226623+08	BC-PH-2425	10.292031	118.632886	95.8	1.09	3.1	26.9	satellite
2026-04-04 03:51:04.445587+08	BC-PH-2425	10.419578	118.790659	96.9	0.52	6.5	28.5	satellite
2026-04-04 08:26:33.731021+08	BC-PH-2425	10.202333	118.658550	98.1	0.77	6.8	28.5	satellite
2026-04-04 14:07:28.928536+08	BC-PH-2425	10.306164	118.840428	101.8	0.79	3.1	25.3	satellite
2026-04-04 18:43:35.792866+08	BC-PH-2425	10.307814	118.869595	100.9	0.94	10.7	27.7	drone
2026-04-04 22:57:29.546807+08	BC-PH-2425	10.225240	118.693019	95.1	1.18	6.1	23.5	satellite
2026-04-05 04:04:40.140711+08	BC-PH-2425	10.349305	118.778607	95.9	0.62	2.8	25.6	satellite
2026-04-05 09:16:29.975047+08	BC-PH-2425	10.296833	118.747213	101.8	1.20	3.3	24.2	satellite
2026-04-05 13:32:25.932303+08	BC-PH-2425	10.257160	118.858842	100.4	0.63	11.2	27.2	drone
2026-04-05 17:58:49.439562+08	BC-PH-2425	10.253808	118.852052	99.9	0.16	3.9	28.3	buoy
2026-04-05 22:52:16.446108+08	BC-PH-2425	10.492113	118.893992	97.4	0.77	9.9	26.0	drone
2026-04-06 04:23:58.153577+08	BC-PH-2425	10.435351	118.747415	93.8	0.92	15.9	23.4	satellite
2026-04-06 09:07:19.356274+08	BC-PH-2425	10.272130	118.885088	99.1	0.13	7.0	28.0	satellite
2026-04-06 13:10:01.219119+08	BC-PH-2425	10.376441	118.819112	98.3	0.84	3.5	23.7	satellite
2026-04-06 18:21:10.705683+08	BC-PH-2425	10.352058	118.710319	94.3	0.00	3.0	32.4	buoy
2026-04-06 23:05:22.189536+08	BC-PH-2425	10.502535	118.927338	100.4	1.71	5.5	28.1	satellite
2026-04-07 03:34:13.580572+08	BC-PH-2425	10.359035	118.897364	98.6	1.09	2.3	26.1	buoy
2026-04-07 08:42:30.725174+08	BC-PH-2425	10.466265	118.805720	97.2	1.67	15.8	27.4	buoy
2026-04-07 14:03:16.003632+08	BC-PH-2425	10.522562	118.785039	93.5	0.96	12.3	27.0	drone
2026-04-07 18:11:46.843423+08	BC-PH-2425	10.492008	118.712223	94.3	1.13	9.6	26.7	drone
2026-04-07 23:23:24.750828+08	BC-PH-2425	10.326343	118.764585	91.8	0.97	5.9	23.9	satellite
2026-04-08 04:19:25.532337+08	BC-PH-2425	10.336292	118.934799	97.6	0.84	7.2	26.0	buoy
2026-04-08 08:29:21.783669+08	BC-PH-2425	10.310125	118.734262	93.4	0.46	0.8	27.3	satellite
2026-04-08 14:06:59.888458+08	BC-PH-2425	10.545354	118.953954	92.7	1.04	7.6	29.3	buoy
2026-04-08 18:54:53.614989+08	BC-PH-2425	10.359938	118.718157	93.8	0.76	3.1	25.8	buoy
2026-04-08 23:18:57.795849+08	BC-PH-2425	10.547037	118.751307	89.4	0.60	8.5	24.8	satellite
2026-04-09 04:02:50.724898+08	BC-PH-2425	10.470100	118.742831	89.4	0.49	7.5	29.9	drone
2026-04-09 08:25:47.684645+08	BC-PH-2425	10.476380	118.978067	92.9	1.38	10.5	29.7	buoy
2026-04-09 14:04:53.924624+08	BC-PH-2425	10.577886	118.832628	90.9	1.31	4.4	25.0	satellite
2026-04-09 18:39:24.052394+08	BC-PH-2425	10.450332	118.932360	93.1	0.21	13.4	28.4	satellite
2026-04-09 23:08:54.805196+08	BC-PH-2425	10.339786	118.931248	92.2	0.20	8.2	27.0	satellite
2026-04-10 03:47:03.293249+08	BC-PH-2425	10.447601	118.997202	89.4	0.58	11.3	27.3	satellite
2026-04-10 09:08:35.392612+08	BC-PH-2425	10.337657	118.905473	92.6	0.00	11.3	23.0	satellite
2026-04-10 13:54:15.523044+08	BC-PH-2425	10.359274	118.959731	94.4	1.08	9.9	28.6	satellite
2026-04-10 18:32:20.791437+08	BC-PH-2425	10.583280	118.776195	86.6	1.59	3.4	22.9	satellite
2026-04-10 23:10:29.174585+08	BC-PH-2425	10.444723	118.848724	95.3	1.25	9.0	28.0	satellite
2026-04-11 03:50:25.817771+08	BC-PH-2425	10.568241	118.995798	86.4	1.21	4.2	24.3	buoy
2026-04-11 09:16:28.881852+08	BC-PH-2425	10.376934	118.816422	85.8	0.47	11.2	25.6	drone
2026-04-11 13:39:10.531548+08	BC-PH-2425	10.605353	118.909771	86.8	0.97	8.7	27.8	satellite
2026-04-11 18:16:54.780854+08	BC-PH-2425	10.395176	118.783016	85.5	0.50	4.8	26.2	satellite
2026-04-11 22:46:30.301481+08	BC-PH-2425	10.334667	118.764927	89.4	0.39	16.1	27.3	satellite
2026-04-12 03:33:32.688186+08	BC-PH-2425	10.377871	118.910007	85.3	1.47	2.0	28.0	satellite
2026-04-12 08:28:15.415381+08	BC-PH-2425	10.635618	118.929685	92.8	1.06	12.4	25.9	satellite
2026-04-12 13:39:37.81068+08	BC-PH-2425	10.624449	118.885367	93.2	0.60	0.0	27.7	satellite
2026-04-12 18:17:53.780002+08	BC-PH-2425	10.379527	118.941956	91.6	1.30	7.2	25.6	satellite
2026-04-12 23:19:37.23502+08	BC-PH-2425	10.564684	118.838058	91.8	0.36	3.0	25.4	buoy
2026-04-13 04:31:42.652062+08	BC-PH-2425	10.594526	119.017931	83.7	1.32	7.8	25.8	drone
2026-04-13 08:34:08.907405+08	BC-PH-2425	10.654195	119.069112	83.2	1.19	9.5	24.4	drone
2026-04-13 13:16:33.406157+08	BC-PH-2425	10.574348	119.040577	84.0	0.79	9.8	23.8	satellite
2026-04-13 18:14:36.296091+08	BC-PH-2425	10.572412	118.843606	85.3	0.85	13.9	22.6	satellite
2026-04-13 23:24:58.8265+08	BC-PH-2425	10.572500	118.896696	88.8	0.20	8.5	26.3	satellite
2026-04-14 03:43:44.186366+08	BC-PH-2425	10.412512	118.913432	81.7	0.87	2.0	28.1	buoy
2026-04-14 09:07:35.476752+08	BC-PH-2425	10.541195	119.062886	82.4	0.41	3.8	23.0	satellite
2026-04-14 13:59:55.562607+08	BC-PH-2425	10.493597	118.950048	90.3	0.03	4.7	25.6	satellite
2026-04-14 18:39:14.86597+08	BC-PH-2425	10.628471	118.848050	83.2	1.06	8.6	30.3	buoy
2026-04-14 23:29:10.006234+08	BC-PH-2425	10.419288	118.822624	81.9	0.91	0.0	25.5	satellite
2026-04-15 04:14:27.728426+08	BC-PH-2425	10.394626	119.003755	87.0	1.34	5.6	25.1	satellite
2026-04-15 08:58:08.167604+08	BC-PH-2425	10.606762	119.101533	82.6	0.75	1.2	25.1	satellite
2026-04-15 14:07:45.109039+08	BC-PH-2425	10.605903	119.011013	81.0	0.01	8.3	26.2	satellite
2026-04-15 18:32:02.049818+08	BC-PH-2425	10.588339	118.921290	86.2	0.37	0.0	25.4	satellite
2026-04-15 23:04:49.71325+08	BC-PH-2425	10.499905	118.850984	79.1	1.01	12.1	26.4	drone
2026-04-16 03:36:23.888516+08	BC-PH-2425	10.687907	118.908790	87.2	0.85	17.7	24.8	satellite
2026-04-16 08:48:20.028134+08	BC-PH-2425	10.489364	119.064047	86.0	0.59	12.2	30.2	satellite
2026-04-16 13:29:41.305562+08	BC-PH-2425	10.629109	118.908462	87.6	0.59	8.7	28.1	drone
2026-04-16 18:12:00.81752+08	BC-PH-2425	10.708898	118.972352	78.6	0.09	5.0	25.3	satellite
2026-04-16 23:23:23.274367+08	BC-PH-2425	10.713614	119.059714	78.6	1.84	0.2	28.0	buoy
2026-04-17 04:27:33.608313+08	BC-PH-2425	10.586699	119.090368	86.3	1.70	13.4	22.6	satellite
2026-04-17 08:30:21.603891+08	BC-PH-2425	10.699782	119.106576	87.0	0.29	0.0	24.4	satellite
2026-04-17 14:07:32.149935+08	BC-PH-2425	10.629209	119.098672	79.2	0.90	5.4	24.1	satellite
2026-04-17 18:53:54.97216+08	BC-PH-2425	10.618334	119.113606	84.7	0.57	0.0	27.8	satellite
2026-04-17 23:23:42.482565+08	BC-PH-2425	10.506160	118.987185	82.2	1.22	13.2	27.9	satellite
2026-04-18 03:45:59.604802+08	BC-PH-2425	10.587921	119.123316	79.0	0.44	11.1	24.2	buoy
2026-04-18 08:30:42.955719+08	BC-PH-2425	10.711856	119.154785	84.3	0.44	6.9	25.1	drone
2026-04-18 13:54:36.837363+08	BC-PH-2425	10.732107	119.046144	82.8	0.81	11.9	27.3	buoy
2026-04-18 18:46:24.373602+08	BC-PH-2425	10.715770	119.136985	81.2	0.61	10.9	30.9	buoy
2026-04-18 23:36:36.610557+08	BC-PH-2425	10.749104	119.109895	77.4	1.32	11.7	26.1	satellite
2026-04-19 03:38:46.474935+08	BC-PH-2425	10.529707	119.163219	78.7	0.96	6.1	26.9	satellite
2026-04-19 08:51:34.552608+08	BC-PH-2425	10.681447	119.168669	84.4	1.77	15.1	28.4	satellite
2026-04-19 13:08:40.42651+08	BC-PH-2425	10.641655	119.020559	78.5	1.07	7.1	24.8	satellite
2026-04-19 17:56:50.01736+08	BC-PH-2425	10.608970	119.122813	80.2	0.50	3.7	27.2	satellite
2026-04-19 23:32:11.795046+08	BC-PH-2425	10.747363	119.113870	76.0	0.99	4.4	26.6	satellite
2026-04-20 04:08:04.658896+08	BC-PH-2425	10.507159	119.002789	79.9	0.36	0.0	26.9	buoy
2026-04-20 08:58:48.446592+08	BC-PH-2425	10.726161	119.051111	81.1	0.41	3.0	25.8	buoy
2026-04-20 13:23:24.065672+08	BC-PH-2425	10.588625	119.209215	78.8	1.02	12.5	26.2	satellite
2026-04-20 18:22:27.500534+08	BC-PH-2425	10.785891	119.125799	74.9	1.34	1.0	24.0	satellite
2026-04-20 23:40:13.089717+08	BC-PH-2425	10.727233	119.026717	76.5	0.88	5.0	26.4	satellite
2026-04-21 03:59:54.611698+08	BC-PH-2425	10.792597	119.110497	81.3	1.47	4.5	29.3	buoy
2026-04-21 08:58:29.077155+08	BC-PH-2425	10.794028	118.960771	76.6	0.88	4.8	27.9	satellite
2026-04-21 13:21:49.369397+08	BC-PH-2425	10.747696	119.171042	79.2	0.00	5.3	28.3	drone
2026-04-21 18:28:43.926733+08	BC-PH-2425	10.791029	118.982990	77.6	0.45	8.0	25.8	satellite
2026-04-21 22:59:55.596812+08	BC-PH-2425	10.712238	118.950707	79.0	0.36	8.4	29.1	satellite
2026-04-22 03:46:02.825527+08	BC-PH-2425	10.683454	118.960335	75.8	1.40	8.6	24.7	drone
2026-04-22 08:52:37.822176+08	BC-PH-2425	10.797405	119.009071	78.0	1.14	0.0	26.5	buoy
2026-04-22 13:18:54.118256+08	BC-PH-2425	10.685782	119.176838	73.5	0.06	7.4	29.0	satellite
2026-04-22 18:49:44.034058+08	BC-PH-2425	10.697949	119.190709	76.5	0.00	5.4	28.1	satellite
2026-04-22 23:15:29.542933+08	BC-PH-2425	10.638164	119.145538	78.6	1.13	7.0	26.2	drone
2026-04-23 04:27:25.481091+08	BC-PH-2425	10.572354	119.219268	75.0	0.93	16.7	26.3	buoy
2026-04-23 08:20:44.981112+08	BC-PH-2425	10.754263	119.036481	70.3	0.70	11.6	24.0	drone
2026-04-23 13:10:34.124833+08	BC-PH-2425	10.622773	119.212924	76.0	0.70	5.8	21.1	drone
2026-04-23 18:33:27.668416+08	BC-PH-2425	10.814531	119.097090	72.3	1.41	0.0	25.5	buoy
2026-04-23 22:53:19.257634+08	BC-PH-2425	10.629260	119.259441	72.8	0.00	3.0	26.7	satellite
2026-04-24 03:45:02.34934+08	BC-PH-2425	10.808910	119.055745	70.3	1.07	5.4	27.7	satellite
2026-04-24 09:03:55.242177+08	BC-PH-2425	10.695706	119.069209	76.4	0.79	6.0	23.5	buoy
2026-04-24 13:40:27.58935+08	BC-PH-2425	10.622393	119.069270	76.4	1.56	13.3	28.0	buoy
2026-04-24 18:24:03.446356+08	BC-PH-2425	10.708971	119.233839	74.9	1.04	0.0	26.5	satellite
2026-04-24 23:33:25.442221+08	BC-PH-2425	10.643272	119.224741	74.4	0.90	10.2	27.5	satellite
2026-04-25 04:04:18.169875+08	BC-PH-2425	10.793923	119.284810	76.3	0.43	11.6	27.4	drone
2026-04-25 08:23:57.355589+08	BC-PH-2425	10.655839	119.090088	74.1	0.00	10.3	24.0	drone
2026-04-25 13:31:16.490097+08	BC-PH-2425	10.662571	119.261880	71.9	0.40	10.1	25.8	buoy
2026-04-25 18:25:26.786531+08	BC-PH-2425	10.733800	119.074780	75.3	0.95	8.6	27.1	satellite
2026-04-25 23:21:12.39411+08	BC-PH-2425	10.730112	119.243306	72.1	1.12	8.8	26.2	drone
2026-04-26 03:53:35.602212+08	BC-PH-2425	10.861821	119.158288	74.9	1.06	10.2	24.0	satellite
2026-04-26 09:03:24.66511+08	BC-PH-2425	10.864248	119.107094	65.3	0.75	6.8	26.5	satellite
2026-04-26 14:06:12.82033+08	BC-PH-2425	10.806837	119.067062	74.8	1.22	8.7	27.7	satellite
2026-04-26 18:54:40.395578+08	BC-PH-2425	10.748835	119.295510	70.4	0.94	6.4	25.4	drone
2026-04-26 22:56:32.487855+08	BC-PH-2425	10.824537	119.270161	66.0	0.43	13.3	29.5	satellite
2026-04-27 03:39:18.418813+08	BC-PH-2425	10.918703	119.263072	72.8	0.71	7.2	30.3	satellite
2026-04-27 09:01:56.687193+08	BC-PH-2425	10.770729	119.272062	69.2	0.37	3.8	28.8	drone
2026-04-27 13:35:34.184493+08	BC-PH-2425	10.708939	119.353069	64.4	1.10	2.4	25.6	satellite
2026-04-27 18:43:02.380158+08	BC-PH-2425	10.924970	119.112659	66.3	1.06	6.5	26.8	drone
2026-04-27 23:29:25.504544+08	BC-PH-2425	10.907066	119.309845	71.3	1.70	4.5	30.8	satellite
2026-04-28 03:41:43.097241+08	BC-PH-2425	10.774961	119.271949	68.2	0.42	1.9	23.2	buoy
2026-04-28 08:33:12.711087+08	BC-PH-2425	10.887190	119.371200	66.0	1.11	13.0	25.3	satellite
2026-04-28 14:00:41.591815+08	BC-PH-2425	10.880461	119.254977	62.4	1.52	9.8	26.3	satellite
2026-04-28 18:46:25.985122+08	BC-PH-2425	10.900729	119.135172	66.5	1.07	1.0	25.2	buoy
2026-04-28 23:07:40.96075+08	BC-PH-2425	10.840437	119.166906	66.8	0.19	5.7	25.6	satellite
2026-04-29 04:12:03.702765+08	BC-PH-2425	10.888152	119.283169	67.7	0.80	3.6	25.7	satellite
2026-04-29 08:29:28.738738+08	BC-PH-2425	10.787152	119.168130	66.6	0.78	9.2	26.2	satellite
2026-04-29 13:53:44.552253+08	BC-PH-2425	10.878163	119.321483	65.5	1.07	12.8	25.4	satellite
2026-04-29 18:39:42.983993+08	BC-PH-2425	10.880827	119.223365	65.4	1.22	4.3	27.4	drone
2026-04-29 23:41:19.389044+08	BC-PH-2425	10.870450	119.179425	67.9	1.86	8.8	28.7	buoy
2026-04-30 04:28:47.832428+08	BC-PH-2425	10.984275	119.117006	63.5	1.42	5.3	23.9	satellite
2026-04-30 08:49:47.324104+08	BC-PH-2425	10.902107	119.153667	68.7	0.52	17.2	28.3	buoy
2026-04-30 13:51:48.79609+08	BC-PH-2425	10.983481	119.327279	65.6	0.58	7.0	27.9	satellite
2026-04-30 18:47:30.780619+08	BC-PH-2425	10.712107	119.156193	63.9	0.83	0.0	25.4	satellite
2026-04-30 22:56:35.64809+08	BC-PH-2425	10.822551	119.136906	62.9	0.83	7.0	26.3	drone
2026-05-01 04:07:41.472335+08	BC-PH-2425	10.977464	119.372358	61.8	0.59	11.8	30.2	satellite
2026-05-01 09:06:02.323576+08	BC-PH-2425	11.006130	119.380927	60.3	0.85	19.3	25.8	satellite
2026-05-01 13:41:37.348723+08	BC-PH-2425	10.930924	119.349562	65.8	0.21	0.0	24.4	satellite
2026-05-01 18:05:06.645368+08	BC-PH-2425	10.914033	119.400964	65.1	1.09	14.4	23.2	satellite
2026-05-01 23:30:31.039456+08	BC-PH-2425	11.000707	119.235642	60.1	0.83	3.9	26.7	satellite
2026-05-02 04:06:06.223955+08	BC-PH-2425	10.999166	119.335505	60.8	1.53	5.4	30.2	satellite
2026-05-02 08:59:42.410251+08	BC-PH-2425	10.855050	119.386642	63.0	0.24	7.2	27.0	buoy
2026-05-02 13:36:23.781722+08	BC-PH-2425	11.013628	119.168009	57.4	1.11	10.8	29.3	satellite
2026-05-02 18:22:25.67419+08	BC-PH-2425	10.839010	119.347810	59.0	0.00	0.0	26.8	satellite
2026-05-02 23:38:42.224455+08	BC-PH-2425	10.866406	119.317369	61.4	0.00	5.3	28.1	satellite
2026-05-03 03:39:03.419234+08	BC-PH-2425	10.960505	119.263209	65.7	1.03	2.0	25.3	drone
2026-05-03 09:17:11.770555+08	BC-PH-2425	10.808589	119.276469	62.8	0.07	4.3	25.4	drone
2026-05-03 13:08:43.282645+08	BC-PH-2425	11.042069	119.277367	55.8	1.15	11.6	28.1	buoy
2026-05-03 18:42:11.419521+08	BC-PH-2425	10.777659	119.453275	62.1	0.06	0.6	27.8	satellite
2026-04-03 23:15:34.826004+08	BC-RY-2429	24.461717	124.325658	97.0	1.09	0.0	27.1	drone
2026-04-04 04:28:03.24749+08	BC-RY-2429	24.369281	124.034776	98.4	1.68	14.1	26.8	satellite
2026-04-04 08:45:37.638572+08	BC-RY-2429	24.452786	124.220766	98.3	0.94	4.4	26.6	drone
2026-04-04 13:18:42.337427+08	BC-RY-2429	24.510130	124.228340	98.3	0.89	8.6	25.9	buoy
2026-04-04 18:17:46.118748+08	BC-RY-2429	24.568825	124.129530	95.5	0.59	4.8	28.9	satellite
2026-04-04 23:29:11.256498+08	BC-RY-2429	24.588426	124.097124	101.9	0.80	1.6	29.3	satellite
2026-04-05 04:03:52.944477+08	BC-RY-2429	24.392401	124.098823	102.9	1.72	7.7	29.3	satellite
2026-04-05 09:07:00.069863+08	BC-RY-2429	24.467345	124.144452	101.9	1.06	6.0	25.0	satellite
2026-04-05 13:11:19.991219+08	BC-RY-2429	24.396115	124.093694	96.2	0.29	3.6	27.6	satellite
2026-04-05 18:45:36.232659+08	BC-RY-2429	24.593633	124.227917	100.5	0.49	4.4	28.5	satellite
2026-04-05 22:56:54.520854+08	BC-RY-2429	24.377717	124.241220	97.3	1.28	18.4	28.2	satellite
2026-04-06 04:04:29.422505+08	BC-RY-2429	24.511091	124.187584	97.1	0.80	3.1	27.2	satellite
2026-04-06 08:54:53.269974+08	BC-RY-2429	24.379522	124.200951	98.7	0.40	5.7	28.1	drone
2026-04-06 14:04:22.421546+08	BC-RY-2429	24.416857	124.122516	92.7	0.93	3.6	25.4	buoy
2026-04-06 18:32:49.559405+08	BC-RY-2429	24.284922	124.049829	97.1	1.00	11.4	31.7	drone
2026-04-06 23:19:43.680926+08	BC-RY-2429	24.282162	124.234452	97.7	0.89	10.7	25.8	drone
2026-04-07 04:25:10.528246+08	BC-RY-2429	24.266840	124.120683	92.4	1.46	11.2	28.6	satellite
2026-04-07 08:49:23.329109+08	BC-RY-2429	24.285331	124.027501	97.8	0.34	3.7	26.9	buoy
2026-04-07 14:01:27.04338+08	BC-RY-2429	24.525726	123.995031	91.7	0.56	5.4	24.8	satellite
2026-04-07 18:08:40.6895+08	BC-RY-2429	24.258242	124.004004	93.4	0.87	11.2	27.1	satellite
2026-04-07 23:04:13.06571+08	BC-RY-2429	24.515210	124.112211	95.0	0.56	0.8	27.4	satellite
2026-04-08 04:19:46.986833+08	BC-RY-2429	24.492606	124.218715	91.6	0.79	0.0	23.2	satellite
2026-04-08 08:36:05.161307+08	BC-RY-2429	24.384144	124.088721	92.7	0.44	13.3	28.4	satellite
2026-04-08 13:29:45.060023+08	BC-RY-2429	24.391629	123.971805	95.3	0.99	7.0	25.6	buoy
2026-04-08 18:50:00.484065+08	BC-RY-2429	24.501556	124.198480	90.7	0.30	12.5	26.2	satellite
2026-04-08 23:35:12.289524+08	BC-RY-2429	24.323588	124.122010	93.3	0.84	3.7	26.5	satellite
2026-04-09 04:31:48.634202+08	BC-RY-2429	24.208024	124.129163	90.8	0.31	7.6	24.6	satellite
2026-04-09 08:58:56.81452+08	BC-RY-2429	24.366592	124.032492	95.9	0.93	8.9	27.0	satellite
2026-04-09 13:33:26.545452+08	BC-RY-2429	24.208636	123.960756	95.5	0.63	9.2	25.5	satellite
2026-04-09 18:21:59.360003+08	BC-RY-2429	24.339590	123.966815	88.6	1.79	10.3	29.1	satellite
2026-04-09 23:16:54.324277+08	BC-RY-2429	24.261820	123.999866	91.1	0.44	11.1	27.3	satellite
2026-04-10 04:25:12.961826+08	BC-RY-2429	24.351512	124.145332	90.6	0.50	4.8	28.4	satellite
2026-04-10 08:41:41.537127+08	BC-RY-2429	24.230506	124.031847	86.8	0.00	12.9	24.5	satellite
2026-04-10 14:04:04.37948+08	BC-RY-2429	24.189420	124.121051	94.0	1.31	1.1	27.5	satellite
2026-04-10 18:23:52.92731+08	BC-RY-2429	24.306475	123.970371	88.7	1.68	9.9	27.6	satellite
2026-04-10 23:31:12.683872+08	BC-RY-2429	24.299468	124.105850	86.0	0.07	5.4	26.9	satellite
2026-04-11 03:47:27.358809+08	BC-RY-2429	24.318282	124.152481	85.7	0.27	8.5	26.1	satellite
2026-04-11 09:09:18.926135+08	BC-RY-2429	24.393413	123.883184	92.2	1.09	1.3	28.0	drone
2026-04-11 13:26:00.847351+08	BC-RY-2429	24.209717	124.027254	88.6	0.72	1.8	24.8	satellite
2026-04-11 18:20:40.774326+08	BC-RY-2429	24.295223	123.891864	86.0	0.80	3.6	24.3	buoy
2026-04-11 23:21:30.154369+08	BC-RY-2429	24.412505	124.118722	89.2	0.42	3.2	27.9	satellite
2026-04-12 04:11:15.982065+08	BC-RY-2429	24.174512	124.030931	90.0	0.73	8.4	28.7	buoy
2026-04-12 09:04:30.090126+08	BC-RY-2429	24.221773	124.160832	84.9	1.94	10.0	28.0	buoy
2026-04-12 13:33:12.601291+08	BC-RY-2429	24.254606	124.047644	85.3	0.16	4.3	26.7	satellite
2026-04-12 18:48:59.750629+08	BC-RY-2429	24.359611	124.140965	87.4	1.39	19.4	26.3	buoy
2026-04-12 23:12:46.517234+08	BC-RY-2429	24.106204	124.144623	91.3	1.77	7.1	27.9	drone
2026-04-13 03:59:48.541674+08	BC-RY-2429	24.101527	124.051552	89.2	0.00	16.5	25.4	buoy
2026-04-13 09:15:56.072181+08	BC-RY-2429	24.156395	123.851825	85.4	0.00	8.7	26.1	satellite
2026-04-13 13:44:14.37832+08	BC-RY-2429	24.258240	123.987476	82.7	1.69	6.2	26.3	satellite
2026-04-13 18:04:10.979824+08	BC-RY-2429	24.311403	123.847731	91.3	1.15	9.1	28.4	satellite
2026-04-13 23:15:05.366395+08	BC-RY-2429	24.256708	124.064753	85.7	0.00	0.0	25.7	satellite
2026-04-14 04:12:18.189028+08	BC-RY-2429	24.246130	123.913235	91.0	0.61	6.2	28.1	satellite
2026-04-14 08:53:33.874543+08	BC-RY-2429	24.206923	123.830404	89.8	0.76	3.6	25.8	satellite
2026-04-14 13:10:39.293892+08	BC-RY-2429	24.133646	123.863119	90.7	1.55	15.4	26.3	drone
2026-04-14 18:56:01.707256+08	BC-RY-2429	24.243070	123.829380	80.7	0.93	8.6	26.0	satellite
2026-04-14 22:59:06.676357+08	BC-RY-2429	24.328302	123.857406	87.6	1.36	2.7	27.3	satellite
2026-04-15 03:53:49.957951+08	BC-RY-2429	24.130108	124.056142	90.1	0.00	7.5	26.7	satellite
2026-04-15 08:35:05.086164+08	BC-RY-2429	24.228921	124.036039	85.4	0.47	17.0	29.2	satellite
2026-04-15 13:48:38.91817+08	BC-RY-2429	24.210050	124.029579	84.7	1.11	8.8	25.8	drone
2026-04-15 18:33:44.785709+08	BC-RY-2429	24.222292	123.934744	80.6	0.94	3.6	29.3	satellite
2026-04-15 23:40:14.385127+08	BC-RY-2429	24.162306	123.923212	88.4	0.90	1.3	24.7	drone
2026-04-16 03:45:09.52562+08	BC-RY-2429	24.109241	123.847133	86.6	0.23	3.5	26.2	drone
2026-04-16 09:00:01.703714+08	BC-RY-2429	24.093352	123.979172	88.3	0.00	12.9	31.8	satellite
2026-04-16 13:41:01.577673+08	BC-RY-2429	24.266129	123.870702	80.9	1.15	17.8	28.8	satellite
2026-04-16 18:30:35.961896+08	BC-RY-2429	23.988705	123.777215	80.5	1.52	0.0	24.7	satellite
2026-04-16 23:17:41.792468+08	BC-RY-2429	24.092004	123.881106	87.1	0.44	12.1	27.2	satellite
2026-04-17 04:23:53.919918+08	BC-RY-2429	23.995849	124.052211	77.5	0.28	0.0	27.6	satellite
2026-04-17 08:32:56.666258+08	BC-RY-2429	24.055853	124.030307	81.9	1.53	11.1	25.3	satellite
2026-04-17 14:05:41.388821+08	BC-RY-2429	24.105865	123.862502	79.5	0.89	6.3	27.9	drone
2026-04-17 18:21:15.498617+08	BC-RY-2429	24.074945	123.820257	78.0	0.70	14.3	24.9	satellite
2026-04-17 22:48:55.873318+08	BC-RY-2429	24.109838	123.822343	84.4	0.21	6.7	29.6	buoy
2026-04-18 04:16:30.938453+08	BC-RY-2429	23.949327	123.879659	83.9	0.42	20.6	26.6	satellite
2026-04-18 08:28:55.900693+08	BC-RY-2429	24.166869	123.911891	77.1	0.60	3.2	24.6	satellite
2026-04-18 13:54:01.967433+08	BC-RY-2429	24.052614	123.905399	79.5	0.47	6.1	27.9	satellite
2026-04-18 18:46:35.245648+08	BC-RY-2429	24.087309	123.883972	82.0	0.39	8.6	28.1	satellite
2026-04-18 23:03:59.545349+08	BC-RY-2429	23.928398	123.904399	76.5	1.37	14.9	28.0	satellite
2026-04-19 04:10:13.303314+08	BC-RY-2429	23.934611	123.732675	80.0	1.46	2.2	27.1	drone
2026-04-19 09:19:32.453797+08	BC-RY-2429	23.985624	123.949119	82.0	0.85	8.0	28.1	satellite
2026-04-19 13:29:40.038234+08	BC-RY-2429	24.042904	123.862741	81.5	0.06	15.2	27.1	satellite
2026-04-19 18:47:57.101517+08	BC-RY-2429	23.981643	123.850402	80.6	0.28	2.8	29.5	satellite
2026-04-19 22:56:41.641273+08	BC-RY-2429	24.099918	123.769924	79.9	2.35	6.0	23.9	satellite
2026-04-20 04:13:00.278033+08	BC-RY-2429	23.910719	123.940068	80.0	1.05	6.1	28.4	satellite
2026-04-20 08:29:14.171609+08	BC-RY-2429	24.057699	123.851721	82.3	0.87	7.2	24.9	satellite
2026-04-20 13:25:02.010979+08	BC-RY-2429	23.889110	123.737481	74.9	0.47	9.9	25.6	satellite
2026-04-20 18:19:36.497676+08	BC-RY-2429	24.085280	123.717888	82.2	1.53	9.5	27.7	satellite
2026-04-20 22:45:50.53714+08	BC-RY-2429	23.862951	123.925756	80.0	0.66	5.1	29.8	buoy
2026-04-21 04:20:02.890501+08	BC-RY-2429	23.926021	123.919300	75.1	1.20	9.1	25.1	drone
2026-04-21 08:57:39.576826+08	BC-RY-2429	24.085944	123.779651	80.1	0.00	14.4	26.2	drone
2026-04-21 13:55:18.714558+08	BC-RY-2429	23.984440	123.785259	81.5	0.31	14.9	26.2	satellite
2026-04-21 18:39:02.265354+08	BC-RY-2429	23.981755	123.747312	71.5	0.56	8.8	29.5	satellite
2026-04-21 23:07:50.780603+08	BC-RY-2429	24.116132	123.700208	77.6	0.94	8.3	28.1	buoy
2026-04-22 03:34:59.075682+08	BC-RY-2429	23.869550	123.789656	74.8	0.83	8.7	29.4	satellite
2026-04-22 08:30:41.747227+08	BC-RY-2429	23.823903	123.667672	72.0	1.77	17.7	28.0	satellite
2026-04-22 13:10:57.234025+08	BC-RY-2429	23.923259	123.796914	77.1	0.72	7.7	25.3	satellite
2026-04-22 18:32:05.654391+08	BC-RY-2429	23.995212	123.926318	78.7	1.29	3.5	26.7	buoy
2026-04-22 22:49:40.48163+08	BC-RY-2429	24.050482	123.856824	76.3	0.92	5.0	25.9	satellite
2026-04-23 04:02:39.702893+08	BC-RY-2429	23.877386	123.758306	71.0	1.97	2.9	26.2	satellite
2026-04-23 09:10:30.54353+08	BC-RY-2429	23.912780	123.919281	75.3	0.94	14.2	25.1	drone
2026-04-23 13:36:56.558068+08	BC-RY-2429	23.874605	123.764452	77.6	1.24	2.4	24.4	satellite
2026-04-23 18:25:09.92014+08	BC-RY-2429	24.027427	123.905778	75.2	0.03	7.4	26.2	satellite
2026-04-23 22:53:25.75198+08	BC-RY-2429	24.043182	123.734718	75.9	0.47	5.8	26.2	satellite
2026-04-24 03:43:43.45836+08	BC-RY-2429	23.991644	123.672978	72.8	0.93	10.5	24.4	drone
2026-04-24 09:07:58.530546+08	BC-RY-2429	23.963785	123.716948	70.1	0.54	14.6	28.8	satellite
2026-04-24 13:52:28.98878+08	BC-RY-2429	23.784534	123.791372	71.4	0.33	14.9	28.6	drone
2026-04-24 18:42:49.082453+08	BC-RY-2429	23.810340	123.762242	75.6	0.48	12.4	28.1	satellite
2026-04-24 23:28:36.982365+08	BC-RY-2429	23.797778	123.906299	69.6	1.11	1.9	26.9	satellite
2026-04-25 04:06:54.246407+08	BC-RY-2429	23.808479	123.867148	73.1	0.97	2.3	25.8	satellite
2026-04-25 09:03:20.362787+08	BC-RY-2429	23.900017	123.781675	72.1	0.00	8.0	27.0	drone
2026-04-25 13:31:40.279305+08	BC-RY-2429	23.897875	123.858145	75.0	0.49	0.0	27.9	satellite
2026-04-25 18:52:05.769985+08	BC-RY-2429	23.847044	123.881768	74.3	0.34	12.8	32.6	drone
2026-04-25 22:56:44.209054+08	BC-RY-2429	23.885012	123.624612	70.4	0.75	1.9	23.8	drone
2026-04-26 04:29:17.680705+08	BC-RY-2429	23.789194	123.765847	73.3	0.00	16.6	28.1	satellite
2026-04-26 08:44:51.710679+08	BC-RY-2429	23.859196	123.743005	72.9	1.14	5.6	22.8	buoy
2026-04-26 13:15:38.224695+08	BC-RY-2429	23.972309	123.644935	70.8	0.84	0.0	25.4	buoy
2026-04-26 18:53:03.832457+08	BC-RY-2429	23.965010	123.678576	71.4	0.88	9.3	29.1	satellite
2026-04-26 22:57:57.195736+08	BC-RY-2429	23.703319	123.673350	65.3	1.54	0.0	30.2	satellite
2026-04-27 03:52:16.937563+08	BC-RY-2429	23.730324	123.598687	69.1	0.58	12.5	27.7	satellite
2026-04-27 08:45:39.885191+08	BC-RY-2429	23.937135	123.859629	66.7	0.90	13.0	25.9	satellite
2026-04-27 13:36:33.96908+08	BC-RY-2429	23.662188	123.632154	65.9	1.31	21.8	28.6	drone
2026-04-27 18:04:18.369006+08	BC-RY-2429	23.872044	123.840243	70.2	0.22	5.9	30.1	satellite
2026-04-27 23:32:47.734486+08	BC-RY-2429	23.895413	123.711710	71.1	0.29	14.3	28.9	satellite
2026-04-28 04:12:14.164206+08	BC-RY-2429	23.790462	123.634540	67.9	0.88	1.4	26.6	satellite
2026-04-28 09:19:19.336437+08	BC-RY-2429	23.874346	123.674725	64.8	0.83	7.2	25.8	drone
2026-04-28 13:46:25.206121+08	BC-RY-2429	23.797943	123.545746	69.5	1.00	15.3	28.2	drone
2026-04-28 18:36:49.767438+08	BC-RY-2429	23.670210	123.689162	64.9	0.44	1.4	26.6	drone
2026-04-28 23:42:50.812516+08	BC-RY-2429	23.824543	123.769278	65.8	1.72	8.9	26.0	drone
2026-04-29 04:10:13.118229+08	BC-RY-2429	23.751809	123.816755	62.1	0.61	7.9	25.7	buoy
2026-04-29 08:38:29.981835+08	BC-RY-2429	23.660626	123.604502	63.7	0.96	9.9	27.9	drone
2026-04-29 13:35:09.71646+08	BC-RY-2429	23.845279	123.581503	67.3	0.23	7.6	28.8	satellite
2026-04-29 18:52:38.618886+08	BC-RY-2429	23.790659	123.801329	67.8	0.00	8.7	28.2	drone
2026-04-29 23:26:06.026384+08	BC-RY-2429	23.739704	123.752143	66.0	0.68	12.3	23.1	satellite
2026-04-30 04:21:50.710961+08	BC-RY-2429	23.802469	123.670383	69.2	1.02	4.4	24.8	buoy
2026-04-30 08:52:43.783782+08	BC-RY-2429	23.569854	123.698186	60.6	0.14	10.5	20.3	satellite
2026-04-30 13:10:30.98246+08	BC-RY-2429	23.681630	123.544127	66.5	0.85	2.8	26.8	satellite
2026-04-30 18:14:17.060082+08	BC-RY-2429	23.570324	123.550682	63.8	0.25	11.9	27.4	drone
2026-04-30 22:44:30.993554+08	BC-RY-2429	23.699909	123.525777	66.5	0.84	12.1	26.1	satellite
2026-05-01 03:55:01.730081+08	BC-RY-2429	23.758331	123.507317	61.0	0.46	7.2	24.0	satellite
2026-05-01 08:23:35.222482+08	BC-RY-2429	23.717150	123.568061	59.1	0.36	0.7	27.8	satellite
2026-05-01 13:16:24.606416+08	BC-RY-2429	23.655711	123.695385	60.4	1.40	10.0	22.2	buoy
2026-05-01 18:38:16.350894+08	BC-RY-2429	23.562287	123.478286	67.2	0.21	10.9	27.1	drone
2026-05-01 23:38:27.532048+08	BC-RY-2429	23.685093	123.598763	58.7	1.06	0.7	25.4	satellite
2026-05-02 04:30:33.456038+08	BC-RY-2429	23.627462	123.628480	57.9	0.95	6.8	25.9	buoy
2026-05-02 08:51:12.71975+08	BC-RY-2429	23.801445	123.561159	59.5	0.39	0.0	26.7	satellite
2026-05-02 13:38:09.552843+08	BC-RY-2429	23.664576	123.646195	57.2	0.67	5.5	27.8	satellite
2026-05-02 18:06:53.837582+08	BC-RY-2429	23.598817	123.525511	63.0	1.26	19.3	25.1	buoy
2026-05-02 23:14:12.191947+08	BC-RY-2429	23.498521	123.623169	63.7	0.52	1.5	22.5	satellite
2026-05-03 03:59:17.509624+08	BC-RY-2429	23.632264	123.518017	57.5	1.26	14.8	27.7	buoy
2026-05-03 08:43:44.464332+08	BC-RY-2429	23.707384	123.729402	56.3	0.81	12.4	23.5	satellite
2026-05-03 13:34:00.111377+08	BC-RY-2429	23.700017	123.698199	63.2	0.98	10.1	25.5	buoy
2026-05-03 18:00:33.447275+08	BC-RY-2429	23.635452	123.702608	62.6	1.39	17.0	26.0	buoy
2026-04-03 22:45:04.261781+08	BC-CD-2304	8.732377	106.610082	101.4	0.74	9.5	27.4	satellite
2026-04-04 03:44:12.095444+08	BC-CD-2304	8.805575	106.607767	99.0	0.82	0.5	29.8	satellite
2026-04-04 08:38:46.821193+08	BC-CD-2304	8.671509	106.578402	102.6	1.25	5.7	25.4	satellite
2026-04-04 13:39:33.949253+08	BC-CD-2304	8.664607	106.546352	101.3	0.00	2.5	29.2	satellite
2026-04-04 18:22:12.580011+08	BC-CD-2304	8.727915	106.547086	96.1	0.83	6.9	28.3	buoy
2026-04-04 22:58:24.433195+08	BC-CD-2304	8.661393	106.620052	97.6	0.71	1.5	25.7	satellite
2026-04-05 03:48:27.196343+08	BC-CD-2304	8.672883	106.697081	95.2	0.74	11.9	27.9	satellite
2026-04-05 09:02:28.764858+08	BC-CD-2304	8.842345	106.780318	100.5	0.01	17.1	26.3	satellite
2026-04-05 13:38:37.727725+08	BC-CD-2304	8.788897	106.714570	99.2	0.00	18.9	30.0	satellite
2026-04-05 18:42:54.186622+08	BC-CD-2304	8.839086	106.686302	99.5	0.37	1.8	23.9	drone
2026-04-05 23:34:39.523776+08	BC-CD-2304	8.702139	106.702070	99.9	1.05	9.6	23.6	satellite
2026-04-06 04:15:21.525798+08	BC-CD-2304	8.656116	106.632545	97.5	1.22	6.7	23.6	satellite
2026-04-06 08:36:21.409275+08	BC-CD-2304	8.820518	106.562830	101.3	1.44	6.1	25.5	satellite
2026-04-06 13:41:44.838701+08	BC-CD-2304	8.826303	106.779965	100.7	0.62	12.8	26.7	satellite
2026-04-06 18:35:29.447525+08	BC-CD-2304	8.721996	106.724471	97.1	1.59	7.5	29.5	satellite
2026-04-06 23:04:38.880238+08	BC-CD-2304	8.820510	106.798301	93.4	1.09	15.8	24.9	drone
2026-04-07 04:32:03.807448+08	BC-CD-2304	8.782528	106.800701	100.5	0.71	5.8	23.2	drone
2026-04-07 09:12:02.67991+08	BC-CD-2304	8.633668	106.678439	92.0	1.16	8.7	26.0	satellite
2026-04-07 13:28:12.84129+08	BC-CD-2304	8.664066	106.752532	98.8	0.24	10.4	26.6	satellite
2026-04-07 18:12:57.343762+08	BC-CD-2304	8.712977	106.682227	94.9	0.53	9.6	26.3	satellite
2026-04-07 23:36:54.85921+08	BC-CD-2304	8.798666	106.722284	97.0	1.69	4.6	30.7	satellite
2026-04-08 03:37:19.00562+08	BC-CD-2304	8.882282	106.691028	98.0	0.63	10.8	27.9	satellite
2026-04-08 09:10:23.947739+08	BC-CD-2304	8.832651	106.610241	90.9	0.81	17.3	25.1	satellite
2026-04-08 13:37:11.971612+08	BC-CD-2304	8.685507	106.843847	96.3	0.96	7.5	28.5	satellite
2026-04-08 18:12:40.247129+08	BC-CD-2304	8.877196	106.833093	96.8	0.62	0.0	26.7	satellite
2026-04-08 23:43:33.946419+08	BC-CD-2304	8.793908	106.658403	88.5	1.15	13.5	24.6	satellite
2026-04-09 04:20:38.321955+08	BC-CD-2304	8.686140	106.882731	95.5	1.18	11.8	29.1	buoy
2026-04-09 08:29:52.280755+08	BC-CD-2304	8.718684	106.761483	88.4	0.00	13.9	25.5	satellite
2026-04-09 13:12:56.257731+08	BC-CD-2304	8.749764	106.681097	95.9	0.77	8.6	27.3	satellite
2026-04-09 18:54:15.265286+08	BC-CD-2304	8.702169	106.886352	91.8	0.62	14.7	23.1	drone
2026-04-09 23:08:19.242848+08	BC-CD-2304	8.892666	106.676326	95.2	0.95	6.2	24.0	drone
2026-04-10 04:19:26.882053+08	BC-CD-2304	8.856957	106.914505	89.5	0.55	7.4	26.9	drone
2026-04-10 08:49:15.811448+08	BC-CD-2304	8.836402	106.693747	88.8	1.60	15.5	30.2	satellite
2026-04-10 14:01:19.929825+08	BC-CD-2304	8.769119	106.878949	87.8	0.29	16.1	26.2	satellite
2026-04-10 18:42:24.60619+08	BC-CD-2304	8.819576	106.669300	88.8	1.32	9.1	28.9	satellite
2026-04-10 22:51:40.354063+08	BC-CD-2304	8.958526	106.897592	86.9	0.65	4.3	24.3	drone
2026-04-11 04:02:54.492421+08	BC-CD-2304	8.883476	106.758367	94.6	0.00	9.1	27.0	buoy
2026-04-11 09:01:29.85033+08	BC-CD-2304	8.960405	106.943708	88.1	0.59	3.5	27.1	buoy
2026-04-11 14:03:47.001866+08	BC-CD-2304	8.995586	106.835565	87.6	0.00	12.4	29.9	drone
2026-04-11 18:23:20.419128+08	BC-CD-2304	8.946906	106.964204	90.6	1.45	10.4	28.6	drone
2026-04-11 23:41:50.581794+08	BC-CD-2304	8.784758	106.871196	93.7	1.04	14.8	29.4	satellite
2026-04-12 04:20:37.24764+08	BC-CD-2304	9.018818	106.975860	87.0	1.41	12.3	27.2	satellite
2026-04-12 09:08:17.723702+08	BC-CD-2304	8.875546	106.792639	91.3	1.02	11.5	28.0	buoy
2026-04-12 13:40:45.473083+08	BC-CD-2304	8.907408	106.900887	85.5	1.02	13.2	26.0	drone
2026-04-12 18:36:55.906989+08	BC-CD-2304	8.934821	106.967935	88.9	0.60	2.9	30.1	satellite
2026-04-12 23:21:54.238261+08	BC-CD-2304	8.867881	106.833820	89.4	1.59	12.4	25.0	satellite
2026-04-13 04:32:10.829802+08	BC-CD-2304	8.800128	106.747260	89.3	0.75	20.8	25.1	satellite
2026-04-13 09:19:03.960919+08	BC-CD-2304	9.032291	106.945461	83.7	0.45	14.7	23.6	satellite
2026-04-13 13:14:51.050591+08	BC-CD-2304	8.905987	106.904324	90.5	1.28	8.0	27.3	satellite
2026-04-13 18:53:04.349206+08	BC-CD-2304	8.900786	106.914930	89.2	0.08	0.0	28.2	buoy
2026-04-16 18:43:11.229565+08	BC-PH-2311	23.144571	119.582924	83.2	0.68	14.2	24.2	buoy
2026-04-13 23:10:43.627385+08	BC-CD-2304	8.874948	106.818915	85.8	1.03	2.6	27.8	satellite
2026-04-14 04:28:37.661149+08	BC-CD-2304	8.881545	106.803863	89.6	0.00	9.2	28.1	satellite
2026-04-14 08:22:05.774886+08	BC-CD-2304	9.056921	106.823820	84.1	1.05	2.0	24.4	buoy
2026-04-14 13:44:17.570239+08	BC-CD-2304	8.893980	107.035939	81.1	0.25	0.0	28.8	satellite
2026-04-14 18:39:41.194579+08	BC-CD-2304	9.008622	106.880148	89.4	0.61	2.9	24.8	buoy
2026-04-14 22:50:53.902148+08	BC-CD-2304	8.822383	107.042748	88.0	1.25	0.0	28.5	drone
2026-04-15 04:22:50.923312+08	BC-CD-2304	9.054946	107.069672	88.3	0.46	17.6	26.1	satellite
2026-04-15 09:12:36.953453+08	BC-CD-2304	9.085668	106.844861	87.1	0.60	9.1	26.1	satellite
2026-04-15 13:10:47.905083+08	BC-CD-2304	8.985851	107.043203	81.2	0.88	6.8	29.5	satellite
2026-04-15 18:05:21.051079+08	BC-CD-2304	9.003826	106.857267	86.1	0.69	6.0	26.6	buoy
2026-04-15 23:00:38.46126+08	BC-CD-2304	8.835718	106.879822	88.8	0.56	11.6	24.5	satellite
2026-04-16 04:20:40.463132+08	BC-CD-2304	8.848715	107.056640	78.9	1.48	6.5	26.9	satellite
2026-04-16 08:24:07.990962+08	BC-CD-2304	8.965218	106.953863	84.6	0.63	8.1	24.8	satellite
2026-04-16 13:58:09.330364+08	BC-CD-2304	8.918278	107.051432	84.7	1.02	6.8	26.5	satellite
2026-04-16 18:44:41.706635+08	BC-CD-2304	8.880059	107.074653	87.3	0.73	6.1	26.6	satellite
2026-04-16 23:31:05.974257+08	BC-CD-2304	9.039730	107.117145	81.2	0.45	16.1	26.7	drone
2026-04-17 04:13:02.895271+08	BC-CD-2304	9.076656	106.867026	77.5	0.69	3.5	26.9	buoy
2026-04-17 09:16:38.165864+08	BC-CD-2304	9.049855	106.923311	82.0	0.33	11.3	27.7	drone
2026-04-17 14:00:05.105276+08	BC-CD-2304	8.873768	106.900012	81.5	1.33	5.7	28.3	satellite
2026-04-17 18:40:24.766907+08	BC-CD-2304	8.891212	106.980210	77.4	0.66	4.7	27.4	satellite
2026-04-17 22:58:05.192831+08	BC-CD-2304	8.922748	106.954750	77.2	0.54	6.8	26.6	drone
2026-04-18 03:49:36.306549+08	BC-CD-2304	9.079496	107.144792	78.4	0.36	0.0	26.3	satellite
2026-04-18 08:55:23.875572+08	BC-CD-2304	9.015923	107.014090	77.6	0.47	11.1	25.7	satellite
2026-04-18 13:26:14.013522+08	BC-CD-2304	9.068469	107.017000	84.3	0.31	17.1	28.3	buoy
2026-04-18 18:35:57.653941+08	BC-CD-2304	8.942127	107.106469	76.9	1.22	16.0	25.9	satellite
2026-04-18 23:17:51.159937+08	BC-CD-2304	9.050612	106.954361	84.6	1.12	6.7	30.4	satellite
2026-04-19 03:56:57.572328+08	BC-CD-2304	8.894658	107.125754	83.3	0.61	2.8	26.6	satellite
2026-04-19 08:55:10.024474+08	BC-CD-2304	9.076019	107.133182	80.6	1.77	13.8	26.1	buoy
2026-04-19 13:51:10.744655+08	BC-CD-2304	9.091061	107.050128	77.9	0.22	5.5	25.0	drone
2026-04-19 18:38:46.288671+08	BC-CD-2304	8.883340	107.000280	76.4	1.09	5.0	24.8	satellite
2026-04-19 23:11:49.311226+08	BC-CD-2304	8.931518	107.131508	79.1	0.66	12.3	24.8	satellite
2026-04-20 04:01:38.111206+08	BC-CD-2304	9.004894	107.117929	82.5	0.15	3.4	26.2	buoy
2026-04-20 09:07:08.027395+08	BC-CD-2304	8.912663	107.204585	80.5	0.95	2.5	29.6	satellite
2026-04-20 13:56:36.789647+08	BC-CD-2304	9.038679	106.972838	77.7	0.06	4.1	27.0	satellite
2026-04-20 18:06:05.113387+08	BC-CD-2304	8.929094	107.064555	77.0	1.19	9.4	25.6	satellite
2026-04-20 23:22:10.874041+08	BC-CD-2304	9.032339	107.101782	78.5	0.38	3.5	29.8	drone
2026-04-21 03:51:04.417856+08	BC-CD-2304	9.131131	107.125809	81.4	0.81	12.6	28.2	satellite
2026-04-21 09:12:51.0249+08	BC-CD-2304	9.155851	107.045924	74.6	0.85	12.3	28.0	satellite
2026-04-21 13:21:20.50712+08	BC-CD-2304	9.167424	107.148556	71.6	0.58	6.1	29.5	drone
2026-04-21 18:14:39.066175+08	BC-CD-2304	9.084447	107.059780	76.9	0.26	8.0	25.3	satellite
2026-04-21 23:35:34.925561+08	BC-CD-2304	9.094355	107.147688	71.2	0.71	2.2	25.4	satellite
2026-04-22 04:30:53.156525+08	BC-CD-2304	8.991603	107.171962	75.0	1.57	13.5	25.4	satellite
2026-04-22 08:28:04.927024+08	BC-CD-2304	9.109653	107.148097	75.3	0.63	8.2	25.2	satellite
2026-04-22 14:00:00.39744+08	BC-CD-2304	8.971363	107.316844	77.6	1.01	9.5	24.8	satellite
2026-04-22 18:42:24.88653+08	BC-CD-2304	9.028177	107.169138	70.2	0.00	10.0	24.0	drone
2026-04-22 23:40:55.924429+08	BC-CD-2304	9.194882	107.207138	71.1	0.22	0.2	26.7	satellite
2026-04-23 04:28:31.233508+08	BC-CD-2304	9.045195	107.191959	69.6	0.77	5.2	25.7	buoy
2026-04-23 08:47:42.920934+08	BC-CD-2304	9.069511	107.095388	73.7	1.12	13.1	27.9	satellite
2026-04-23 13:42:03.771014+08	BC-CD-2304	9.000438	107.246705	76.0	0.53	12.4	26.5	drone
2026-04-23 18:34:08.841258+08	BC-CD-2304	9.002183	107.324078	74.3	0.83	10.8	27.3	drone
2026-04-23 23:27:41.348071+08	BC-CD-2304	9.068053	107.077785	73.9	0.87	1.6	27.4	satellite
2026-04-24 04:22:53.206981+08	BC-CD-2304	9.040004	107.142709	73.7	0.00	4.1	22.2	buoy
2026-04-24 08:40:50.741052+08	BC-CD-2304	9.131896	107.293237	74.0	1.20	4.8	22.5	buoy
2026-04-24 13:54:45.902459+08	BC-CD-2304	9.128169	107.371253	77.0	0.43	0.6	31.0	satellite
2026-04-24 18:54:47.920081+08	BC-CD-2304	9.126979	107.117975	68.5	0.00	15.0	28.0	satellite
2026-04-24 23:37:43.920459+08	BC-CD-2304	9.034099	107.346219	70.2	2.32	9.8	24.1	buoy
2026-04-25 03:41:55.681509+08	BC-CD-2304	9.082159	107.294368	67.5	1.20	15.4	28.1	satellite
2026-04-25 08:38:43.948559+08	BC-CD-2304	9.158271	107.233720	75.9	0.90	9.8	25.0	satellite
2026-04-25 13:28:07.094935+08	BC-CD-2304	9.182944	107.381882	66.4	0.79	4.8	23.9	buoy
2026-04-25 18:02:01.121823+08	BC-CD-2304	9.078443	107.170584	70.4	0.70	16.3	21.5	satellite
2026-04-25 22:57:42.216127+08	BC-CD-2304	9.177375	107.258988	66.5	0.78	17.6	26.1	drone
2026-04-26 04:22:25.834936+08	BC-CD-2304	9.040491	107.320470	67.8	0.73	8.4	28.3	satellite
2026-04-26 08:38:39.249779+08	BC-CD-2304	9.307158	107.418422	74.1	0.70	15.4	24.7	satellite
2026-04-26 13:53:59.585855+08	BC-CD-2304	9.094110	107.236489	71.7	0.36	1.7	26.9	drone
2026-04-26 18:42:31.484882+08	BC-CD-2304	9.267280	107.382895	71.5	0.98	13.3	27.4	satellite
2026-04-26 22:46:00.011731+08	BC-CD-2304	9.306460	107.363878	70.5	1.58	16.0	24.6	satellite
2026-04-27 03:49:14.473572+08	BC-CD-2304	9.115602	107.315424	65.6	0.73	15.4	26.6	drone
2026-04-27 08:39:30.767818+08	BC-CD-2304	9.265669	107.327987	68.5	0.11	6.2	28.9	satellite
2026-04-27 14:05:29.462871+08	BC-CD-2304	9.100992	107.231650	64.3	1.52	2.4	26.7	satellite
2026-04-27 18:34:56.320309+08	BC-CD-2304	9.149274	107.376025	72.1	1.14	10.3	27.6	drone
2026-04-27 22:57:09.013487+08	BC-CD-2304	9.297747	107.430353	69.2	1.26	11.9	24.9	drone
2026-04-28 03:49:36.721099+08	BC-CD-2304	9.090439	107.407305	68.1	0.96	13.1	28.6	buoy
2026-04-28 09:01:02.406932+08	BC-CD-2304	9.072963	107.337334	62.8	0.57	16.9	25.2	satellite
2026-04-28 14:07:23.34683+08	BC-CD-2304	9.216599	107.331201	66.0	0.05	15.5	23.7	drone
2026-04-28 18:42:53.243283+08	BC-CD-2304	9.120236	107.465662	62.7	1.08	8.3	27.5	drone
2026-04-28 23:28:34.284737+08	BC-CD-2304	9.284270	107.240689	71.4	0.56	9.6	25.3	satellite
2026-04-29 04:01:53.662115+08	BC-CD-2304	9.276098	107.497369	64.1	0.46	9.4	24.7	buoy
2026-04-29 08:55:02.996669+08	BC-CD-2304	9.098861	107.233528	67.8	1.24	8.9	25.3	drone
2026-04-29 13:44:42.746884+08	BC-CD-2304	9.326995	107.507277	70.2	0.53	1.6	29.4	satellite
2026-04-29 18:26:24.932023+08	BC-CD-2304	9.095061	107.378998	70.1	0.76	13.7	25.5	drone
2026-04-29 23:37:32.943916+08	BC-CD-2304	9.319339	107.445972	60.8	1.29	0.0	25.0	satellite
2026-04-30 04:30:59.647031+08	BC-CD-2304	9.119164	107.344665	65.9	0.59	7.6	30.3	satellite
2026-04-30 08:46:12.330616+08	BC-CD-2304	9.330170	107.432304	66.3	0.46	3.5	24.6	satellite
2026-04-30 13:13:45.154644+08	BC-CD-2304	9.259278	107.463418	69.0	0.47	11.6	29.6	buoy
2026-04-30 18:40:44.412469+08	BC-CD-2304	9.129173	107.559380	67.9	1.73	15.5	25.2	satellite
2026-04-30 22:59:14.844064+08	BC-CD-2304	9.173962	107.389029	67.1	0.00	2.9	24.3	satellite
2026-05-01 04:11:34.831822+08	BC-CD-2304	9.366254	107.438142	65.6	0.50	8.9	27.2	satellite
2026-05-01 09:12:55.985756+08	BC-CD-2304	9.308967	107.556127	65.2	0.06	3.8	28.6	satellite
2026-05-01 14:03:19.447471+08	BC-CD-2304	9.197727	107.562679	63.6	0.69	4.0	26.4	satellite
2026-05-01 18:32:27.548531+08	BC-CD-2304	9.351717	107.431003	66.1	1.17	8.5	28.1	drone
2026-05-01 23:07:34.617456+08	BC-CD-2304	9.391847	107.321013	66.6	0.00	19.3	26.0	buoy
2026-05-02 03:37:07.399716+08	BC-CD-2304	9.378601	107.525049	60.7	0.72	4.5	25.5	satellite
2026-05-02 08:34:44.747674+08	BC-CD-2304	9.180648	107.402326	63.8	0.62	3.3	29.2	drone
2026-05-02 14:01:53.078642+08	BC-CD-2304	9.213409	107.537508	65.7	1.45	12.2	27.8	buoy
2026-05-02 18:46:51.211746+08	BC-CD-2304	9.375097	107.405664	63.8	1.11	6.8	29.5	drone
2026-05-02 22:51:49.847445+08	BC-CD-2304	9.155639	107.559855	64.9	0.39	10.8	27.5	satellite
2026-05-03 04:27:26.669945+08	BC-CD-2304	9.296743	107.413349	56.1	0.94	7.6	26.6	drone
2026-05-03 08:43:02.331763+08	BC-CD-2304	9.297059	107.454101	58.6	0.94	2.6	25.7	satellite
2026-05-03 14:03:46.092396+08	BC-CD-2304	9.268165	107.605318	56.8	0.73	14.8	26.9	satellite
2026-05-03 18:54:25.923922+08	BC-CD-2304	9.211429	107.605299	60.0	0.82	12.1	26.0	satellite
2026-04-03 23:14:04.58943+08	BC-PG-2307	-3.468205	135.455258	97.4	0.56	13.2	24.3	drone
2026-04-04 03:37:58.392922+08	BC-PG-2307	-3.457875	135.309328	97.7	0.17	6.2	27.2	satellite
2026-04-04 09:05:59.755656+08	BC-PG-2307	-3.509075	135.525011	102.6	0.49	4.9	24.8	drone
2026-04-04 14:03:24.153732+08	BC-PG-2307	-3.436884	135.480994	97.1	1.13	2.3	28.3	satellite
2026-04-04 18:16:28.773001+08	BC-PG-2307	-3.427496	135.314763	99.1	1.08	6.4	25.7	drone
2026-04-04 23:12:57.899465+08	BC-PG-2307	-3.483241	135.305907	97.5	1.00	2.5	26.5	satellite
2026-04-05 04:21:05.956999+08	BC-PG-2307	-3.625464	135.396075	93.6	0.67	2.2	29.0	satellite
2026-04-05 09:10:25.272776+08	BC-PG-2307	-3.457603	135.278460	97.9	0.96	18.4	23.1	drone
2026-04-05 13:42:07.306929+08	BC-PG-2307	-3.433416	135.422365	95.6	0.78	5.6	27.0	satellite
2026-04-05 18:33:27.201521+08	BC-PG-2307	-3.451746	135.336312	97.3	0.55	3.5	27.1	buoy
2026-04-05 23:02:29.9967+08	BC-PG-2307	-3.432977	135.490111	101.4	0.37	0.0	26.4	satellite
2026-04-06 04:27:41.803949+08	BC-PG-2307	-3.532980	135.395102	98.3	1.67	6.4	28.5	satellite
2026-04-06 09:01:21.780566+08	BC-PG-2307	-3.392959	135.251526	98.7	1.26	12.8	26.9	drone
2026-04-06 13:17:53.665775+08	BC-PG-2307	-3.586320	135.429781	94.5	0.81	11.5	26.9	buoy
2026-04-06 18:12:35.823134+08	BC-PG-2307	-3.549235	135.302043	92.1	0.67	11.8	26.8	satellite
2026-04-06 23:14:58.100297+08	BC-PG-2307	-3.541869	135.436061	95.7	0.86	1.4	22.5	satellite
2026-04-07 03:40:40.908452+08	BC-PG-2307	-3.542682	135.241863	97.7	0.44	15.5	25.5	satellite
2026-04-07 08:39:56.243813+08	BC-PG-2307	-3.539905	135.392994	98.8	0.55	9.8	26.3	buoy
2026-04-07 13:28:41.008266+08	BC-PG-2307	-3.367281	135.224210	99.5	0.45	10.6	26.9	satellite
2026-04-07 17:59:07.162879+08	BC-PG-2307	-3.418223	135.467520	99.8	0.00	9.4	27.5	drone
2026-04-07 23:05:21.160091+08	BC-PG-2307	-3.538844	135.283270	94.4	0.68	15.4	27.9	satellite
2026-04-08 04:20:49.731556+08	BC-PG-2307	-3.485904	135.399542	99.1	1.22	6.1	23.6	satellite
2026-04-08 08:57:56.881694+08	BC-PG-2307	-3.377020	135.421737	91.9	0.85	8.4	30.5	drone
2026-04-08 13:27:42.808879+08	BC-PG-2307	-3.400595	135.434946	96.4	0.00	10.2	27.3	satellite
2026-04-08 18:46:50.308082+08	BC-PG-2307	-3.496760	135.366429	88.8	0.00	1.3	25.2	drone
2026-04-08 23:43:28.110576+08	BC-PG-2307	-3.386217	135.346301	89.1	0.61	15.3	29.2	drone
2026-04-09 04:07:29.948492+08	BC-PG-2307	-3.318177	135.412149	91.2	0.69	5.3	30.2	satellite
2026-04-09 09:16:05.54516+08	BC-PG-2307	-3.400157	135.410164	97.7	1.33	2.8	23.2	satellite
2026-04-09 13:16:25.045626+08	BC-PG-2307	-3.515617	135.220369	89.2	1.47	11.8	27.8	buoy
2026-04-09 18:17:50.303788+08	BC-PG-2307	-3.465172	135.170095	90.0	1.03	0.9	25.6	satellite
2026-04-09 22:57:03.722645+08	BC-PG-2307	-3.442939	135.307790	93.4	0.98	3.0	23.3	satellite
2026-04-10 03:49:28.05553+08	BC-PG-2307	-3.390894	135.385497	88.5	0.79	11.7	27.4	buoy
2026-04-10 08:42:25.787643+08	BC-PG-2307	-3.302429	135.415515	90.7	1.86	19.3	22.1	satellite
2026-04-10 13:47:18.206775+08	BC-PG-2307	-3.543014	135.208737	86.3	1.14	8.6	28.5	drone
2026-04-10 18:08:07.296292+08	BC-PG-2307	-3.460431	135.157584	90.3	1.41	4.3	22.0	satellite
2026-04-10 23:44:22.340776+08	BC-PG-2307	-3.545260	135.232657	93.9	0.91	11.1	27.3	drone
2026-04-11 03:56:39.128682+08	BC-PG-2307	-3.330677	135.176959	86.5	0.63	4.6	27.2	satellite
2026-04-11 08:59:51.419342+08	BC-PG-2307	-3.305345	135.253719	90.4	0.61	8.7	26.4	drone
2026-04-11 13:23:47.738257+08	BC-PG-2307	-3.499853	135.308987	92.4	0.39	9.9	29.9	buoy
2026-04-11 18:09:08.52936+08	BC-PG-2307	-3.563179	135.413700	87.8	0.95	11.8	25.3	drone
2026-04-11 23:26:59.83192+08	BC-PG-2307	-3.301345	135.146370	91.4	0.90	4.8	25.9	buoy
2026-04-12 03:53:33.338152+08	BC-PG-2307	-3.540326	135.164862	92.7	0.14	12.5	27.2	satellite
2026-04-12 08:37:00.038527+08	BC-PG-2307	-3.502786	135.316989	91.8	0.61	7.3	27.3	buoy
2026-04-12 13:20:21.363317+08	BC-PG-2307	-3.528018	135.277029	84.7	0.87	10.0	27.9	satellite
2026-04-12 18:34:32.777374+08	BC-PG-2307	-3.494989	135.349779	88.2	0.64	3.9	25.6	drone
2026-04-12 22:56:27.838041+08	BC-PG-2307	-3.495646	135.099518	86.2	0.53	6.8	26.5	satellite
2026-04-13 03:53:53.968816+08	BC-PG-2307	-3.324301	135.292141	84.2	1.14	0.6	25.9	satellite
2026-04-13 09:16:19.772483+08	BC-PG-2307	-3.275881	135.179394	91.7	0.91	6.3	25.7	satellite
2026-04-13 13:54:45.132255+08	BC-PG-2307	-3.258915	135.211837	90.6	0.11	10.7	26.9	satellite
2026-04-13 18:27:08.741832+08	BC-PG-2307	-3.449664	135.223521	84.0	0.87	8.0	24.4	drone
2026-04-13 23:38:17.588001+08	BC-PG-2307	-3.356735	135.119958	81.7	1.48	8.1	25.8	buoy
2026-04-14 03:37:21.318154+08	BC-PG-2307	-3.381934	135.209891	83.2	0.40	15.8	26.1	satellite
2026-04-14 09:10:03.567684+08	BC-PG-2307	-3.506796	135.324084	83.7	0.28	10.4	26.7	satellite
2026-04-14 13:58:17.485834+08	BC-PG-2307	-3.312327	135.068437	81.4	1.60	14.1	30.1	buoy
2026-04-14 18:41:01.727451+08	BC-PG-2307	-3.276168	135.127125	80.9	0.36	13.0	24.2	satellite
2026-04-14 22:51:10.681199+08	BC-PG-2307	-3.391331	135.273594	84.8	0.49	7.7	28.6	satellite
2026-04-15 03:42:08.031182+08	BC-PG-2307	-3.517142	135.283419	84.4	0.49	12.5	27.6	satellite
2026-04-15 08:39:20.333145+08	BC-PG-2307	-3.280410	135.212274	84.7	1.24	2.1	26.8	satellite
2026-04-15 13:34:41.354312+08	BC-PG-2307	-3.239063	135.309369	80.5	1.05	0.0	24.5	satellite
2026-04-15 18:10:43.029426+08	BC-PG-2307	-3.515238	135.315925	80.8	0.94	8.8	27.4	satellite
2026-04-15 23:39:59.477202+08	BC-PG-2307	-3.418854	135.310701	88.0	0.12	3.0	25.3	buoy
2026-04-16 04:25:45.34203+08	BC-PG-2307	-3.520519	135.050190	86.9	0.81	6.5	24.6	satellite
2026-04-16 08:45:01.055074+08	BC-PG-2307	-3.477179	135.118596	80.4	0.47	9.0	26.7	satellite
2026-04-16 13:12:51.667551+08	BC-PG-2307	-3.457486	135.083398	80.6	0.57	21.6	25.3	satellite
2026-04-16 18:45:52.176632+08	BC-PG-2307	-3.521526	135.259052	83.2	1.47	6.2	27.4	drone
2026-04-16 23:35:17.320344+08	BC-PG-2307	-3.342344	135.134678	87.2	1.76	2.2	25.5	buoy
2026-04-17 04:23:05.834975+08	BC-PG-2307	-3.336999	135.217231	79.0	1.40	11.7	27.9	satellite
2026-04-17 08:45:51.964322+08	BC-PG-2307	-3.506697	135.224158	80.1	0.96	3.0	25.1	satellite
2026-04-17 13:39:03.206899+08	BC-PG-2307	-3.219827	135.151632	85.0	0.93	12.5	28.9	buoy
2026-04-17 18:06:18.718148+08	BC-PG-2307	-3.496327	135.262998	85.7	0.60	13.9	26.5	satellite
2026-04-17 23:39:37.484257+08	BC-PG-2307	-3.447350	135.080383	85.9	1.25	0.0	29.0	satellite
2026-04-18 03:43:37.540161+08	BC-PG-2307	-3.362317	135.081257	85.7	1.38	13.8	28.9	buoy
2026-04-18 08:46:10.353662+08	BC-PG-2307	-3.206296	135.261512	76.6	0.99	9.8	24.1	satellite
2026-04-18 14:05:31.492106+08	BC-PG-2307	-3.368016	135.130637	81.0	0.98	5.6	30.2	buoy
2026-04-18 18:42:35.200378+08	BC-PG-2307	-3.243333	135.063056	76.1	0.96	14.5	24.7	drone
2026-04-18 23:43:58.315843+08	BC-PG-2307	-3.498004	135.128630	81.5	0.76	5.3	25.2	satellite
2026-04-19 03:49:35.088154+08	BC-PG-2307	-3.212241	135.216191	76.3	0.31	5.7	24.7	buoy
2026-04-19 08:45:04.559421+08	BC-PG-2307	-3.197210	135.098459	82.1	1.19	7.9	25.8	buoy
2026-04-19 14:05:03.456324+08	BC-PG-2307	-3.484225	135.172023	80.3	0.23	6.7	26.6	drone
2026-04-19 18:52:02.108019+08	BC-PG-2307	-3.356302	135.195936	79.5	0.71	10.2	27.5	satellite
2026-04-19 23:30:34.142575+08	BC-PG-2307	-3.292940	135.002358	82.4	0.88	8.1	28.4	buoy
2026-04-20 03:58:14.458261+08	BC-PG-2307	-3.371080	135.230709	82.6	0.16	5.4	26.4	satellite
2026-04-20 08:52:14.289106+08	BC-PG-2307	-3.254952	135.096083	74.5	0.55	7.5	27.5	satellite
2026-04-20 13:24:16.795812+08	BC-PG-2307	-3.417624	135.129792	77.6	0.00	16.0	24.5	buoy
2026-04-20 18:50:24.610987+08	BC-PG-2307	-3.199790	135.036874	73.6	0.00	8.6	26.6	satellite
2026-04-20 23:22:57.390441+08	BC-PG-2307	-3.374532	134.961877	73.3	0.41	0.1	27.5	satellite
2026-04-21 04:11:46.973598+08	BC-PG-2307	-3.372082	135.007520	76.1	0.25	15.1	27.8	satellite
2026-04-21 08:23:06.434311+08	BC-PG-2307	-3.287126	135.017846	80.7	0.83	16.8	25.5	satellite
2026-04-21 13:51:12.767811+08	BC-PG-2307	-3.332082	135.094368	72.6	0.77	12.9	27.5	satellite
2026-04-21 18:33:50.226561+08	BC-PG-2307	-3.310396	135.031543	77.0	0.94	7.7	26.7	satellite
2026-04-21 23:16:02.442922+08	BC-PG-2307	-3.261812	135.059519	74.0	0.51	5.4	25.1	satellite
2026-04-22 03:54:13.324303+08	BC-PG-2307	-3.345190	135.110281	79.7	0.07	10.2	25.4	satellite
2026-04-22 09:03:34.278522+08	BC-PG-2307	-3.358478	134.950742	72.4	0.75	8.4	20.5	drone
2026-04-22 13:58:09.29616+08	BC-PG-2307	-3.404385	135.074726	79.6	0.87	0.4	24.3	drone
2026-04-22 18:48:04.902038+08	BC-PG-2307	-3.286871	135.160496	79.1	2.02	2.4	26.8	drone
2026-04-22 22:56:21.331993+08	BC-PG-2307	-3.407882	134.917322	75.8	1.25	13.0	27.8	drone
2026-04-23 03:45:56.976235+08	BC-PG-2307	-3.203591	135.068522	75.6	0.54	6.4	24.3	satellite
2026-04-23 08:26:41.646214+08	BC-PG-2307	-3.344740	134.985404	70.5	0.00	13.8	27.6	drone
2026-04-23 14:00:08.431263+08	BC-PG-2307	-3.370968	134.943633	77.8	0.97	8.1	27.9	satellite
2026-04-23 18:21:57.706987+08	BC-PG-2307	-3.275836	134.944185	77.0	1.67	7.0	28.0	satellite
2026-04-23 23:22:20.015896+08	BC-PG-2307	-3.264322	134.986230	73.2	0.65	12.2	27.0	satellite
2026-04-24 03:46:12.885926+08	BC-PG-2307	-3.341881	134.924143	76.7	1.65	0.4	26.3	satellite
2026-04-24 08:50:10.913536+08	BC-PG-2307	-3.391206	134.887876	76.7	0.24	13.0	22.3	satellite
2026-04-24 13:57:01.697949+08	BC-PG-2307	-3.234697	134.996972	73.1	1.70	8.0	27.4	satellite
2026-04-24 18:10:47.496199+08	BC-PG-2307	-3.245735	135.013160	67.4	0.64	14.1	25.9	satellite
2026-04-24 23:05:58.20828+08	BC-PG-2307	-3.431183	134.967622	76.3	1.21	11.2	27.0	buoy
2026-04-25 04:18:07.193142+08	BC-PG-2307	-3.236863	134.899964	73.3	0.49	5.0	26.6	satellite
2026-04-25 08:54:35.153241+08	BC-PG-2307	-3.310162	134.907967	72.9	0.21	4.5	22.2	satellite
2026-04-25 13:52:09.27534+08	BC-PG-2307	-3.192731	135.050784	76.1	0.95	11.0	22.8	satellite
2026-04-25 18:15:40.033723+08	BC-PG-2307	-3.419240	135.112122	67.4	0.51	2.1	25.0	satellite
2026-04-25 23:27:10.174096+08	BC-PG-2307	-3.331307	134.978459	74.0	1.68	0.0	23.3	satellite
2026-04-26 04:08:38.13465+08	BC-PG-2307	-3.304311	135.110903	68.7	0.95	7.0	23.5	satellite
2026-04-26 08:57:56.95557+08	BC-PG-2307	-3.301588	134.846884	73.8	0.55	16.8	26.7	buoy
2026-04-26 13:59:04.125948+08	BC-PG-2307	-3.123970	134.949697	67.7	1.73	3.2	27.5	buoy
2026-04-26 18:15:50.24715+08	BC-PG-2307	-3.227777	135.039609	72.9	1.03	9.6	26.0	satellite
2026-04-26 23:25:28.432336+08	BC-PG-2307	-3.232574	134.971686	65.2	0.54	6.7	24.8	buoy
2026-04-27 03:59:52.490389+08	BC-PG-2307	-3.317122	134.973729	72.7	1.30	10.8	25.0	drone
2026-04-27 09:14:24.750626+08	BC-PG-2307	-3.132473	134.865610	66.1	0.29	5.4	21.3	drone
2026-04-27 13:16:52.823747+08	BC-PG-2307	-3.143107	134.916026	64.1	0.41	9.4	27.8	satellite
2026-04-27 18:02:01.182204+08	BC-PG-2307	-3.212759	134.933980	65.2	0.00	0.0	25.2	buoy
2026-04-27 22:53:47.306016+08	BC-PG-2307	-3.199483	134.860520	71.9	1.30	8.0	27.1	satellite
2026-04-28 04:30:07.067554+08	BC-PG-2307	-3.211756	135.076732	65.4	1.07	0.7	30.9	satellite
2026-04-28 08:24:12.616121+08	BC-PG-2307	-3.207740	134.891304	69.0	0.00	11.6	25.0	buoy
2026-04-28 14:03:16.842992+08	BC-PG-2307	-3.362289	134.889980	67.3	0.54	6.2	26.4	satellite
2026-04-28 18:33:58.895545+08	BC-PG-2307	-3.353772	135.031677	68.4	1.27	0.0	26.6	satellite
2026-04-28 22:51:17.553825+08	BC-PG-2307	-3.394488	134.983338	64.5	0.33	0.0	30.2	drone
2026-04-29 04:16:05.4583+08	BC-PG-2307	-3.379567	134.812910	67.1	1.38	0.3	25.1	buoy
2026-04-29 08:53:13.914739+08	BC-PG-2307	-3.170437	134.914922	67.1	1.02	8.3	28.0	satellite
2026-04-29 13:26:18.564403+08	BC-PG-2307	-3.217398	134.762786	62.0	0.68	12.9	22.6	satellite
2026-04-29 17:59:35.342815+08	BC-PG-2307	-3.287807	134.859309	64.8	0.52	12.5	26.5	satellite
2026-04-29 23:03:02.793496+08	BC-PG-2307	-3.353796	135.030614	65.9	0.35	9.8	31.7	satellite
2026-04-30 03:44:24.18293+08	BC-PG-2307	-3.205342	134.864018	63.7	0.40	7.7	24.4	satellite
2026-04-30 08:30:12.262487+08	BC-PG-2307	-3.176836	134.745101	64.4	1.52	0.2	23.7	drone
2026-04-30 14:07:43.183615+08	BC-PG-2307	-3.258801	135.003371	62.3	1.01	5.0	27.8	satellite
2026-04-30 18:53:13.844564+08	BC-PG-2307	-3.267014	135.032662	65.2	0.32	9.7	31.0	satellite
2026-04-30 22:51:23.923748+08	BC-PG-2307	-3.091687	134.742404	61.1	0.66	13.8	25.0	satellite
2026-05-01 03:36:02.10218+08	BC-PG-2307	-3.358033	134.814446	59.3	1.02	5.2	28.3	satellite
2026-05-01 08:32:03.46566+08	BC-PG-2307	-3.264854	134.912995	64.9	0.98	9.2	24.0	buoy
2026-05-01 13:20:07.741438+08	BC-PG-2307	-3.084813	134.927683	63.9	0.14	5.0	29.3	satellite
2026-05-01 18:12:07.987794+08	BC-PG-2307	-3.277464	134.738604	65.0	1.27	5.5	27.5	drone
2026-05-01 23:24:28.395541+08	BC-PG-2307	-3.276661	134.877440	59.9	0.00	14.2	25.4	drone
2026-05-02 03:56:06.100115+08	BC-PG-2307	-3.298377	134.869904	59.2	0.50	11.1	27.4	satellite
2026-05-02 09:14:09.340032+08	BC-PG-2307	-3.321711	134.937576	62.4	0.00	4.2	24.5	satellite
2026-05-02 13:15:20.896649+08	BC-PG-2307	-3.296451	134.872106	61.5	1.24	1.2	27.5	satellite
2026-05-02 18:00:10.282396+08	BC-PG-2307	-3.137366	134.964450	63.8	0.41	9.3	25.0	satellite
2026-05-02 23:22:14.826548+08	BC-PG-2307	-3.079295	134.870788	60.0	0.24	3.9	22.5	satellite
2026-05-03 04:32:00.709302+08	BC-PG-2307	-3.267538	134.945299	61.3	0.27	5.9	26.2	satellite
2026-05-03 08:45:33.411678+08	BC-PG-2307	-3.114210	134.949660	62.3	0.11	13.8	24.9	satellite
2026-05-03 13:19:41.384373+08	BC-PG-2307	-3.327811	134.866996	61.7	0.97	9.1	22.1	drone
2026-05-03 18:23:44.59683+08	BC-PG-2307	-3.260333	134.674349	62.1	1.21	11.6	23.7	satellite
2026-04-03 22:44:38.845384+08	BC-PH-2311	23.470028	119.458581	102.5	0.54	6.7	24.5	satellite
2026-04-04 03:34:27.249481+08	BC-PH-2311	23.380270	119.639324	99.8	1.66	8.5	25.4	buoy
2026-04-04 09:12:31.050859+08	BC-PH-2311	23.419930	119.609148	99.1	0.80	12.2	26.7	satellite
2026-04-04 14:08:19.154421+08	BC-PH-2311	23.344736	119.585633	99.4	1.57	3.3	26.5	drone
2026-04-04 18:04:38.45808+08	BC-PH-2311	23.331854	119.421914	94.2	0.25	5.9	26.0	drone
2026-04-04 23:29:08.763422+08	BC-PH-2311	23.303583	119.455619	93.8	0.00	10.3	26.0	drone
2026-04-05 03:42:51.273446+08	BC-PH-2311	23.368532	119.540491	96.7	1.40	11.3	28.2	satellite
2026-04-05 09:00:12.191864+08	BC-PH-2311	23.386215	119.501395	98.3	0.73	8.1	23.5	buoy
2026-04-05 13:58:19.469969+08	BC-PH-2311	23.289902	119.616610	96.8	1.10	8.8	26.9	satellite
2026-04-05 18:07:22.725917+08	BC-PH-2311	23.342665	119.623497	102.1	0.20	17.3	27.3	satellite
2026-04-05 22:54:19.89251+08	BC-PH-2311	23.442028	119.463730	96.0	1.19	15.6	27.8	satellite
2026-04-06 03:56:16.388362+08	BC-PH-2311	23.323438	119.508292	97.4	0.58	4.8	29.1	satellite
2026-04-06 08:24:02.264962+08	BC-PH-2311	23.326959	119.408001	98.6	0.31	16.0	26.0	satellite
2026-04-06 14:04:47.802299+08	BC-PH-2311	23.272961	119.652867	96.4	0.93	16.9	26.8	satellite
2026-04-06 18:50:35.187406+08	BC-PH-2311	23.208397	119.555587	99.3	1.49	6.3	25.0	satellite
2026-04-06 23:27:19.434074+08	BC-PH-2311	23.348113	119.493408	94.4	0.50	7.8	25.9	satellite
2026-04-07 04:21:33.967878+08	BC-PH-2311	23.183797	119.669621	96.0	0.92	9.0	24.4	satellite
2026-04-07 08:47:17.049134+08	BC-PH-2311	23.359480	119.607459	95.3	0.31	3.1	23.9	buoy
2026-04-07 13:54:37.724263+08	BC-PH-2311	23.335278	119.585720	94.1	0.92	10.6	27.3	drone
2026-04-07 18:53:42.737113+08	BC-PH-2311	23.278472	119.444596	95.9	0.97	0.5	27.3	drone
2026-04-07 23:17:19.642758+08	BC-PH-2311	23.378402	119.406744	99.6	0.12	13.1	25.9	buoy
2026-04-08 03:52:45.345967+08	BC-PH-2311	23.154056	119.585962	92.9	1.33	9.9	28.6	buoy
2026-04-08 08:39:01.393542+08	BC-PH-2311	23.376670	119.408504	90.1	1.63	3.1	27.1	satellite
2026-04-08 14:02:09.664775+08	BC-PH-2311	23.197939	119.622938	94.3	0.81	15.1	25.2	buoy
2026-04-08 18:03:23.520156+08	BC-PH-2311	23.296921	119.622536	93.9	0.28	9.8	29.3	satellite
2026-04-08 23:37:21.249612+08	BC-PH-2311	23.319064	119.591832	98.0	0.63	4.1	26.6	buoy
2026-04-09 03:49:10.458271+08	BC-PH-2311	23.187759	119.519710	91.7	0.39	2.3	27.3	buoy
2026-04-09 08:26:43.767748+08	BC-PH-2311	23.365313	119.583409	93.7	0.08	5.1	30.6	drone
2026-04-09 13:23:37.97988+08	BC-PH-2311	23.197165	119.664557	95.8	0.85	13.6	26.3	satellite
2026-04-09 18:24:18.034932+08	BC-PH-2311	23.207082	119.581351	89.8	0.77	4.8	25.9	satellite
2026-04-09 23:11:22.632018+08	BC-PH-2311	23.386906	119.644782	91.3	0.00	7.5	24.3	satellite
2026-04-10 04:17:51.572175+08	BC-PH-2311	23.220858	119.573861	86.8	0.70	12.8	24.1	satellite
2026-04-10 08:23:05.219675+08	BC-PH-2311	23.124705	119.662066	95.8	0.62	4.2	26.8	satellite
2026-04-10 13:49:49.473927+08	BC-PH-2311	23.292542	119.677544	86.3	2.07	14.6	26.4	buoy
2026-04-10 18:06:26.395456+08	BC-PH-2311	23.146946	119.517874	94.7	0.45	7.8	27.7	satellite
2026-04-10 23:01:42.911499+08	BC-PH-2311	23.097749	119.486602	93.6	1.23	5.8	28.6	satellite
2026-04-11 04:02:50.406908+08	BC-PH-2311	23.371764	119.618629	91.7	0.92	12.9	25.1	drone
2026-04-11 08:23:00.085542+08	BC-PH-2311	23.166516	119.474162	86.0	1.52	17.3	25.7	satellite
2026-04-11 13:32:01.788103+08	BC-PH-2311	23.261460	119.582931	90.4	0.44	6.4	24.4	satellite
2026-04-11 18:47:14.448598+08	BC-PH-2311	23.208841	119.581027	86.5	0.63	6.5	27.5	satellite
2026-04-11 23:20:13.144097+08	BC-PH-2311	23.129058	119.706445	90.0	1.39	0.0	31.1	satellite
2026-04-12 04:21:28.8115+08	BC-PH-2311	23.076322	119.615967	86.0	1.09	10.4	29.0	satellite
2026-04-12 08:40:24.604341+08	BC-PH-2311	23.171391	119.576355	90.3	0.77	6.6	26.0	buoy
2026-04-12 13:55:32.724739+08	BC-PH-2311	23.302956	119.714092	84.5	0.15	8.1	28.7	satellite
2026-04-12 18:14:33.089112+08	BC-PH-2311	23.128540	119.474791	85.5	0.98	8.8	24.0	drone
2026-04-12 23:35:40.972399+08	BC-PH-2311	23.182015	119.635387	89.2	0.93	6.9	29.9	satellite
2026-04-13 04:15:29.901747+08	BC-PH-2311	23.099489	119.673805	89.5	1.48	10.7	23.3	drone
2026-04-13 08:49:16.355776+08	BC-PH-2311	23.256255	119.536948	88.5	0.28	4.1	27.0	drone
2026-04-13 13:19:42.874432+08	BC-PH-2311	23.029891	119.676073	85.1	0.80	10.2	26.5	buoy
2026-04-13 18:14:29.822438+08	BC-PH-2311	23.159271	119.500664	88.7	0.54	2.6	23.6	satellite
2026-04-13 23:30:20.945195+08	BC-PH-2311	23.261446	119.476581	81.8	1.08	7.0	28.3	satellite
2026-04-14 03:42:18.125623+08	BC-PH-2311	23.084620	119.748537	81.7	1.07	12.1	28.6	buoy
2026-04-14 08:52:12.685767+08	BC-PH-2311	23.037858	119.539196	89.2	1.70	0.0	26.2	buoy
2026-04-14 13:49:53.495646+08	BC-PH-2311	23.265220	119.652692	85.0	0.10	17.7	25.5	satellite
2026-04-14 18:43:46.278628+08	BC-PH-2311	23.107854	119.462745	82.0	0.53	20.4	24.7	satellite
2026-04-14 23:32:25.095299+08	BC-PH-2311	23.061583	119.680189	83.6	0.96	19.9	28.9	satellite
2026-04-15 04:27:24.088492+08	BC-PH-2311	23.184914	119.638587	81.1	1.17	7.3	29.1	satellite
2026-04-15 08:24:40.607664+08	BC-PH-2311	23.033065	119.744792	84.1	0.70	8.5	26.1	buoy
2026-04-15 14:01:59.386708+08	BC-PH-2311	23.094027	119.576697	88.9	1.09	6.5	24.6	satellite
2026-04-15 18:00:54.06527+08	BC-PH-2311	23.197621	119.567579	80.2	1.11	0.0	27.9	satellite
2026-04-15 22:58:12.814217+08	BC-PH-2311	23.279149	119.496326	82.7	1.10	3.0	25.9	satellite
2026-04-16 03:36:23.045804+08	BC-PH-2311	23.057096	119.687334	88.7	0.56	10.9	25.5	satellite
2026-04-16 08:47:05.899605+08	BC-PH-2311	23.240278	119.569436	84.8	0.11	4.7	27.7	satellite
2026-04-16 13:20:44.215529+08	BC-PH-2311	22.987145	119.672669	83.9	0.54	0.0	25.6	buoy
2026-04-16 23:30:05.109794+08	BC-PH-2311	23.255077	119.619901	78.6	1.37	11.1	22.5	satellite
2026-04-17 03:45:08.201927+08	BC-PH-2311	23.006599	119.634333	81.4	0.88	4.4	24.8	drone
2026-04-17 08:44:30.112738+08	BC-PH-2311	23.037579	119.750592	78.2	0.85	2.4	27.5	satellite
2026-04-17 13:26:23.45511+08	BC-PH-2311	23.135392	119.502778	86.0	1.99	1.6	25.8	satellite
2026-04-17 18:43:32.053451+08	BC-PH-2311	23.115684	119.543720	84.8	0.55	6.7	27.2	satellite
2026-04-17 23:37:31.088999+08	BC-PH-2311	23.179191	119.501494	83.0	1.77	1.7	28.0	satellite
2026-04-18 04:28:48.598343+08	BC-PH-2311	23.074558	119.633864	80.5	0.00	5.7	29.6	buoy
2026-04-18 08:58:43.3929+08	BC-PH-2311	23.040440	119.667693	80.2	0.76	12.0	28.5	buoy
2026-04-18 13:16:21.043611+08	BC-PH-2311	23.133772	119.638969	80.5	1.01	11.0	23.4	satellite
2026-04-18 18:03:14.49608+08	BC-PH-2311	23.006876	119.627259	76.3	0.92	8.0	28.2	buoy
2026-04-18 23:11:07.606344+08	BC-PH-2311	23.167739	119.566455	76.5	0.26	1.1	27.1	buoy
2026-04-19 04:21:27.343966+08	BC-PH-2311	23.004880	119.525022	81.4	0.69	0.0	29.6	satellite
2026-04-19 09:13:59.581278+08	BC-PH-2311	23.160079	119.678106	78.0	0.70	11.0	28.6	satellite
2026-04-19 13:47:22.578228+08	BC-PH-2311	23.025856	119.651115	81.3	1.80	16.0	27.3	buoy
2026-04-19 18:25:55.141643+08	BC-PH-2311	22.908225	119.643950	82.0	0.55	12.2	24.2	satellite
2026-04-19 23:38:03.749107+08	BC-PH-2311	23.062764	119.572652	74.4	1.40	6.0	30.1	satellite
2026-04-20 03:34:57.924145+08	BC-PH-2311	23.063817	119.563748	81.6	1.25	13.3	27.9	satellite
2026-04-20 08:50:25.28593+08	BC-PH-2311	23.015620	119.668079	80.6	0.63	12.9	27.0	buoy
2026-04-20 13:55:21.342766+08	BC-PH-2311	23.186926	119.532061	82.5	0.43	0.0	23.0	satellite
2026-04-20 18:52:09.341081+08	BC-PH-2311	23.085642	119.698702	79.8	0.42	1.9	25.9	satellite
2026-04-20 23:26:22.890373+08	BC-PH-2311	23.001056	119.565566	79.6	0.00	1.3	28.8	satellite
2026-04-21 03:44:46.785686+08	BC-PH-2311	23.015230	119.623633	73.0	0.64	3.5	26.6	buoy
2026-04-21 09:00:47.899403+08	BC-PH-2311	23.021015	119.799460	75.4	0.94	16.3	29.5	buoy
2026-04-21 13:08:39.369339+08	BC-PH-2311	22.889369	119.751131	73.2	0.67	14.8	25.7	satellite
2026-04-21 18:24:40.416228+08	BC-PH-2311	23.155275	119.598958	74.7	0.49	2.1	23.1	satellite
2026-04-21 23:30:22.251097+08	BC-PH-2311	23.015904	119.700885	79.1	0.79	7.6	23.9	satellite
2026-04-22 03:50:24.685761+08	BC-PH-2311	22.888213	119.603654	74.9	0.32	5.5	27.4	buoy
2026-04-22 08:52:17.958334+08	BC-PH-2311	22.906899	119.680896	78.9	1.20	12.2	24.2	buoy
2026-04-22 13:49:46.391582+08	BC-PH-2311	22.859742	119.794700	70.9	2.08	6.3	26.7	satellite
2026-04-22 18:14:15.220637+08	BC-PH-2311	23.027810	119.546766	74.3	1.28	3.1	26.0	satellite
2026-04-22 23:08:21.036115+08	BC-PH-2311	22.864794	119.679313	78.9	0.91	3.8	26.3	satellite
2026-04-23 03:40:29.457718+08	BC-PH-2311	23.055885	119.561446	76.3	1.50	2.0	25.7	buoy
2026-04-23 08:45:12.147608+08	BC-PH-2311	22.930500	119.675309	71.6	0.77	3.7	27.6	satellite
2026-04-23 13:39:54.800244+08	BC-PH-2311	23.096010	119.558096	74.4	0.06	10.4	26.5	satellite
2026-04-23 18:50:22.82227+08	BC-PH-2311	23.067592	119.682201	76.0	0.37	10.0	26.7	drone
2026-04-23 23:18:35.906965+08	BC-PH-2311	23.085394	119.637441	72.2	0.53	3.6	29.4	buoy
2026-04-24 04:12:10.80404+08	BC-PH-2311	23.001705	119.598247	76.7	1.50	1.4	27.1	buoy
2026-04-24 08:59:41.102367+08	BC-PH-2311	23.047660	119.618186	70.2	1.02	7.6	29.9	satellite
2026-04-24 13:11:04.623337+08	BC-PH-2311	22.903998	119.603313	72.0	0.73	0.9	28.3	buoy
2026-04-24 18:48:33.245036+08	BC-PH-2311	23.066740	119.685535	67.9	1.31	15.6	26.6	drone
2026-04-24 23:20:19.023643+08	BC-PH-2311	22.905976	119.624641	68.6	0.15	5.3	26.0	satellite
2026-04-25 04:01:41.995802+08	BC-PH-2311	22.855584	119.729139	73.5	0.29	9.7	22.4	satellite
2026-04-25 08:28:52.812154+08	BC-PH-2311	23.028929	119.765293	73.3	1.70	5.2	28.6	satellite
2026-04-25 13:42:31.370081+08	BC-PH-2311	22.865535	119.633181	70.3	0.34	5.6	28.1	satellite
2026-04-25 18:06:51.119538+08	BC-PH-2311	22.976569	119.863307	71.2	0.77	9.3	31.2	drone
2026-04-25 23:26:48.306114+08	BC-PH-2311	22.981509	119.697582	73.8	0.22	9.9	25.5	satellite
2026-04-26 03:36:39.095023+08	BC-PH-2311	23.065182	119.842988	71.8	0.33	15.0	27.2	buoy
2026-04-26 08:53:59.402167+08	BC-PH-2311	23.068080	119.727447	67.5	0.00	8.7	24.8	satellite
2026-04-26 13:17:05.752109+08	BC-PH-2311	23.061093	119.758920	68.8	0.99	11.2	26.0	satellite
2026-04-26 18:13:21.628463+08	BC-PH-2311	23.049532	119.721993	65.2	0.73	3.3	25.0	satellite
2026-04-26 22:47:18.940574+08	BC-PH-2311	22.908664	119.660117	71.3	0.48	10.7	27.2	drone
2026-04-27 04:01:29.047264+08	BC-PH-2311	22.895040	119.653941	67.3	1.13	8.4	26.0	buoy
2026-04-27 08:21:15.881368+08	BC-PH-2311	22.970265	119.768109	67.6	1.88	5.3	26.1	satellite
2026-04-27 13:31:28.007304+08	BC-PH-2311	23.046026	119.657747	68.4	1.05	2.5	24.2	satellite
2026-04-27 18:47:45.384969+08	BC-PH-2311	22.756779	119.731175	65.1	0.38	8.6	28.5	drone
2026-04-27 22:47:36.534928+08	BC-PH-2311	23.010765	119.702789	65.6	1.27	4.9	26.9	satellite
2026-04-28 04:30:05.286176+08	BC-PH-2311	22.978585	119.711109	63.7	0.73	2.1	28.6	drone
2026-04-28 09:15:24.087918+08	BC-PH-2311	22.861574	119.883111	66.7	0.77	2.3	28.9	satellite
2026-04-28 13:33:49.132951+08	BC-PH-2311	22.936153	119.806299	71.7	0.66	14.3	22.6	drone
2026-04-28 18:38:36.319258+08	BC-PH-2311	22.831316	119.776694	67.0	1.37	0.0	28.2	satellite
2026-04-28 23:33:24.73719+08	BC-PH-2311	22.756736	119.658035	62.8	0.89	11.7	28.0	satellite
2026-04-29 04:21:30.763665+08	BC-PH-2311	22.836758	119.627895	61.5	0.94	6.8	26.6	buoy
2026-04-29 08:46:19.286987+08	BC-PH-2311	22.976141	119.847531	66.0	0.87	11.8	25.8	satellite
2026-04-29 13:45:21.141806+08	BC-PH-2311	22.742712	119.840881	61.8	0.28	4.5	26.8	drone
2026-04-29 18:12:13.073638+08	BC-PH-2311	22.903912	119.881961	65.2	1.14	0.0	27.1	drone
2026-04-29 23:03:47.122417+08	BC-PH-2311	22.876621	119.656491	69.7	1.08	20.2	29.9	satellite
2026-04-30 03:44:32.241978+08	BC-PH-2311	22.779568	119.880040	68.0	0.00	0.0	28.4	buoy
2026-04-30 09:11:02.378805+08	BC-PH-2311	22.811633	119.796776	64.2	0.95	6.2	23.3	buoy
2026-04-30 13:16:01.017684+08	BC-PH-2311	22.923182	119.770823	69.4	0.15	8.9	26.6	buoy
2026-04-30 18:21:18.710724+08	BC-PH-2311	22.719644	119.666988	62.6	0.41	9.6	25.7	drone
2026-04-30 23:18:47.173225+08	BC-PH-2311	22.883344	119.894493	60.2	0.54	6.1	27.1	buoy
2026-05-01 03:42:02.007586+08	BC-PH-2311	22.896587	119.643869	61.5	0.17	4.3	26.9	satellite
2026-05-01 08:39:49.874055+08	BC-PH-2311	22.964371	119.799070	67.5	1.28	2.6	29.2	buoy
2026-05-01 13:56:57.653655+08	BC-PH-2311	22.878009	119.817305	63.4	1.76	3.5	23.5	satellite
2026-05-01 18:15:54.266188+08	BC-PH-2311	22.781947	119.895440	65.2	0.00	14.1	27.7	buoy
2026-05-01 22:50:09.870192+08	BC-PH-2311	22.917748	119.847318	66.4	1.66	7.8	28.2	satellite
2026-05-02 03:33:30.154905+08	BC-PH-2311	22.777957	119.830176	61.1	1.04	11.3	25.0	satellite
2026-05-02 08:35:08.791755+08	BC-PH-2311	22.784953	119.858489	63.0	1.21	16.0	28.7	satellite
2026-05-02 13:34:44.11453+08	BC-PH-2311	22.902126	119.667799	66.8	1.30	10.6	26.5	satellite
2026-05-02 18:16:03.612601+08	BC-PH-2311	22.735614	119.821252	61.7	0.49	5.3	25.8	drone
2026-05-02 23:31:32.778158+08	BC-PH-2311	22.879040	119.801771	65.6	0.12	8.9	26.1	satellite
2026-05-03 04:22:18.770363+08	BC-PH-2311	22.895959	119.863890	63.5	0.18	8.7	27.7	satellite
2026-05-03 08:46:12.696279+08	BC-PH-2311	22.726955	119.941907	65.2	0.99	0.0	27.5	drone
2026-05-03 13:11:21.072813+08	BC-PH-2311	22.881892	119.928000	64.6	1.26	4.6	24.3	satellite
2026-05-03 18:50:48.11558+08	BC-PH-2311	22.871254	119.871713	61.9	1.13	0.5	27.0	satellite
2026-04-03 23:10:16.803784+08	BC-SB-2315	6.148520	117.974723	105.0	0.75	12.6	26.7	drone
2026-04-04 04:04:56.806161+08	BC-SB-2315	6.081430	118.064484	97.3	0.00	17.3	27.2	satellite
2026-04-04 08:28:26.842738+08	BC-SB-2315	6.304534	117.923538	99.1	0.00	0.0	25.5	satellite
2026-04-04 13:54:48.162303+08	BC-SB-2315	6.178809	118.012372	94.7	1.30	3.5	27.8	satellite
2026-04-04 18:26:54.237889+08	BC-SB-2315	6.193692	118.137088	97.3	0.28	4.2	25.2	satellite
2026-04-04 22:55:33.548135+08	BC-SB-2315	6.173534	117.934267	101.8	0.85	6.3	25.9	buoy
2026-04-05 04:25:51.064298+08	BC-SB-2315	6.277867	117.996176	95.7	0.22	6.6	28.4	buoy
2026-04-05 09:15:34.72131+08	BC-SB-2315	6.086350	118.031244	102.3	1.25	12.2	28.2	drone
2026-04-05 13:58:11.98482+08	BC-SB-2315	6.109677	117.912338	101.3	1.75	2.7	23.9	drone
2026-04-05 18:52:05.247624+08	BC-SB-2315	6.048886	118.023770	98.7	0.12	5.8	26.3	drone
2026-04-05 22:51:54.697661+08	BC-SB-2315	6.058708	117.996634	97.6	0.93	5.5	27.0	satellite
2026-04-06 04:13:46.274715+08	BC-SB-2315	6.113969	117.874217	101.9	0.69	4.7	25.5	satellite
2026-04-06 09:03:23.150161+08	BC-SB-2315	6.164570	117.889617	93.1	0.00	19.1	24.1	satellite
2026-04-06 13:24:24.193019+08	BC-SB-2315	6.281369	118.035443	100.3	0.76	9.2	26.7	satellite
2026-04-06 18:13:46.583258+08	BC-SB-2315	6.256002	118.060006	95.6	0.00	10.0	28.1	drone
2026-04-06 23:27:33.874188+08	BC-SB-2315	6.200822	117.996438	91.9	0.79	14.8	24.6	satellite
2026-04-07 04:20:34.856751+08	BC-SB-2315	6.220134	117.860047	95.5	0.64	8.0	27.0	satellite
2026-04-07 08:28:07.463552+08	BC-SB-2315	5.992113	117.790958	97.4	0.72	0.0	25.8	drone
2026-04-07 13:31:46.036228+08	BC-SB-2315	6.000840	118.063661	100.0	0.16	12.5	23.6	satellite
2026-04-07 18:31:01.81579+08	BC-SB-2315	6.116938	117.885071	91.0	0.73	13.0	27.9	satellite
2026-04-07 23:07:24.406954+08	BC-SB-2315	6.158750	117.968985	94.7	1.96	12.4	28.3	satellite
2026-04-08 04:00:58.244102+08	BC-SB-2315	6.027960	117.922637	96.1	0.17	0.0	23.6	buoy
2026-04-08 08:27:46.409682+08	BC-SB-2315	6.175521	117.955679	95.3	1.24	6.7	26.2	satellite
2026-04-08 13:47:45.741871+08	BC-SB-2315	6.098402	117.916787	94.4	1.06	9.8	23.0	satellite
2026-04-08 18:13:06.710506+08	BC-SB-2315	6.218635	117.851949	96.0	1.44	5.8	25.8	satellite
2026-04-08 23:14:33.678464+08	BC-SB-2315	6.099570	117.869710	95.3	0.56	10.6	29.0	satellite
2026-04-09 03:48:28.063463+08	BC-SB-2315	6.092011	118.030135	89.4	0.86	9.4	30.4	satellite
2026-04-09 08:36:43.511913+08	BC-SB-2315	6.098396	117.856147	95.0	0.61	5.7	24.3	satellite
2026-04-09 13:08:26.78321+08	BC-SB-2315	6.150532	117.982995	88.4	0.36	13.2	23.8	drone
2026-04-09 18:03:45.862996+08	BC-SB-2315	6.051354	117.819553	93.9	1.27	10.9	27.7	buoy
2026-04-09 22:45:53.331797+08	BC-SB-2315	6.245610	117.738131	89.0	0.70	4.1	23.6	satellite
2026-04-10 03:47:07.693349+08	BC-SB-2315	6.093834	117.968777	87.9	0.93	17.2	22.4	drone
2026-04-10 08:24:28.398443+08	BC-SB-2315	6.063383	117.918459	87.5	0.48	7.4	27.6	buoy
2026-04-10 13:29:02.162345+08	BC-SB-2315	6.121696	117.849980	94.2	1.16	9.5	27.8	satellite
2026-04-10 18:51:36.857195+08	BC-SB-2315	6.152067	117.696261	89.1	0.28	9.2	30.3	drone
2026-04-10 22:49:53.171067+08	BC-SB-2315	6.075737	117.771143	93.1	0.53	6.3	24.5	drone
2026-04-11 04:28:25.673468+08	BC-SB-2315	6.150019	117.900007	87.1	0.89	8.0	23.9	satellite
2026-04-11 08:37:19.418158+08	BC-SB-2315	6.043864	117.845946	90.1	0.53	6.3	28.7	satellite
2026-04-11 13:23:44.470067+08	BC-SB-2315	6.096190	117.950766	94.6	0.70	6.0	28.4	satellite
2026-04-11 18:30:18.665802+08	BC-SB-2315	5.946202	117.812979	94.0	0.00	5.2	26.3	satellite
2026-04-11 23:28:39.117519+08	BC-SB-2315	6.235489	117.725870	87.7	0.82	11.8	28.9	satellite
2026-04-12 04:30:31.9741+08	BC-SB-2315	6.063433	117.717291	91.3	0.54	12.8	25.3	buoy
2026-04-12 09:20:03.174354+08	BC-SB-2315	6.233288	117.776779	84.8	0.45	13.3	26.6	satellite
2026-04-12 13:10:49.133391+08	BC-SB-2315	6.184677	117.803780	85.9	1.32	10.2	26.9	satellite
2026-04-12 18:53:54.069089+08	BC-SB-2315	6.179366	117.865444	85.9	0.53	12.2	25.1	satellite
2026-04-12 23:36:26.004857+08	BC-SB-2315	6.152475	117.827709	88.8	0.17	7.8	26.6	satellite
2026-04-13 04:17:38.838541+08	BC-SB-2315	6.068737	117.898626	82.9	0.93	9.0	22.0	satellite
2026-04-13 08:53:20.965412+08	BC-SB-2315	6.193871	117.650360	84.5	1.14	11.3	26.5	satellite
2026-04-13 13:21:45.847235+08	BC-SB-2315	6.060717	117.825660	90.8	0.37	4.1	27.1	buoy
2026-04-13 18:51:18.505604+08	BC-SB-2315	5.976703	117.623238	86.5	0.59	3.3	28.6	buoy
2026-04-13 23:31:35.004082+08	BC-SB-2315	5.978436	117.792164	88.9	0.34	10.6	25.4	satellite
2026-04-14 04:29:20.892896+08	BC-SB-2315	5.934926	117.792501	89.6	1.28	10.7	26.0	satellite
2026-04-14 08:45:08.064194+08	BC-SB-2315	6.192289	117.678097	88.0	1.12	17.2	28.5	satellite
2026-04-14 13:12:46.42584+08	BC-SB-2315	6.157964	117.819700	84.8	1.04	6.7	26.7	buoy
2026-04-14 18:16:46.985737+08	BC-SB-2315	6.011218	117.860493	85.9	0.11	14.1	29.0	drone
2026-04-14 23:13:30.683014+08	BC-SB-2315	6.115633	117.607662	88.4	0.46	3.8	26.3	satellite
2026-04-15 04:17:10.689163+08	BC-SB-2315	5.914615	117.608820	81.2	0.09	6.0	23.8	satellite
2026-04-15 09:04:13.613494+08	BC-SB-2315	5.921451	117.725579	88.4	1.69	1.7	26.2	satellite
2026-04-15 14:04:13.388054+08	BC-SB-2315	6.065190	117.655821	80.1	0.44	11.0	27.1	buoy
2026-04-15 18:07:44.416337+08	BC-SB-2315	5.975932	117.556511	82.2	0.72	11.8	26.7	buoy
2026-04-15 22:48:55.157854+08	BC-SB-2315	5.972173	117.748632	81.3	1.31	8.7	26.0	buoy
2026-04-16 04:24:20.572583+08	BC-SB-2315	6.177654	117.649202	86.4	0.90	4.2	25.8	satellite
2026-04-16 08:30:18.306664+08	BC-SB-2315	6.059825	117.776247	84.2	1.47	4.5	25.5	satellite
2026-04-16 13:53:40.674437+08	BC-SB-2315	6.107119	117.620788	85.1	1.14	8.3	25.3	satellite
2026-04-16 18:16:56.178274+08	BC-SB-2315	6.027049	117.567225	80.0	0.86	10.4	27.2	drone
2026-04-16 23:32:58.405484+08	BC-SB-2315	6.044898	117.537992	78.6	1.28	7.5	26.4	satellite
2026-04-17 03:57:39.577264+08	BC-SB-2315	5.913287	117.606879	77.9	0.51	18.7	27.9	satellite
2026-04-17 08:31:00.285436+08	BC-SB-2315	5.903234	117.655865	79.5	1.29	0.0	26.7	satellite
2026-04-17 13:41:59.459515+08	BC-SB-2315	6.013491	117.524937	84.1	1.33	19.2	27.3	satellite
2026-04-17 18:26:11.480701+08	BC-SB-2315	5.897965	117.527544	84.9	0.85	9.2	27.6	satellite
2026-04-17 23:04:06.863803+08	BC-SB-2315	6.143868	117.634723	79.6	0.84	4.9	24.5	drone
2026-04-18 03:39:17.453681+08	BC-SB-2315	6.006052	117.722466	80.7	0.18	9.2	24.2	satellite
2026-05-03 20:30:00+08	BC-XS-2401	-16.972017	112.324267	84.4	\N	\N	\N	argos
2026-04-18 09:07:17.647499+08	BC-SB-2315	6.151693	117.487871	80.8	0.95	12.3	23.6	satellite
2026-04-18 13:09:07.906595+08	BC-SB-2315	6.167315	117.659220	75.5	0.48	9.7	25.8	satellite
2026-04-18 18:49:31.2623+08	BC-SB-2315	6.151017	117.691290	79.8	1.14	10.3	23.6	satellite
2026-04-18 23:26:44.719145+08	BC-SB-2315	6.067578	117.559476	83.2	0.82	17.7	27.2	drone
2026-04-19 04:03:06.003409+08	BC-SB-2315	6.012679	117.473484	80.0	1.43	9.1	26.6	buoy
2026-04-19 08:48:28.231422+08	BC-SB-2315	6.047621	117.511596	83.3	1.02	5.3	29.2	satellite
2026-04-19 13:43:11.713422+08	BC-SB-2315	6.163331	117.434647	84.1	1.07	7.5	27.1	drone
2026-04-19 18:34:24.994926+08	BC-SB-2315	5.886882	117.464768	81.6	0.00	0.0	28.1	buoy
2026-04-19 23:16:21.121638+08	BC-SB-2315	6.154758	117.470191	74.2	0.98	11.3	24.1	satellite
2026-04-20 03:39:56.66375+08	BC-SB-2315	6.053586	117.406210	78.8	1.19	3.8	24.8	satellite
2026-04-20 08:37:26.237545+08	BC-SB-2315	6.125166	117.677731	80.0	1.81	5.3	27.7	satellite
2026-04-20 13:26:04.101891+08	BC-SB-2315	5.901716	117.654758	82.7	1.17	12.4	26.8	satellite
2026-04-20 18:05:16.280154+08	BC-SB-2315	5.884116	117.486107	74.4	1.00	11.9	22.0	satellite
2026-04-20 22:49:28.981704+08	BC-SB-2315	6.147017	117.510983	77.8	0.37	9.1	26.2	buoy
2026-04-21 03:43:30.66383+08	BC-SB-2315	6.082527	117.479793	74.9	1.99	7.3	28.3	buoy
2026-04-21 08:37:18.051545+08	BC-SB-2315	5.881697	117.381145	78.6	1.25	0.0	28.4	buoy
2026-04-21 13:13:01.537397+08	BC-SB-2315	5.845101	117.375716	73.9	1.08	14.5	27.2	satellite
2026-04-21 18:03:58.987604+08	BC-SB-2315	5.848849	117.605013	75.1	1.21	8.1	25.6	satellite
2026-04-21 23:05:52.516206+08	BC-SB-2315	5.967820	117.432364	75.0	0.25	4.4	27.0	satellite
2026-04-22 04:24:57.54514+08	BC-SB-2315	6.071901	117.463751	78.5	0.53	17.6	28.9	satellite
2026-04-22 08:48:18.471931+08	BC-SB-2315	6.021783	117.364303	72.2	0.69	8.8	25.8	drone
2026-04-22 14:06:03.07077+08	BC-SB-2315	6.130665	117.475351	70.6	0.36	2.7	25.7	drone
2026-04-22 17:56:31.72591+08	BC-SB-2315	6.043533	117.385038	79.4	1.02	9.4	25.6	satellite
2026-04-22 22:55:21.88362+08	BC-SB-2315	5.893753	117.378956	78.7	0.33	6.8	30.9	buoy
2026-04-23 04:02:36.31398+08	BC-SB-2315	5.966210	117.586115	69.5	0.69	5.2	27.0	satellite
2026-04-23 08:40:09.436877+08	BC-SB-2315	6.028316	117.330152	75.3	0.76	7.6	25.5	drone
2026-04-23 13:56:21.284848+08	BC-SB-2315	5.824006	117.339838	70.7	0.27	3.6	26.6	satellite
2026-04-23 18:04:01.149222+08	BC-SB-2315	6.085042	117.554082	69.2	0.50	10.3	22.8	drone
2026-04-23 23:34:59.689684+08	BC-SB-2315	6.073379	117.319599	71.5	0.59	14.7	27.8	satellite
2026-04-24 03:48:55.608109+08	BC-SB-2315	5.935058	117.375704	76.1	1.46	3.2	28.6	satellite
2026-04-24 09:12:52.213506+08	BC-SB-2315	6.091073	117.330005	71.8	0.57	0.0	29.1	satellite
2026-04-24 13:21:15.734414+08	BC-SB-2315	6.017621	117.563013	71.0	0.40	3.5	29.2	satellite
2026-04-24 18:54:37.674335+08	BC-SB-2315	5.997876	117.535851	74.7	0.66	10.1	27.5	satellite
2026-04-24 23:14:22.803964+08	BC-SB-2315	6.025582	117.521074	69.2	0.00	9.9	25.8	buoy
2026-04-25 04:08:28.838647+08	BC-SB-2315	5.879511	117.437025	76.4	1.52	3.4	28.1	satellite
2026-04-25 08:35:47.724556+08	BC-SB-2315	6.047124	117.287259	69.7	1.29	11.7	28.1	buoy
2026-04-25 13:57:50.18324+08	BC-SB-2315	5.908169	117.529489	66.3	0.31	8.5	24.9	satellite
2026-04-25 17:57:52.374347+08	BC-SB-2315	5.864319	117.322744	74.9	0.89	7.7	26.1	satellite
2026-04-25 23:02:03.068161+08	BC-SB-2315	5.805373	117.519099	69.7	0.92	10.1	24.8	buoy
2026-04-26 03:49:03.264257+08	BC-SB-2315	6.095635	117.472579	66.1	0.81	4.6	26.7	satellite
2026-04-26 08:41:15.882469+08	BC-SB-2315	6.037895	117.511117	73.4	0.09	3.6	26.3	buoy
2026-04-26 13:47:23.621838+08	BC-SB-2315	5.821069	117.388138	70.1	0.11	13.9	28.3	satellite
2026-04-26 18:03:43.252274+08	BC-SB-2315	5.953771	117.399246	72.3	1.17	0.0	25.6	satellite
2026-04-26 23:27:36.228388+08	BC-SB-2315	6.076684	117.338866	68.4	0.67	9.5	27.6	satellite
2026-04-27 04:03:22.612476+08	BC-SB-2315	5.997162	117.454080	65.8	0.58	5.1	24.2	satellite
2026-04-27 08:47:14.053138+08	BC-SB-2315	5.965701	117.462021	67.5	0.71	10.6	24.1	buoy
2026-04-27 13:36:53.024006+08	BC-SB-2315	5.959809	117.373170	67.6	0.92	6.2	27.3	satellite
2026-04-27 18:31:07.322879+08	BC-SB-2315	5.842280	117.406032	64.3	0.92	6.9	25.6	satellite
2026-04-27 23:28:35.578498+08	BC-SB-2315	5.813622	117.198247	72.1	0.81	1.7	23.9	buoy
2026-04-28 03:37:54.378831+08	BC-SB-2315	5.864658	117.269439	67.3	0.15	10.2	24.9	satellite
2026-04-28 08:51:48.829177+08	BC-SB-2315	5.928405	117.421978	72.4	0.43	7.2	28.8	satellite
2026-04-28 13:16:32.853245+08	BC-SB-2315	5.965769	117.308109	69.0	0.65	17.1	27.7	drone
2026-04-28 18:10:10.605276+08	BC-SB-2315	5.881340	117.383704	69.6	1.95	7.5	26.9	drone
2026-04-28 22:58:34.737891+08	BC-SB-2315	5.957228	117.179959	63.3	0.80	9.3	24.1	buoy
2026-04-29 04:23:02.793704+08	BC-SB-2315	6.011041	117.273686	66.8	0.76	0.0	27.8	drone
2026-04-29 08:55:13.530003+08	BC-SB-2315	6.057616	117.321745	63.5	1.21	0.0	20.9	satellite
2026-04-29 13:48:47.606592+08	BC-SB-2315	5.840685	117.408036	61.6	0.90	16.0	26.1	satellite
2026-04-29 18:39:56.276218+08	BC-SB-2315	5.780246	117.252411	61.8	0.17	16.1	28.1	drone
2026-04-29 22:58:49.526544+08	BC-SB-2315	5.984256	117.170269	64.6	0.47	6.8	25.4	buoy
2026-04-30 04:27:17.185306+08	BC-SB-2315	5.896356	117.169096	68.1	0.00	3.1	28.3	satellite
2026-04-30 08:45:15.236062+08	BC-SB-2315	5.910108	117.211848	61.7	0.01	9.9	24.3	satellite
2026-04-30 13:43:08.508493+08	BC-SB-2315	6.045742	117.279661	63.6	0.87	11.4	26.5	satellite
2026-04-30 18:24:42.188393+08	BC-SB-2315	5.875135	117.169038	65.2	1.11	0.0	28.3	buoy
2026-04-30 23:43:11.936749+08	BC-SB-2315	5.932224	117.085320	67.0	0.91	1.1	27.7	buoy
2026-05-01 03:57:30.728426+08	BC-SB-2315	6.031200	117.331080	66.5	1.67	12.4	24.3	satellite
2026-05-01 08:32:54.036+08	BC-SB-2315	5.812936	117.312691	67.8	0.52	12.0	27.7	drone
2026-05-01 13:20:15.026741+08	BC-SB-2315	5.753238	117.167372	66.8	1.00	17.0	22.5	satellite
2026-05-01 18:36:26.496619+08	BC-SB-2315	5.841273	117.101162	58.3	0.60	0.0	27.7	satellite
2026-05-01 22:59:08.824527+08	BC-SB-2315	5.865012	117.146621	60.5	1.00	9.7	25.5	satellite
2026-05-02 04:17:10.797553+08	BC-SB-2315	5.833052	117.243587	64.1	0.54	5.4	31.7	satellite
2026-05-02 08:32:30.048189+08	BC-SB-2315	5.901719	117.042120	64.3	0.95	5.7	26.5	buoy
2026-05-02 13:26:42.25148+08	BC-SB-2315	5.969759	117.061510	62.6	0.23	4.4	25.4	satellite
2026-05-02 18:07:00.424996+08	BC-SB-2315	5.849641	117.136820	57.1	0.99	7.3	28.7	satellite
2026-05-02 23:26:31.173166+08	BC-SB-2315	5.813879	117.092240	61.1	0.70	12.7	26.2	buoy
2026-05-03 03:47:54.009738+08	BC-SB-2315	5.997902	117.228623	59.7	1.92	6.6	24.6	drone
2026-05-03 08:57:03.006322+08	BC-SB-2315	6.016556	117.020974	63.2	0.87	8.3	26.1	drone
2026-05-03 14:01:16.698992+08	BC-SB-2315	5.776665	117.296379	64.7	0.77	1.3	27.1	satellite
2026-05-03 18:51:43.237294+08	BC-SB-2315	5.875474	117.158253	60.5	1.44	8.7	29.0	satellite
\.


--
-- Data for Name: trial_applications; Type: TABLE DATA; Schema: public; Owner: bluecircle
--

COPY public.trial_applications (id, user_id, institution, contact_name, contact_email, contact_phone, target_species, preferred_device, quantity, duration_months, project_brief, status, reviewer_notes, created_at, updated_at) FROM stdin;
1	\N	Audit Institute	Dr. Audit	audit@inst.org	\N	绿海龟	\N	5	6	Testing trial system	pending	\N	2026-05-03 22:59:51.480567+08	2026-05-03 22:59:51.480567+08
2	\N	Audit Institute	Dr. Audit	audit@inst.org	\N	绿海龟	\N	5	6	Testing trial system	pending	\N	2026-05-03 23:03:25.316666+08	2026-05-03 23:03:25.316666+08
3	\N	Audit Institute	Dr. Audit	audit@inst.org	\N	绿海龟	\N	5	6	Testing trial system	pending	\N	2026-05-03 23:03:57.626363+08	2026-05-03 23:03:57.626363+08
4	\N	Test Institute	\N	trial@test.com	\N	\N	\N	3	6	\N	pending	\N	2026-05-03 23:26:19.220966+08	2026-05-03 23:26:19.220966+08
5	\N	DB Check	\N	dbcheck-e1321a@test.com	\N	\N	\N	1	1	\N	pending	\N	2026-05-03 23:27:03.242711+08	2026-05-03 23:27:03.242711+08
6	\N	Test Institute	\N	trial@test.com	\N	\N	\N	3	6	\N	pending	\N	2026-05-03 23:27:04.467307+08	2026-05-03 23:27:04.467307+08
7	\N	Audit	\N	audit-07509b@t.com	\N	\N	\N	2	3	\N	pending	\N	2026-05-03 23:43:18.434517+08	2026-05-03 23:43:18.434517+08
8	\N	Audit	\N	audit-321560@t.com	\N	\N	\N	2	3	\N	pending	\N	2026-05-03 23:45:22.772812+08	2026-05-03 23:45:22.772812+08
9	\N	Audit Lab	Auditor	audit-p15-fflcimgo@test.com	\N	Loggerhead	\N	3	12	\N	pending	\N	2026-05-04 00:42:14.64103+08	2026-05-04 00:42:14.64103+08
10	024e899b-c8cb-487e-95e0-fd2233d59b3b	Audit Lab	Auditor	audit-p15-sdwihqmb@test.com	\N	Loggerhead	\N	3	12	\N	pending	\N	2026-05-04 00:45:05.163243+08	2026-05-04 00:45:05.163243+08
14	2f0b0b7f-9d19-49da-8062-899e870200bc	Audit Lab	Auditor	audit-p15-czpwpzpi@test.com	\N	Loggerhead	\N	3	12	\N	approved	\N	2026-05-04 01:20:07.311976+08	2026-05-04 22:10:56.497092+08
13	2f1b9881-5529-4d85-ae81-ab856d6a5ede	Audit Lab	Auditor	audit-p15-wwdhiwha@test.com	\N	Loggerhead	\N	3	12	\N	approved	\N	2026-05-04 01:13:33.749213+08	2026-05-04 22:10:56.720612+08
12	e89d9a77-a8b6-4b98-944e-fa82c082e3ad	Audit Lab	Auditor	audit-p15-wlsimokq@test.com	\N	Loggerhead	\N	3	12	\N	approved	\N	2026-05-04 01:05:30.494415+08	2026-05-04 22:10:57.164796+08
11	fc46d2d8-22a5-4135-a3ea-73654adc589e	Audit Lab	Auditor	audit-p15-manseqcy@test.com	\N	Loggerhead	\N	3	12	\N	approved	\N	2026-05-04 00:56:46.889033+08	2026-05-04 22:10:57.63836+08
\.


--
-- Data for Name: turtles; Type: TABLE DATA; Schema: public; Owner: bluecircle
--

COPY public.turtles (id, name, name_en, species, species_en, sex, age_class, origin, origin_en, carapace_length_cm, photo_url, device_id, last_lat, last_lng, last_battery_pct, last_speed_kmh, last_depth_m, last_seen_at, is_active, risk_level, created_at) FROM stdin;
BC-HN-2418	文昌	Wenchang	绿海龟	Green	M	亚成体	海南岛东岸	East Hainan	62.0	img/turtles/bc-hn-2418.jpg	TT4-BC-HN-2418	19.850000	111.200000	77.0	2.10	18.0	2026-05-03 22:21:53.055111+08	t	low	2026-05-03 22:21:53.055111+08
BC-XS-2421	Pearl	Pearl	绿海龟	Green	F	成体	西沙北岛	Xisha North Is.	101.0	img/turtles/BC-XS-2421.png	TT4-BC-XS-2421	17.100000	112.450000	77.0	1.60	22.0	2026-05-03 22:21:53.055111+08	t	low	2026-05-03 22:21:53.055111+08
BC-PH-2425	Palawan	Palawan	绿海龟	Green	F	成体	菲律宾巴拉望	Palawan, PH	95.0	img/turtles/bc-ph-2425.png	TT4-BC-PH-2425	10.320000	118.740000	65.0	2.40	22.0	2026-05-03 22:21:53.055111+08	t	low	2026-05-03 22:21:53.055111+08
BC-RY-2429	琉球	Ryukyu	绿海龟	Green	F	成体	琉球群岛	Ryukyu Is.	88.0	img/turtles/bc-ry-2429.png	TT4-BC-RY-2429	24.510000	124.180000	20.0	2.00	16.0	2026-05-04 03:12:53+08	t	low	2026-05-03 22:21:53.055111+08
BC-CD-2304	Côn Đảo	Côn Đảo	绿海龟	Green	F	成体	越南昆岛	Côn Đảo, VN	148.0	img/turtles/bc-cd-2304.jpg	TT4-BC-CD-2304	17.500000	113.000000	88.0	2.00	10.0	2026-05-04 01:20:09.343214+08	t	high	2026-05-03 22:21:53.055111+08
BC-PG-2307	Papua	Papua	棱皮龟	Leatherback	F	成体	巴布亚	Papua	155.0	img/turtles/bc-pg-2307.png	TT4-BC-PG-2307	-3.500000	135.420000	78.0	3.10	42.3	2026-05-03 18:00:00+08	t	high	2026-05-03 22:21:53.055111+08
BC-PH-2311	望安	Wang-an	绿海龟	Green	F	成体	台湾澎湖望安岛	Wang-an Is., Penghu, TW	96.0	img/turtles/bc-ph-2311.jpg	TT4-BC-PH-2311	23.370000	119.500000	80.0	3.00	24.0	2026-05-04 03:12:53+08	t	med	2026-05-03 22:21:53.055111+08
BC-SB-2315	Selingan	Selingan	玳瑁	Hawksbill	F	成体	沙巴海龟群岛海洋公园	Sabah Turtle Islands Park, MY	78.0	img/turtles/bc-sb-2315.png	TT4-BC-SB-2315	6.170000	118.040000	20.0	1.40	12.0	2026-05-04 03:12:53+08	t	high	2026-05-03 22:21:53.055111+08
BC-XS-2401	Luna	Luna	绿海龟	Green	F	成体	西沙七连屿北岛	Qilianyu North Is., Xisha	98.0	img/turtles/BC-xs-2401.png	TT4-BC-XS-2401	-16.972017	112.324267	84.4	0.60	14.0	2026-05-03 20:30:00+08	t	low	2026-05-03 22:21:53.055111+08
BC-HD-2412	惠东	Huidong	绿海龟	Green	F	成体	广东惠东	Huidong, Guangdong	104.0	img/turtles/bc-hd-2412.png	TT4-BC-HD-2412	22.550000	114.890000	80.0	1.80	9.0	2026-05-04 03:12:53+08	t	low	2026-05-03 22:21:53.055111+08
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: bluecircle
--

COPY public.users (id, email, password_hash, institution, role, is_active, created_at, is_approved) FROM stdin;
374f4faf-aa4c-46b7-89ff-8c9622ec02f1	vps@test.com	$2b$12$NIVYzrgpE.NJP8ed.bOkQOiPTvQCOPnszO6SD4uayWfk1bxCNGvAa	\N	user	t	2026-05-03 22:52:51.787195+08	t
dcb1be46-706c-4fa8-82e2-30fb8704cf19	audit-e42953b6@test.com	$2b$12$jVZBTEnu3F7qzNSAPnFx1.0fXiz///2FYbq9JyRJbUfIOiLA3Y11G	Audit Lab	user	t	2026-05-03 22:59:50.289455+08	t
fda6a146-4778-4427-9aed-b2d1ed88561e	other-98dc75@test.com	$2b$12$dK61Q4NpGOe7ak6o3IiiVeGMe9IC/F1fqs301MFzMfpjz9jOolgl6	\N	user	t	2026-05-03 22:59:51.189181+08	t
023391ee-bac3-4c1d-936b-7d0b1a0bf708	bad	$2b$12$v.yYFy7HNk7QV3hhts/pM.eKldZ016cxWjEgNRwwVMNTCDjs40ZQi	\N	user	t	2026-05-03 22:59:51.502002+08	t
20bc171a-e381-4743-84e2-ebf01b06f89a	audit-a1cff43d@test.com	$2b$12$9B14iFLYbDI0zXzT5xVOJeO06tcCjkWPmPF5lBYl32QAhfud7xrm2	Audit Lab	user	t	2026-05-03 23:03:24.13196+08	t
3cf32687-a8e8-4e63-9385-2171e40906b0	other-672f5c@test.com	$2b$12$2aQEkAGqPhoI5EAEc.lwGudtWj/xkWOAp5FbIeq83UipYh8rg5LPu	\N	user	t	2026-05-03 23:03:25.030388+08	t
8d99d7d3-8b28-4a60-8f0c-668469b68d6b	audit-ab4516f1@test.com	$2b$12$Et1tCNaV64fA9M61Uf8if.J0fNVYAP5dqAX.oMa34RPHFa5nr6P8G	Audit Lab	user	t	2026-05-03 23:03:56.436657+08	t
30f7fc45-a153-4d99-95c7-3fcd60f1c49a	other-061325@test.com	$2b$12$qZ/TB7ULp0xLkqaoCIqIe.vsoprUqYDBJuWEWEmGTYIm6gERahZWC	\N	user	t	2026-05-03 23:03:57.339598+08	t
6652f33c-817b-49c1-9500-8f18722e800c	bad-email-af4ab8	$2b$12$/V/EgZdnZXgi8xSxWBlF/.JPu8780mJwylSh5rbjPEW5FvFgjoRji	\N	user	t	2026-05-03 23:03:57.642912+08	t
0547d021-d923-47cf-a8a6-c103d097225d	full-006eda9e@test.com	$2b$12$IDh/2Jg7uooh9Zdq/goxd..d8YHj9HqcPJaPA5eDVKfCElE.h9NlC	Full Test Lab	user	t	2026-05-03 23:26:18.027487+08	t
39db3940-b588-4e02-bb66-c52ae9abf3ff	other-c5c5de@test.com	$2b$12$wxWhoEEn9wZLqikNZFrV9O6w973O1xNhgyVeX28Qfd.UfRm.bCQIK	\N	user	t	2026-05-03 23:26:18.909528+08	t
1f688f79-d228-4a64-bd7e-7a749e4f7a03	iso-dea1af@test.com	$2b$12$dExqy4llIeucNS0al4BLqulNB/VYFCivuePy31EKAGy6bQgmjm4De	\N	user	t	2026-05-03 23:26:19.634202+08	t
b3128ace-7961-4f44-947e-6004e829e406	dbcheck-e1321a@test.com	$2b$12$4S261MvoQ0zH/969PqRON.hgGyIRFOSnR542j6yuTFPSKlx8ailKm	\N	user	t	2026-05-03 23:27:02.947849+08	t
6bedf9df-20e5-4d3b-ad82-8226538639f9	full-d4270517@test.com	$2b$12$sIs7KpBZlxX5q8PMV/dnGOUNJSEwp5tzXTIl6aOtJmDnfh3lpDSpy	Full Test Lab	user	t	2026-05-03 23:27:03.292844+08	t
18c52150-e33c-40a8-ba91-0fea2ed282f2	other-af26d2@test.com	$2b$12$1Y5k0rFjgD0/xrvEcaV7yOHiigzjOqvItGBT3ViPrnENOXl6XEa5m	\N	user	t	2026-05-03 23:27:04.163004+08	t
4c3fbd4c-0eaf-4857-8af1-bd46766d233f	iso-ef3d5b@test.com	$2b$12$IhfM4LUpr.7/c8tc4NmKBuapVwaIYr7aSx0MzJ4PES8DyFb6l4INO	\N	user	t	2026-05-03 23:27:04.872881+08	t
2bc3a48d-aa1e-4802-b6b9-c62a1d70085e	audit-07509b@t.com	$2b$12$j1sGNkaBW8cYvfxXdach6OFil3NdJKHvZ6PBo3XIF4XGyHZW/Z7l.	\N	user	t	2026-05-03 23:43:17.274442+08	t
1e498881-3217-4e2d-ae6a-4183769e9682	iso-43f7@t.com	$2b$12$MCpBIIh//wKk9tvgNhiAVOHHKxdckYgCAZD7pUExj8voCXFCzshQK	\N	user	t	2026-05-03 23:43:18.141979+08	t
24804828-da4d-4f69-b6d1-2ea67245f3c8	audit-321560@t.com	$2b$12$R/jOHfth/rIvTrovfAM/7ufW3tEizShoqaxOuB/xa6zvEpSujiGG2	\N	user	t	2026-05-03 23:45:21.598521+08	t
4c0d0836-bfd4-42ad-bfeb-b3929d3c24b7	iso-5445@t.com	$2b$12$Wdpspo7ANNEnQYng47cKyOEPJexcGmgkdq7PnVi80Qfm8IOpfIZt2	\N	user	t	2026-05-03 23:45:22.476584+08	t
3e80f2c6-71aa-4e66-996e-e4ad3f8c879d	rpt@test.com	$2b$12$DwDCrJwdSZQasZ4olpz6yufQrDwUIeLGde3WMMZL42KivzEg4dosu	Test	user	t	2026-05-04 00:07:29.016973+08	t
0d5a9a9b-05e9-490d-9277-32e875cad209	audit-p15-kgwdsycr@test.com	$2b$12$uY/s23QpnpHWXW4P4mOObu5ddipToOiJ26C9GfJYiMj8j1BQRiTni	Audit	user	t	2026-05-04 00:41:44.842843+08	t
64e3b750-ffef-468e-ba9f-510be74db15c	audit-p15-fflcimgo@test.com	$2b$12$vsYAZuzCZ9//RIXVDtkdpuK2ujjbKnpOsPYUzbdXT2ZImw1shjyhi	Audit	user	t	2026-05-04 00:42:13.765116+08	t
19eda18c-f4cf-40b3-b67a-25ce83998f90	audit-test@x.com	$2b$12$wcWkmcXge9Oy967WjCkeNeqxAfrebg3CsgLHcdeokUsMg79M5JMX6	Test	user	t	2026-05-04 00:42:39.164968+08	t
638355de-1e16-4b47-ab46-a429bd37f993	ar@test.com	$2b$12$JfruXg3LSQkePeI/3Zadiu8Ffo4ZeIWI7zsHqaNxzpzzilz2JbcYC	\N	user	t	2026-05-04 00:43:04.870157+08	t
024e899b-c8cb-487e-95e0-fd2233d59b3b	audit-p15-sdwihqmb@test.com	$2b$12$Eba3TQfgEMyPVJOB3ZN48OE4NaGOjDcikn9l8jUQLT0KEjzuBegum	Audit	user	t	2026-05-04 00:45:04.296017+08	t
fc46d2d8-22a5-4135-a3ea-73654adc589e	audit-p15-manseqcy@test.com	$2b$12$0OdOH5vWjF1zQYi94uszpOJpbOeNMg4tprarbcOkMQCqzQ39epCGe	Audit	user	t	2026-05-04 00:56:46.005455+08	t
e89d9a77-a8b6-4b98-944e-fa82c082e3ad	audit-p15-wlsimokq@test.com	$2b$12$eexJgWXma21exxbi4HqtQ.bX7.MguIvNrqDS0qorfxaZL7Eh0T3RK	Audit	user	t	2026-05-04 01:05:29.622409+08	t
2f1b9881-5529-4d85-ae81-ab856d6a5ede	audit-p15-wwdhiwha@test.com	$2b$12$NoS.iuPF6fhSPAq930NQjOSL6l9UKtt/O1sMFbQIxb/nEiAuKOytO	Audit	user	t	2026-05-04 01:13:32.878001+08	t
2f0b0b7f-9d19-49da-8062-899e870200bc	audit-p15-czpwpzpi@test.com	$2b$12$yShE3R25xZsn6oc87r1li.kV4Ho/4GAcB7f1lMVuKwtCfMRYZMU8W	Audit	user	t	2026-05-04 01:20:06.443592+08	t
0a3e888f-28d9-472b-ac08-c7d183071c0e	test_health@bluecircle.tech	$2b$12$Ev/i8ee2rWBSwZMG10K5b.Ugh//zEvG0GFFha9SUz3ag8l09wfNz6	HealthCheck	user	t	2026-05-04 04:33:31.089438+08	t
109b0449-e734-4ac1-b3ad-f784c7682728	healthcheck@bluecircle.tech	$2b$12$/l7BUYvPFGkOLzwMYwySXO9wF8cmrig8wRHQaMrHdHEsdw96NXI2.	HealthCheck	user	t	2026-05-04 04:33:43.275979+08	t
254a67d2-fb72-4e8a-8b1e-b85b6abf9ad3	researcher@ocean.org	$2b$12$tIIRgtfZAZfaQHTnpgwAkOUDxL8VlKo7QWhOvfoARQ64n5lOeCzRi	Ocean Research Institute	admin	t	2026-05-03 22:48:26.493363+08	t
4795fb79-1bb9-4a61-9c6e-73a7e9f371d0	qareg1777879036913@test.org	$2b$12$aqdh.Hq2nsEs30HJYHhRZOVw/8aDJeGsIWY5cMNpssf2QlTi9w8F.	Ocean Institute	user	t	2026-05-04 15:17:23.386009+08	t
b4cafe72-cce1-4900-a197-cd545a3714f8	test0504@bluecircle.com	$2b$12$713YmuPB5Lx/KpmGIEF78uTzfvNLyKwIqrbSzhMK8COT0J2K962gS		user	t	2026-05-04 19:13:49.353295+08	t
aa541a0c-820c-4669-8e3f-35f1526478f7	qatest@check.org	$2b$12$ocmO8d.XW1NMCXYip2bo4.KdbIqGwP7zYvGPWAVhi0klagxZIupLO	\N	user	t	2026-05-04 15:10:12.912841+08	t
ad23a2e9-8ecc-44c1-a8d0-61acf55076a6	test2@example.edu.cn	$2b$12$mKS8kflhefiqfVrMjs//5OAh0tIW5nHxSea0yfqLy0bEMl3OA4CrK	PKU	user	t	2026-05-04 22:04:56.986203+08	f
38e02b87-9c3f-4b89-95c2-cd0d373135e7	z123@123.com	$2b$12$w3unvHsFTjgas18tMMZaBO/bryRd/POYu.tz5iRVaScvbu912VAGi	z123	researcher	t	2026-05-04 22:07:18.793594+08	t
141ad63f-fca4-468c-81f6-0bc6cc9215da	hwadmin@test.com	$2b$12$kDDdWcHasQzrwiO4.//6deLKi0Va/ckWgOqu6d6AuktJEqGATQRKm	\N	admin	t	2026-05-04 00:29:38.55842+08	t
9035f559-3b67-4b2b-9261-5ebacca99490	test@example.com	$2b$12$lDvxGfm4DcwzUDHluYQGk.wj9.qdMgjCYoaVP18yJO5YKzPtKD9BK	Test	user	t	2026-05-04 22:04:47.683063+08	t
fd7f5856-87af-408b-900d-7c36fdfedecc	zq@zq.com	$2b$12$kVKOv4cBVsDJZUVjcbEkb.Okt/AUOHdqrAbWhtxDh8WkPXTRzrlYC	zq	user	t	2026-05-04 22:18:59.099878+08	t
\.


--
-- Name: alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bluecircle
--

SELECT pg_catalog.setval('public.alerts_id_seq', 26, true);


--
-- Name: dataset_files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bluecircle
--

SELECT pg_catalog.setval('public.dataset_files_id_seq', 1, false);


--
-- Name: datasets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bluecircle
--

SELECT pg_catalog.setval('public.datasets_id_seq', 1, false);


--
-- Name: hardware_applications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bluecircle
--

SELECT pg_catalog.setval('public.hardware_applications_id_seq', 27, true);


--
-- Name: notification_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bluecircle
--

SELECT pg_catalog.setval('public.notification_logs_id_seq', 2, true);


--
-- Name: notification_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bluecircle
--

SELECT pg_catalog.setval('public.notification_rules_id_seq', 1, true);


--
-- Name: trial_applications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bluecircle
--

SELECT pg_catalog.setval('public.trial_applications_id_seq', 14, true);


--
-- Name: alerts alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


--
-- Name: api_keys api_keys_key_hash_key; Type: CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_key_hash_key UNIQUE (key_hash);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: dataset_files dataset_files_pkey; Type: CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.dataset_files
    ADD CONSTRAINT dataset_files_pkey PRIMARY KEY (id);


--
-- Name: datasets datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT datasets_pkey PRIMARY KEY (id);


--
-- Name: hardware_applications hardware_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.hardware_applications
    ADD CONSTRAINT hardware_applications_pkey PRIMARY KEY (id);


--
-- Name: notification_logs notification_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.notification_logs
    ADD CONSTRAINT notification_logs_pkey PRIMARY KEY (id);


--
-- Name: notification_rules notification_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.notification_rules
    ADD CONSTRAINT notification_rules_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: track_points track_points_pkey; Type: CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.track_points
    ADD CONSTRAINT track_points_pkey PRIMARY KEY ("time", turtle_id);


--
-- Name: trial_applications trial_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.trial_applications
    ADD CONSTRAINT trial_applications_pkey PRIMARY KEY (id);


--
-- Name: turtles turtles_pkey; Type: CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.turtles
    ADD CONSTRAINT turtles_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_reports_turtle; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX idx_reports_turtle ON public.reports USING btree (turtle_id);


--
-- Name: idx_reports_type; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX idx_reports_type ON public.reports USING btree (report_type);


--
-- Name: idx_reports_user; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX idx_reports_user ON public.reports USING btree (created_by);


--
-- Name: ix_alerts_created; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX ix_alerts_created ON public.alerts USING btree (created_at DESC);


--
-- Name: ix_alerts_severity; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX ix_alerts_severity ON public.alerts USING btree (severity);


--
-- Name: ix_alerts_status; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX ix_alerts_status ON public.alerts USING btree (status);


--
-- Name: ix_alerts_turtle_id; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX ix_alerts_turtle_id ON public.alerts USING btree (turtle_id);


--
-- Name: ix_alerts_type; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX ix_alerts_type ON public.alerts USING btree (alert_type);


--
-- Name: ix_hardware_email; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX ix_hardware_email ON public.hardware_applications USING btree (email);


--
-- Name: ix_hardware_status; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX ix_hardware_status ON public.hardware_applications USING btree (status);


--
-- Name: ix_notif_logs_alert; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX ix_notif_logs_alert ON public.notification_logs USING btree (alert_id);


--
-- Name: ix_notif_logs_rule; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX ix_notif_logs_rule ON public.notification_logs USING btree (rule_id);


--
-- Name: ix_notif_logs_sent; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX ix_notif_logs_sent ON public.notification_logs USING btree (sent_at DESC);


--
-- Name: ix_notif_rules_turtle; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX ix_notif_rules_turtle ON public.notification_rules USING btree (turtle_id);


--
-- Name: ix_notif_rules_user; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX ix_notif_rules_user ON public.notification_rules USING btree (created_by);


--
-- Name: ix_track_points_time; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX ix_track_points_time ON public.track_points USING btree ("time" DESC);


--
-- Name: ix_track_points_turtle_id; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE INDEX ix_track_points_turtle_id ON public.track_points USING btree (turtle_id);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: bluecircle
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: alerts alerts_turtle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_turtle_id_fkey FOREIGN KEY (turtle_id) REFERENCES public.turtles(id) ON DELETE SET NULL;


--
-- Name: api_keys api_keys_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: dataset_files dataset_files_dataset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.dataset_files
    ADD CONSTRAINT dataset_files_dataset_id_fkey FOREIGN KEY (dataset_id) REFERENCES public.datasets(id) ON DELETE CASCADE;


--
-- Name: hardware_applications hardware_applications_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.hardware_applications
    ADD CONSTRAINT hardware_applications_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: notification_logs notification_logs_alert_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.notification_logs
    ADD CONSTRAINT notification_logs_alert_id_fkey FOREIGN KEY (alert_id) REFERENCES public.alerts(id) ON DELETE SET NULL;


--
-- Name: notification_logs notification_logs_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.notification_logs
    ADD CONSTRAINT notification_logs_rule_id_fkey FOREIGN KEY (rule_id) REFERENCES public.notification_rules(id) ON DELETE SET NULL;


--
-- Name: notification_rules notification_rules_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.notification_rules
    ADD CONSTRAINT notification_rules_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: notification_rules notification_rules_turtle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.notification_rules
    ADD CONSTRAINT notification_rules_turtle_id_fkey FOREIGN KEY (turtle_id) REFERENCES public.turtles(id) ON DELETE SET NULL;


--
-- Name: reports reports_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports reports_turtle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_turtle_id_fkey FOREIGN KEY (turtle_id) REFERENCES public.turtles(id) ON DELETE SET NULL;


--
-- Name: track_points track_points_turtle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.track_points
    ADD CONSTRAINT track_points_turtle_id_fkey FOREIGN KEY (turtle_id) REFERENCES public.turtles(id) ON DELETE CASCADE;


--
-- Name: trial_applications trial_applications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bluecircle
--

ALTER TABLE ONLY public.trial_applications
    ADD CONSTRAINT trial_applications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: bluecircle
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict hc6YkVZLikrPL2oHQWt5oYydly6eLseUINMLbskFZuvnLzaJX5wdO1rf9UAvdbt

