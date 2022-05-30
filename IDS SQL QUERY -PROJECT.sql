----get all data from AllCountriesData table
SELECT *
FROM IDS_ALLCountries_Data
ORDER BY 1;

----get top 10 entries
SELECT TOP (10)
 *
FROM IDS_ALLCountries_Data 
ORDER BY CountryName;

---Find the total number of  Countries owing IDS
SELECT COUNT(DISTINCT CountryName) As Total_No_of_Countries
FROM IDS_ALLCountries_Data;

---select the all the entries in allCountriesMetaData table
SELECT *
FROM IDS_CountryMetaData
ORDER BY 1;

---join both tables using "Region" as the joining key to get the countries alone
SELECT TableName AS Country, Code, LendingCategory, CurrencyUnit, SeriesName, SeriesCode,Debt
FROM IDS_ALLCountries_Data AS a
JOIN IDS_CountryMetaData AS b
ON  a.Region = b.Region
ORDER BY 1;

---Create a view that we can use to store our distinct countries data for further analysis
CREATE VIEW 
DebtOwedByDistinctCountries AS
SELECT TableName AS Country, Code, LendingCategory, CurrencyUnit, SeriesName, SeriesCode,Debt
FROM IDS_ALLCountries_Data AS a
JOIN IDS_CountryMetaData AS b
ON  a.Region = b.Region
--ORDER BY 1;

---Now let us find total number of distinct countries
SELECT 
COUNT(DISTINCT Country) As Total_No_of_Countries
FROM DebtOwedByDistinctCountries;

---get the number of conutries in contienet from allcountries_data
SELECT
COUNT(DISTINCT CountryName) AS Total_NO_OF_COUNTRIES_BY_REGION, Region
FROM IDS_AllCountries_Data
GROUP BY Region;

---find the total number of only countries  in each continents.This is done by joining our debtOwedByDistinct table to allCountriesData table
SELECT 
a.Region, COUNT(DISTINCT CountryName) AS Total_No_Countries
FROM DebtOwedByDistinctCountries AS b
JOIN IDS_ALLCountries_Data AS a
ON a.SeriesCode = b.SeriesCode
WHERE Region NOT LIKE  '%an' 
AND Region NOT LIKE '%IDA'
AND Region NOT LIKE '%N/A'
AND Region NOT LIKE '%ome'
AND Region NOT LIKE '%sia'
AND Region NOT LIKE '%tion'
AND Region NOT like 'sub%'
GROUP BY a.Region
ORDER BY 1 ;

----Select the distinct indicator's name
SELECT DISTINCT SeriesCode AS distinct_series_code
FROM IDS_ALLCountries_Data
ORDER BY distinct_series_code;

----Total debt owed by country in $
SELECT ROUND(SUM (Debt)/1000000 , 2) AS Total_Debt
FROM DebtOwedByDistinctCountries;


---Continent with the highest Debt
SELECT a.region AS Continents,  ROUND(SUM(a.Debt)/1000000, 2) AS Total_Debt
FROM DebtOwedByDistinctCountries AS b
JOIN IDS_ALLCountries_Data as a
ON a.SeriesCode = b.SeriesCode
WHERE Region NOT LIKE  '%an' 
AND Region NOT LIKE '%IDA'
AND Region NOT LIKE '%N/A'
AND Region NOT LIKE '%ome'
AND Region NOT LIKE 'South%'
AND Region NOT LIKE '%tion'
AND Region NOT like 'sub%'
AND Region NOT like'%nt%'
GROUP BY a.Region
ORDER BY Total_Debt DESC;

----The country with the highest Debt
SELECT TOP 7
CountryName, SUM(Debt) AS Total_debt
FROM IDS_ALLCountries_Data
GROUP BY CountryName
ORDER BY Total_Debt DESC;

