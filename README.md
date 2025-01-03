# My_Project_Bike_Sales_Analysis

 This project shows my skills in Excel and SQL

![bikesales](https://github.com/user-attachments/assets/7a43d977-7829-473a-b712-d82aaa6866a5)

 
### Project Overview

This is my first personal project, created to showcase the skills I have gained through self-study. The dataset used for this analysis was sourced from GitHub. For this project, I utilized Excel to perform basic calculations, apply functions for analysis, data cleaning, and create data visualizations. Additionally, I used SQL to conduct an in-depth analysis of bike sales.

**The goal of this project is to provide an in-depth analysis of:**

- Gender-based purchasing trends.
- Bike purchase behaviors by marital status.
- Geographic distribution of bike sales.
- The impact of income levels on bike purchases.
- The influence of having children on purchasing decisions.
- Bike sales trends based on commute distance.
- The relationship between education levels and bike purchases.
- Occupation-specific purchasing patterns.

**Problem Statement**

1. What are the key demographic and behavioral factors influencing bike purchase decisions?
2. How do income levels and geographic regions impact bike sales trends?
3. Do commute distances and family structures affect the likelihood of purchasing a bike?
4. What roles do education and occupation play in shaping bike purchasing behavior?
5. How can businesses leverage these insights to develop targeted marketing strategies and product offerings?

**Data Overview**

Dataset Source: [GitHub](https://github.com/AlexTheAnalyst/Excel-Tutorial/blob/b80a3c4f971a1608f2593ad8a585b53fbe74435e/Excel%20Project%20Dataset.xlsx)

File Size: 72 KB

**Data Structure:**

id, Marital Status, Gender, Income, Children, Education, Occupation, Home Owner, Cars, Commute Distance, Region, Age, Purchased Bike
 
### Exploratory Data Analysis (EDA) Questions

**Table Analysis**

1.	What is the dataset's total number of rows and columns?
2.	What is the range and scope of the data, including missing values?

**Demographics**
1.	What is the gender distribution in the dataset?
2.	What is customers' age range and average age across marital status categories?

**Purchasing Trends**

1.	What percentage of each demographic group (e.g., Gender, Marital Status) purchased a bike?
2.	Is there a trend in bike purchases across different income brackets?
   
**Regional Insights**

1.	Which region has the highest proportion of bike buyers?
2.	How does commute distance vary by region?
   
**Financial Analysis**

1.	What is the income distribution of customers who purchased a bike versus those who didn’t?
2.	How does owning a car affect the likelihood of purchasing a bike?

**Lifestyle Factors**

1.	How does the number of children influence bike purchases?
2.	What commute distances are most common among bike purchasers?

**Education and Occupation**

1.	What is the relationship between education level and bike purchases?
2.	Which occupation groups are most likely to purchase bikes?

### Tools and Their Applications

Excel: Use for Basic Analysis, Data Cleaning, PIVOT Table, and Data Visualization

MySQL Workbench: Data Cleaning, and Explanatory Data Analysis

ChatGPT: For Improving Sentences and getting better suggestions and recommendations

**Excel Data Cleaning**

After Downloading the Dataset from GitHub I started by duplicating the file and starting data cleaning this included:

- Removing Duplicates
- Standardize Data
- Removing Blank and Null data
- Removing Unnecessary Data

![image](https://github.com/user-attachments/assets/b1d5eab9-5397-487a-afb3-3c3fd2131572)

### Data Cleaning Using MySQL Workbench

- After Doing the data cleaning in Excel, I also did cleaning in SQL to double-check if any data needed to be cleaned.

~~~
DROP DATABASE IF EXISTS Bike_sale_analysis;
CREATE DATABASE Bike_sale_analysis; -- Creating database
USE Bike_sale_analysis;
CREATE TABLE bike_sale_Staging -- Creating table
LIKE bike_sale_worksheet;
INSERT INTO bike_sale_Staging -- Inserting data in the table
SELECT *
FROM bike_sale_worksheet;
DELIMITER // -- creating stored procedure for faster data viewing
CREATE PROCEDURE select_bike_sale_staging () BEGIN
SELECT *
FROM bike_sale_staging; END //
DELIMITER ;
-- Data Cleaning
ALTER TABLE bike_sale_staging – changing the column name
RENAME COLUMN `ï»¿ID` TO id;
CALL select_bike_sale_staging();
~~~

### Explanatory Data Analysis (EDA) MySQL Workbench

- Provides the age range (minimum, maximum, and average age) for customers in each marital status category.

~~~
-- Table Analysis
-- Demographics
-- What is the gender distribution across the dataset?
SELECT gender,
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
~~~

- Determines the percentage of bike purchases within each marital status group.
~~~
-- Purchasing Trends
-- What percentage of each demographic group (e.g., Gender, Marital Status) purchased a bike?
WITH cte AS
 (SELECT gender,
         COUNT(gender) AS total_customer,
         COUNT(CASE
                   WHEN `Purchased Bike` = 'Yes' THEN 1
               END) AS Num_Purchased_Bike
  FROM bike_sale_explanatory_analysis
  GROUP BY gender)
SELECT gender,
       total_customer,
       Num_Purchased_Bike,
       ROUND(((Num_Purchased_Bike / total_customer) * 100), 2) AS Percentage_Purchased_Gender
FROM cte;

WITH cte AS
 (SELECT `Marital Status`,
         COUNT(`Marital Status`) AS total_customer,
         COUNT(CASE
                   WHEN `Purchased Bike` = 'Yes' THEN 1
               END) AS Num_Purchased_Bike
  FROM bike_sale_explanatory_analysis
  GROUP BY `Marital Status`)
SELECT `Marital Status`,
       total_customer,
       Num_Purchased_Bike,
       ROUND(((Num_Purchased_Bike / total_customer) * 100), 2) AS Percentage_Purchased_MaritalStatus
FROM cte;
-- Is there a trend in bike purchases across different income brackets?
-- Yes Male intend to buy more bike than female customer
-- Single intend to buy more bike than married customer
~~~

- Identifies the number of bike buyers in each region and determines which region has the highest count.

~~~
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
~~~

- Understand the income profiles of customers who purchased or did not purchase a bike. Identify income brackets where bike purchases are most common, enabling targeted financial or marketing strategies.

~~~
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
WITH RankedData AS
 (SELECT `Purchased Bike`,
         Income,
         ROW_NUMBER() OVER (PARTITION BY `Purchased Bike`
                            ORDER BY Income) AS RowNum,
         COUNT(*) OVER (PARTITION BY `Purchased Bike`) AS TotalCount
  FROM bike_sale_explanatory_analysis),
     median AS
 (SELECT `Purchased Bike`,
         AVG(Income) AS MedianIncome
  FROM RankedData AS rd
  WHERE RowNum IN (FLOOR((TotalCount + 1) / 2),
                   CEIL((TotalCount + 1) / 2))
  GROUP BY rd.`Purchased Bike`)
SELECT b.`Purchased Bike`,
       MIN(b.Income) AS min_income,
       MAX(b.Income) AS max_income,
       AVG(b.Income) AS avg_income,
       ROUND(STDDEV(Income)) AS standard_dev_income,
       m.MedianIncome
FROM bike_sale_explanatory_analysis AS b
INNER JOIN median AS m ON b.`Purchased Bike` = m.`Purchased Bike`
GROUP BY b.`Purchased Bike`;
•	Counts the number of customers in each combination of car ownership status and bike purchase decision.
-- Does owning a car affect the likelihood of purchasing a bike?
WITH cte AS
 (SELECT `Purchased Bike`,
         CASE
             WHEN cars = 0 THEN 'No Cars'
             WHEN cars >= 1 THEN 'Have Cars'
         END AS cars
  FROM bike_sale_explanatory_analysis)
SELECT `Purchased Bike`,
       cars,
       COUNT(*) AS num_of_customer
FROM cte
GROUP BY `Purchased Bike`,
         cars
ORDER BY num_of_customer DESC;

-- owning a car does affect the likelihood of purchasing a bike
~~~

- This SQL query investigates how the number of children influences bike purchases by categorizing customers into groups based on whether they have children or not and analyzing their bike purchase behavior.

~~~
-- Lifestyle Factors
-- How does the number of children influence bike purchases?
WITH cte AS
 (SELECT `Purchased Bike`,
         CASE
             WHEN Children = 0 THEN 'No children'
             WHEN Children >= 1 THEN 'Have children'
         END AS children
  FROM bike_sale_explanatory_analysis)
SELECT `Purchased Bike`,
       children,
       num_of_purchased,
       ROUND((num_of_purchased / SUM(num_of_purchased) OVER (PARTITION BY children)) * 100, 2) AS percentage
FROM
 (SELECT `Purchased Bike`,
         children,
         COUNT(*) AS num_of_purchased
  FROM cte
  GROUP BY `Purchased Bike`,
           children
  ORDER BY `Purchased Bike` DESC) AS TEMP;

-- No	Have children	388
-- Yes	Have children	349
-- Yes	No children	146
-- No	No children	143
-- Having children does influence bike purchases
•	This SQL query analyzes the relationship between commute distances and bike purchases to identify which commute distances are most common among bike purchasers.
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
~~~
 
- This SQL query investigates the relationship between education levels and bike purchases by analyzing the distribution of purchases among customers with different education levels.

~~~
-- Education and Occupation
-- What is the relationship between education level and bike purchases?
WITH cte AS
 (SELECT Education,
         COUNT(CASE
                   WHEN `Purchased Bike` = 'Yes' THEN 1
               END) AS BikePurchases,
         COUNT(CASE
                   WHEN `Purchased Bike` = 'No' THEN 1
               END) AS NoBikePurchases
  FROM bike_sale_explanatory_analysis
  GROUP BY Education)
SELECT Education,
       BikePurchases,
       NoBikePurchases,
       BikePurchases + NoBikePurchases AS sum_customer,
       ROUND((BikePurchases / (BikePurchases + NoBikePurchases) * 100),2) AS PurchasedPercentage
FROM cte
GROUP BY Education,
         BikePurchases,
         NoBikePurchases;

-- Bachelor tends to buy more bikes
-- Bachelors	169	142	311	54.3408
-- Partial College	127	151	278	45.6835
-- High School	82	102	184	44.5652
-- Partial High School	22	56	78	28.2051
-- Graduate Degree	95	80	175	54.2857
~~~

- This SQL query determines which occupation groups are most likely to purchase bikes by analyzing bike purchase behavior across different occupations.

~~~
-- Which occupation groups are most likely to purchase bikes?
WITH cte AS
 (SELECT Occupation,
         COUNT(CASE
                   WHEN `Purchased Bike` = 'Yes' THEN 1
               END) AS BikePurchases,
         COUNT(CASE
                   WHEN `Purchased Bike` = 'No' THEN 1
               END) AS NoBikePurchases
  FROM bike_sale_explanatory_analysis
  GROUP BY Occupation)
SELECT Occupation,
       BikePurchases,
       NoBikePurchases,
       BikePurchases + NoBikePurchases AS sum_customer,
       ROUND((BikePurchases / (BikePurchases + NoBikePurchases) * 100),2)AS PurchasedPercentage
FROM cte
GROUP BY Occupation,
         BikePurchases,
         NoBikePurchases
ORDER BY PurchasedPercentage DESC;

-- Professional	150	130	280	53.5714
-- Clerical	95	92	187	50.8021
-- Manual	59	67	126	46.8254
-- Skilled Manual	118	141	259	45.5598
-- Management	73	101	174	41.9540
-- Professional Clerical have a high percentage that the other occupation
~~~

### Excel Visualization 

![image](https://github.com/user-attachments/assets/0146ffab-15f9-458f-a15d-d3513c6645d1)

1. Gender Insights

Insight: Males have a slightly higher bike purchase percentage than females, but the difference is minimal.

Recommendation:

Suggest targeting both genders equally in bike marketing efforts since the purchase ratio is nearly balanced.

![image](https://github.com/user-attachments/assets/9831ecfb-3911-4597-ba68-523c1c394311)

2. Marital Status

Insight: Singles are more likely to purchase bikes (54%) compared to married individuals (43%).

Recommendation:

Marketing campaigns can emphasize benefits tailored to single individuals, such as recreational or lifestyle enhancements.

![image](https://github.com/user-attachments/assets/c55630e2-3b74-4122-9830-d41865033869)

3. Geographic Analysis

Insight: North America has the highest percentage of bike purchasers (44%).

Recommendation:

Focus marketing efforts and promotional campaigns in North America while exploring strategies to improve engagement in Europe and the Pacific regions.

![image](https://github.com/user-attachments/assets/d22ca547-7db6-470b-8fff-b5fe64145738)

Insight: Bike purchasers have slightly higher average income levels ($57,474.75 vs. $55,028.25 for non-purchasers).

Recommendation:

Offer premium models or financing options targeting higher-income customers who are more likely to buy.

![image](https://github.com/user-attachments/assets/6e636676-a386-4697-8c70-e9d5114e6af1)

5. Children Factor

Insight: Households without children are marginally more likely to purchase bikes (50.52%) than those with children (47.35%).

Recommendation:

Highlight family-oriented bike packages or products suitable for child-friendly biking to tap into this demographic.

![image](https://github.com/user-attachments/assets/1c162c5c-09a5-40ae-9514-133b2c6237c1)

6. Commute Distance

Insight: Customers with a commute distance of 0-1 miles (41.82%) are the most common bike purchasers.

Recommendation:

Emphasize the benefits of short-distance biking, such as cost savings and convenience for urban commutes.

![image](https://github.com/user-attachments/assets/ce5c7bfb-436f-4510-847e-4ad2fff8647f)

7. Education Level

Insight: Higher education levels (e.g., Bachelors, Graduate Degree) corresponds with a greater likelihood of bike purchases.

Recommendation:

Partner with institutions or professional groups to market bikes as tools for work-life balance and fitness.

![image](https://github.com/user-attachments/assets/ea7f1826-cec0-4e17-87f0-5865fd05ca31)

8. Occupation

Insight: Professionals (53.57%) and Clerical workers (50.80%) are more likely to purchase bikes.

Recommendation:

Develop targeted campaigns for professionals, emphasizing bikes as a sustainable and practical commuting option.

### Problem Statement Answer

1.	Key demographic and behavioral factors influencing bike purchases

Gender, marital status, children factor, education level, and occupation are the things that influence bike purchases.

3.	Impact of income levels and geographic regions on bike sales trends

North America leads in bike purchases, and higher-income individuals are more likely to buy bikes.

4.	Effect of commute distances and family structures on purchasing decisions

Short-distance commuters (0-1 miles) are the most frequent purchasers and households without children are slightly more inclined to buy bikes.

5.	Role of education and occupation in bike purchasing behavior

Professionals and clerical workers show higher purchase rates and higher education levels align with greater bike ownership.

6.	Strategies to leverage insights for targeted marketing and product offerings

Target both genders equally, emphasize benefits for singles, focus efforts in North America, and promote short-distance biking for urban commuters.
