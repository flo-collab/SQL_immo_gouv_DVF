CREATE DATABASE IF NOT EXISTS immo_sample ;
USE immo_sample  ;

DROP TABLE transactions;
CREATE TABLE IF NOT EXISTS transactions (
    key_T VARCHAR (255),
    date_ date ,
    valeur INTEGER (10),
    key_A VARCHAR (255),
    key_B VARCHAR (255),
    PRIMARY KEY(key_T),
    FOREIGN KEY(key_A) REFERENCES Fournisseur(key_A),
    FOREIGN KEY(key_B) REFERENCES bien(key_B)
);

DROP TABLE bien;
CREATE TABLE IF NOT EXISTS bien (
    key_B VARCHAR (255),
    surface_carrez_lot1 FLOAT (20),
    surface_bati INTEGER (10),
    nb_pieces INTEGER (10),
    type_local VARCHAR (255),
    nb_lots INTEGER (10),
    key_A VARCHAR (255),
    PRIMARY KEY(key_B),
    FOREIGN KEY(key_A) REFERENCES Fournisseur(key_A)
);

DROP TABLE adresse;
CREATE TABLE IF NOT EXISTS adresse (
    key_A VARCHAR (255),
    b_t_q VARCHAR (255),
    surface_bati INTEGER (10),
    no_voie INTEGER (10),
    type_voie VARCHAR (255),
    voie VARCHAR (10),
    code_postal VARCHAR (255),
    PRIMARY KEY(key_A),
    FOREIGN KEY(code_postal) REFERENCES departement(code_postal)
);

DROP TABLE departement;
CREATE TABLE IF NOT EXISTS departement (
    code_postal VARCHAR (255),
    code_departement INTEGER (10),
    PRIMARY KEY(code_postal)
);

LOAD DATA LOCAL INFILE  'CSV Samples\\df_departement_sample.csv' 
INTO TABLE departement 
FIELDS TERMINATED BY "," 
LINES TERMINATED BY "\n"
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE  'CSV Samples\\df_adresse_sample.csv' 
INTO TABLE adresse 
FIELDS TERMINATED BY "," 
LINES TERMINATED BY "\n"
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE  'CSV Samples\\df_bien_sample.csv' 
INTO TABLE bien
FIELDS TERMINATED BY "," 
LINES TERMINATED BY "\n"
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE  'CSV Samples\\df_transaction_sample.csv' 
INTO TABLE transactions 
FIELDS TERMINATED BY "," 
LINES TERMINATED BY "\n"
IGNORE 1 LINES;