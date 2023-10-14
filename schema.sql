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



-- The following code is for 3rd project
-- Create the owners table
CREATE TABLE IF NOT EXISTS owners (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR,
    age INTEGER
);

-- Create the species table
CREATE TABLE IF NOT EXISTS species (
    id SERIAL PRIMARY KEY,
    name VARCHAR
);

-- Modify the animals table
ALTER TABLE animals
DROP COLUMN species;

ALTER TABLE animals
ADD COLUMN species_id INTEGER,
ADD COLUMN owner_id INTEGER;

ALTER TABLE animals
ADD FOREIGN KEY (species_id) REFERENCES species(id),
ADD FOREIGN KEY (owner_id) REFERENCES owners(id);



-- The following code is for the 4th project
-- Create the vets table
CREATE TABLE IF NOT EXISTS vets (
    id SERIAL PRIMARY KEY,
    name VARCHAR,
    age INTEGER,
    date_of_graduation DATE
);

-- Create the specializations join table
CREATE TABLE IF NOT EXISTS specializations (
    vet_id INTEGER,
    species_id INTEGER,
    PRIMARY KEY (vet_id, species_id),
    FOREIGN KEY (vet_id) REFERENCES vets(id),
    FOREIGN KEY (species_id) REFERENCES species(id)
);

-- Create the visits join table
CREATE TABLE IF NOT EXISTS visits (
    vet_id INTEGER,
    animal_id INTEGER,
    visit_date DATE,
    PRIMARY KEY (vet_id, animal_id, visit_date),
    FOREIGN KEY (vet_id) REFERENCES vets(id),
    FOREIGN KEY (animal_id) REFERENCES animals(id)
);
