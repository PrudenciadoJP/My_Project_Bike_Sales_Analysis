DROP TABLE IF EXISTS bike_sale_explanatory_analysis;
CREATE TABLE bike_sale_explanatory_analysis
LIKE bike_sale_staging;

INSERT INTO bike_sale_explanatory_analysis
SELECT * FROM bike_sale_staging;

DELIMITER //
CREATE PROCEDURE select_bike_sale_explanatory_analysis()
BEGIN
	SELECT * FROM bike_sale_explanatory_analysis;
END //
DELIMITER ;

-- Table Analysis
-- Demographics
-- What is the gender distribution across the dataset?
SELECT 	gender,
		COUNT(gender) AS count_gender
FROM bike_sale_explanatory_analysis
WHERE gender IS NOT NULL
GROUP BY gender;
-- Female	501
-- Male	525

-- What is the age range of customers in each marital status category?
SELECT `Marital Status`,
		MIN(Age) AS 'Min Age',
		MAX(Age) AS 'Max Age',
		AVG(Age) AS 'Average Age'
FROM bike_sale_explanatory_analysis
GROUP BY `Marital Status`;
-- Married	25	89	46.3570
-- Single	25	78	41.5849

-- Purchasing Trends
-- What percentage of each demographic group (e.g., Gender, Marital Status) purchased a bike?
WITH cte AS (
	SELECT 	gender,
		COUNT(gender) AS total_customer,
        COUNT(CASE WHEN `Purchased Bike` = 'Yes' THEN 1 END) AS Num_Purchased_Bike
	FROM bike_sale_explanatory_analysis
	GROUP BY gender
)
	SELECT 	gender,
			total_customer,
			Num_Purchased_Bike,
			ROUND(((Num_Purchased_Bike / total_customer) * 100), 2) AS Percentage_Purchased_Gender 
    FROM cte;
    
WITH cte AS (
	SELECT 	`Marital Status`,
		COUNT(`Marital Status`) AS total_customer,
        COUNT(CASE WHEN `Purchased Bike` = 'Yes' THEN 1 END) AS Num_Purchased_Bike
	FROM bike_sale_explanatory_analysis
	GROUP BY `Marital Status`
)
	SELECT 	`Marital Status`,
			total_customer,
			Num_Purchased_Bike,
			ROUND(((Num_Purchased_Bike / total_customer) * 100), 2) AS Percentage_Purchased_MaritalStatus
    FROM cte;

-- Is there a trend in bike purchases across different income brackets?
-- Yes Male intend to buy more bike than female customer
-- Single intend to buy more bike than married customer

-- Regional Insights
-- Which region has the highest proportion of bike buyers?
SELECT 	Region,
		COUNT(`Purchased Bike`) AS bike_purchased
FROM bike_sale_explanatory_analysis
WHERE `Purchased Bike` = 'Yes'
GROUP BY Region;
-- Pacific	119
-- Europe	156
-- North America	220
-- North America has the highest proportion of bike buyers

-- How does commute distance vary by region?
SELECT 	Region,
		MIN(`Commute Distance`) AS min_commute_distance,
		MAX(`Commute Distance`) AS max_commute_distance,
		ROUND(AVG(`Commute Distance`), 2) AS avg_commute_distance
FROM bike_sale_explanatory_analysis
GROUP BY Region;
-- Europe	0-1 Miles	More Than 10 Miles	0.67
-- Pacific	0-1 Miles	More Than 10 Miles	2.05
-- North America	0-1 Miles	More Than 10 Miles	1.69

-- Financial Analysis
-- What is the income distribution of customers who purchased a bike versus those who didn’t?
SELECT `Purchased Bike`,
		MIN(Income) AS min_income,
		MAX(Income) AS max_income,
        AVG(Income) AS avg_income,
        ROUND(STDDEV(Income)) AS standard_dev_income
FROM bike_sale_explanatory_analysis
GROUP BY `Purchased Bike`;

-- Median 
WITH RankedData AS (
    SELECT 
        `Purchased Bike`, 
        Income,
        ROW_NUMBER() OVER (PARTITION BY `Purchased Bike` ORDER BY Income) AS RowNum,
        COUNT(*) OVER (PARTITION BY `Purchased Bike`) AS TotalCount
    FROM bike_sale_explanatory_analysis
),
	median AS ( 
SELECT `Purchased Bike`,
		AVG(Income) AS MedianIncome
FROM RankedData AS rd
WHERE RowNum IN (FLOOR((TotalCount + 1) / 2), CEIL((TotalCount + 1) / 2))
GROUP BY rd.`Purchased Bike`
)
	SELECT b.`Purchased Bike`,
		MIN(b.Income) AS min_income,
		MAX(b.Income) AS max_income,
        AVG(b.Income) AS avg_income,
        ROUND(STDDEV(Income)) AS standard_dev_income,
        m.MedianIncome
