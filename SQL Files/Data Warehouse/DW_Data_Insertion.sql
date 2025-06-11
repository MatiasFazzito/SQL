-- Use the Data Warehouse schema
USE concertio_dw;

-- Load data into dim_band
INSERT INTO dim_band (id, name, members, nationality, language, genre)
SELECT id, name, members, nationality, language, genre  FROM concertio.bands;

-- Load data into dim_stadium
INSERT INTO dim_stadium (id, name, country, capacity)
SELECT id, name, country, capacity FROM concertio.stadium;

-- Load data into dim_staff
INSERT INTO dim_staff (id, name, gender, age, specialty)
SELECT id, name, gender, age, specialty FROM concertio.staff;

-- Load data into dim_specialty
INSERT INTO dim_specialty (id, name)
SELECT id, name FROM concertio.specialty;

-- Load data into dim_concert
INSERT INTO dim_concert (id, tickets_sold, band_id, stadium_id)
SELECT
    c.id,
    c.Tickets_Sold,
    c.Band,
    c.Stadium
FROM concertio.concert c;

-- Load data into fact_staff_assignment
INSERT INTO fact_staff_assignment (
    concert_id, staff_id
)
SELECT
    a.Concert,
    a.Staff
FROM concertio.asignation a;

