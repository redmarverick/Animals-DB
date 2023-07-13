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
*/


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



