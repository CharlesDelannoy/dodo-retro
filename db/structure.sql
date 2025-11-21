\restrict MJOctaL2wf36Xga0WltqavT5eauG3Sj92iWT0LkiVda9wUDnYYonhUHDcijxdmD

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: ice_breaker_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ice_breaker_questions (
    id bigint NOT NULL,
    content text NOT NULL,
    question_type character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: ice_breaker_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ice_breaker_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ice_breaker_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ice_breaker_questions_id_seq OWNED BY public.ice_breaker_questions.id;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.participants (
    id bigint NOT NULL,
    team_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.participants_id_seq OWNED BY public.participants.id;


--
-- Name: pending_invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pending_invitations (
    id bigint NOT NULL,
    team_id bigint NOT NULL,
    email character varying NOT NULL,
    inviter_id bigint NOT NULL,
    status character varying DEFAULT 'pending'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: pending_invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pending_invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pending_invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pending_invitations_id_seq OWNED BY public.pending_invitations.id;


--
-- Name: retrospective_columns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.retrospective_columns (
    id bigint NOT NULL,
    retrospective_type_id bigint NOT NULL,
    name character varying NOT NULL,
    color character varying,
    "position" integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: retrospective_columns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.retrospective_columns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: retrospective_columns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.retrospective_columns_id_seq OWNED BY public.retrospective_columns.id;


--
-- Name: retrospective_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.retrospective_types (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: retrospective_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.retrospective_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: retrospective_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.retrospective_types_id_seq OWNED BY public.retrospective_types.id;


--
-- Name: retrospectives; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.retrospectives (
    id bigint NOT NULL,
    team_id bigint NOT NULL,
    creator_id bigint NOT NULL,
    retrospective_type_id bigint NOT NULL,
    title character varying NOT NULL,
    current_step character varying DEFAULT 'ice_breaker'::character varying NOT NULL,
    current_revealing_user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    current_ice_breaker_question_id bigint
);


--
-- Name: retrospectives_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.retrospectives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: retrospectives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.retrospectives_id_seq OWNED BY public.retrospectives.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    ip_address character varying,
    user_agent character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: solid_cable_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_cable_messages (
    id bigint NOT NULL,
    channel bytea NOT NULL,
    payload bytea NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    channel_hash bigint NOT NULL
);


--
-- Name: solid_cable_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_cable_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_cable_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_cable_messages_id_seq OWNED BY public.solid_cable_messages.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teams (
    id bigint NOT NULL,
    name character varying,
    creator_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: ticket_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ticket_groups (
    id bigint NOT NULL,
    retrospective_id bigint NOT NULL,
    title character varying,
    created_by_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: ticket_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ticket_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ticket_groups_id_seq OWNED BY public.ticket_groups.id;


--
-- Name: tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tickets (
    id bigint NOT NULL,
    retrospective_id bigint NOT NULL,
    retrospective_column_id bigint NOT NULL,
    author_id bigint NOT NULL,
    content text NOT NULL,
    "position" integer DEFAULT 0,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    is_revealed boolean DEFAULT false NOT NULL,
    ticket_group_id bigint
);


--
-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tickets_id_seq OWNED BY public.tickets.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email_address character varying NOT NULL,
    password_digest character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    username character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: ice_breaker_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ice_breaker_questions ALTER COLUMN id SET DEFAULT nextval('public.ice_breaker_questions_id_seq'::regclass);


--
-- Name: participants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants ALTER COLUMN id SET DEFAULT nextval('public.participants_id_seq'::regclass);


--
-- Name: pending_invitations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pending_invitations ALTER COLUMN id SET DEFAULT nextval('public.pending_invitations_id_seq'::regclass);


--
-- Name: retrospective_columns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retrospective_columns ALTER COLUMN id SET DEFAULT nextval('public.retrospective_columns_id_seq'::regclass);


--
-- Name: retrospective_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retrospective_types ALTER COLUMN id SET DEFAULT nextval('public.retrospective_types_id_seq'::regclass);


--
-- Name: retrospectives id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retrospectives ALTER COLUMN id SET DEFAULT nextval('public.retrospectives_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: solid_cable_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_cable_messages ALTER COLUMN id SET DEFAULT nextval('public.solid_cable_messages_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: ticket_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket_groups ALTER COLUMN id SET DEFAULT nextval('public.ticket_groups_id_seq'::regclass);


--
-- Name: tickets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets ALTER COLUMN id SET DEFAULT nextval('public.tickets_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: ice_breaker_questions ice_breaker_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ice_breaker_questions
    ADD CONSTRAINT ice_breaker_questions_pkey PRIMARY KEY (id);


--
-- Name: participants participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (id);


--
-- Name: pending_invitations pending_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pending_invitations
    ADD CONSTRAINT pending_invitations_pkey PRIMARY KEY (id);


--
-- Name: retrospective_columns retrospective_columns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retrospective_columns
    ADD CONSTRAINT retrospective_columns_pkey PRIMARY KEY (id);


--
-- Name: retrospective_types retrospective_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retrospective_types
    ADD CONSTRAINT retrospective_types_pkey PRIMARY KEY (id);


--
-- Name: retrospectives retrospectives_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retrospectives
    ADD CONSTRAINT retrospectives_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: solid_cable_messages solid_cable_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_cable_messages
    ADD CONSTRAINT solid_cable_messages_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: ticket_groups ticket_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket_groups
    ADD CONSTRAINT ticket_groups_pkey PRIMARY KEY (id);


--
-- Name: tickets tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_participants_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participants_on_team_id ON public.participants USING btree (team_id);


--
-- Name: index_participants_on_team_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_participants_on_team_id_and_user_id ON public.participants USING btree (team_id, user_id);


--
-- Name: index_participants_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participants_on_user_id ON public.participants USING btree (user_id);


--
-- Name: index_pending_invitations_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pending_invitations_on_email ON public.pending_invitations USING btree (email);


--
-- Name: index_pending_invitations_on_inviter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pending_invitations_on_inviter_id ON public.pending_invitations USING btree (inviter_id);


--
-- Name: index_pending_invitations_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pending_invitations_on_team_id ON public.pending_invitations USING btree (team_id);


--
-- Name: index_pending_invitations_on_team_id_and_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pending_invitations_on_team_id_and_email ON public.pending_invitations USING btree (team_id, email);


--
-- Name: index_retrospective_columns_on_retrospective_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_retrospective_columns_on_retrospective_type_id ON public.retrospective_columns USING btree (retrospective_type_id);


--
-- Name: index_retrospectives_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_retrospectives_on_creator_id ON public.retrospectives USING btree (creator_id);


--
-- Name: index_retrospectives_on_current_ice_breaker_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_retrospectives_on_current_ice_breaker_question_id ON public.retrospectives USING btree (current_ice_breaker_question_id);


--
-- Name: index_retrospectives_on_current_revealing_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_retrospectives_on_current_revealing_user_id ON public.retrospectives USING btree (current_revealing_user_id);


--
-- Name: index_retrospectives_on_retrospective_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_retrospectives_on_retrospective_type_id ON public.retrospectives USING btree (retrospective_type_id);


--
-- Name: index_retrospectives_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_retrospectives_on_team_id ON public.retrospectives USING btree (team_id);


--
-- Name: index_sessions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_user_id ON public.sessions USING btree (user_id);


--
-- Name: index_solid_cable_messages_on_channel; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_cable_messages_on_channel ON public.solid_cable_messages USING btree (channel);


--
-- Name: index_solid_cable_messages_on_channel_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_cable_messages_on_channel_hash ON public.solid_cable_messages USING btree (channel_hash);


--
-- Name: index_solid_cable_messages_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_cable_messages_on_created_at ON public.solid_cable_messages USING btree (created_at);


--
-- Name: index_teams_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_teams_on_creator_id ON public.teams USING btree (creator_id);


--
-- Name: index_ticket_groups_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ticket_groups_on_created_by_id ON public.ticket_groups USING btree (created_by_id);


--
-- Name: index_ticket_groups_on_retrospective_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ticket_groups_on_retrospective_id ON public.ticket_groups USING btree (retrospective_id);


--
-- Name: index_tickets_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tickets_on_author_id ON public.tickets USING btree (author_id);


--
-- Name: index_tickets_on_retrospective_column_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tickets_on_retrospective_column_id ON public.tickets USING btree (retrospective_column_id);


--
-- Name: index_tickets_on_retrospective_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tickets_on_retrospective_id ON public.tickets USING btree (retrospective_id);


--
-- Name: index_tickets_on_retrospective_id_and_is_revealed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tickets_on_retrospective_id_and_is_revealed ON public.tickets USING btree (retrospective_id, is_revealed);


--
-- Name: index_tickets_on_retrospective_id_and_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tickets_on_retrospective_id_and_position ON public.tickets USING btree (retrospective_id, "position");


--
-- Name: index_tickets_on_ticket_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tickets_on_ticket_group_id ON public.tickets USING btree (ticket_group_id);


--
-- Name: index_users_on_email_address; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email_address ON public.users USING btree (email_address);


--
-- Name: retrospective_columns fk_rails_470b40e078; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retrospective_columns
    ADD CONSTRAINT fk_rails_470b40e078 FOREIGN KEY (retrospective_type_id) REFERENCES public.retrospective_types(id);


--
-- Name: tickets fk_rails_4cf276e8fa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT fk_rails_4cf276e8fa FOREIGN KEY (retrospective_id) REFERENCES public.retrospectives(id);


--
-- Name: retrospectives fk_rails_4f82817a85; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retrospectives
    ADD CONSTRAINT fk_rails_4f82817a85 FOREIGN KEY (current_ice_breaker_question_id) REFERENCES public.ice_breaker_questions(id);


--
-- Name: sessions fk_rails_758836b4f0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT fk_rails_758836b4f0 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: tickets fk_rails_762b54b80b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT fk_rails_762b54b80b FOREIGN KEY (author_id) REFERENCES public.users(id);


--
-- Name: teams fk_rails_7ecf94116f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT fk_rails_7ecf94116f FOREIGN KEY (creator_id) REFERENCES public.users(id);


--
-- Name: retrospectives fk_rails_8a15682056; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retrospectives
    ADD CONSTRAINT fk_rails_8a15682056 FOREIGN KEY (retrospective_type_id) REFERENCES public.retrospective_types(id);


--
-- Name: retrospectives fk_rails_8f3ace5cb5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retrospectives
    ADD CONSTRAINT fk_rails_8f3ace5cb5 FOREIGN KEY (current_revealing_user_id) REFERENCES public.users(id);


--
-- Name: retrospectives fk_rails_90feebef67; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retrospectives
    ADD CONSTRAINT fk_rails_90feebef67 FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: tickets fk_rails_97f11fc876; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT fk_rails_97f11fc876 FOREIGN KEY (retrospective_column_id) REFERENCES public.retrospective_columns(id);


--
-- Name: participants fk_rails_990c37f108; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT fk_rails_990c37f108 FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: retrospectives fk_rails_a94d5f0657; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retrospectives
    ADD CONSTRAINT fk_rails_a94d5f0657 FOREIGN KEY (creator_id) REFERENCES public.users(id);


--
-- Name: participants fk_rails_b9a3c50f15; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT fk_rails_b9a3c50f15 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: pending_invitations fk_rails_cbe9e90e83; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pending_invitations
    ADD CONSTRAINT fk_rails_cbe9e90e83 FOREIGN KEY (inviter_id) REFERENCES public.users(id);


--
-- Name: ticket_groups fk_rails_cf0c9951a9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket_groups
    ADD CONSTRAINT fk_rails_cf0c9951a9 FOREIGN KEY (retrospective_id) REFERENCES public.retrospectives(id);


--
-- Name: ticket_groups fk_rails_d44b715483; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket_groups
    ADD CONSTRAINT fk_rails_d44b715483 FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: pending_invitations fk_rails_f1293202b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pending_invitations
    ADD CONSTRAINT fk_rails_f1293202b5 FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: tickets fk_rails_ffc1c7d483; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT fk_rails_ffc1c7d483 FOREIGN KEY (ticket_group_id) REFERENCES public.ticket_groups(id);


--
-- PostgreSQL database dump complete
--

\unrestrict MJOctaL2wf36Xga0WltqavT5eauG3Sj92iWT0LkiVda9wUDnYYonhUHDcijxdmD

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20251121155938'),
('20251121095435'),
('20251121095353'),
('20251121095311'),
('20251120163540'),
('20251120105918'),
('20251120104357'),
('20251120104014'),
('20251120103938'),
('20251120100220'),
('20251120100219'),
('20251120100217'),
('20251008071011'),
('20250914212001'),
('20250914211949'),
('20250914140005'),
('20250914122748'),
('20250914122747');

