-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://redmine.postgresql.org/projects/pgadmin4/issues/new if you find any bugs, including reproduction steps.
BEGIN;


DROP TABLE IF EXISTS public.funds CASCADE;

CREATE TABLE IF NOT EXISTS public.funds
(
    isin_code character varying NOT NULL,
    mc_code character varying NOT NULL,
    name character varying NOT NULL,
    managed_by integer NOT NULL,
    legal_type integer,
    category integer,
    periodicity integer,
    PRIMARY KEY (isin_code)
);

DROP TABLE IF EXISTS public.legal_types;

CREATE TABLE IF NOT EXISTS public.legal_types
(
    legal_type_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    name character varying NOT NULL,
    PRIMARY KEY (legal_type_id)
);

DROP TABLE IF EXISTS public.categories;

CREATE TABLE IF NOT EXISTS public.categories
(
    category_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    name character varying NOT NULL,
    PRIMARY KEY (category_id)
);

DROP TABLE IF EXISTS public.periodicities;

CREATE TABLE IF NOT EXISTS public.periodicities
(
    periodicity_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    name character varying NOT NULL,
    PRIMARY KEY (periodicity_id)
);

DROP TABLE IF EXISTS public.rates;

CREATE TABLE IF NOT EXISTS public.rates
(
    rate_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    isin_code character varying NOT NULL,
    subscription_fee real NOT NULL,
    redemption_fee real NOT NULL,
    mgt_fee real NOT NULL,
    PRIMARY KEY (rate_id),
    CONSTRAINT "UNIQUE ISIN" UNIQUE (isin_code)
);

DROP TABLE IF EXISTS public.performances;

CREATE TABLE IF NOT EXISTS public.performances
(
    performance_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    isin_code character varying NOT NULL,
    date date NOT NULL,
    an_value numeric NOT NULL,
    vl_value numeric NOT NULL,
    PRIMARY KEY (performance_id)
);

DROP TABLE IF EXISTS public.managers;

CREATE TABLE IF NOT EXISTS public.managers
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    manager_name character varying NOT NULL,
    website_url character varying,
    logo_url character varying,
    PRIMARY KEY (id),
    CONSTRAINT "Unique name" UNIQUE (manager_name)
);

ALTER TABLE IF EXISTS public.funds
    ADD CONSTRAINT "Legal type constraint" FOREIGN KEY (legal_type)
    REFERENCES public.legal_types (legal_type_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.funds
    ADD CONSTRAINT "Category constraint" FOREIGN KEY (category)
    REFERENCES public.categories (category_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.funds
    ADD CONSTRAINT "Periodicity constraint" FOREIGN KEY (periodicity)
    REFERENCES public.periodicities (periodicity_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.funds
    ADD CONSTRAINT "Manager constraint" FOREIGN KEY (managed_by)
    REFERENCES public.managers (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.rates
    ADD CONSTRAINT isin FOREIGN KEY (isin_code)
    REFERENCES public.funds (isin_code) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.performances
    ADD CONSTRAINT "ISIN constraint" FOREIGN KEY (isin_code)
    REFERENCES public.funds (isin_code) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

INSERT INTO public.periodicities (name)
VALUES ('daily'), ('weekly');

INSERT INTO public.categories (name)
VALUES ('Actions'), ('OMLT'), ('Monétaire'), ('Diversifié'), ('OCT'), ('Contractuel');

INSERT INTO public.legal_types (name)
VALUES ('SICAV'), ('FCP');

END;