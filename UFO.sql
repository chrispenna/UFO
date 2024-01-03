-- All Data
SELECT * FROM [dbo].[complete]

-- USA States with the most UFO sightings
SELECT DISTINCT state AS State, COUNT(*) AS Sightings
FROM complete
WHERE COUNTRY = 'US' AND STATE IS NOT NULL
GROUP BY state
ORDER BY Sightings DESC

-- Year Range
SELECT DISTINCT YEAR(datetime) AS YEAR, COUNT(*) AS sightings
FROM complete
GROUP BY YEAR(datetime)
ORDER BY YEAR DESC

-- PCT Change per Year
WITH YearlyCounts AS (
    SELECT
        YEAR(datetime) AS Year,
        COUNT(*) AS Sightings
    FROM complete
    GROUP BY Year(datetime)
)
SELECT
    Year,
    Sightings,
    LAG(Sightings) OVER (ORDER BY Year) AS PrevYearSightings,
    CASE
        WHEN LAG(Sightings) OVER (ORDER BY Year) IS NOT NULL
        THEN CONCAT(SIGN(Sightings - LAG(Sightings) OVER (ORDER BY Year)) * CAST(ABS((Sightings - LAG(Sightings) OVER (ORDER BY Year)) * 100.0 / NULLIF(LAG(Sightings) OVER (ORDER BY Year), 0)) AS DECIMAL(10, 2)), '%')
        ELSE NULL
    END AS PctChange
FROM YearlyCounts
ORDER BY Year DESC;

-- Month
SELECT MONTH(datetime) AS Month, COUNT(*) AS Sightings
FROM complete
GROUP BY MONTH(datetime)
ORDER BY 1

-- Time of day
SELECT DATEPART(HOUR, datetime) AS Hour, COUNT(*) AS Sightings
FROM complete
GROUP BY DATEPART(HOUR, datetime)
ORDER BY 1;

-- City
SELECT DISTINCT city AS City, COUNT(*) AS Sightings
FROM complete
WHERE COUNTRY = 'US' AND city IS NOT NULL
GROUP BY city
ORDER BY Sightings DESC

-- Description
SELECT DISTINCT shape AS Shape, COUNT(*) AS Description
FROM complete
WHERE shape IS NOT NULL
GROUP BY shape
ORDER BY 2 DESC

-- 2014 Latitude and Longitude for map
SELECT latitude, longitude
FROM complete
WHERE YEAR(datetime) = 2014 AND latitude <> 0 AND longitude <> 0;
