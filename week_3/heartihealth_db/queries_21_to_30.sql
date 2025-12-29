-- query 21
--  Get a list of wearable device information.

SELECT
    wearable_device_id,
    thalach,
    slope,
    date AS recorded_date,
    cardiodiagnosis_cardio_id
FROM wearabledevicedata;



-- query 22
--  Get a list of all the blood tests done.

SELECT
    blood_id,
    date AS test_date,
    bloodpressure,
    fbs,
    thal,
    serumcholesterol,
    cardiodiagnosis_cardio_id
FROM bloodtest;


-- query 23
-- Get a list of members who are aged greater than 50.

SELECT
    member_id,
    username,
    firstname,
    lastname,
    age,
    gender,
    email,
    phonenumber
FROM memberinfo
WHERE age > 50;


-- query 24
-- Get a list of addresses for the city 'Flora'.

SELECT
    address_id,
    city,
    state,
    country,
    pincode,
    memberinfo_member_id
FROM addressinfo
WHERE city = 'Flora';


-- query 25
-- Get a list of all unique states. 

SELECT DISTINCT state
FROM addressinfo
WHERE state IS NOT NULL;


-- query 26
-- Get the total number of members in the database. 

SELECT COUNT(*) AS total_members
FROM memberinfo;


-- query 27
--  Get the total number of blood tests done.

SELECT COUNT(*) AS total_blood_tests
FROM bloodtest;


-- query 28
-- Get the average cholesterol level for members.

SELECT
    AVG(serumcholesterol) AS average_cholesterol_level
FROM bloodtest
WHERE serumcholesterol IS NOT NULL;


-- query 29
-- Get the maximum peak value in symptoms.

SELECT
    MAX(oldpeak) AS max_peak_value
FROM symptom
WHERE oldpeak IS NOT NULL;


-- query 30
-- Get the list of tests done between January 1, 2015, and January 31, 2019.

SELECT
    blood_id AS test_id,
    date AS test_date,
    bloodpressure,
    fbs,
    thal,
    serumcholesterol,
    cardiodiagnosis_cardio_id
FROM bloodtest
WHERE date::date 
BETWEEN '2015-01-01' AND '2019-01-31'


