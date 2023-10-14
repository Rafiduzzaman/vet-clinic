-- This is code for the first project
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Agumon', '2020-02-03', 0, TRUE, 10.23),
       ('Gabumon', '2018-11-15', 2, TRUE, 8),
       ('Pikachu', '2021-01-07', 1, FALSE, 15.04),
       ('Devimon', '2017-05-12', 5, TRUE, 11);


--This is part is for second project
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg, species)
VALUES 
('Charmander', '2020-02-08', 0, FALSE, -11, 'Unknown'),
('Plantmon', '2021-11-15', 2, TRUE, -5.7, 'Plant'),
('Squirtle', '1993-04-02', 3, FALSE, -12.13, 'Water'),
('Angemon', '2005-06-12', 1, TRUE, -45, 'Unknown'),
('Boarmon', '2005-06-07', 7, TRUE, 20.4, 'Mammal'),
('Blossom', '1998-10-13', 3, TRUE, 17, 'Unknown'),
('Ditto', '2022-05-14', 4, TRUE, 22, 'Unknown');

-- This following code is for the third project
-- Insert data into owners table
INSERT INTO owners (full_name, age) VALUES
('Sam Smith', 34),
('Jennifer Orwell', 19),
('Bob', 45),
('Melody Pond', 77),
('Dean Winchester', 14),
('Jodie Whittaker', 38);

-- Insert data into species table
INSERT INTO species (name) VALUES
('Pokemon'),
('Digimon');

-- Modify animals to include species_id and owner_id
UPDATE animals SET species_id = (CASE WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon') ELSE (SELECT id FROM species WHERE name = 'Pokemon') END);

UPDATE animals SET owner_id = 
(CASE
    WHEN name = 'Agumon' THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
    WHEN name = 'Gabumon' OR name = 'Pikachu' THEN (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
    WHEN name = 'Devimon' OR name = 'Plantmon' THEN (SELECT id FROM owners WHERE full_name = 'Bob')
    WHEN name = 'Charmander' OR name = 'Squirtle' OR name = 'Blossom' THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
    WHEN name = 'Angemon' OR name = 'Boarmon' THEN (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
END);
