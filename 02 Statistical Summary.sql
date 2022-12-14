-- Summary Statistical Analysis on Health Care Analysis
-- Centeral Tendancy (Average ,Mean & Mode) -- Try Shift + enter for auto adujstment of text

Select
    Measure,
    avg(measure_value) as Avg_MeasureValue -- Weight,Blood_Glucose & Bloood Pressure
From health.user_logs
group by measure;

-- Spread Statistics
-- Min , Max, range(Min - Max)

Select
    avg(measure_value) as Avg_Weight,
    Percentile_Cont(0.5) within Group (Order BY measure_value) as median_Weight,
    Mode() within Group (Order By measure_value) as Mode_Weight,
    Min(measure_value) as Min_Weight,
    Max(measure_value) as Max_Weight,
    Max(measure_value) - Min(measure_value) as Weight_Range
From health.user_logs
where measure = 'weight'
 
-- Analysing Weight Top 20 asc weights and desc Weights to understand dataissue if any 

Select 
    measure_value
From health.user_logs
where measure ='weight'
order by measure_value asc
Limit 20;

-- Selection of proper data by using various and filter to remove abormal dataentry

Select
    avg(measure_value) as Avg_Weight,
    Percentile_Cont(0.5) within Group (Order BY measure_value) as median_Weight,
    Mode() within Group (Order By measure_value) as Mode_Weight,
    Min(measure_value) as Min_Weight,
    Max(measure_value) as Max_Weight,
    Max(measure_value) - Min(measure_value) as Weight_Range
From health.user_logs
where measure = 'weight'
  and measure_value >0
  and measure_value <201;
  
-- Doing Same Filter Process Using Between Function

Select
    avg(measure_value) as Avg_Weight,
    Percentile_Cont(0.5) within Group (Order BY measure_value) as median_Weight,
    Mode() within Group (Order By measure_value) as Mode_Weight,
    Min(measure_value) as Min_Weight,
    Max(measure_value) as Max_Weight,
    Max(measure_value) - Min(measure_value) as Weight_Range
From health.user_logs
where measure = 'weight'
  and measure_value between 1 and 201;
  

-- Variance & Standard Deviation (Helping in Identifying Outliers)
-- Variance is Square root of Standard Deviation 
-- Standard Deviation is distance from mean


Select
    Variance(measure_value) as Variance_Weight,
    Stddev(measure_value) as Stddev_Weight,
    avg(measure_value) as Avg_Weight,
    Percentile_Cont(0.5) within Group (Order BY measure_value) as median_Weight,
    Mode() within Group (Order By measure_value) as Mode_Weight,
    Min(measure_value) as Min_Weight,
    Max(measure_value) as Max_Weight,
    Max(measure_value) - Min(measure_value) as Weight_Range
From health.user_logs
where measure = 'weight'
  and measure_value between 1 and 201;


-- Using Round Function to bring Decimal in 2 digits

Select
    Round(Variance(measure_value),2) as Variance_Weight,
    Round(Stddev(measure_value),2) as Stddev_Weight,
    Round(avg(measure_value),2) as Avg_Weight,
    Percentile_Cont(0.5) within Group (Order BY measure_value) as median_Weight,
    Mode() within Group (Order By measure_value) as Mode_Weight,
    Min(measure_value) as Min_Weight,
    Max(measure_value) as Max_Weight,
    Max(measure_value) - Min(measure_value) as Weight_Range
From health.user_logs
where measure = 'weight'
  and measure_value between 1 and 201;