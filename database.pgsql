--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4
-- Dumped by pg_dump version 14.4

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: city; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.city (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    region_id integer,
    user_id_added integer,
    group_id_added integer,
    unixtime_added integer,
    removed boolean,
    unixtime_removed integer,
    user_id_removed integer
);


ALTER TABLE public.city OWNER TO abyrondeans;

--
-- Name: city_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.city_id_seq OWNER TO abyrondeans;

--
-- Name: city_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.city_id_seq OWNED BY public.city.id;


--
-- Name: country; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.country (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    user_id_added integer,
    group_id_added integer,
    unixtime_added integer,
    removed boolean,
    unixtime_removed integer,
    user_id_removed integer
);


ALTER TABLE public.country OWNER TO abyrondeans;

--
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.country_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.country_id_seq OWNER TO abyrondeans;

--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.country_id_seq OWNED BY public.country.id;


--
-- Name: district; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.district (
    id integer NOT NULL,
    name character varying(100),
    user_id_added integer,
    unixtime_added integer,
    city_id integer,
    group_id_added integer,
    unixtime_removed integer,
    user_removed integer,
    removed boolean
);


ALTER TABLE public.district OWNER TO abyrondeans;

--
-- Name: district_choice; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.district_choice (
    id integer NOT NULL,
    user_id integer,
    created_on integer,
    group_id integer,
    choice_string character varying(1024)
);


ALTER TABLE public.district_choice OWNER TO abyrondeans;

--
-- Name: district_choice_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.district_choice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.district_choice_id_seq OWNER TO abyrondeans;

--
-- Name: district_choice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.district_choice_id_seq OWNED BY public.district_choice.id;


--
-- Name: district_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.district_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.district_id_seq OWNER TO abyrondeans;

--
-- Name: district_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.district_id_seq OWNED BY public.district.id;


--
-- Name: invite_links; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.invite_links (
    id integer NOT NULL,
    link_code character varying(20),
    group_id integer,
    user_generated integer,
    created_on integer,
    used_on integer,
    used_by integer
);


ALTER TABLE public.invite_links OWNER TO abyrondeans;

--
-- Name: invite_links_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.invite_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invite_links_id_seq OWNER TO abyrondeans;

--
-- Name: invite_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.invite_links_id_seq OWNED BY public.invite_links.id;


--
-- Name: price; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.price (
    price numeric,
    user_id integer,
    unixtime_added integer,
    product_store_id integer,
    id integer NOT NULL,
    group_id integer
);


ALTER TABLE public.price OWNER TO abyrondeans;

--
-- Name: price_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.price_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.price_id_seq OWNER TO abyrondeans;

--
-- Name: price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.price_id_seq OWNED BY public.price.id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.product (
    id integer NOT NULL,
    name character varying(170) NOT NULL,
    user_added integer,
    unixtime_added integer,
    removed boolean,
    group_id integer
);


ALTER TABLE public.product OWNER TO abyrondeans;

--
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_id_seq OWNER TO abyrondeans;

--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.id;


--
-- Name: product_store; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.product_store (
    id integer NOT NULL,
    product_id integer,
    store_id integer,
    removed boolean,
    time_removed integer,
    user_added integer,
    user_removed integer,
    group_id integer,
    time_added integer
);


ALTER TABLE public.product_store OWNER TO abyrondeans;

--
-- Name: product_store_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.product_store_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_store_id_seq OWNER TO abyrondeans;

--
-- Name: product_store_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.product_store_id_seq OWNED BY public.product_store.id;


--
-- Name: region; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.region (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    country_id integer,
    user_id_added integer,
    group_id_added integer,
    unixtime_added integer,
    removed boolean,
    unixtime_removed integer,
    user_id_removed integer
);


ALTER TABLE public.region OWNER TO abyrondeans;

--
-- Name: region_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.region_id_seq OWNER TO abyrondeans;

--
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.region_id_seq OWNED BY public.region.id;


--
-- Name: shopping_group; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.shopping_group (
    id integer NOT NULL,
    user_id_created integer,
    unixtime_created integer,
    removed boolean,
    user_id_removed integer,
    unixtime_removed integer,
    name character varying(256)
);


ALTER TABLE public.shopping_group OWNER TO abyrondeans;

--
-- Name: shopping_group_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.shopping_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shopping_group_id_seq OWNER TO abyrondeans;

--
-- Name: shopping_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.shopping_group_id_seq OWNED BY public.shopping_group.id;


--
-- Name: store; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.store (
    id integer NOT NULL,
    name character varying(120) NOT NULL,
    district_id integer,
    unixtime_added integer,
    removed boolean,
    unixtime_removed integer,
    user_added integer,
    user_removed integer,
    group_id integer
);


ALTER TABLE public.store OWNER TO abyrondeans;

--
-- Name: store_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.store_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_id_seq OWNER TO abyrondeans;

--
-- Name: store_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.store_id_seq OWNED BY public.store.id;


--
-- Name: user_admin; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.user_admin (
    id integer NOT NULL,
    user_id integer,
    shopping_group_id integer,
    unixtime_added integer,
    removed boolean,
    time_removed integer
);


ALTER TABLE public.user_admin OWNER TO abyrondeans;

--
-- Name: user_admin_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.user_admin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_admin_id_seq OWNER TO abyrondeans;

--
-- Name: user_admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.user_admin_id_seq OWNED BY public.user_admin.id;


