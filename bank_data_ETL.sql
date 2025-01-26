USE bank_data;

SELECT * FROM data1;

-- Remove unnecessary columns
ALTER TABLE data1 
DROP COLUMN Mem__no__Products,
DROP COLUMN Surname_tfidf_0,
DROP COLUMN Surname_tfidf_1,
DROP COLUMN Surname_tfidf_2,
DROP COLUMN Surname_tfidf_3,
DROP COLUMN Surname_tfidf_4,
DROP COLUMN Cred_Bal_Sal,
DROP COLUMN Bal_sal,
DROP COLUMN Tenure_Age,
DROP COLUMN Age_Tenure_product;

-- Add columns age group
ALTER TABLE data1 
ADD COLUMN age_group VARCHAR(10) NOT NULL;

SET sql_safe_updates = 0;

-- add data in column age_group
UPDATE data1
SET age_group = CASE WHEN age >=15 AND age<30 THEN '15-30'
					  WHEN age >=30 AND age<45 THEN '30-45'
                      WHEN age >=45 AND age<60 THEN '45-60'
                     ELSE '60-100' END;

DESCRIBE data1;

-- Rename column Male to Gender of varchar data type
ALTER TABLE data1
CHANGE COLUMN Male Gender VARCHAR(10);

-- Update values in Gender column - Male for 1 and Female for 0
UPDATE data1 
SET Gender = CASE WHEN Gender=1 THEN 'Male'
                 ELSE 'Female' END;

-- Remove column Female
ALTER TABLE data1
DROP COLUMN Female;

-- Add a column Geography of varchar data type
ALTER TABLE data1
ADD COLUMN Geography VARCHAR(10);

-- Change data type of following columns to varchar - France, Germany, Spain
ALTER TABLE data1
MODIFY COLUMN France VARCHAR(10),
MODIFY COLUMN Germany VARCHAR(10),
MODIFY COLUMN Spain VARCHAR(10);

-- Change values in following columns to their respective country - France, Germany, Spain
UPDATE data1
SET France= CASE WHEN France= 1 THEN 'France'
                 ELSE '' END,
	Germany= CASE WHEN Germany= 1 THEN 'Germany'
                 ELSE '' END,
	Spain= CASE WHEN Spain= 1 THEN 'Spain'
                 ELSE '' END;

-- Add values in column Geography
UPDATE data1
SET Geography = concat(France,Germany,Spain);

-- Remove columns France, Germany, Spain
ALTER TABLE data1
DROP COLUMN France,
DROP COLUMN Germany,
DROP COLUMN Spain;

SET sql_safe_updates = 1;
