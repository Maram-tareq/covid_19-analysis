-- To avoid any errors, check missing value / null value      ------------[DONE]

select  * from [Corona Virus Dataset]

-- Q1. Write a code to check NULL values    ------------[DONE]

select * from [Corona Virus Dataset]
where Province is null or Country_Region is null 
or Latitude is null or Longitude is null or Date is null
or Confirmed is null or Deaths is null or Recovered is null  


--Q2. If NULL values are present, update them with zeros for all columns.    ------------[DONE]

update [Corona Virus Dataset]  set
date= coalesce(date,'0000-00-00'),
Province=coalesce(Province,'0'),
Country_Region=coalesce(Country_Region,'0'),
Latitude=coalesce(Latitude,'0'),
Longitude=coalesce(Longitude,'0'),
Confirmed=coalesce(Confirmed,0),
Deaths=coalesce(Deaths,0),
Recovered=coalesce(Recovered,0)


-- Q3. check total number of rows    ------------[DONE]

select COUNT(*) as Total_number_of_rows from [Corona Virus Dataset]

-- Q4. Check what is start_date and end_date    ------------[DONE]

select min(date) as start_date,
max(date) as end_date 
from [Corona Virus Dataset] 

-- Q5. Number of month present in dataset    ------------[DONE]
 -- dividing the date into 

 SELECT count(DISTINCT CONCAT(year(date),month(date))) AS Number_of_months    
 FROM [Corona Virus Dataset];

--WITH DateDivided (date, year,month,day) AS (
--  SELECT date,
--         YEAR(date) AS year,
--         MONTH(date) AS month,
--		 DAY(date) AS day
--  FROM [Corona Virus Dataset]
--)

--SELECT count(DISTINCT CONCAT(year,month)) AS Number_of_months
--FROM DateDivided;


-- Q6. Find monthly average for confirmed, deaths, recovered ------------[DONE]

SELECT
  year(date) as year,
  month(date) as month,
  AVG(confirmed) AS avg_confirmed,  
  AVG(deaths) AS avg_deaths,          
  AVG(recovered) AS avg_recovered   
FROM [Corona Virus Dataset] 
GROUP BY year(date), month(date)
ORDER BY year(date), month(date);

--WITH DateDivided (date, year, month) AS (
--  SELECT date,
--         YEAR(date) AS year,
--         MONTH(date) AS month
--  FROM [Corona Virus Dataset]
--)
--SELECT
--  de.year,
--  de.month,
--  AVG(CAST(c.confirmed AS bigint)) AS avg_confirmed,  -- Change to larger data type (e.g., bigint, decimal)
--  AVG(CAST(c.deaths AS bigint)) AS avg_deaths,          -- Change to larger data type (e.g., bigint, decimal)
--  AVG(CAST(c.recovered AS bigint)) AS avg_recovered     -- Change to larger data type (e.g., bigint, decimal)
--FROM DateDivided  AS de
--INNER JOIN [Corona Virus Dataset] AS c ON de.date = c.date
--GROUP BY de.year, de.month
--ORDER BY de.year, de.month;


-- Q7. Find most frequent value for confirmed, deaths, recovered each month 

WITH cte AS (
SELECT 
    month(date) as month,year(date) as year
  , confirmed,deaths,recovered
  , ROW_NUMBER() OVER (PARTITION BY month(date),year(date) 
  ORDER BY COUNT(confirmed) DESC,count(recovered) desc,count(deaths) desc) rn
FROM [Corona Virus Dataset]
GROUP BY
  month(date),year(date),
  confirmed,recovered,deaths)
SELECT
    month,year,
    confirmed,recovered,deaths
FROM cte WHERE rn = 1
order by year,month

WITH cte AS (
SELECT 
    month(date) as month,year(date) as year
  , confirmed
  , ROW_NUMBER() OVER (PARTITION BY month(date),year(date) ORDER BY COUNT(confirmed) DESC) rn
FROM [Corona Virus Dataset]
GROUP BY
  month(date),year(date),
  confirmed)

SELECT
    month,year,
    confirmed