---filter out only the country in the result and get highest debt owed country
SELECT TOP 1
CountryName, ROUND(SUM(Debt)/1000000, 2) AS Total_debt
FROM IDS_ALLCountries_Data
WHERE CountryName  NOT LIKE '%IDA%'
AND CountryName NOT LIKE '%mid%'
AND CountryName NOT LIKE '%cif%'
AND CountryName NOT LIKE '%pac%'
AND CountryName NOT LIKE '%bb%'
AND CountryName NOT LIKE '%igh%'
AND CountryName NOT Like '%South Asia%'
AND CountryName NOT LIKE '%UN class%'
GROUP BY CountryName
ORDER BY 2 DESC;

---get the top 20 debt owed countries with their continent
SELECT TOP 20
CountryName, Region, ROUND(SUM(Debt)/1000000, 2) AS Total_debt
FROM IDS_ALLCountries_Data
WHERE CountryName  NOT LIKE '%IDA%'
AND CountryName NOT LIKE '%mid%'
AND CountryName NOT LIKE '%cif%'
AND CountryName NOT LIKE '%pac%'
AND CountryName NOT LIKE '%bb%'
AND CountryName NOT LIKE '%igh%'
AND CountryName NOT Like '%South Asia%'
AND CountryName NOT LIKE '%UN class%'
AND CountryName NOT LIKE '%Low inc%'
GROUP BY CountryName,Region
ORDER BY 3 DESC;

--Determine the average amount of Average debt owed by countries across all Debt indidcators(SeriesCode)

 SELECT  TOP 10
 SeriesCode, 
 SeriesName , 
 ROUND(AVG(Debt)/1000000, 2) AS Average_Debt
 FROM IDS_ALLCountries_Data
 GROUP BY SeriesName, SeriesCode
 ORDER BY Average_Debt DESC;

 --Get the avaerage amount of debt owed by African Countries across all indicators
 SELECT TOP 10
 SeriesCode, 
 SeriesName,
ROUND( AVG (Debt)/1000000, 2)AS Average_Debt
 FROM IDS_ALLCountries_Data
 WHERE Region ='Africa'
 GROUP BY SeriesName, SeriesCode
 ORDER BY Average_Debt DESC;



 ---get the region with the highest IDS debt using the GNI as the debt indicator 
SELECT Region, SeriesName, Max(Debt)
FROM IDS_ALLCountries_Data
WHERE SeriesCode = 'NY.GNP.MKTP.CD'
GROUP BY Region, SeriesName
ORDER BY MAX(Debt) DESC;

---filter down to Continents only 
SELECT Region, SeriesCode, SeriesName, MAX(Debt) AS MAX_Debt
FROM IDS_ALLCountries_Data
WHERE SeriesCode ='NY.GNP.MKTP.CD'
AND Region NOT LIKE '%N/A%'
AND Region NOT LIKE '%Low & mid%'
AND Region NOT LIKE '%Middle income%'
AND Region NOT LIKE '%latin%'
AND Region NOT LIKE '%nt%'
AND Region NOT LIKE '%South Asia%'
AND Region NOT LIKE '%sub%'
AND Region NOT LIKE '%North Africa%'
AND Region NOT LIKE '%DA%'
AND Region NOT LIKE '%Low inco%'
GROUP BY Region, SeriesCode,SeriesName
ORDER BY MAX_Debt DESC;

----Filter down to countries
SELECT CountryName,Region, SeriesCode, SeriesName, MAX(Debt) AS MAX_Debt
FROM IDS_ALLCountries_Data
WHERE SeriesCode ='NY.GNP.MKTP.CD'
AND Region NOT LIKE '%N/A%'
AND Region NOT LIKE '%Low & mid%'
AND Region NOT LIKE '%Middle income%'
AND Region NOT LIKE '%latin%'
AND Region NOT LIKE '%nt%'
AND Region NOT LIKE '%South Asia%'
AND Region NOT LIKE '%sub%'
AND Region NOT LIKE '%North Africa%'
AND Region NOT LIKE '%DA%'
AND Region NOT LIKE '%Low inco%'
GROUP BY CountryName, Region, SeriesCode,SeriesName
ORDER BY MAX_Debt DESC;

