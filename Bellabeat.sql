select DISTINCT Id
from Bellabeat..dailyActivity

-- Numbers of unique users
SELECT COUNT
  (DISTINCT Id )
FROM Bellabeat..dailyActivity


-- Active user of the Fit tracker
SELECT 
	Id, COUNT(Id) AS Total_Uses,
	CASE
	WHEN 
		COUNT(Id) BETWEEN 21 AND 31 THEN 'Active User'
	WHEN 
		COUNT(Id) BETWEEN 11 and 20 THEN 'Casual User'
	WHEN 
		COUNT(Id) BETWEEN 0 and 10 THEN 'Minimal User'
	END Fitbit_Usage_Type
FROM 
	Bellabeat..dailyActivity
GROUP BY 
	Id

-- Total Steps vs Minutes Asleep
WITH temp_table AS (
SELECT
  DISTINCT dailyActivity.Id AS Id,
  AVG(dailyActivity.TotalSteps) AS TotalSteps
FROM
  Bellabeat..dailyActivity AS dailyActivity
GROUP BY
  Id
--ORDER BY
  --TotalSteps DESC
)
SELECT
  temp_table.Id,
  temp_table.TotalSteps,
  AVG(Sleep.TotalMinutesAsleep) AS TotalMinutesAsleep
FROM
  temp_table
INNER JOIN
 Bellabeat..sleepDay_merged AS Sleep
ON
  Sleep.Id = temp_table.Id
GROUP BY
  temp_table.Id,
  temp_table.TotalSteps
ORDER BY
  temp_table.TotalSteps DESC


-- Meets WHO recommendation of active minutes a week

SELECT Id,
avg(VeryActiveMinutes) + avg(FairlyActiveMinutes) AS  Vigorous_Active_Minutes,
avg(LightlyActiveMinutes) AS Lightly_Active_Minutes,
avg(VeryActiveMinutes) + avg(FairlyActiveMinutes) + avg(LightlyActiveMinutes) AS  Total_Active_Minutes,
CASE
WHEN avg(VeryActiveMinutes) + avg(FairlyActiveMinutes) + avg(LightlyActiveMinutes) >= 150 THEN 'Meets WHO Recommendation'
WHEN avg(VeryActiveMinutes) + avg(FairlyActiveMinutes) + avg(LightlyActiveMinutes) < 150 THEN 'Does Not Meet WHO Recommendation'
END WHO_Recommendation
FROM Bellabeat..dailyActivity
GROUP BY Id
ORDER BY (Vigorous_Active_Minutes) desc


-- Recommended steps a day  for woman
SELECT Id,
avg(TotalSteps)  AS  Average_Steps_Day,
CASE
WHEN avg(TotalSteps) < 4500 THEN 'Less than 4500'
WHEN avg(TotalSteps) >= 4500 AND avg(TotalSteps) < 7500 THEN 'Between 4500 and 7500'
WHEN avg(TotalSteps) >= 7500 THEN '7500 or more'
END Steps_Recommendation
FROM Bellabeat..dailyActivity
GROUP BY Id
ORDER BY (Average_Steps_Day) desc

