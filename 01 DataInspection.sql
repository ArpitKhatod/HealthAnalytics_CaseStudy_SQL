Using Health Care Data Doing Data_Analysis

-- Count no. of Columns 
select count(*) as count from health.user_logs;


-- 
select
  Measure,
  Count(*) as frequency
From health.user_logs
group by measure;


-- Find the number of unique customers
Select Count(Distinct id)
from health.user_logs;

-- Find top 10 Customers by record country
Select id,
      Count(*) as RowCount
From Health.user_logs
Group by id
order by RowCount desc;

--Inspecting the data where measure_value = 0 

select * from health.user_logs
where measure_value = 0;

select 
  measure,
  count(*)
from health.user_logs
where measure_value=0
group by measure
order by count desc;

-- Inspecting Where measure_value could be null

select count(*) 
from health.user_logs
where measure_value =0 or 
measure_value IS Null;

-- Inspecting Null or 0 in Systolic 


select
        count(*) as RowCount
from health.user_logs
where systolic = 0
or systolic IS NULL;

--Identification of DistinctID in health Data Set

select
  count(distinct id)
From health.user_logs;

-- Common Table Expression CTE 
with CTE_logs as (
  Select Distinct *
  From health.user_logs
)

SELECT COUNT(*)
FROM CTE_Logs;

select count(*)
From health.user_logs;

select count(id) - count(Distinct ID)
from health.user_logs; 

-- another way to calculate distinct ID
Select
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic,
  count(*) as Record_Count
from health.user_logs
group by 
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic
order by record_count Desc;