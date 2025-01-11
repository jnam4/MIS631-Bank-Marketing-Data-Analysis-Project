-- ---
-- Give customer id, and campaign id generation
-- ---
INSERT INTO "final"."Customers" (Customers_id, age, job, marital, education, "default", balance, housing, loan)
SELECT 
    row_number() OVER () + 50, -- Offset to avoid conflicts
    age, 
    job, 
    marital, 
    education, 
    "default", 
    balance, 
    housing, 
    loan
FROM "final"."Temp_Customers"
ON CONFLICT (Customers_id) DO NOTHING;

SELECT * FROM "final"."Customers";
SELECT MAX(Customers_id) AS max_id FROM "final"."Customers"; -- max customer id # of people 


INSERT INTO "final"."Campaigns" (Campaigns_id, contact, "day", "month", duration, campaign, pdays, previous, poutcome)
SELECT 
    row_number() OVER (), -- Generates sequential unique IDs
    contact, 
    "day", 
    "month", 
    duration, 
    campaign, 
    pdays, 
    previous, 
    poutcome
FROM "final"."Temp_Campaigns"
ON CONFLICT (Campaigns_id) DO NOTHING;
SELECT * FROM "final"."Campaigns";

-- ---
-- Mean, min, max, stddev for age and balance for the customers
-- ---
SELECT
    'age' AS attribute,
    COUNT(age) AS count,
    AVG(age) AS mean,
    MIN(age) AS min,
    MAX(age) AS max,
    STDDEV(age) AS stddev
FROM "final"."Customers" 
UNION ALL
SELECT
    'balance',
    COUNT(balance),
    AVG(balance),
    MIN(balance),
    MAX(balance),
    STDDEV(balance)
FROM "final"."Customers" ;

-- ---
-- Education for customers
-- ---
SELECT 
    job,
    education,
    COUNT(*) AS frequency
FROM "final"."Customers"
GROUP BY job, education
ORDER BY frequency DESC;

-- ------
-- Data Cleansing
-- -------
--a. UNKNOWN value
SELECT 
    job, 
    COUNT(*) AS frequency, 
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM "final"."Customers"), 2) AS percentage
FROM "final"."Customers"
WHERE job = 'unknown'
GROUP BY job;


UPDATE "final"."Customers"
SET job = (
    SELECT job 
    FROM "final"."Customers" 
    WHERE job != 'unknown'
    GROUP BY job
    ORDER BY COUNT(*) DESC 
    LIMIT 1
)
WHERE job = 'unknown';

--b.Outlier
WITH stats AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY balance) AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY balance) AS Q3
    FROM "final"."Customers"
)
SELECT *
FROM "final"."Customers", stats
WHERE balance < (Q1 - 1.5 * (Q3 - Q1)) OR balance > (Q3 + 1.5 * (Q3 - Q1));

DELETE FROM "final"."Customers"
WHERE balance < -500 OR balance > 10000;