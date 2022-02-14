--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

DROP DATABASE omnidocdb;




--
-- Drop roles
--

DROP ROLE postgres;
DROP ROLE user_db;


--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md590ef4c8692f1944263b9e08dc65370b9';
CREATE ROLE user_db;
ALTER ROLE user_db WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md53837ad5d2ced76c007bd88129177a727';






--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4 (Debian 13.4-1.pgdg100+1)
-- Dumped by pg_dump version 13.4 (Debian 13.4-1.pgdg100+1)

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

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO postgres;

\connect template1

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
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

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
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: postgres
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- Database "omnidocdb" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4 (Debian 13.4-1.pgdg100+1)
-- Dumped by pg_dump version 13.4 (Debian 13.4-1.pgdg100+1)

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
-- Name: omnidocdb; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE omnidocdb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE omnidocdb OWNER TO postgres;

\connect omnidocdb

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
-- Name: addmoneyaccount(integer, integer, double precision); Type: FUNCTION; Schema: public; Owner: user_db
--

CREATE FUNCTION public.addmoneyaccount(customer_id_in integer, type_account_in integer, monto_in double precision) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	account_id_tmp int;

BEGIN
	IF NOT EXISTS (SELECT 1 FROM customer WHERE customer_id = customer_id_in)then
		RETURN -1;
	ELSE
		SELECT a.account_id into account_id_tmp FROM account a WHERE type_account = type_account_in and status =1 and customer_id = customer_id_in;
		
		INSERT INTO public."statement" (customer_id, account_id, balance, type_statement, status_statement, date_statement, cash) 
			(SELECT customer_id_in, account_id, (balance+monto_in),  2,1, now(),monto_in
			FROM account WHERE type_account = type_account_in AND status =1 AND customer_id = customer_id_in);
		
		UPDATE account SET balance = (balance+monto_in) WHERE type_account = type_account_in AND status =1 AND customer_id = customer_id_in;			 
	END IF;	
RETURN 1;
END;
$$;


ALTER FUNCTION public.addmoneyaccount(customer_id_in integer, type_account_in integer, monto_in double precision) OWNER TO user_db;

