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
*/

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