FROM cte WHERE rn = 1
order by year,month

WITH cte AS (
SELECT 
    month(date) as month,year(date) as year
  , recovered
  , ROW_NUMBER() OVER (PARTITION BY month(date),year(date) ORDER BY COUNT(recovered) DESC) rn
FROM [Corona Virus Dataset]
GROUP BY
  month(date),year(date),
  recovered)

SELECT
    month,year,
    recovered
FROM cte WHERE rn = 1
order by year,month

WITH cte AS (
SELECT 
    month(date) as month,year(date) as year
  , deaths
  , ROW_NUMBER() OVER (PARTITION BY month(date),year(date) ORDER BY COUNT(deaths) DESC) rn
FROM [Corona Virus Dataset]
GROUP BY
  month(date),year(date),
  deaths)

SELECT
    month,year,
    deaths
FROM cte WHERE rn = 1
order by year,month






WITH cte AS (
  SELECT
    month(date) AS month,year(date) AS year,confirmed,deaths,recovered,
    DENSE_RANK() OVER (PARTITION BY month(date), year(date) ORDER BY confirmed DESC, deaths DESC, recovered DESC) AS rn
  FROM [Corona Virus Dataset]
  GROUP BY
    month(date),
    year(date),
    confirmed,
    recovered,
    deaths)
SELECT
  month,year,confirmed,recovered,deaths
FROM cte
WHERE rn = 1
ORDER BY year, month;

-- Q8. Find minimum values for confirmed, deaths, recovered per year      ------------[DONE]


select year(date) as year,min(Confirmed) as minConfirmed,
min(deaths) as minDeaths,
min(recovered) as minRecoverd 
from [Corona Virus Dataset]  
group by year(date) 

-- Q9. Find maximum values of confirmed, deaths, recovered per year     ------------[DONE]

select year(date) as year,max(Confirmed) as maxConfirmed,
max(deaths) as maxDeaths ,
max(recovered) as maxRecovered 
from [Corona Virus Dataset] 
group by year(date) 

-- Q10. The total number of case of confirmed, deaths, recovered each month        ------------[DONE]

select month(date) as month,year(date) as year,
sum(confirmed) as total_case_confirmed,
sum(deaths) as total_deaths,
sum(recovered) as total_recovered
from [Corona Virus Dataset] 
group by year(date),month(date)
order by year(date),month(date)

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
select year(date) as year,month(date) as month,
sum(confirmed) as totalConfirmed,
avg(confirmed) as avgConfirmed,
round(STDEV(confirmed),2)as stdConfirmed,
round(var(confirmed),2) as varianceConfirmed
from [Corona Virus Dataset]
group by year(date),month(date)
order by year(date),month(date)


-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
select year(date) as year ,month(date) as month,
sum(deaths) as totalDeaths,
avg(deaths) as avgDeaths,
round(var(deaths),2) as varianceDeaths,
round(STDEV(deaths),2)as stdDevDeaths
from [Corona Virus Dataset]
group by year(date),month(date)
order by year(date),month(date)
-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

select year(date) as year ,month(date) as month,
sum(recovered) as totalRecovered,
avg(recovered) as avgRecovered,
round(var(recovered),2) as varianceRecoverd,
round(STDEV(recovered),2)as stdDevRecoverd
from [Corona Virus Dataset]
group by year(date),month(date)
order by year(date),month(date)

-- Q14. Find Country having highest number of the Confirmed case     ------------[DONE]

select top 1 Country_Region,
sum(confirmed) as numberOfConfirmed
from [Corona Virus Dataset]
group by Country_Region
order by sum(Confirmed) desc;

-- Q15. Find Country having lowest number of the death case       ------------[DONE]

select top 1 Country_Region,
sum(Deaths) as numberOfDeaths
from [Corona Virus Dataset]
group by Country_Region
order by sum(Deaths) asc;


-- Q16. Find top 5 countries having highest recovered case     ------------[DONE]

select top 5 Country_Region,
sum(Recovered) AS TotalRecoverd 
from [Corona Virus Dataset]
group by Country_Region
order by sum(Recovered) desc ;



