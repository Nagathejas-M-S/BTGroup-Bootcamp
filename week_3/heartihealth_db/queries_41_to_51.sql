-- query 41
-- Get the list of female members and their cardio information for those aged above 50. 

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
  AND m.age > 50;



-- query 42
-- Get the list of males who have blood pressure > 140 and have not had a heart attack. 

SELECT DISTINCT
    m.member_id,
    m.firstname,
    m.lastname,
    m.age,
    m.gender,
    b.bloodpressure,
    c.cardio_id,
    c.cardioarrestdetected
FROM memberinfo m
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
JOIN bloodtest b
    ON b.cardiodiagnosis_cardio_id = c.cardio_id
WHERE m.gender = '0'
  AND b.bloodpressure > 140
  AND c.cardioarrestdetected = 0;



-- query 43
-- Get the list of members who had a heart attack from the state "Mountain Province".

SELECT DISTINCT
    m.member_id,
    m.firstname,
    m.lastname,
    m.age,
    m.gender,
    a.state,
    c.cardio_id,
    c.cardioarrestdetected,
    c.date AS diagnosis_date
FROM memberinfo m
JOIN addressinfo a
    ON m.member_id = a.memberinfo_member_id
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
WHERE a.state = 'Mountain Province'
  AND c.cardioarrestdetected = 1;



-- query 44
-- Get the list of male members and their diseases with symptoms for those aged less than 40.

SELECT
    m.member_id,
    m.firstname,
    m.lastname,
    m.age,
    m.gender,

    d.disease_id,
    d.diagnoseddate,
    d.recovereddate,
    d.isrecovered,

    s.symptom_id,
    s.date AS symptom_date,
    s.exang,
    s.oldpeak,
    s.cp

FROM memberinfo m
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
JOIN diseasedetail d
    ON d.cardiodiagnosis_cardio_id = c.cardio_id
JOIN symptom s
    ON s.cardiodiagnosis_cardio_id = c.cardio_id

WHERE m.gender = '0'
  AND m.age < 40;



-- query 45
--  Get the count of members from "Mountain Province" aged between 50 and 60.

SELECT
    COUNT(DISTINCT m.member_id) AS total_members
FROM memberinfo m
JOIN addressinfo a
    ON m.member_id = a.memberinfo_member_id
WHERE a.state = 'Mountain Province'
  AND m.age BETWEEN 50 AND 60;


-- query 46
-- Get the count of male and female members who have blood pressure > 140 and have been 
-- detected with a heart attack. 

SELECT
    m.gender,
    COUNT(DISTINCT m.member_id) AS total_members
FROM memberinfo m
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
JOIN bloodtest b
    ON b.cardiodiagnosis_cardio_id = c.cardio_id
WHERE b.bloodpressure > 140
  AND c.cardioarrestdetected = 1
GROUP BY m.gender;


-- query 47
-- Get the average blood pressure of people aged between 40-50 and 50-60.

SELECT
    CASE
        WHEN m.age BETWEEN 40 AND 49 THEN '40-50'
        WHEN m.age BETWEEN 50 AND 59 THEN '50-60'
    END AS age_group,
    AVG(b.bloodpressure) AS average_blood_pressure
FROM memberinfo m
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
JOIN bloodtest b
    ON b.cardiodiagnosis_cardio_id = c.cardio_id
WHERE m.age BETWEEN 40 AND 59
  AND b.bloodpressure IS NOT NULL
GROUP BY age_group
ORDER BY age_group;


SELECT
    AVG(b.bloodpressure) FILTER (WHERE m.age BETWEEN 40 AND 49) AS "40-50",
    AVG(b.bloodpressure) FILTER (WHERE m.age BETWEEN 50 AND 59) AS "50-60"
FROM memberinfo m
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
JOIN bloodtest b
    ON b.cardiodiagnosis_cardio_id = c.cardio_id
WHERE b.bloodpressure IS NOT NULL;




-- query 48
-- Get the list of diseases for people with high blood pressure in the range of 120-180, sorted by gender.

SELECT
    m.member_id,
    m.firstname,
    m.lastname,
    m.gender,

    d.disease_id,
    d.diagnoseddate,
    d.recovereddate,
    d.isrecovered,

    b.bloodpressure
FROM memberinfo m
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
JOIN bloodtest b
    ON b.cardiodiagnosis_cardio_id = c.cardio_id
JOIN diseasedetail d
    ON d.cardiodiagnosis_cardio_id = c.cardio_id
WHERE b.bloodpressure BETWEEN 120 AND 180
ORDER BY m.gender;



-- query 49
--  Get the count of people who have had their X-rays every month from the state of "Special Province". 


SELECT
    DATE_TRUNC('month', x.date) AS month,
    COUNT(DISTINCT m.member_id) AS total_people
FROM memberinfo m
JOIN addressinfo a
    ON m.member_id = a.memberinfo_member_id
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
JOIN xray x
    ON x.cardiodiagnosis_cardio_id = c.cardio_id
WHERE a.state = 'Special Provinces'
GROUP BY DATE_TRUNC('month', x.date)
ORDER BY month;



-- query 50
-- Get the average age of people diagnosed with a heart attack for each state, broken down by male and female. 

SELECT
    a.state,
    m.gender,
    AVG(m.age) AS average_age
FROM memberinfo m
JOIN addressinfo a
    ON m.member_id = a.memberinfo_member_id
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
WHERE c.cardioarrestdetected = 1
  AND m.age IS NOT NULL
  AND m.gender IS NOT NULL
GROUP BY a.state, m.gender
ORDER BY a.state, m.gender;


-- query 51
-- Get the count of people for each state diagnosed with a heart attack, who have a slope value of 2, 
-- and have had at least one X-ray and one symptom.


SELECT
    a.state,
    COUNT(DISTINCT m.member_id) AS total_people
FROM memberinfo m
JOIN addressinfo a
    ON m.member_id = a.memberinfo_member_id
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
JOIN wearabledevicedata w
    ON w.cardiodiagnosis_cardio_id = c.cardio_id
WHERE c.cardioarrestdetected = 1
  AND w.slope = 2
  AND EXISTS (
        SELECT 1
        FROM xray x
        WHERE x.cardiodiagnosis_cardio_id = c.cardio_id
  )
  AND EXISTS (
        SELECT 1
        FROM symptom s
        WHERE s.cardiodiagnosis_cardio_id = c.cardio_id
  )
GROUP BY a.state
ORDER BY a.state;



