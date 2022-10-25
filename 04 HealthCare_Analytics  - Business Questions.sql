/*
Business Questions

01. How many unique users exist in the logs dataset?
02. How many total measurements do we have per user on average?
03. What about the median number of measurements per user?
04. How many users have 3 or more measurements?
05. How many users have 1,000 or more measurements?

	Looking at the logs data - what is the number and percentage of the active user base who:

06. Have logged blood glucose measurements?
07. Have at least 2 types of measurements?
08. Have all 3 measures - blood glucose, weight and blood pressure?

	For users that have blood pressure measurements:

09. What is the median systolic/diastolic blood pressure values?
*/

-- 01 How many unique users exists in the logs dataset ?

select 
  distinct(id)
from health.user_logs;

-- 02 How many total measurements do we have per user on average rounded to the nearest integer?

DROP TABLE IF EXISTS user_measure_cont;
CREATE temporary TABLE user_measure_cont as
SELECT
    id,
    COUNT(*) AS measure_count,
    COUNT(DISTINCT measure) as unique_measures
FROM health.user_logs
GROUP BY id; 
  
  
  Select * from health.user_logs;
  SELECT
  ROUND(MEAN(measure_count),2)
FROM user_measure_cont;

-- 3. What about the median number of measurements per user?

SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY measure_Count) AS median_value
FROM user_measure_cont;

-- 4. How many users have 3 or more measurements?

SELECT
 count(*)
  FROM user_measure_cont
where measure_count >= 3;

-- 5. How many users have 1,000 or more measurements?

SELECT
  count(id)
FROM user_measure_cont
WHERE measure_count >= 1000;

-- 06. How many users have logged blood glucose measurements?

SELECT
  COUNT(DISTINCT id)
FROM health.user_logs
WHERE measure = 'blood_glucose';

-- 07 Have at least 2 types of measurements?

SELECT
  COUNT(*)
FROM user_measure_cont
WHERE unique_measures >= 3;


-- 08 Have all 3 measures - blood glucose, weight and blood pressure?
SELECT
  COUNT(*)
FROM user_measure_cont
WHERE unique_measures >= 3;

-- 09 What is the median systolic/diastolic blood pressure values?
SELECT
  PERCENTILE_CONT(0.5) WITHIN Group (ORDER BY systolic) AS median_systolic,
  PERCENTILE_CONT(0.5) WITHIN Group (ORDER BY diastolic) AS median_diastolic
FROM health.user_logs
WHERE measure = 'blood_pressure';
