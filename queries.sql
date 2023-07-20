/*
-- Query 1: Find all animals whose name ends in "mon"
SELECT * FROM animals
WHERE name LIKE '%mon';

-- Query 2: List the name of all animals born between 2016 and 2019
SELECT name FROM animals
WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- Query 3: List the name of all animals that are neutered and have less than 3 escape attempts
SELECT name FROM animals
WHERE neutered = true AND escape_attempts < 3;

-- Query 4: List the date of birth of all animals named either "Agumon" or "Pikachu"
SELECT date_of_birth FROM animals
WHERE name IN ('Agumon', 'Pikachu');

-- Query 5: List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals
WHERE weight_kg > 10.5;

-- Query 6: Find all animals that are neutered
SELECT * FROM animals
WHERE neutered = true;

-- Query 7: Find all animals not named Gabumon
SELECT * FROM animals
WHERE name <> 'Gabumon';

-- Query 8: Find all animals with a weight between 10.4kg and 17.3kg (including animals with weights equal to 10.4kg or 17.3kg)
SELECT * FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;

BEGIN; -- Begin the FIRST transaction

-- Update the animals table by setting the species column to "unspecified" for all animals
UPDATE animals
SET species = 'unspecified';

-- Verify the changes
SELECT * FROM animals;

ROLLBACK; -- Roll back the transaction

-- Verify that the changes were rolled back
SELECT * FROM animals;


BEGIN; -- Begin the SECOND transaction

-- Update the animals table by setting the species column to "digimon" for animals with names ending in "mon"
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

-- Update the animals table by setting the species column to "pokemon" for animals without a species already set
UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

-- Verify the changes within the transaction
SELECT * FROM animals;

COMMIT; -- Commit the transaction

-- Verify that the changes persist after the commit
SELECT * FROM animals;


BEGIN; -- Begin the THIRD transaction

-- Delete all records in the animals table
DELETE FROM animals;

-- Verify the deletion within the transaction
SELECT * FROM animals;

ROLLBACK; -- Roll back the transaction

-- Verify if all records in the animals table still exist after rollback
SELECT * FROM animals;


BEGIN; -- Begin the FOURTH transaction

-- Delete all animals born after Jan 1st, 2022
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

-- Create a savepoint for the transaction
SAVEPOINT my_savepoint;

-- Update all animals' weight to be their weight multiplied by -1
UPDATE animals
SET weight_kg = weight_kg * -1;

-- Rollback to the savepoint
ROLLBACK TO my_savepoint;

-- Update all animals' weights that are negative to be their weight multiplied by -1
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

COMMIT; -- Commit the transaction

SELECT * FROM animals;

SELECT COUNT(*) AS total_animals
FROM animals;

SELECT COUNT(*) AS animals_never_escaped
FROM animals
WHERE escape_attempts = 0;

SELECT AVG(weight_kg) AS average_weight
FROM animals;

SELECT neutered, SUM(escape_attempts) AS total_escape_attempts
FROM animals
GROUP BY neutered
ORDER BY total_escape_attempts DESC
LIMIT 1;

SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;

SELECT species, AVG(escape_attempts) AS average_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

/* What animals belong to Melody Pond? */

SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';

/* List of all animals that are pokemon (their type is Pokemon).*/

SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

/* List all owners and their animals, including those that don't own any animal.*/

SELECT o.full_name, a.name
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;

/* How many animals are there per species? */

SELECT s.name, COUNT(*) AS total_animals
FROM animals a
JOIN species s ON a.species_id = s.id
GROUP BY s.name;

/* List all Digimon owned by Jennifer Orwell. */

SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
JOIN owners o ON a.owner_id = o.id
WHERE s.name = 'Digimon' AND o.full_name = 'Jennifer Orwell';

/* List all animals owned by Dean Winchester that haven't tried to escape. */

SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

/* Who owns the most animals? */

SELECT o.full_name, COUNT(*) AS total_animals
FROM owners o
JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY total_animals DESC
LIMIT 1;
*/

/*---------------------------------------------------------------*/

/*
Write queries to answer the following:


/* Who was the last animal seen by William Tatcher? */

SELECT a.name
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets ve ON v.vet_id = ve.id
WHERE ve.name = 'William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

/* How many different animals did Stephanie Mendez see? */

SELECT COUNT(DISTINCT a.id) AS total_animals
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets ve ON v.vet_id = ve.id
WHERE ve.name = 'Stephanie Mendez';

/* List all vets and their specialties, including vets with no specialties. */

SELECT v.name, s.name AS specialty
FROM vets v
LEFT JOIN specializations sp ON v.id = sp.vet_id
LEFT JOIN species s ON sp.species_id = s.id;

/*List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020. */

SELECT a.name
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets ve ON v.vet_id = ve.id
WHERE ve.name = 'Stephanie Mendez'
  AND v.visit_date >= '2020-04-01' AND v.visit_date <= '2020-08-30';

/* What animal has the most visits to vets? */

SELECT a.name
FROM animals a
JOIN visits v ON a.id = v.animal_id
GROUP BY a.name
ORDER BY COUNT(*) DESC
LIMIT 1;

/* Who was Maisy Smith's first visit? */

SELECT a.name
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets ve ON v.vet_id = ve.id
WHERE ve.name = 'Maisy Smith'
ORDER BY v.visit_date ASC
LIMIT 1;

/* Details for the most recent visit: animal information, vet information, and date of visit. */

SELECT a.name AS animal_name, ve.name AS vet_name, v.visit_date
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets ve ON v.vet_id = ve.id
ORDER BY v.visit_date DESC
LIMIT 1;

/* How many visits were with a vet that did not specialize in that animal's species? */

SELECT COUNT(*) AS total_visits
FROM visits v
JOIN vets ve ON v.vet_id = ve.id
JOIN animals a ON v.animal_id = a.id
LEFT JOIN specializations sp ON ve.id = sp.vet_id AND a.species_id = sp.species_id
WHERE sp.vet_id IS NULL;

/* What specialty should Maisy Smith consider getting? Look for the species she visits the most. */

SELECT s.name AS specialty
FROM visits v
JOIN vets ve ON v.vet_id = ve.id
JOIN animals a ON v.animal_id = a.id
JOIN species s ON a.species_id = s.id
WHERE ve.name = 'Maisy Smith'
GROUP BY s.name
ORDER BY COUNT(*) DESC
LIMIT 1;
*/

EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 12;

EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2;

EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';

