-- This part is for creating the animals table (1st project)

CREATE TABLE IF NOT EXISTS public.animals
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name "varchar",
    date_of_birth date,
    escape_attempts integer,
    neutered boolean,
    weight_kg real,
    CONSTRAINT animals_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.animals
    OWNER to postgres;


-- This part is for the updating animal table (2nd project)

ALTER TABLE animals
ADD COLUMN species VARCHAR(255);