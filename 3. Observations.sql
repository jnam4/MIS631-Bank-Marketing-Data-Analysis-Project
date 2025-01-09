-- ---
-- observation
-- ---

-- ----
-- Observations 1 – Relationship between loan, housing, default and the job 
-- ----
WITH job_frequency AS (
    SELECT
        c."default",
        c.loan,
        c.housing,
        tc.y, -- Purchase outcome from Temp_Campaigns
        c.job,
        COUNT(*) AS job_count
    FROM "final"."Customers" c
    JOIN "final"."Customers_Campaigns" cc
        ON c.Customers_id = cc.Customers_id
    JOIN "final"."Temp_Campaigns" tc
        ON cc.Campaigns_id = tc.campaign -- Match campaigns to get `y`
    GROUP BY c."default", c.loan, c.housing, tc.y, c.job
),
stats AS (
    SELECT 
        c."default",
        c.loan,
        c.housing,
        tc.y, -- Purchase outcome from Temp_Campaigns
        AVG(c.balance) AS avg_balance,
        MIN(c.balance) AS min_balance,
        MAX(c.balance) AS max_balance
    FROM "final"."Customers" c
    JOIN "final"."Customers_Campaigns" cc
        ON c.Customers_id = cc.Customers_id
    JOIN "final"."Temp_Campaigns" tc
        ON cc.Campaigns_id = tc.campaign -- Match campaigns to get `y`
    GROUP BY c."default", c.loan, c.housing, tc.y
)
SELECT 
    jf."default",
    jf.loan,
    jf.housing,
    jf.y AS purchase_outcome,
    jf.job AS most_frequent_job,
    jf.job_count,
    stats.avg_balance,
    stats.min_balance,
    stats.max_balance
FROM job_frequency jf
JOIN stats
ON jf."default" = stats."default" 
   AND jf.loan = stats.loan 
   AND jf.housing = stats.housing
   AND jf.y = stats.y -- Include purchase outcome in the join
WHERE jf.job_count = (
    SELECT MAX(job_count)
    FROM job_frequency
    WHERE 
        job_frequency."default" = jf."default" AND
        job_frequency.loan = jf.loan AND
        job_frequency.housing = jf.housing AND
        job_frequency.y = jf.y
);


-- ----
-- Observation 2-Effectiveness of the Contacts of Method
-- ----
SELECT 
    contact, 
    COUNT(*) AS total_contacts,
    SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) AS successful_subscriptions,
    ROUND((SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS success_rate
FROM "final"."Temp_Campaigns"
GROUP BY contact 
ORDER BY success_rate DESC;

-- ----
-- Observation 3-Relationship between previous campaign outcome and success rate
-- ----
SELECT 
    poutcome,
    COUNT(*) AS total_contacts,
    SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) AS successful_subscriptions,
    ROUND((SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS success_rate
FROM "final"."Temp_Campaigns"
GROUP BY poutcome
ORDER BY success_rate DESC;

-- ----
-- Observation 4– Relationship between duration and the success rate of the marketing
-- ----
SELECT 
    CASE 
        WHEN duration < 100 THEN 'Short (<100 secs)'
        WHEN duration BETWEEN 100 AND 300 THEN 'Medium (100-300 secs)'
        ELSE 'Long (>300 secs)'
    END AS duration_category,
    COUNT(*) AS total_contacts,
    SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) AS successful_subscriptions,
    ROUND((SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS success_rate
FROM "final"."Temp_Campaigns"
GROUP BY duration_category
ORDER BY success_rate DESC;