--
-- Name: savecustomer(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: user_db
--

CREATE FUNCTION public.savecustomer(name_in character varying, last_name_father_in character varying, cellphone_in character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	id_cus int;
	account_id_tmp_deb int;
	account_id_tmp_cred int;
BEGIN
	IF NOT EXISTS (SELECT * FROM customer WHERE name_ LIKE name_in)THEN
		INSERT INTO public.customer (name_, father_last_name, cellphone) VALUES(name_in, last_name_father_in, cellphone_in) returning customer_id into id_cus; 
		INSERT INTO public.account (balance, customer_id, type_account, status) VALUES(1000, id_cus , 1, 1) returning account_id into account_id_tmp_deb;
		INSERT INTO public.account (balance, customer_id, type_account, status) VALUES(1000, id_cus , 2, 1) returning account_id into account_id_tmp_cred;
		INSERT INTO public."statement" (customer_id, account_id, balance, type_statement, status_statement, date_statement, cash) 
				VALUES(id_cus, account_id_tmp_deb, 0, 2, 1, now(), 1000);
		INSERT INTO public."statement" (customer_id, account_id, balance, type_statement, status_statement, date_statement, cash) 
				VALUES(id_cus, account_id_tmp_cred, 0, 2, 1, now(), 1000);
	END IF;	
RETURN id_cus;
END;
$$;


ALTER FUNCTION public.savecustomer(name_in character varying, last_name_father_in character varying, cellphone_in character varying) OWNER TO user_db;

--
-- Name: withdrawals(integer, double precision); Type: FUNCTION; Schema: public; Owner: user_db
--

CREATE FUNCTION public.withdrawals(customer_id_in integer, retiro double precision) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	balance_tmp float;
	account_tmp int;
BEGIN
	SELECT balance, account_id INTO balance_tmp, account_tmp FROM account WHERE customer_id  = customer_id_in AND type_account = 1;
	
	IF((balance_tmp-retiro) >=0)THEN
		INSERT INTO public."statement" (customer_id, account_id, balance, type_statement, status_statement, date_statement, cash) VALUES(customer_id_in, account_tmp, (balance_tmp-retiro), 1, 1, now(), retiro);
		UPDATE account SET balance= (balance_tmp -retiro) WHERE customer_id  = customer_id_in AND type_account = 1;
		RETURN 1;		
	ELSE 
		RETURN 0;
	END IF;	
END;
$$;


ALTER FUNCTION public.withdrawals(customer_id_in integer, retiro double precision) OWNER TO user_db;

--
-- Name: withdrawals(integer, double precision, integer); Type: FUNCTION; Schema: public; Owner: user_db
--

CREATE FUNCTION public.withdrawals(customer_id_in integer, retiro double precision, type_account_in integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	balance_tmp float;
	account_tmp int;
BEGIN
	SELECT balance, account_id INTO balance_tmp, account_tmp FROM account WHERE customer_id  = customer_id_in AND type_account = type_account_in;
	
	IF((balance_tmp-retiro) >=0)THEN
		INSERT INTO public."statement" (customer_id, account_id, balance, type_statement, status_statement, date_statement, cash) VALUES(customer_id_in, account_tmp, (balance_tmp-retiro), 1, 1, now(), retiro);
		UPDATE account SET balance= (balance_tmp -retiro) WHERE customer_id  = customer_id_in AND type_account = type_account_in;
		RETURN 1;		
	ELSE 
		RETURN 0;
	END IF;	
END;
$$;


ALTER FUNCTION public.withdrawals(customer_id_in integer, retiro double precision, type_account_in integer) OWNER TO user_db;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: public; Owner: user_db
--

CREATE TABLE public.account (
    account_id smallint NOT NULL,
    balance real,
    customer_id smallint NOT NULL,
    type_account smallint NOT NULL,
    status smallint NOT NULL
);


ALTER TABLE public.account OWNER TO user_db;

--
-- Name: account_account_id_seq; Type: SEQUENCE; Schema: public; Owner: user_db
--

CREATE SEQUENCE public.account_account_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_account_id_seq OWNER TO user_db;

--
-- Name: account_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user_db
--

ALTER SEQUENCE public.account_account_id_seq OWNED BY public.account.account_id;


--
-- Name: customer; Type: TABLE; Schema: public; Owner: user_db
--

CREATE TABLE public.customer (
    customer_id smallint NOT NULL,
    name_ character varying(150),
    father_last_name character varying(150),
    cellphone character varying(20)
);


ALTER TABLE public.customer OWNER TO user_db;

--
-- Name: customer_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: user_db
--

CREATE SEQUENCE public.customer_customer_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_customer_id_seq OWNER TO user_db;

--
-- Name: customer_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user_db
--

ALTER SEQUENCE public.customer_customer_id_seq OWNED BY public.customer.customer_id;


--
-- Name: statement; Type: TABLE; Schema: public; Owner: user_db
--

CREATE TABLE public.statement (
    statement_id integer NOT NULL,
    customer_id smallint NOT NULL,
    account_id smallint NOT NULL,
    balance real,
    type_statement smallint NOT NULL,
    status_statement smallint DEFAULT 1 NOT NULL,
    date_statement timestamp without time zone DEFAULT now() NOT NULL,
    cash real NOT NULL
);


ALTER TABLE public.statement OWNER TO user_db;

--
-- Name: statement_statement_id_seq; Type: SEQUENCE; Schema: public; Owner: user_db
--

CREATE SEQUENCE public.statement_statement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.statement_statement_id_seq OWNER TO user_db;

--
-- Name: statement_statement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user_db
--

ALTER SEQUENCE public.statement_statement_id_seq OWNED BY public.statement.statement_id;


--
-- Name: account account_id; Type: DEFAULT; Schema: public; Owner: user_db
--

ALTER TABLE ONLY public.account ALTER COLUMN account_id SET DEFAULT nextval('public.account_account_id_seq'::regclass);


--
-- Name: customer customer_id; Type: DEFAULT; Schema: public; Owner: user_db
--

ALTER TABLE ONLY public.customer ALTER COLUMN customer_id SET DEFAULT nextval('public.customer_customer_id_seq'::regclass);


--
-- Name: statement statement_id; Type: DEFAULT; Schema: public; Owner: user_db
--

ALTER TABLE ONLY public.statement ALTER COLUMN statement_id SET DEFAULT nextval('public.statement_statement_id_seq'::regclass);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: user_db
--

COPY public.account (account_id, balance, customer_id, type_account, status) FROM stdin;
14	1000	7	2	1
13	500	7	1	1
15	2350	8	1	1
16	475	8	2	1
17	2600	9	1	1
18	5475	9	2	1
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: user_db
--

COPY public.customer (customer_id, name_, father_last_name, cellphone) FROM stdin;
7	Alex	Pérez	7894561202
8	Ricardo	Pérez	2214304211
9	Eduardo	Pérez	2248759812
\.


--
-- Data for Name: statement; Type: TABLE DATA; Schema: public; Owner: user_db
--

COPY public.statement (statement_id, customer_id, account_id, balance, type_statement, status_statement, date_statement, cash) FROM stdin;
1	7	13	0	2	1	2022-02-14 14:24:44.404265	1000
2	7	14	0	2	1	2022-02-14 14:24:44.404265	1000
3	7	13	800	1	1	2022-02-14 14:25:10.314337	200
4	7	13	600	1	1	2022-02-14 14:26:26.337874	200
5	7	13	400	1	1	2022-02-14 14:26:35.284917	200
6	7	13	200	1	1	2022-02-14 14:26:38.891684	200
7	7	13	0	1	1	2022-02-14 14:26:45.417565	200
8	7	13	500	2	1	2022-02-14 08:57:12.708326	500
9	8	15	0	2	1	2022-02-14 16:16:31.791925	1000
10	8	16	0	2	1	2022-02-14 16:16:31.791925	1000
11	8	15	850	1	1	2022-02-14 16:17:30.412488	150
12	8	15	1350	2	1	2022-02-14 16:19:01.866296	500
13	8	15	1850	2	1	2022-02-14 16:19:18.835571	500
14	8	15	2350	2	1	2022-02-14 16:20:22.800562	500
15	8	16	475	1	1	2022-02-14 17:08:29.83758	525
16	9	17	0	2	1	2022-02-14 17:19:30.09763	1000
17	9	18	0	2	1	2022-02-14 17:19:30.09763	1000
18	9	17	850	1	1	2022-02-14 17:19:39.127657	150
19	9	17	700	1	1	2022-02-14 17:19:41.004867	150
20	9	17	550	1	1	2022-02-14 17:19:42.036658	150
21	9	17	400	1	1	2022-02-14 17:19:42.748369	150
22	9	17	250	1	1	2022-02-14 17:19:43.509926	150
23	9	17	100	1	1	2022-02-14 17:19:44.128877	150
24	9	18	475	1	1	2022-02-14 17:19:57.49364	525
25	9	17	2600	2	1	2022-02-14 17:23:13.706404	2500
26	9	18	5475	2	1	2022-02-14 17:25:18.176491	5000
\.


--
-- Name: account_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user_db
--

SELECT pg_catalog.setval('public.account_account_id_seq', 18, true);


--
-- Name: customer_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user_db
--

SELECT pg_catalog.setval('public.customer_customer_id_seq', 9, true);


--
-- Name: statement_statement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user_db
--

SELECT pg_catalog.setval('public.statement_statement_id_seq', 26, true);


--
-- Name: account account_pk; Type: CONSTRAINT; Schema: public; Owner: user_db
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pk PRIMARY KEY (account_id);


--
-- Name: account account_un; Type: CONSTRAINT; Schema: public; Owner: user_db
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_un UNIQUE (account_id, customer_id, type_account);


--
-- Name: customer customer_pk; Type: CONSTRAINT; Schema: public; Owner: user_db
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pk PRIMARY KEY (customer_id);


--
-- Name: statement statement_pk; Type: CONSTRAINT; Schema: public; Owner: user_db
--

ALTER TABLE ONLY public.statement
    ADD CONSTRAINT statement_pk PRIMARY KEY (statement_id);


--
-- Name: account account_fk; Type: FK CONSTRAINT; Schema: public; Owner: user_db
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_fk FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: statement statement_fk; Type: FK CONSTRAINT; Schema: public; Owner: user_db
--

ALTER TABLE ONLY public.statement
    ADD CONSTRAINT statement_fk FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: statement statement_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: user_db
--

ALTER TABLE ONLY public.statement
    ADD CONSTRAINT statement_fk_1 FOREIGN KEY (account_id) REFERENCES public.account(account_id);


--
-- Name: DATABASE omnidocdb; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON DATABASE omnidocdb TO user_db;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4 (Debian 13.4-1.pgdg100+1)
-- Dumped by pg_dump version 13.4 (Debian 13.4-1.pgdg100+1)

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

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

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
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

