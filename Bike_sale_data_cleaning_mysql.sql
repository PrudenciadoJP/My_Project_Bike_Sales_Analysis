DROP DATABASE IF EXISTS Bike_sale_analysis;
CREATE DATABASE Bike_sale_analysis;
USE Bike_sale_analysis;

CREATE TABLE bike_sale_Staging
LIKE bike_sale_worksheet;

INSERT INTO bike_sale_Staging
SELECT * FROM bike_sale_worksheet;

DELIMITER //
CREATE PROCEDURE select_bike_sale_staging ()
BEGIN
	SELECT * FROM bike_sale_staging;
END //
DELIMITER ;

-- Data Cleaning

ALTER TABLE bike_sale_staging
RENAME COLUMN `ï»¿ID` TO id;

CALL select_bike_sale_staging();