FROM bike_sale_explanatory_analysis AS b
INNER JOIN median AS m
ON b.`Purchased Bike` = m.`Purchased Bike`
GROUP BY b.`Purchased Bike`;

-- Does owning a car affect the likelihood of purchasing a bike?
WITH cte AS (
SELECT `Purchased Bike`,
	CASE 	WHEN cars = 0 THEN 'No Cars'
			WHEN cars >= 1 THEN 'Have Cars'
	END AS cars
FROM bike_sale_explanatory_analysis
)
	SELECT `Purchased Bike`,
			cars,
            COUNT(*) AS num_of_customer
    FROM cte
    GROUP BY `Purchased Bike`, cars
    ORDER BY num_of_customer DESC;
-- owning a car does affect the likelihood of purchasing a bike

-- Lifestyle Factors
-- How does the number of children influence bike purchases?
WITH cte AS (
SELECT `Purchased Bike`,
	CASE 	WHEN Children = 0 THEN 'No children'
			WHEN Children >= 1 THEN 'Have children'
	END AS children
FROM bike_sale_explanatory_analysis
)
	SELECT  `Purchased Bike`,
			children,
            num_of_purchased,
            ROUND((num_of_purchased / SUM(num_of_purchased) OVER (PARTITION BY children)) * 100,2) AS percentage
    FROM (SELECT `Purchased Bike`,
			children,
            COUNT(*) AS num_of_purchased
    FROM cte
    GROUP BY `Purchased Bike`, children
    ORDER BY `Purchased Bike` DESC) AS temp;
-- No	Have children	388
-- Yes	Have children	349
-- Yes	No children	146
-- No	No children	143
-- Having children does influence bike purchases


-- What commute distances are most common among bike purchasers?
SELECT `Commute Distance`,
		COUNT(`Purchased Bike`) AS num_purchased
FROM bike_sale_explanatory_analysis
WHERE `Purchased Bike` = 'Yes'
GROUP BY `Commute Distance`
ORDER BY num_purchased DESC;
-- 0-1 Miles are the most common among bike purchasers
-- 0-1 Miles	207
-- 2-5 Miles	95
-- 1-2 Miles	83
-- 5-10 Miles	77
-- More Than 10 Miles	33

-- Education and Occupation
-- What is the relationship between education level and bike purchases?
WITH cte AS (
SELECT 	Education,
		COUNT(CASE WHEN `Purchased Bike` = 'Yes' THEN 1 END) AS BikePurchases,
        COUNT(CASE WHEN `Purchased Bike` = 'No' THEN 1 END) AS NoBikePurchases
FROM bike_sale_explanatory_analysis
GROUP BY Education
)
	SELECT 	Education,
			BikePurchases,
            NoBikePurchases,
            BikePurchases + NoBikePurchases AS sum_customer,
            ROUND((BikePurchases / (BikePurchases + NoBikePurchases) * 100),2) AS PurchasedPercentage
	FROM cte 
    GROUP BY Education, BikePurchases, NoBikePurchases;
 -- Bachelor tends to buy more bikes 
-- Bachelors	169	142	311	54.3408
-- Partial College	127	151	278	45.6835
-- High School	82	102	184	44.5652
-- Partial High School	22	56	78	28.2051
-- Graduate Degree	95	80	175	54.2857

-- Which occupation groups are most likely to purchase bikes?
WITH cte AS (
SELECT 	Occupation,
		COUNT(CASE WHEN `Purchased Bike` = 'Yes' THEN 1 END) AS BikePurchases,
        COUNT(CASE WHEN `Purchased Bike` = 'No' THEN 1 END) AS NoBikePurchases
FROM bike_sale_explanatory_analysis
GROUP BY Occupation
)
	SELECT 	Occupation,
			BikePurchases,
            NoBikePurchases,
            BikePurchases + NoBikePurchases AS sum_customer,
            ROUND((BikePurchases / (BikePurchases + NoBikePurchases) * 100),2)AS PurchasedPercentage
	FROM cte 
    GROUP BY Occupation, BikePurchases, NoBikePurchases
    ORDER BY PurchasedPercentage DESC;
-- Professional	150	130	280	53.5714
-- Clerical	95	92	187	50.8021
-- Manual	59	67	126	46.8254
-- Skilled Manual	118	141	259	45.5598
-- Management	73	101	174	41.9540
-- Professional Clerical have a high percentage that the other occupation


CALL select_bike_sale_explanatory_analysis();