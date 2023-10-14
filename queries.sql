-- Query to Find all animals whose name ends in "mon":
SELECT *
FROM animals
WHERE name LIKE '%mon';
-- Query to List the name of all animals born between 2016 and 2019:
SELECT name
FROM animals
WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
-- Query to List the name of all animals that are neutered and have less than 3 escape attempts:
SELECT name
FROM animals
WHERE neutered = TRUE AND escape_attempts < 3;
-- Query to List the date of birth of all animals named either "Agumon" or "Pikachu":
SELECT date_of_birth
FROM animals
WHERE name IN ('Agumon', 'Pikachu');
-- Query to List name and escape attempts of animals that weigh more than 10.5kg:
SELECT name, escape_attempts
FROM animals
WHERE weight_kg > 10.5;
-- Query to Find all animals that are neutered:
SELECT *
FROM animals
WHERE neutered = TRUE;
-- Query to Find all animals not named Gabumon:
SELECT *
FROM animals
WHERE name <> 'Gabumon';
-- Query to Find all animals with a weight between 10.4kg and 17.3kg (inclusive):
SELECT *
FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;


-- THis part is for the second project

-- 1. **Update species and rollback changes for names ending in "mon":**

BEGIN TRANSACTION;

-- Update species for names ending in "mon"
UPDATE animals
SET species = 'unspecified'
WHERE name LIKE '%mon';

-- Verify the changes
SELECT * FROM animals;

ROLLBACK;

-- 2. **Update species for animals without a species and commit changes:**

BEGIN TRANSACTION;

-- Update species for animals without a species
UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

-- Verify the changes
SELECT * FROM animals;

COMMIT;


-- 3. **Delete all records and roll back the transaction:**

BEGIN TRANSACTION;

-- Delete all records
DELETE FROM animals;

-- Rollback the transaction
ROLLBACK;


-- 4. **Update weights and rollback changes using savepoint:**

BEGIN TRANSACTION;

-- Delete animals born after Jan 1st, 2022
DELETE FROM animals WHERE date_of_birth > '2022-01-01';

-- Create a savepoint
SAVEPOINT weight_update;

-- Update weights to be their weight multiplied by -1
UPDATE animals
SET weight_kg = weight_kg * -1;

-- Rollback to the savepoint
ROLLBACK TO weight_update;

-- Update weights for negative values
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

-- Commit transaction
COMMIT;



-- 1. **Count of animals:**

SELECT COUNT(*) AS total_animals FROM animals;

-- 2. **Count of animals that have never tried to escape:**
SELECT COUNT(*) AS no_escape_animals FROM animals WHERE escape_attempts = 0;

-- 3. **Average weight of animals:**
SELECT AVG(weight_kg) AS average_weight FROM animals;

-- 4. **Count of escape attempts for neutered and non-neutered animals:**
SELECT neutered, SUM(escape_attempts) AS total_escape_attempts
FROM animals
GROUP BY neutered;

-- 5. **Minimum and maximum weight for each type of animal:**
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;

-- 6. **Average number of escape attempts per animal type for those born between 1990 and 2000:**
SELECT species, AVG(escape_attempts) AS avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

