/* CREATE DATABASE vet_clinic;

\c vet_clinic;

CREATE TABLE animals (
  id SERIAL PRIMARY KEY,
  name VARCHAR,
  date_of_birth DATE,
  escape_attempts INTEGER,
  neutered BOOLEAN,
  weight_kg DECIMAL
);

ALTER TABLE animals
ADD COLUMN species VARCHAR;



/* Create a table named owners with the following columns:
id: integer (set it as autoincremented PRIMARY KEY)
full_name: string
age: integer
vvvvvvvvv*/

CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR,
  age INTEGER
);

/*
Create a table named species with the following columns:
id: integer (set it as autoincremented PRIMARY KEY)
name: string
*/

CREATE TABLE species (
  id SERIAL PRIMARY KEY,
  name VARCHAR
);

/*
Modify animals table:
Make sure that id is set as autoincremented PRIMARY KEY
Remove column species
Add column species_id which is a foreign key referencing species table
Add column owner_id which is a foreign key referencing the owners table
*/

-- Remove the species column from the animals table
ALTER TABLE animals
DROP COLUMN species;

-- Modify the id column to be auto-incremented primary key if not already set
ALTER TABLE animals
ALTER COLUMN id SET DEFAULT nextval('animals_id_seq');

-- Add the species_id column as a foreign key referencing the species table
ALTER TABLE animals
ADD COLUMN species_id INTEGER,
ADD CONSTRAINT fk_species_id
    FOREIGN KEY (species_id)
    REFERENCES species(id);

-- Add the owner_id column as a foreign key referencing the owners table
ALTER TABLE animals
ADD COLUMN owner_id INTEGER,
ADD CONSTRAINT fk_owner_id
    FOREIGN KEY (owner_id)
    REFERENCES owners(id);
*/

/*---------------------------------------------------------------*/

/*
Create a table named vets with the following columns:
id: integer (set it as autoincremented PRIMARY KEY)
name: string
age: integer
date_of_graduation: date

CREATE TABLE vets (
  id SERIAL PRIMARY KEY,
  name VARCHAR,
  age INTEGER,
  date_of_graduation DATE
);

/*
There is a many-to-many relationship between the tables species and vets: a vet can specialize in multiple species, 
and a species can have multiple vets specialized in it. Create a "join table" called specializations to handle this relationship.
*/

CREATE TABLE specializations (
  vet_id INTEGER REFERENCES vets (id),
  species_id INTEGER REFERENCES species (id),
  PRIMARY KEY (vet_id, species_id)
);

/*
There is a many-to-many relationship between the tables animals and vets: an animal can visit multiple vets and one vet can be visited by multiple animals. 
Create a "join table" called visits to handle this relationship, it should also keep track of the date of the visit.
*/

CREATE TABLE visits (
  animal_id INTEGER REFERENCES animals (id),
  vet_id INTEGER REFERENCES vets (id),
  visit_date DATE,
);
*/

-- First improve on performance
CREATE INDEX ON visits (animal_id);

-- Second improve
CREATE INDEX ON visits (vet_id);
CREATE TEMPORARY TABLE temp_visits AS SELECT * FROM visits WHERE vet_id = 2;
CREATE INDEX ON temp_visits (vet_id);

-- Third improve
CREATE INDEX ON owners (email);