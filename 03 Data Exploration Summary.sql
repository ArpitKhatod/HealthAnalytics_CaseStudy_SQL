-- Data Exploration Summary

-- Inspecting Row Counts

Select 
  Count(*) as row_count
From health.user_logs;

-- check Distribution of Duplicates & Record Frequency

Select
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic,
count(*) as frequency
from health.user_logs
Group By
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic;
    
-- Single Coumn Frequency Counts

Select
  measure,
  count(*) as Frequency,
  Round (
    100* count(*) / sum(count(*)) over(),
    2  
  ) as Percentage
From health.user_logs
Group by  measure
Order by frequency DESC;

-- Summary Statistics

Select
  'weight' as measure,
  Round(min(measure_value),2) as minimum_value,
  Round(min(measure_value),2) as maximum_value,
  Round(avg(measure_value),2) as mean_value,
  Round(
    -- this function isn' compatible
    -- we will be using cast function to convert output to numerical
    
    Cast(Percentile_cont(0.5) within group (order by measure_value) as Numeric),2
  ) As median_value,
  Round(
    Mode() within group(order by measure_value),
    2
    ) As mode_value,
    Round (Stddev(measure_value),2) as Standard_deviation,
    Round (Variance(measure_value),2) as Variance_Value
  From health.user_logs
  where measure = 'weight';
  
-- Check Cumulative Distributions

WITH percentile_values As (
  Select
    measure_value,
    NTILE(100) over (
      order by 
        measure_value
    ) as Percentile
  From health.user_logs
  Where measure = 'weight'
  )
  Select
    percentile,
    min(measure_value) as floor_value,
    Max(measure_value) as ceiling_value,
    Count(*) as percentile_counts
  From percentile_values
  Group By Percentile
  order by percentile;
  
-- Investigation of Large Outliers at End Ranges

with percentile_values as(
  select
    measure_value,
    NTILE(100) OVER (
      Order BY measure_value
    ) as percentile
  From health.user_logs
  where measure = 'weight'
)
Select
  measure_value,
  Row_number() Over(Order By measure_value DESC) as row_number_order,
  Rank() over (order by measure_value desc) as rank_order,
  Dense_rank() over (Order By measure_value desc) as dense_rank_order
From Percentile_values
Where Percentile = 100
Order By measure_value Desc

-- Investigation of Small Outliers

WITH percentile_value as (
    Select 
      measure_value,
      NTILE(100) Over (
        Order By
          measure_value
      ) as Percentile
    From health.user_logs
    Where measure ='weight'
)
Select
  measure_value,
  Row_Number() Over (order by measure_value) as Row_number_order,
  Rank() Over (Order By measure_value) as rank_order,
  Dense_Rank() Over (Order By measure_value) as dense_rank_order
from percentile_value
where percentile =1
order by measure_value;

-- Remove Outliers & Create Temp Table

Drop Table If Exists Clean_weight_logs;
Create temporary Table Clean_weight_logs as (
    Select * 
    from health.user_logs
    where measure ='weight'
      and measure_value>0
      and measure_value <201
);

Select
  *
From Clean_weight_logs
limit 5;

-- Frequency Distribution

Select
  Width_Bucket(measure_value,0,200,50) as bucket,
  Avg(measure_value) as measure_value,
  Count(*) as frequency
From health.user_logs
where measure = 'weight'
group by bucket
order by bucket;
