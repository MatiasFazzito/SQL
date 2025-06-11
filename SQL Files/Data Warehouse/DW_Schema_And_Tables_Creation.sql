-- Create the Data Warehouse schema
CREATE SCHEMA IF NOT EXISTS concertio_dw;
USE concertio_dw;

-- Dimension Table: Band
CREATE TABLE dim_band (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    members INT,
    nationality VARCHAR(50),
    language VARCHAR(15),
    genre VARCHAR(50)
);

-- Dimension Table: Stadium
CREATE TABLE dim_stadium (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    country VARCHAR(50),
    capacity INT
);

-- Dimension Table: Staff
CREATE TABLE dim_staff (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(20),
    age INT,
    specialty INT
);

-- Dimension Table: Specialty
CREATE TABLE dim_specialty (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Dimension Table: Concert
CREATE TABLE dim_concert (
    id INT PRIMARY KEY,
    tickets_sold INT,
    band_id INT,
    stadium_id INT,
    FOREIGN KEY (band_id) REFERENCES dim_band(id),
    FOREIGN KEY (stadium_id) REFERENCES dim_stadium(id)
);

-- Fact Table: Staff Assignment
CREATE TABLE fact_staff_assignment (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    concert_id INT,
    staff_id INT
);
