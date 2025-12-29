-- query 11
--  Get all address details for member ID M303.

SELECT 
    address_id,
    city,
    state,
    country,
    pincode
FROM addressinfo
WHERE memberinfo_member_id = 'M303';


-- query 12
-- Get all X-ray details for cardio ID CID122.

SELECT 
    xray_id,
    date AS xray_date,
    ca,
    cardiodiagnosis_cardio_id
FROM xray
WHERE cardiodiagnosis_cardio_id ILIKE 'CID122';


-- query 13
-- Get all symptom details whose cardio ID is CID250 and CID300.

SELECT 
    symptom_id,
    date AS symptom_date,
    exang,
    oldpeak,
    cp,
    cardiodiagnosis_cardio_id
FROM symptom
WHERE 
cardiodiagnosis_cardio_id ILIKE ANY (ARRAY['CID250', 'CID300']);


-- query 14
-- Get all symptom details for the month of July and year 2019.

SELECT
    symptom_id,
    date AS symptom_date,
    exang,
    oldpeak,
    cp,
    cardiodiagnosis_cardio_id
FROM symptom
WHERE date::date >= '2019-07-01'
  AND date::date <  '2019-08-01';



-- query 15
--  Get X-ray details for the member with the last name "Dailley". 

SELECT
    x.xray_id,
    x.date AS xray_date,
    x.ca,
    c.cardio_id,
    m.member_id,
    m.firstname,
    m.lastname
FROM memberinfo m
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
JOIN xray x
    ON x.cardiodiagnosis_cardio_id = c.cardio_id
WHERE m.lastname ILIKE 'Dailley';



-- query 16
-- Get wearable device data details for cardio IDs between CID100 and CID200. 

SELECT
    wearable_device_id,
    thalach,
    slope,
    date AS wearable_date,
    cardiodiagnosis_cardio_id
FROM wearabledevicedata
WHERE cardiodiagnosis_cardio_id BETWEEN 'cid100' AND 'cid200';



-- query 17
--  Display all cardio diagnosis details where the first name starts with the letter "A". 

SELECT
    c.cardio_id,
    c.cardioarrestdetected,
    c.date AS diagnosis_date,
    c.memberinfo_member_id,
    m.firstname,
    m.lastname
FROM memberinfo m
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
WHERE m.firstname ILIKE 'A%';


-- query 18
-- Display all cardio diagnosis details where the first name starts with "A" and ends with "A". 
SELECT
    c.cardio_id,
    c.cardioarrestdetected,
    c.date AS diagnosis_date,
    c.memberinfo_member_id,
    m.firstname,
    m.lastname
FROM memberinfo m
JOIN cardiodiagnosis c
    ON m.member_id = c.memberinfo_member_id
WHERE m.firstname ILIKE 'A%A';


-- query 19
-- Get all the members from the MemberInfo table. 

SELECT
    member_id,
    username,
    firstname,
    lastname,
    age,
    gender,
    email,
    phonenumber
FROM memberinfo;


-- query 20
-- Get all the addresses of members.

SELECT
    address_id,
    city,
    state,
    country,
    pincode,
    memberinfo_member_id
FROM addressinfo;