--
-- Name: user_group; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.user_group (
    id integer NOT NULL,
    user_id integer,
    shopping_group_id integer,
    unixtime_added integer,
    removed boolean,
    unixtime_removed integer,
    user_id_that_removed integer,
    time_removed integer
);


ALTER TABLE public.user_group OWNER TO abyrondeans;

--
-- Name: user_group_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.user_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_group_id_seq OWNER TO abyrondeans;

--
-- Name: user_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.user_group_id_seq OWNED BY public.user_group.id;


--
-- Name: user_group_toggle; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.user_group_toggle (
    id integer NOT NULL,
    user_id integer,
    created_on integer,
    user_group_id integer
);


ALTER TABLE public.user_group_toggle OWNER TO abyrondeans;

--
-- Name: user_group_toggle_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.user_group_toggle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_group_toggle_id_seq OWNER TO abyrondeans;

--
-- Name: user_group_toggle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.user_group_toggle_id_seq OWNED BY public.user_group_toggle.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: abyrondeans
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    created_on integer NOT NULL
);


ALTER TABLE public.users OWNER TO abyrondeans;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: abyrondeans
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO abyrondeans;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abyrondeans
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: city id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.city ALTER COLUMN id SET DEFAULT nextval('public.city_id_seq'::regclass);


--
-- Name: country id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.country ALTER COLUMN id SET DEFAULT nextval('public.country_id_seq'::regclass);


--
-- Name: district id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.district ALTER COLUMN id SET DEFAULT nextval('public.district_id_seq'::regclass);


--
-- Name: district_choice id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.district_choice ALTER COLUMN id SET DEFAULT nextval('public.district_choice_id_seq'::regclass);


--
-- Name: invite_links id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.invite_links ALTER COLUMN id SET DEFAULT nextval('public.invite_links_id_seq'::regclass);


--
-- Name: price id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.price ALTER COLUMN id SET DEFAULT nextval('public.price_id_seq'::regclass);


--
-- Name: product id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- Name: product_store id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.product_store ALTER COLUMN id SET DEFAULT nextval('public.product_store_id_seq'::regclass);


--
-- Name: region id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.region ALTER COLUMN id SET DEFAULT nextval('public.region_id_seq'::regclass);


--
-- Name: shopping_group id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.shopping_group ALTER COLUMN id SET DEFAULT nextval('public.shopping_group_id_seq'::regclass);


--
-- Name: store id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.store ALTER COLUMN id SET DEFAULT nextval('public.store_id_seq'::regclass);


--
-- Name: user_admin id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.user_admin ALTER COLUMN id SET DEFAULT nextval('public.user_admin_id_seq'::regclass);


--
-- Name: user_group id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.user_group ALTER COLUMN id SET DEFAULT nextval('public.user_group_id_seq'::regclass);


