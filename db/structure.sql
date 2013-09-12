--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    resource_id character varying(255) NOT NULL,
    resource_type character varying(255) NOT NULL,
    author_id integer,
    author_type character varying(255),
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    namespace character varying(255)
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    address_line_1 character varying(255),
    address_line_2 character varying(255),
    city character varying(255),
    state character varying(255),
    postal_code character varying(255),
    addressable_type character varying(255),
    addressable_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    country character varying(255)
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: booking_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE booking_logs (
    id integer NOT NULL,
    state character varying(255),
    booking_id integer,
    updated_by_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: booking_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE booking_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: booking_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE booking_logs_id_seq OWNED BY booking_logs.id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bookings (
    id integer NOT NULL,
    renter_id integer,
    tool_id integer,
    price money DEFAULT 0.0,
    deadline date,
    sample_description text,
    state character varying(255),
    tos_accepted boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sample_deliverable text,
    sample_transit character varying(255),
    last_updated_by_id integer,
    address_id integer,
    sample_disposal character varying(255),
    disposal_instructions text,
    currency character varying(3),
    shipping_package_size character varying(255),
    shipping_price money DEFAULT 0.0,
    rareshare_fee money DEFAULT 0.0,
    shipping_weight numeric,
    shipping_service character varying(255),
    samples integer
);


--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bookings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bookings_id_seq OWNED BY bookings.id;


--
-- Name: executed_searches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE executed_searches (
    id integer NOT NULL,
    user_id integer,
    search_params hstore,
    results_count integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: executed_searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE executed_searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: executed_searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE executed_searches_id_seq OWNED BY executed_searches.id;


--
-- Name: facilities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE facilities (
    id integer NOT NULL,
    user_id integer,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: facilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE facilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE facilities_id_seq OWNED BY facilities.id;


--
-- Name: file_attachments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE file_attachments (
    id integer NOT NULL,
    "position" integer NOT NULL,
    attachable_id integer NOT NULL,
    attachable_type character varying(255) NOT NULL,
    file_id integer NOT NULL,
    category character varying(255)
);


--
-- Name: file_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE file_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: file_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE file_attachments_id_seq OWNED BY file_attachments.id;


--
-- Name: files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE files (
    id integer NOT NULL,
    name character varying(255),
    size integer,
    content_type character varying(255),
    url character varying(255),
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE files_id_seq OWNED BY files.id;


--
-- Name: helpers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE helpers (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    zip character varying(255),
    phone character varying(255),
    blog character varying(255),
    listserv character varying(255),
    twitter character varying(255),
    groups text,
    other text,
    memories text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: helpers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE helpers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: helpers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE helpers_id_seq OWNED BY helpers.id;


--
-- Name: manufacturers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE manufacturers (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: manufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE manufacturers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: manufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE manufacturers_id_seq OWNED BY manufacturers.id;


--
-- Name: models; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE models (
    id integer NOT NULL,
    name character varying(255),
    manufacturer_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: models_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE models_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: models_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE models_id_seq OWNED BY models.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifications (
    id integer NOT NULL,
    user_id integer,
    notifiable_id integer,
    notifiable_type character varying(255),
    seen_at timestamp without time zone,
    properties hstore,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    title character varying(255),
    slug character varying(255),
    content text
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: requested_searches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE requested_searches (
    id integer NOT NULL,
    request text,
    user_id integer
);


--
-- Name: requested_searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE requested_searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: requested_searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE requested_searches_id_seq OWNED BY requested_searches.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: skills; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skills (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skills_id_seq OWNED BY skills.id;


--
-- Name: skills_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skills_users (
    id integer NOT NULL,
    user_id integer,
    skill_id integer
);


--
-- Name: skills_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skills_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skills_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skills_users_id_seq OWNED BY skills_users.id;


--
-- Name: tool_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tool_categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tool_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tool_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tool_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tool_categories_id_seq OWNED BY tool_categories.id;


--
-- Name: tools; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tools (
    id integer NOT NULL,
    owner_id integer,
    model_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description text,
    manufacturer_id integer,
    sample_size_min integer,
    sample_size_max integer,
    year_manufactured integer,
    serial_number character varying(255),
    tool_category_id integer,
    base_lead_time integer,
    base_price money,
    can_expedite boolean,
    expedited_lead_time integer,
    expedited_price money,
    document text,
    latitude double precision,
    longitude double precision,
    resolution integer,
    currency character varying(3),
    facility_id integer,
    samples_per_run integer DEFAULT 1,
    bulk_runs integer,
    can_bulkify boolean DEFAULT false,
    sample_size_unit_id integer,
    resolution_unit_id integer,
    calibrated boolean,
    last_calibrated_at timestamp without time zone,
    condition character varying(255),
    condition_notes text,
    has_resolution boolean,
    access_type character varying(255),
    access_type_notes text
);


--
-- Name: tools_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tools_id_seq OWNED BY tools.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transactions (
    id integer NOT NULL,
    booking_id integer NOT NULL,
    amount money NOT NULL,
    customer_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


--
-- Name: units; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE units (
    id integer NOT NULL,
    name character varying(255),
    label character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE units_id_seq OWNED BY units.id;


--
-- Name: user_messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_messages (
    id integer NOT NULL,
    sender_id integer,
    receiver_id integer,
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    originating_message_id integer,
    messageable_id integer,
    messageable_type character varying(255)
);


--
-- Name: user_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_messages_id_seq OWNED BY user_messages.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    provider character varying(255),
    uid character varying(255),
    image_url character varying(255),
    linkedin_profile_url character varying(255),
    title character varying(255),
    organization character varying(255),
    education character varying(255),
    bio text,
    primary_phone character varying(255),
    secondary_phone character varying(255),
    qualifications text,
    tools_count integer DEFAULT 0,
    avatar character varying(255),
    admin boolean,
    tos_accepted boolean DEFAULT false,
    can_email_news boolean DEFAULT true,
    can_email_status boolean DEFAULT true
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY booking_logs ALTER COLUMN id SET DEFAULT nextval('booking_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bookings ALTER COLUMN id SET DEFAULT nextval('bookings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY executed_searches ALTER COLUMN id SET DEFAULT nextval('executed_searches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY facilities ALTER COLUMN id SET DEFAULT nextval('facilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY file_attachments ALTER COLUMN id SET DEFAULT nextval('file_attachments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY files ALTER COLUMN id SET DEFAULT nextval('files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY helpers ALTER COLUMN id SET DEFAULT nextval('helpers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY manufacturers ALTER COLUMN id SET DEFAULT nextval('manufacturers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY models ALTER COLUMN id SET DEFAULT nextval('models_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY requested_searches ALTER COLUMN id SET DEFAULT nextval('requested_searches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skills ALTER COLUMN id SET DEFAULT nextval('skills_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skills_users ALTER COLUMN id SET DEFAULT nextval('skills_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tool_categories ALTER COLUMN id SET DEFAULT nextval('tool_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tools ALTER COLUMN id SET DEFAULT nextval('tools_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY units ALTER COLUMN id SET DEFAULT nextval('units_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_messages ALTER COLUMN id SET DEFAULT nextval('user_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admin_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT admin_notes_pkey PRIMARY KEY (id);


--
-- Name: booking_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY booking_logs
    ADD CONSTRAINT booking_logs_pkey PRIMARY KEY (id);


--
-- Name: bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: executed_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY executed_searches
    ADD CONSTRAINT executed_searches_pkey PRIMARY KEY (id);


--
-- Name: facilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY facilities
    ADD CONSTRAINT facilities_pkey PRIMARY KEY (id);


--
-- Name: file_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY file_attachments
    ADD CONSTRAINT file_attachments_pkey PRIMARY KEY (id);


--
-- Name: files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: helpers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY helpers
    ADD CONSTRAINT helpers_pkey PRIMARY KEY (id);


--
-- Name: manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (id);


--
-- Name: models_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY models
    ADD CONSTRAINT models_pkey PRIMARY KEY (id);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: requested_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY requested_searches
    ADD CONSTRAINT requested_searches_pkey PRIMARY KEY (id);


--
-- Name: skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- Name: skills_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skills_users
    ADD CONSTRAINT skills_users_pkey PRIMARY KEY (id);


--
-- Name: tool_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tool_categories
    ADD CONSTRAINT tool_categories_pkey PRIMARY KEY (id);


--
-- Name: tools_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (id);


--
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: units_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: user_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_messages
    ADD CONSTRAINT user_messages_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_admin_notes_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_admin_notes_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_bookings_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bookings_on_state ON bookings USING btree (state);


--
-- Name: index_file_attachments_for_uniqueness; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_file_attachments_for_uniqueness ON file_attachments USING btree (file_id, attachable_id, attachable_type, category);


--
-- Name: index_file_attachments_on_attachable_type_and_attachable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_file_attachments_on_attachable_type_and_attachable_id ON file_attachments USING btree (attachable_type, attachable_id);


--
-- Name: index_notifications_on_notifiable_id_and_notifiable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_notifiable_id_and_notifiable_type ON notifications USING btree (notifiable_id, notifiable_type);


--
-- Name: index_notifications_on_user_id_and_seen_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_user_id_and_seen_at ON notifications USING btree (user_id, seen_at);


--
-- Name: index_user_messages_on_messageable_id_and_messageable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_messages_on_messageable_id_and_messageable_type ON user_messages USING btree (messageable_id, messageable_type);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: tools_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX tools_to_tsvector_idx ON tools USING gin (to_tsvector('english'::regconfig, document));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20121112004616');

INSERT INTO schema_migrations (version) VALUES ('20121114130555');

INSERT INTO schema_migrations (version) VALUES ('20121118175903');

INSERT INTO schema_migrations (version) VALUES ('20121118182604');

INSERT INTO schema_migrations (version) VALUES ('20121125012323');

INSERT INTO schema_migrations (version) VALUES ('20121125165843');

INSERT INTO schema_migrations (version) VALUES ('20121125192732');

INSERT INTO schema_migrations (version) VALUES ('20121125230232');

INSERT INTO schema_migrations (version) VALUES ('20121125230945');

INSERT INTO schema_migrations (version) VALUES ('20121125232133');

INSERT INTO schema_migrations (version) VALUES ('20121126063316');

INSERT INTO schema_migrations (version) VALUES ('20121127112816');

INSERT INTO schema_migrations (version) VALUES ('20121128035215');

INSERT INTO schema_migrations (version) VALUES ('20121202203824');

INSERT INTO schema_migrations (version) VALUES ('20121209200927');

INSERT INTO schema_migrations (version) VALUES ('20130106164258');

INSERT INTO schema_migrations (version) VALUES ('20130106214054');

INSERT INTO schema_migrations (version) VALUES ('20130118235802');

INSERT INTO schema_migrations (version) VALUES ('20130119175020');

INSERT INTO schema_migrations (version) VALUES ('20130119175738');

INSERT INTO schema_migrations (version) VALUES ('20130203181207');

INSERT INTO schema_migrations (version) VALUES ('20130217190244');

INSERT INTO schema_migrations (version) VALUES ('20130217193236');

INSERT INTO schema_migrations (version) VALUES ('20130224172736');

INSERT INTO schema_migrations (version) VALUES ('20130316191418');

INSERT INTO schema_migrations (version) VALUES ('20130324181552');

INSERT INTO schema_migrations (version) VALUES ('20130327170745');

INSERT INTO schema_migrations (version) VALUES ('20130427214948');

INSERT INTO schema_migrations (version) VALUES ('20130427223349');

INSERT INTO schema_migrations (version) VALUES ('20130427223350');

INSERT INTO schema_migrations (version) VALUES ('20130427224150');

INSERT INTO schema_migrations (version) VALUES ('20130502162021');

INSERT INTO schema_migrations (version) VALUES ('20130502162226');

INSERT INTO schema_migrations (version) VALUES ('20130508003345');

INSERT INTO schema_migrations (version) VALUES ('20130508144328');

INSERT INTO schema_migrations (version) VALUES ('20130508171938');

INSERT INTO schema_migrations (version) VALUES ('20130508184828');

INSERT INTO schema_migrations (version) VALUES ('20130519190419');

INSERT INTO schema_migrations (version) VALUES ('20130530154949');

INSERT INTO schema_migrations (version) VALUES ('20130530155005');

INSERT INTO schema_migrations (version) VALUES ('20130531193415');

INSERT INTO schema_migrations (version) VALUES ('20130531221848');

INSERT INTO schema_migrations (version) VALUES ('20130603150348');

INSERT INTO schema_migrations (version) VALUES ('20130624024414');

INSERT INTO schema_migrations (version) VALUES ('20130624140350');

INSERT INTO schema_migrations (version) VALUES ('20130626035938');

INSERT INTO schema_migrations (version) VALUES ('20130716131949');

INSERT INTO schema_migrations (version) VALUES ('20130718193029');

INSERT INTO schema_migrations (version) VALUES ('20130727142033');

INSERT INTO schema_migrations (version) VALUES ('20130728164032');

INSERT INTO schema_migrations (version) VALUES ('20130728221705');

INSERT INTO schema_migrations (version) VALUES ('20130729125543');

INSERT INTO schema_migrations (version) VALUES ('20130730033828');

INSERT INTO schema_migrations (version) VALUES ('20130809155039');

INSERT INTO schema_migrations (version) VALUES ('20130810233337');

INSERT INTO schema_migrations (version) VALUES ('20130811163617');

INSERT INTO schema_migrations (version) VALUES ('20130826192156');

INSERT INTO schema_migrations (version) VALUES ('20130901050515');

INSERT INTO schema_migrations (version) VALUES ('20130901171248');

INSERT INTO schema_migrations (version) VALUES ('20130910123306');

INSERT INTO schema_migrations (version) VALUES ('20130910135749');

INSERT INTO schema_migrations (version) VALUES ('20130911124052');

INSERT INTO schema_migrations (version) VALUES ('20130911134559');

INSERT INTO schema_migrations (version) VALUES ('20130912043152');

INSERT INTO schema_migrations (version) VALUES ('20130912152223');

INSERT INTO schema_migrations (version) VALUES ('20130912173527');
