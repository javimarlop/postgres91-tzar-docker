--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: constants; Type: TABLE; Schema: public; Owner: tzar; Tablespace: 
--

CREATE TABLE constants (
    db_version character varying(16) NOT NULL
);


ALTER TABLE public.constants OWNER TO tzar;

--
-- Name: libraries; Type: TABLE; Schema: public; Owner: tzar; Tablespace: 
--

CREATE TABLE libraries (
    library_id integer NOT NULL,
    repo_type character varying(16) NOT NULL,
    uri text NOT NULL,
    name text NOT NULL,
    revision character varying(16) NOT NULL,
    download_mode boolean NOT NULL
);
CREATE UNIQUE INDEX libraries_repo_type_key ON libraries ( repo_type, uri, name, revision, download_mode );

ALTER TABLE public.libraries OWNER TO tzar;

--
-- Name: libraries_library_id_seq; Type: SEQUENCE; Schema: public; Owner: tzar
--

CREATE SEQUENCE libraries_library_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.libraries_library_id_seq OWNER TO tzar;

--
-- Name: libraries_library_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tzar
--

ALTER SEQUENCE libraries_library_id_seq OWNED BY libraries.library_id;

--
-- Name: run_libraries; Type: TABLE; Schema: public; Owner: tzar; Tablespace: 
--

CREATE TABLE run_libraries (
    id bigserial NOT NULL,
    run_id integer,
    library_id integer
);


ALTER TABLE public.run_libraries OWNER TO tzar;

--
-- Name: run_params; Type: TABLE; Schema: public; Owner: tzar; Tablespace: 
--

CREATE TABLE run_params (
    run_param_id integer NOT NULL,
    run_id integer,
    param_name text,
    param_value text,
    param_type text,
    data_type text NOT NULL
);


ALTER TABLE public.run_params OWNER TO tzar;

--
-- Name: run_params_run_param_id_seq; Type: SEQUENCE; Schema: public; Owner: tzar
--

CREATE SEQUENCE run_params_run_param_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.run_params_run_param_id_seq OWNER TO tzar;

--
-- Name: run_params_run_param_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tzar
--

ALTER SEQUENCE run_params_run_param_id_seq OWNED BY run_params.run_param_id;


--
-- Name: runs; Type: TABLE; Schema: public; Owner: tzar; Tablespace: 
--

CREATE TABLE runs (
    run_id integer NOT NULL,
    project_name text NOT NULL,
    scenario_name text NOT NULL,
    state text NOT NULL,
    seed integer,
    model_revision text NOT NULL,
    hostname text,
    output_path text,
    output_host text,
    run_start_time timestamp without time zone,
    run_end_time timestamp without time zone,
    runset text,
    cluster_name text,
    runner_class text,
    run_submission_time timestamp without time zone DEFAULT timezone('utc'::text, now()),
    model_url text NOT NULL,
    model_repo_type character varying(16) NOT NULL,
    runner_flags text NOT NULL,
    host_ip text
);


ALTER TABLE public.runs OWNER TO tzar;

--
-- Name: COLUMN runs.model_revision; Type: COMMENT; Schema: public; Owner: tzar
--

COMMENT ON COLUMN runs.model_revision IS 'The subversion revision number of the code used to execute the run.';


--
-- Name: COLUMN runs.run_start_time; Type: COMMENT; Schema: public; Owner: tzar
--

COMMENT ON COLUMN runs.run_start_time IS 'Time run began (UTC)';


--
-- Name: COLUMN runs.run_end_time; Type: COMMENT; Schema: public; Owner: tzar
--

COMMENT ON COLUMN runs.run_end_time IS 'Time run finished (UTC)';


--
-- Name: runs_run_id_seq; Type: SEQUENCE; Schema: public; Owner: tzar
--

CREATE SEQUENCE runs_run_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.runs_run_id_seq OWNER TO tzar;

--
-- Name: runs_run_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tzar
--

ALTER SEQUENCE runs_run_id_seq OWNED BY runs.run_id;


--
-- Name: library_id; Type: DEFAULT; Schema: public; Owner: tzar
--

ALTER TABLE ONLY libraries ALTER COLUMN library_id SET DEFAULT nextval('libraries_library_id_seq'::regclass);


--
-- Name: run_param_id; Type: DEFAULT; Schema: public; Owner: tzar
--

ALTER TABLE ONLY run_params ALTER COLUMN run_param_id SET DEFAULT nextval('run_params_run_param_id_seq'::regclass);


--
-- Name: run_id; Type: DEFAULT; Schema: public; Owner: tzar
--

