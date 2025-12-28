-- query 31
-- Get the number of males and females aged between 50 and 60. 

SELECT
    gender,
    COUNT(*) AS total_members
FROM memberinfo
WHERE age BETWEEN 50 AND 60
GROUP BY gender;


-- query 32
--  Get the list of tests where blood pressure is between 100 and 200. 

SELECT
    blood_id,
    date AS test_date,
    bloodpressure,
    fbs,
    thal,
    serumcholesterol,
    cardiodiagnosis_cardio_id
FROM bloodtest
WHERE bloodpressure BETWEEN 100 AND 200;


-- query 33
--  Get the list of symptoms diagnosed for patients.

SELECT
    symptom_id,
    date AS symptom_date,
    exang,
    oldpeak,
    cp,
    cardiodiagnosis_cardio_id
FROM symptom;


-- query 34
-- Get the average age of patients in the database.

SELECT
    AVG(age) AS average_age
FROM memberinfo
WHERE age IS NOT NULL;


-- query 35
-- Get the total number of cities for each state available. 

SELECT
    state,
    COUNT(DISTINCT city) AS total_cities
FROM addressinfo
WHERE state IS NOT NULL
  AND city IS NOT NULL
GROUP BY state;


-- query 36
-- Get the number of patients in the following age groups: 
-- o 10-20 
-- o 20-30 
-- o 30-40 
-- o 40-50 
-- o 50-60 
-- o 60-70

SELECT
    CASE
        WHEN age BETWEEN 10 AND 19 THEN '10-20'
        WHEN age BETWEEN 20 AND 29 THEN '20-30'
        WHEN age BETWEEN 30 AND 39 THEN '30-40'
        WHEN age BETWEEN 40 AND 49 THEN '40-50'
        WHEN age BETWEEN 50 AND 59 THEN '50-60'
        WHEN age BETWEEN 60 AND 69 THEN '60-70'
    END AS age_group,
    COUNT(*) AS total_patients
FROM memberinfo
WHERE age BETWEEN 10 AND 69
GROUP BY age_group
ORDER BY age_group;


SELECT
    COUNT(*) FILTER (WHERE age BETWEEN 10 AND 19) AS "10-20",
    COUNT(*) FILTER (WHERE age BETWEEN 20 AND 29) AS "20-30",
    COUNT(*) FILTER (WHERE age BETWEEN 30 AND 39) AS "30-40",
    COUNT(*) FILTER (WHERE age BETWEEN 40 AND 49) AS "40-50",
    COUNT(*) FILTER (WHERE age BETWEEN 50 AND 59) AS "50-60",
    COUNT(*) FILTER (WHERE age BETWEEN 60 AND 69) AS "60-70"
FROM memberinfo;


-- query 37
-- Get the list of members and their addresses.

SELECT
    m.member_id,
    m.username,
    m.firstname,
    m.lastname,
    m.age,
    m.gender,
    m.email,
    m.phonenumber,
    a.address_id,
    a.city,
    a.state,
    a.country,
    a.pincode
FROM memberinfo m
JOIN addressinfo a
    ON m.member_id = a.memberinfo_member_id;


-- query 38
-- Get the list of members and their cardio history.

SELECT
    m.member_id,
    m.username,
    m.firstname,
    m.lastname,
    m.age,
    m.gender,
    c.cardio_id,
    c.cardioarrestdetected,
    c.date AS diagnosis_date
FROM memberinfo m
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id;


-- query 39
-- Get the list of members and their diseases.

SELECT
    m.member_id,
    m.firstname,
    m.lastname,
    d.disease_id,
    d.diagnoseddate,
    d.recovereddate,
    d.isrecovered
FROM memberinfo m
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
JOIN diseasedetail d
    ON d.cardiodiagnosis_cardio_id = c.cardio_id;


-- query 40
-- Get the list of females diagnosed with a heart attack.

SELECT
    m.member_id,
    m.firstname,
    m.lastname,
    m.age,
    m.gender,
    c.cardio_id,
    c.cardioarrestdetected,
    c.date AS diagnosis_date
FROM memberinfo m
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
WHERE m.gender = '1'
  AND c.cardioarrestdetected = 1;
