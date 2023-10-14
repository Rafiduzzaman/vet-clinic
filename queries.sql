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


-- This part is for the third project
-- Queries using JOIN to answer the questions

-- What animals belong to Melody Pond?
SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are Pokemon (their type is Pokemon)
SELECT animals.name
FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal
SELECT owners.full_name, animals.name
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id;

-- How many animals are there per species?
SELECT species.name, COUNT(animals.id) AS animal_count
FROM species
LEFT JOIN animals ON species.id = animals.species_id
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell
SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

-- List all animals owned by Dean Winchester that haven't tried to escape
SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

-- Who owns the most animals?
SELECT owners.full_name, COUNT(animals.id) AS animal_count
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.full_name
ORDER BY animal_count DESC
LIMIT 1;


-- The following code is for the 4th project
-- Who was the last animal seen by William Tatcher?
SELECT a.name AS last_animal_seen_by_william_tatcher
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT v.animal_id) AS number_of_animals_stephanie_mendez_saw
FROM visits v
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT v.name AS vet_name, COALESCE(string_agg(s.name, ', '), 'No specialties') AS specialties
FROM vets v
LEFT JOIN specializations sp ON v.id = sp.vet_id
LEFT JOIN species s ON sp.species_id = s.id
GROUP BY v.name;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name AS animal_name
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Stephanie Mendez'
  AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT a.name AS animal_name, COUNT(v.animal_id) AS visit_count
FROM visits v
JOIN animals a ON v.animal_id = a.id
GROUP BY a.name
ORDER BY visit_count DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT a.name AS first_visit_animal
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Maisy Smith'
ORDER BY v.visit_date ASC
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS animal_name, vt.name AS vet_name, v.visit_date AS visit_date
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
ORDER BY v.visit_date DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS visits_with_non_specialized_vet
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
LEFT JOIN specializations sp ON vt.id = sp.vet_id
WHERE sp.species_id IS NULL OR sp.species_id != a.species_id;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT s.name AS suggested_specialty
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
JOIN specializations sp ON vt.id = sp.vet_id
JOIN species s ON sp.species_id = s.id
WHERE vt.name = 'Maisy Smith'
GROUP BY s.name
ORDER BY COUNT(*) DESC
LIMIT 1;