ALTER TABLE ONLY runs ALTER COLUMN run_id SET DEFAULT nextval('runs_run_id_seq'::regclass);


--
-- Name: seed; Type: DEFAULT; Schema: public; Owner: tzar
--

ALTER TABLE ONLY runs ALTER COLUMN seed SET DEFAULT currval('runs_run_id_seq'::regclass);


--
-- Name: PK; Type: CONSTRAINT; Schema: public; Owner: tzar; Tablespace: 
--

ALTER TABLE ONLY runs
    ADD CONSTRAINT "PK" PRIMARY KEY (run_id);


--
-- Name: libraries_pkey; Type: CONSTRAINT; Schema: public; Owner: tzar; Tablespace: 
--

ALTER TABLE ONLY libraries
    ADD CONSTRAINT libraries_pkey PRIMARY KEY (library_id);


--
-- Name: run_params_pkey; Type: CONSTRAINT; Schema: public; Owner: tzar; Tablespace: 
--

ALTER TABLE ONLY run_params
    ADD CONSTRAINT run_params_pkey PRIMARY KEY (run_param_id);


--
-- Name: run_params_run_id_key; Type: CONSTRAINT; Schema: public; Owner: tzar; Tablespace: 
--

ALTER TABLE ONLY run_params
    ADD CONSTRAINT run_params_run_id_key UNIQUE (run_id, param_name);


--
-- Name: fki_run_id; Type: INDEX; Schema: public; Owner: tzar; Tablespace: 
--

CREATE INDEX fki_run_id ON run_params USING btree (run_id);


--
-- Name: fki_run_libraries_run_id_fk; Type: INDEX; Schema: public; Owner: tzar; Tablespace: 
--

CREATE INDEX fki_run_libraries_run_id_fk ON run_libraries USING btree (library_id);


--
-- Name: run_id; Type: FK CONSTRAINT; Schema: public; Owner: tzar
--

ALTER TABLE ONLY run_params
    ADD CONSTRAINT run_id FOREIGN KEY (run_id) REFERENCES runs(run_id) ON DELETE CASCADE;


--
-- Name: run_libraries_library_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tzar
--

ALTER TABLE ONLY run_libraries
    ADD CONSTRAINT run_libraries_library_id_fkey FOREIGN KEY (library_id) REFERENCES libraries(library_id)
    DEFERRABLE INITIALLY IMMEDIATE;


--
-- Name: run_libraries_run_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tzar
--

ALTER TABLE ONLY run_libraries
    ADD CONSTRAINT run_libraries_run_id_fkey FOREIGN KEY (run_id) REFERENCES runs(run_id)
    DEFERRABLE INITIALLY IMMEDIATE;


ALTER TABLE ONLY run_libraries ADD CONSTRAINT run_libraries_pkey PRIMARY KEY (id);


--
-- Name: public; Type: ACL; Schema: -; Owner: tzar
--

GRANT ALL ON SCHEMA public TO tzar;
GRANT ALL ON SCHEMA public TO PUBLIC;


insert into constants (db_version) values ('0.5.4');

-- View: lucy_runset_view

-- DROP VIEW lucy_runset_view;

CREATE OR REPLACE VIEW lucy_runset_view AS
 SELECT runs.runset, count(runs.run_id) AS num_runs,
    min(runs.run_submission_time) AS submission_time,
    max(runs.run_end_time) AS end_time,
    floor(date_part('epoch'::text, max(runs.run_end_time) - min(runs.run_submission_time))) AS seconds_duration,
    ( SELECT count(r.run_id) AS count
           FROM runs r
          WHERE runs.runset = r.runset AND r.state = 'failed'::text) AS failed,
    ( SELECT count(r.run_id) AS count
           FROM runs r
          WHERE runs.runset = r.runset AND r.state = 'scheduled'::text) AS scheduled,
    ( SELECT count(r.run_id) AS count
           FROM runs r
          WHERE runs.runset = r.runset AND r.state = 'in_progress'::text) AS in_progress,
    ( SELECT count(r.run_id) AS count
           FROM runs r
          WHERE runs.runset = r.runset AND r.state = 'completed'::text) AS completed,
    ( SELECT count(r.run_id) AS count
           FROM runs r
          WHERE runs.runset = r.runset AND r.state = 'copied'::text) AS copied,
    ( SELECT count(r.run_id) AS count
           FROM runs r
          WHERE runs.runset = r.runset AND r.state = 'copy_failed'::text) AS copy_failed
   FROM runs
  GROUP BY runs.runset
  ORDER BY min(runs.run_submission_time) DESC;

ALTER TABLE lucy_runset_view
  OWNER TO postgres;

--
-- PostgreSQL database dump complete
--