---filter down to African Countries
SELECT CountryName,Region, SeriesCode, SeriesName, MAX(Debt) AS MAX_Debt
FROM IDS_ALLCountries_Data
WHERE SeriesCode ='NY.GNP.MKTP.CD'
AND Region ='Africa'
AND Region NOT LIKE '%N/A%'
AND Region NOT LIKE '%Low & mid%'
AND Region NOT LIKE '%Middle income%'
AND Region NOT LIKE '%latin%'
AND Region NOT LIKE '%nt%'
AND Region NOT LIKE '%South Asia%'
AND Region NOT LIKE '%sub%'
AND Region NOT LIKE '%North Africa%'
AND Region NOT LIKE '%DA%'
AND Region NOT LIKE '%Low inco%'
GROUP BY CountryName, Region, SeriesCode,SeriesName
ORDER BY MAX_Debt DESC;

 ---count each debt indicator
 SELECT 
 SeriesCode,SeriesName,COUNT (SeriesCode) AS debt_code_count
 FROM IDS_ALLCountries_Data
 GROUP BY SeriesCode, SeriesName
 ORDER BY debt_code_count DESC;


  ----Countries with the most(MAX) debt across all debt_indicators(SeriesCode)
SELECT a.CountryName, a.SeriesCode, a.SeriesName, Max(a.Debt) AS Max_Debt
FROM DebtOwedByDistinctCountries AS b
JOIN IDS_ALLCountries_Data AS a
ON a.SeriesCode = b.SeriesCode
WHERE CountryName NOT LIKE '%dle%' 
AND CountryName NOT LIKE '%South Asia%'
AND CountryName NOT LIKE '%upp%'
AND CountryName NOT LIKE '%high%'
AND  CountryName NOT LIKE '%developed%'
AND Region NOT LIKE '%IDA%'
GROUP BY a.CountryName, a.SeriesCode, a.SeriesName
ORDER BY  4 DESC;

---African Countries with the least debt across all debt indicator categories
SELECT  CountryName, SeriesCode,SeriesName,Max(Debt) AS Max_Debt
FROM IDS_ALLCountries_Data
WHERE Region = 'Africa'
GROUP BY CountryName, SeriesCode, SeriesName
ORDER BY Max_Debt ;

---The Minimum debt owed by Nigeria across all indicators
SELECT TOP 10
CountryName, SeriesCode, SeriesName, Max(Debt) AS Max_Debt
FROM IDS_ALLCountries_Data
WHERE CountryName = 'Nigeria'
GROUP BY CountryName, SeriesCode, SeriesName
ORDER BY Max_Debt ;

---The maximum debt owed by Nigeria across all indicators
SELECT TOP 10
CountryName, SeriesCode, SeriesName, Max(Debt) AS Max_Debt
FROM IDS_ALLCountries_Data
WHERE CountryName = 'Nigeria'
GROUP BY CountryName, SeriesCode, SeriesName
ORDER BY Max_Debt DESC ;

----Get the lending category that gave the most debt
SELECT Country, LendingCategory, CurrencyUnit, ROUND(SUM(Debt/1000000), 2) AS Total_Debt
FROM DebtOwedByDistinctCountries
GROUP BY Country, LendingCategory, CurrencyUnit
ORDER BY Total_Debt DESC;


----get the lending category Nigeria got their most debt from

SELECT Country, CurrencyUnit,  LendingCategory,ROUND(SUM(Debt)/1000000 ,2) AS Total_debt 
FROM DebtOwedByDistinctCountries
WHERE Country ='Nigeria'
GROUP BY Country, CurrencyUnit, LendingCategory
ORDER BY Total_debt DESC;


----get the lending category that gave the most debt in african Countries
SELECT a.Country,a.CurrencyUnit,a.LendingCategory, ROUND(SUM(b.Debt)/1000000, 2) AS Total_debt
FROM DebtOwedByDistinctCountries AS a
JOIN IDS_ALLCountries_Data  AS b
ON a.Country = b.CountryName
WHERE b.Region = 'Africa'
GROUP BY a.Country, a.LendingCategory, a.CurrencyUnit
ORDER BY Total_debt DESC