--
-- Name: user_group_toggle id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.user_group_toggle ALTER COLUMN id SET DEFAULT nextval('public.user_group_toggle_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: city; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.city (id, name, region_id, user_id_added, group_id_added, unixtime_added, removed, unixtime_removed, user_id_removed) FROM stdin;
1	Paphos	1	1	12	\N	\N	\N	\N
4	Limassol	8	1	12	\N	f	\N	\N
2	Platres	8	1	12	\N	t	1667641163	1
3	Traxoni	8	1	12	\N	t	1667641191	1
6	Platres	8	1	12	1667643024	t	1667643066	1
7	Pano P	8	1	12	1667643093	t	1667643192	1
8	Kata P	8	1	12	1667643103	t	1667643196	1
9	Budapest	16	1	11	1667656353	f	\N	\N
11	Minsk	19	1	\N	1668414655	t	1668415317	1
12	Minsk	0	1	\N	1668415356	t	1668415358	1
13	Minsk	0	1	\N	1668415367	f	\N	\N
10	Minsk	17	1	\N	1667657604	t	1668420316	1
14	Belarus-Minsk-Minsk2	17	1	\N	1668420397	f	\N	\N
\.


--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.country (id, name, user_id_added, group_id_added, unixtime_added, removed, unixtime_removed, user_id_removed) FROM stdin;
8	Hungary	2	11	1667309459	t	1667312231	1667312231
9	user2country1	2	\N	1667312252	t	1667312663	2
10	user2country2	2	\N	1667312676	f	\N	\N
7	Greece	1	\N	1666545560	t	1667576247	1
2	Republic of Cyprus	1	\N	\N	t	1667576250	1
4	Turkey	1	11	\N	t	1667576268	1
11	Cyprus	1	12	1667576286	f	\N	\N
13	Hungary	1	11	1667656337	f	\N	\N
14	Belarus	1	\N	1667657472	f	\N	\N
16	Latvia	1	\N	1668413744	t	1668413751	1
15	Lithuania	1	\N	1668413673	t	1668413841	1
\.


--
-- Data for Name: district; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.district (id, name, user_id_added, unixtime_added, city_id, group_id_added, unixtime_removed, user_removed, removed) FROM stdin;
5	test5Lim	1	\N	\N	12	\N	\N	f
1	test1Lim	1	\N	4	12	\N	\N	f
2	test2Lim	1	\N	4	12	\N	\N	f
3	test3Lim	1	\N	4	12	\N	\N	f
4	test4Lim	1	\N	4	12	\N	\N	f
6	test1group11	1	1667657105	9	11	\N	\N	f
7	testdist2group11	1	1667657133	9	11	\N	\N	f
8	user1nogroupdistrict1	1	1667657725	10	\N	\N	\N	f
9	user1nogroupdistrict2	1	1667657735	10	\N	\N	\N	f
10	user1nogroupdistrict3	1	1667657742	10	\N	\N	\N	f
11	NeighborhoodA	1	1668415442	13	\N	\N	\N	f
12	NeighbourhoodB	1	1668415475	13	\N	\N	\N	f
13	Bel-Min-Min2-Dist1	1	1668420417	14	\N	\N	\N	f
14	Bel-Min-Min2-Dist2	1	1668420427	14	\N	\N	\N	f
\.


--
-- Data for Name: district_choice; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.district_choice (id, user_id, created_on, group_id, choice_string) FROM stdin;
1	1	1667646021	12	1, 2, 3
2	1	1667654409	12	1, 2, 3
3	1	1667655859	12	1, 2, 3
4	1	1667655965	12	1, 2, 3
5	1	1667657320	11	6, 7
6	1	1667657332	12	1, 2, 3
7	1	1667657338	11	6, 7
8	1	1667657348	11	6, 7
9	1	1667657358	11	6, 7
10	1	1667657380	11	6, 7
11	1	1667657747	0	8, 9, 10
12	1	1667657758	12	1, 2, 3
13	1	1667657763	11	6, 7
14	1	1667658038	11	6, 7
15	1	1667658234	11	6, 7
16	1	1667658291	11	6, 7
17	1	1667658563	11	6, 7
18	1	1667658641	11	6, 7
19	1	1667658647	11	6, 7
20	1	1667658652	12	1, 2, 3
21	1	1667658659	0	8, 9, 10
22	1	1667659176	0	8, 9, 10
23	1	1667659316	0	8, 9, 10
24	1	1667659328	0	8, 9, 10
25	1	1668255544	0	8, 9, 10
26	1	1668255658	0	8, 9, 10
27	1	1668255682	11	6, 7
28	1	1668255691	0	8, 9, 10
29	1	1668257157	0	8, 9, 10
30	1	1668257208	0	8, 9, 10
31	1	1668257842	0	8, 9, 10
32	1	1668259152	0	8, 9, 10
33	1	1668259388	0	8, 9, 10
34	1	1668259406	0	8, 9, 10
35	1	1668259416	0	8, 9, 10
36	1	1668259659	11	6, 7
37	1	1668259704	11	6, 7
38	1	1668259712	11	6, 7
39	1	1668259720	0	8, 9, 10
40	1	1668260144	0	8, 9, 10
41	1	1668260148	0	8, 9, 10
42	1	1668260164	0	8, 9, 10
43	1	1668260269	0	8, 9, 10
44	1	1668260275	0	8, 9, 10
45	1	1668260277	0	8, 9, 10
46	1	1668260284	0	8, 9, 10
47	1	1668260293	0	8, 9, 10
48	1	1668260298	0	8, 9, 10
49	1	1668260306	0	8, 9, 10
50	1	1668260328	0	8, 9, 10
51	1	1668260329	0	8, 9, 10
52	1	1668260471	0	8, 9, 10
53	1	1668262834	0	8, 9, 10
54	1	1668262836	0	8, 9, 10
55	1	1668262844	0	8, 9, 10
56	1	1668263322	0	8, 9, 10
57	1	1668263492	0	8, 9, 10
58	1	1668263493	0	8, 9, 10
59	1	1668264009	0	8, 9, 10
60	1	1668264320	0	8, 9, 10
61	1	1668264320	0	8, 9, 10
62	1	1668264321	0	8, 9, 10
63	1	1668264396	0	8, 9, 10
64	1	1668264420	0	8, 9, 10
65	1	1668264498	0	8, 9, 10
66	1	1668265158	0	8, 9, 10
67	1	1668265187	0	8, 9, 10
68	1	1668265195	0	8, 9, 10
69	1	1668265200	0	8, 9, 10
70	1	1668265210	0	8, 9, 10
71	1	1668265295	0	8, 9, 10
72	1	1668265418	0	8, 9, 10
73	1	1668265452	0	8, 9, 10
74	1	1668265466	0	8, 9, 10
75	1	1668265471	0	8, 9, 10
76	1	1668265476	0	8, 9, 10
77	1	1668265575	0	8, 9, 10
78	1	1668265593	0	8, 9, 10
79	1	1668265604	0	8, 9, 10
80	1	1668265776	0	8, 9, 10
81	1	1668265781	0	8, 9, 10
82	1	1668266544	0	8, 9, 10
83	1	1668266577	0	8, 9, 10
84	1	1668266583	0	8, 9, 10
85	1	1668266596	0	8, 9, 10
86	1	1668266613	0	8, 9, 10
87	1	1668266975	0	8, 9, 10
88	1	1668266981	0	8, 9, 10
89	1	1668266990	0	8, 9, 10
90	1	1668266994	0	8, 9, 10
91	1	1668267157	0	8, 9, 10
92	1	1668267890	0	9, 10
93	1	1668415455	0	11
94	1	1668415490	0	11, 12
95	1	1668415493	0	11
96	1	1668415529	0	11
97	1	1668415745	0	11
98	1	1668415769	0	11
99	1	1668415831	0	11
100	1	1668415852	0	11
101	1	1668416076	0	8
102	1	1668420430	0	13
103	1	1668422745	0	13, 14
\.


--
-- Data for Name: invite_links; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.invite_links (id, link_code, group_id, user_generated, created_on, used_on, used_by) FROM stdin;
2	THFX804ZHM1NRL0U5VAC	11	1	1665252269	1665932714	3
3	MOV7P8E46G5BCYW122AB	11	1	1665252302	1665932714	3
4	FMSO13D56VN4VC78QGXN	11	1	1665252323	1665932714	3
5	WCI5379XDMZB12Z4ZIES	11	1	1665252402	1665932714	3
1	FT98DUS690G2HDTEHWCH	11	1	1665252106	1665932714	3
6	6KIFILC2BQN2XF5R7J4W	11	1	1665259749	1665932714	3
7	UJXUZ2T2C4D3AVAM1MLD	11	1	1665260233	1665932714	3
8	YIYV87OXJYOB1TMQL5GN	11	1	1665921358	1665932714	3
9	4L527AX70DWUDQUN5QHP	11	1	1665922558	1665932714	3
10	R3FWLLH8LHR8N1WZH06F	11	1	1665932647	1665932714	3
11	UTRZGYCC9FJHLDYD383Y	13	1	1668425905	\N	0
12	V2847IAQS3IYWS2Y5BUS	11	1	1668426038	\N	0
13	331T293WZCKSUKPBTDF3	11	1	1668426111	\N	0
14	H19RFKXW3DVKQ6TT2CUM	11	1	1668426153	\N	0
\.


--
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.price (price, user_id, unixtime_added, product_store_id, id, group_id) FROM stdin;
9.10	1	1656421710	1	1	\N
9	1	1656421960	1	2	\N
5	1	1656782663	2	3	\N
5.10	1	1656782663	3	4	\N
9.20	1	1656782666	4	5	\N
1.15	1	1657312098	5	6	\N
5.25	1	1657652765	6	7	\N
5.45	1	1657652799	7	8	\N
7.25	1	1657653495	8	9	\N
8.10	1	1657653634	9	10	\N
9.05	1	1657653648	10	11	\N
17	1	1658257185	11	12	\N
17.50	1	1658925607	12	13	\N
3	1	1658926165	13	14	\N
8.90	1	1659013363	1	15	\N
9.05	1	1659014535	1	16	\N
5.89	1	1659124241	15	17	\N
5.89	1	1659124325	15	18	\N
5.88	1	1659124510	1	19	\N
5.87	1	1659450153	1	20	\N
5.87	1	1659450184	1	21	\N
5.86	1	1659450213	1	22	\N
5.09	1	1659612999	1	23	\N
1.27	1	1660051005	17	24	\N
1.89	1	1660051929	18	25	\N
7.24	1	1660051969	8	26	\N
7.78	1	1660052512	19	27	\N
9	1	1660054075	1	28	\N
9.01	1	1660054280	1	29	\N
9.02	1	1660054330	20	30	\N
9	1	1660054342	3	31	\N
5	1	1660054451	21	32	\N
8.25	1	1660155015	22	33	\N
8.09	1	1660155056	22	34	\N
8.08	1	1660155179	9	35	\N
9.01	1	1660155343	20	36	\N
9.09	1	1660155392	23	37	\N
7.81	1	1660155416	24	38	\N
7.83	1	1660156354	24	39	\N
9.02	1	1661196877	20	40	\N
8.98	1	1661200040	25	41	\N
8.78	1	1661596329	26	42	\N
8.79	1	1661596345	26	43	\N
8.98	1	1661596947	27	44	\N
9.99	1	1661597106	28	45	\N
10	1	1661608832	29	46	\N
17.01	1	1661608847	29	47	\N
8.10	1	1662208375	30	48	\N
9	1	1662212981	31	49	\N
3	1	1662213002	32	50	\N
2	1	1662213015	33	51	\N
1.30	1	1663415170	34	52	\N
1.75	1	1663415431	35	53	\N
1.29	1	1663415455	36	54	\N
16.99	1	1664112427	29	55	\N
4	1	1664112469	37	56	\N
1	1	1664115268	38	57	\N
5	2	1664112423	39	58	\N
2	2	1664112443	39	59	\N
3	2	1664112829	40	60	\N
4	2	1664113016	41	61	\N
5	2	1664113048	42	62	\N
1	2	1664113073	43	63	\N
5	3	1664113421	44	64	\N
6	3	1664113432	45	65	\N
7	3	1664113444	46	66	\N
7.5	3	1664113527	47	67	\N
50	1	1665926861	49	68	\N
51	1	1665931927	50	69	11
49	1	1665931945	50	70	11
46	3	1665932987	51	71	11
39	1	1665933138	51	72	11
38	1	1665933161	52	73	11
20	2	1666533496	53	74	11
25	1	1666534235	54	75	12
24.99	1	1666534279	55	76	12
4.98	1	1666534295	56	77	12
24.98	1	1666534358	57	78	12
24.97	1	1666534379	58	79	12
19	1	1666539709	59	80	11
20	1	1667658561	60	81	11
100	1	1668257155	61	82	\N
101	1	1668257206	62	83	\N
99	1	1668257841	63	84	\N
80	1	1668259405	64	85	\N
79	1	1668259414	64	86	\N
5	1	1668259702	60	87	11
40	1	1668265185	65	88	\N
20	1	1668265450	66	89	\N
21	1	1668265464	67	90	\N
20	1	1668265592	68	91	\N
21	1	1668265602	69	92	\N
20	1	1668266542	70	93	\N
21	1	1668266594	71	94	\N
1	1	1668415919	72	95	\N
2	1	1668415940	73	96	\N
1	1	1668424855	74	97	\N
1	1	1668424878	75	98	\N
1	1	1668425778	76	99	\N
1	1	1668426516	77	100	\N
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.product (id, name, user_added, unixtime_added, removed, group_id) FROM stdin;
1	Black Pepper Corns 100g	1	\N	\N	\N
2	Ground Black Pepper 100g	1	\N	\N	\N
4	Pork Chops 1kg	1	\N	\N	\N
15	Pork Chops 2kg	1	\N	\N	\N
23	Pork Chops 2.5kg	1	\N	\N	\N
25	Pork Chops 3kg	1	\N	\N	\N
26	asdf	1	\N	\N	\N
28	Pork chops (4kg)	1	\N	\N	\N
29	pork chops (5kg)	1	\N	\N	\N
31	pork chops (6kg)	1	1657546300	\N	\N
33	pork chops (7kg)	1	1657546838	\N	\N
34	pork chops (8kg)	1	1657546863	\N	\N
36	pork chops (9kg)	1	1657546940	\N	\N
38	pork chops (10kg)	1	1657546986	\N	\N
39	pork chops (11kg)	1	1657547005	\N	\N
40	test item 1	1	1657547634	\N	\N
41	test item 2	1	1657547762	\N	\N
42	test item 3	1	1657547970	\N	\N
45	test item 5	1	1657548124	\N	\N
46	test item 6	1	1657548270	\N	\N
47	test item 8	1	1657548493	\N	\N
48	test item 10	1	1657548681	\N	\N
49	test item 11	1	1657653351	\N	\N
51	test item 12	1	1657653495	\N	\N
53	test item 14	1	1657653648	\N	\N
56	test item 17	1	1658926165	\N	\N
57	test item 18	1	1660051005	\N	\N
58	test item 19	1	1660051929	\N	\N
3	Can of Chickpeas 400g	1	\N	f	\N
52	test item 13	1	1657653634	f	\N
54	test item 15	1	1658257185	f	\N
55	test item 16	1	1658925607	f	\N
59	test item 20	1	1660052512	f	\N
60	test item 21	1	1660054330	f	\N
61	test item 22	1	1660155392	f	\N
62	Bag of chickpeas	1	1663415170	\N	\N
63	Bag of Flour	1	1663415431	f	\N
64	test 19	1	1664115268	f	\N
66	user2product2	2	1664112829	f	\N
65	user2product1	2	1664112423	t	\N
67	user2product3	2	1664113016	f	\N
68	user3prod1	3	1664113421	f	\N
69	user3prod2	3	1664113432	f	\N
70	user3prod3	3	1664113444	f	\N
72	test3groupitem2	1	1665926861	f	\N
74	test3grouproduct2	3	1665932987	f	11
71	testgroup1product1	1	1664717384	t	11
75	test3groupproduct3	2	1666533496	f	11
76	group4product1	1	1666534235	f	12
77	group4product2	1	1666534279	f	12
78	group4store3	1	1666534295	t	12
79	group4product3	1	1666534358	f	12
73	test3groupstore2	1	1665931927	t	11
80	test3groupproduct1	1	1666539709	f	11
81	teststore3prod1	1	1667658561	f	11
82	store1user1-product1	1	1668257155	t	\N
84	store1user1-product2	1	1668259405	t	\N
86	user1prod5test	1	1668265592	t	\N
85	user1testprod4	1	1668265450	t	\N
83	teststore10-product1	1	1668257206	t	\N
87	user1prod6test	1	1668266542	t	\N
88	MinskNA-sto1-prod1	1	1668415919	f	\N
89	MinskNeighbA-store1-prod2	1	1668415940	f	\N
91	Bel-Min-Min2-Dist1-Store2-Prod1	1	1668424878	t	\N
90	Bel-Min-Min2-Dist1-Store1-Prod1	1	1668424855	t	\N
92	test79	1	1668425778	t	\N
93	prod80	1	1668426516	f	\N
\.


--
-- Data for Name: product_store; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.product_store (id, product_id, store_id, removed, time_removed, user_added, user_removed, group_id, time_added) FROM stdin;
13	56	1	\N	\N	\N	\N	\N	\N
15	1	5	t	\N	\N	\N	\N	\N
4	1	3	t	\N	\N	\N	\N	\N
69	86	18	t	1668265775	1	1	\N	\N
68	86	17	t	1668265779	1	1	\N	1668265592
16	25	25	\N	\N	\N	\N	\N	\N
71	87	18	t	1668266980	1	1	\N	\N
70	87	17	t	1668266992	1	1	\N	1668266542
72	88	19	f	\N	1	\N	\N	1668415919
73	89	19	f	\N	1	\N	\N	1668415940
11	54	3	f	\N	\N	\N	\N	\N
12	55	1	f	\N	\N	\N	\N	\N
75	91	22	t	1668425686	1	1	\N	1668424878
74	90	21	t	1668425709	1	1	\N	1668424855
76	92	21	t	1668425792	1	1	\N	1668425778
7	49	1	t	1659616868	\N	1	\N	\N
6	48	1	t	1659616874	\N	1	\N	\N
10	53	3	t	1659616880	\N	1	\N	\N
2	2	3	t	1659616896	\N	1	\N	\N
3	2	1	t	1659617138	\N	1	\N	\N
5	3	1	t	1660050971	\N	1	\N	\N
17	57	1	\N	\N	\N	\N	\N	\N
8	51	1	t	1660051979	\N	1	\N	\N
19	59	4	f	\N	\N	\N	\N	\N
18	58	1	t	1660053177	\N	1	\N	\N
20	60	1	f	\N	\N	\N	\N	\N
77	93	21	f	\N	1	\N	\N	1668426516
22	52	4	f	\N	\N	\N	\N	\N
23	61	5	f	\N	\N	\N	\N	\N
1	1	1	t	1660156376	1	1	\N	\N
21	1	1	t	1660156376	\N	1	\N	\N
24	1	1	t	1660156376	\N	1	\N	\N
25	1	6	t	1661596302	\N	1	\N	\N
26	3	6	t	1661597074	\N	1	\N	\N
27	3	6	t	1661597074	\N	1	\N	\N
28	3	6	f	\N	\N	\N	\N	\N
29	54	4	f	\N	\N	\N	\N	\N
30	52	1	f	\N	\N	\N	\N	\N
31	38	1	t	1662213019	\N	1	\N	\N
32	38	1	t	1662213019	\N	1	\N	\N
33	38	1	t	1662213019	\N	1	\N	\N
9	52	2	t	1662213773	\N	1	\N	\N
34	62	1	f	\N	\N	\N	\N	\N
35	63	1	f	\N	\N	\N	\N	\N
36	63	2	f	\N	\N	\N	\N	\N
38	64	1	f	\N	\N	\N	\N	\N
37	61	4	t	1664115508	\N	1	\N	\N
40	66	8	f	\N	\N	\N	\N	\N
39	65	8	t	1664113002	\N	2	\N	\N
41	67	8	f	\N	\N	\N	\N	\N
42	67	9	f	\N	\N	\N	\N	\N
43	66	9	f	\N	\N	\N	\N	\N
44	68	10	f	\N	\N	\N	\N	\N
45	69	10	f	\N	\N	\N	\N	\N
46	70	10	f	\N	\N	\N	\N	\N
47	68	11	f	\N	\N	\N	\N	\N
49	72	12	f	\N	\N	\N	\N	\N
51	74	13	f	\N	3	\N	11	1665932987
52	74	12	f	\N	1	\N	11	\N
48	71	11	t	\N	\N	\N	3	\N
53	75	13	f	\N	2	\N	11	1666533496
54	76	14	f	\N	1	\N	12	1666534235
55	77	14	f	\N	1	\N	12	1666534279
56	78	14	t	1666534337	1	1	12	1666534295
57	79	14	f	\N	1	\N	12	1666534358
58	79	15	f	\N	1	\N	12	\N
50	73	12	t	1666539686	1	1	11	1665931927
59	80	12	f	\N	1	\N	11	1666539709
60	81	16	f	\N	1	\N	11	1667658561
63	82	18	t	1668260291	1	1	\N	\N
61	82	17	t	1668260296	1	1	\N	1668257155
64	84	17	t	1668260322	1	1	\N	1668259405
62	83	18	t	1668265193	1	1	\N	1668257206
65	83	17	t	1668265199	1	1	\N	\N
66	85	17	t	1668265469	1	1	\N	1668265450
67	85	18	t	1668265473	1	1	\N	\N
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.region (id, name, country_id, user_id_added, group_id_added, unixtime_added, removed, unixtime_removed, user_id_removed) FROM stdin;
1	Paphos	2	2	\N	\N	f	\N	\N
2	Athens	10	2	\N	\N	f	\N	\N
3	Attica	\N	2	\N	1667315493	f	\N	\N
5	Attica2	10	2	\N	1667317684	f	\N	\N
7	Attica3	10	2	\N	1667317708	f	\N	\N
8	Limassol	11	1	12	1667625421	f	\N	\N
9	Larnaca	11	1	12	1667625428	t	1667635963	1
10	Agia Napa	11	1	12	1667625434	t	1667636048	1
11	Nicosia	11	1	12	1667625440	t	1667636328	1
12	test1	11	1	12	1667636355	t	1667636358	1
13	test2	11	1	12	1667636389	t	1667636395	1
14	test5	11	1	12	1667636592	t	1667639877	1
15	test6	11	1	12	1667639888	t	1667639891	1
16	Budapest	13	1	11	1667656346	f	\N	\N
17	Minsk	14	1	\N	1667657480	f	\N	\N
18	Jinsk	14	1	\N	1668414438	t	1668414530	1
20	Jinsk	0	1	\N	1668414554	t	1668414556	1
19	Minsk	0	1	\N	1668414543	t	\N	\N
22	Jinsk	14	1	\N	1668420015	t	1668420143	1
21	Belar-Minsk2	14	1	\N	1668419999	t	1668420194	1
\.


--
-- Data for Name: shopping_group; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.shopping_group (id, user_id_created, unixtime_created, removed, user_id_removed, unixtime_removed, name) FROM stdin;
1	1	1664125480	f	\N	\N	\N
2	1	1664125488	f	\N	\N	\N
3	1	1664125491	f	\N	\N	\N
4	1	1664705719	f	\N	\N	\N
5	1	1664706077	f	\N	\N	\N
6	1	1664707524	f	\N	\N	\N
7	1	1664708406	f	\N	\N	\N
8	1	1664708426	f	\N	\N	\N
9	1	1664708521	f	\N	\N	\N
10	1	1664709884	f	\N	\N	testgroup1
11	1	1664714384	f	\N	\N	test3group
12	1	1664716405	f	\N	\N	test4group
13	1	1668425867	f	\N	\N	testgroup5
14	1	1668425974	f	\N	\N	group6
\.


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.store (id, name, district_id, unixtime_added, removed, unixtime_removed, user_added, user_removed, group_id) FROM stdin;
1	Papantoniou (Paphos Harbor)	1	\N	f	\N	1	\N	\N
2	PLAZA MINI MARKET CAVA	1	\N	f	\N	1	\N	\N
3	Poplife	1	\N	f	\N	1	\N	\N
4	Stavros Shock Prices Supermarket	1	\N	f	\N	1	\N	\N
5	Mini-Market, Tobbacco & Alcohol	1	\N	f	\N	1	\N	\N
6	test1	1	\N	t	\N	1	\N	\N
7	test store 2	1	\N	t	\N	1	\N	\N
8	user2test1	1	\N	f	\N	2	\N	\N
9	user2test2	1	\N	f	\N	2	\N	\N
10	user3store1	1	\N	f	\N	3	\N	\N
11	user3store2	1	\N	f	\N	3	\N	\N
14	group4store1	1	\N	f	\N	1	\N	12
15	group4store2	1	\N	f	\N	1	\N	12
16	test3groupstore3	7	\N	f	\N	1	\N	11
12	test3groupstore1	6	\N	f	\N	1	\N	11
13	test3groupstore2	6	\N	f	\N	3	\N	11
17	store1user1	10	\N	f	\N	1	\N	\N
18	teststore10	10	\N	f	\N	1	\N	\N
19	MinskNeighborA-store1	11	\N	f	\N	1	\N	\N
20	MinskNeighborB-store1	12	\N	f	\N	1	\N	\N
21	Bel-Min-Min2-Dist1-Store1	13	\N	f	\N	1	\N	\N
22	Bel-Min-Min2-Dist1-Store2	13	\N	f	\N	1	\N	\N
24	Bel-Min-Min2-Dist2-Store2	14	\N	\N	\N	1	\N	\N
23	Bel-Min-Min2-Dist2-Store1	14	\N	\N	\N	1	\N	\N
\.


--
-- Data for Name: user_admin; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.user_admin (id, user_id, shopping_group_id, unixtime_added, removed, time_removed) FROM stdin;
1	1	1	1	\N	\N
2	1	7	1664708406	\N	\N
3	1	8	1664708426	\N	\N
4	1	9	1664708521	f	\N
5	1	10	1664709884	f	\N
6	1	11	1664714384	f	\N
7	1	12	1664716405	f	\N
8	1	13	1668425867	f	\N
9	1	14	1668425974	f	\N
\.


--
-- Data for Name: user_group; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.user_group (id, user_id, shopping_group_id, unixtime_added, removed, unixtime_removed, user_id_that_removed, time_removed) FROM stdin;
2	1	10	1664709884	t	\N	\N	\N
1	1	9	1664708521	t	\N	\N	\N
4	1	12	1664716405	f	\N	\N	\N
3	1	11	1664714384	f	\N	\N	\N
5	2	11	1665259924	t	\N	\N	\N
6	2	11	1665260263	f	\N	\N	\N
9	1	13	1668425867	t	\N	\N	\N
10	1	14	1668425974	t	\N	\N	\N
7	3	11	1665922480	t	\N	\N	\N
8	3	11	1665932714	t	\N	\N	\N
\.


--
-- Data for Name: user_group_toggle; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.user_group_toggle (id, user_id, created_on, user_group_id) FROM stdin;
1	1	1664717384	2
2	1	1664717385	4
3	1	1664717386	3
4	1	1664720057	4
5	1	1664720074	3
6	1	1664720545	0
7	1	1664721430	3
8	1	1664721463	0
9	1	1664721469	3
10	1	1664721797	3
11	1	1664722690	3
12	1	1664722725	4
13	1	1664722729	3
14	1	1664722734	0
15	1	1665239318	4
16	1	1665239323	3
17	1	1665239328	0
18	2	1665260560	6
19	2	1665260622	0
20	1	1665919022	3
21	3	1665922515	7
22	3	1665922546	0
23	1	1665922747	0
24	1	1665924168	3
25	3	1665932949	8
26	1	1665933339	0
27	1	1665934195	3
28	1	1665934222	0
29	1	1665934229	0
30	1	1665934655	3
31	1	1666533370	0
32	1	1666533383	3
33	1	1666533389	0
34	1	1666533398	3
35	1	1666533405	0
36	2	1666533466	6
37	1	1666533505	3
38	1	1666533512	0
39	2	1666533522	0
40	1	1666533583	4
41	1	1666533588	0
42	1	1666534168	3
43	1	1666534203	4
44	1	1666534424	0
45	1	1666534737	0
46	1	1666534744	3
47	1	1666534753	0
48	1	1666535100	0
49	1	1666535107	3
50	1	1666535246	0
51	1	1666535273	3
52	1	1666539189	0
53	1	1666539198	3
54	1	1666539595	3
55	1	1666539597	0
56	1	1666539608	3
57	1	1666539749	0
58	1	1666539915	4
59	1	1666539947	3
60	1	1666540133	4
61	1	1666540161	3
62	1	1666542379	0
63	1	1666542394	3
64	1	1666542447	0
65	1	1666545592	0
66	2	1667311871	6
67	2	1667311881	0
68	2	1667311901	6
69	2	1667312102	0
70	2	1667312113	6
71	2	1667312241	0
72	1	1667576255	3
73	1	1667576273	4
74	1	1667643777	3
75	1	1667645896	4
76	1	1667647563	4
77	1	1667647567	3
78	1	1667647583	4
79	1	1667647660	4
80	1	1667647761	3
81	1	1667647764	0
82	1	1667647766	4
83	1	1667653857	4
84	1	1667653925	4
85	1	1667653935	3
86	1	1667653938	4
87	1	1667654247	4
88	1	1667654248	3
89	1	1667654277	4
90	1	1667654893	3
91	1	1667654994	3
92	1	1667655099	3
93	1	1667655203	3
94	1	1667655240	3
95	1	1667655260	4
96	1	1667655402	4
97	1	1667655414	3
98	1	1667655816	3
99	1	1667655818	3
100	1	1667655842	3
101	1	1667655844	4
102	1	1667655850	3
103	1	1667655852	4
104	1	1667655937	3
105	1	1667655943	4
106	1	1667655951	3
107	1	1667655963	4
108	1	1667655970	0
109	1	1667655980	4
110	1	1667656034	4
111	1	1667656043	4
112	1	1667656052	3
113	1	1667656055	4
114	1	1667656135	4
115	1	1667656237	4
116	1	1667656241	3
117	1	1667656252	0
118	1	1667656270	3
119	1	1667657330	4
120	1	1667657337	3
121	1	1667657384	4
122	1	1667657388	0
123	1	1667657453	0
124	1	1667657456	4
125	1	1667657458	3
126	1	1667657461	0
127	1	1667657753	3
128	1	1667657756	4
129	1	1667657761	3
130	1	1667658651	4
131	1	1667658658	0
132	1	1668255681	3
133	1	1668255689	0
134	1	1668259658	3
135	1	1668259719	0
136	1	1668268029	3
137	1	1668268034	0
138	1	1668268034	0
139	1	1668268057	3
140	1	1668268059	0
141	1	1668268329	3
142	1	1668268332	0
143	1	1668268761	3
144	1	1668268764	0
145	1	1668425833	3
146	1	1668425919	4
147	1	1668426027	0
148	1	1668426529	3
149	1	1668426532	0
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: abyrondeans
--

COPY public.users (id, username, password, created_on) FROM stdin;
1	abdeans	a	1663418506
2	abdeans2	a	1663418554
3	abdeans3	a	1663418613
4	abdeans4	a	1663418641
5	abdeans5	a	1663418948
6	abdeans6	a	1663418971
10	abdeans10	a	1663419376
11	abdeans11	a	1663420075
12	abdeans12	a	1663423211
\.


--
-- Name: city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.city_id_seq', 14, true);


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.country_id_seq', 16, true);


--
-- Name: district_choice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.district_choice_id_seq', 103, true);


--
-- Name: district_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.district_id_seq', 14, true);


--
-- Name: invite_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.invite_links_id_seq', 14, true);


--
-- Name: price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.price_id_seq', 100, true);


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.product_id_seq', 93, true);


--
-- Name: product_store_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.product_store_id_seq', 77, true);


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.region_id_seq', 22, true);


--
-- Name: shopping_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.shopping_group_id_seq', 14, true);


--
-- Name: store_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.store_id_seq', 24, true);


--
-- Name: user_admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.user_admin_id_seq', 9, true);


--
-- Name: user_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.user_group_id_seq', 10, true);


--
-- Name: user_group_toggle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.user_group_toggle_id_seq', 149, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abyrondeans
--

SELECT pg_catalog.setval('public.users_id_seq', 12, true);


--
-- Name: city city_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.city
    ADD CONSTRAINT city_pkey PRIMARY KEY (id);


--
-- Name: country country_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: district_choice district_choice_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.district_choice
    ADD CONSTRAINT district_choice_pkey PRIMARY KEY (id);


--
-- Name: district district_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.district
    ADD CONSTRAINT district_pkey PRIMARY KEY (id);


--
-- Name: invite_links invite_links_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.invite_links
    ADD CONSTRAINT invite_links_pkey PRIMARY KEY (id);


--
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (id);


--
-- Name: product product_name_key; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_name_key UNIQUE (name);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: product_store product_store_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.product_store
    ADD CONSTRAINT product_store_pkey PRIMARY KEY (id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: shopping_group shopping_group_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.shopping_group
    ADD CONSTRAINT shopping_group_pkey PRIMARY KEY (id);


--
-- Name: store store_name_key; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_name_key UNIQUE (name);


--
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- Name: user_admin user_admin_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.user_admin
    ADD CONSTRAINT user_admin_pkey PRIMARY KEY (id);


--
-- Name: user_group user_group_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.user_group
    ADD CONSTRAINT user_group_pkey PRIMARY KEY (id);


--
-- Name: user_group_toggle user_group_toggle_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.user_group_toggle
    ADD CONSTRAINT user_group_toggle_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: abyrondeans
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- PostgreSQL database dump complete
--

