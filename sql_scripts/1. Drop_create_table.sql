-- -------------
-- Drop Tables
-- -------------

DROP TABLE IF EXISTS "final"."Customers_Campaigns";
DROP TABLE IF EXISTS "final"."Campaigns";
DROP TABLE IF EXISTS "final"."Customers";
DROP TABLE IF EXISTS "final"."Temp_Campaigns";
DROP TABLE IF EXISTS "final"."Temp_Customers";

-- -------------
-- Create Tables
-- -------------

-- Customers Table
CREATE TABLE IF NOT EXISTS "final"."Customers" (
    Customers_id Int PRIMARY KEY NOT NULL,
    age Int NOT NULL,
    job VARCHAR NOT NULL,
    marital VARCHAR NOT NULL,
    education VARCHAR NOT NULL,
    "default" BOOLEAN NOT NULL, -- Reserved keyword enclosed in quotes
    balance Int NOT NULL,
    housing BOOLEAN NOT NULL,
    loan BOOLEAN NOT NULL
);

-- Campaigns Table
CREATE TABLE IF NOT EXISTS "final"."Campaigns" (
    Campaigns_id Int PRIMARY KEY NOT NULL,
    contact VARCHAR NOT NULL,
    "day" Int NOT NULL, -- Reserved keyword enclosed in quotes
    "month" VARCHAR NOT NULL, -- Reserved keyword enclosed in quotes
    duration Int NOT NULL,
    campaign Int NOT NULL,
    pdays Int NOT NULL,
    previous Int NOT NULL,
    poutcome VARCHAR NOT NULL
);

-- Customers_Campaigns Table
CREATE TABLE IF NOT EXISTS "final"."Customers_Campaigns" (
	Customers_Campaigns_id SERIAL PRIMARY KEY,
    Campaigns_id Int NOT NULL,
    Customers_id Int NOT NULL,
    y BOOLEAN NOT NULL,
    FOREIGN KEY (Campaigns_id) REFERENCES "final"."Campaigns"(Campaigns_id),
    FOREIGN KEY (Customers_id) REFERENCES "final"."Customers"(Customers_id) -- Fixed column name
);

--- temporary table 
CREATE TABLE IF NOT EXISTS "final"."Temp_Customers" (
    age INT,
    job VARCHAR(50),
    marital VARCHAR(20),
    education VARCHAR(50),
    "default" BOOLEAN,
    balance INT,
    housing BOOLEAN,
    loan BOOLEAN
	);
	
CREATE TABLE IF NOT EXISTS "final"."Temp_Campaigns"(
	contact VARCHAR(50),
    "day" INT,
    "month" VARCHAR(10),
    duration INT,
    campaign INT,
    pdays INT,
    previous INT,
    poutcome VARCHAR(50),
    y BOOLEAN
);
