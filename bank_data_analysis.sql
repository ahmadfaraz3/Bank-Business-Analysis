USE bank_data;

SELECT * FROM data1;

-- Ques1) What is the gender distribution of current customers?
SELECT Gender,round((count(*)/(SELECT count(*) FROM data1 WHERE Exited = 0)*100),2) AS '% of Customers'
FROM data1
WHERE Exited = 0
GROUP BY 1;

-- Ques2) What is the age group distribution of current customers?
SELECT Age_group,round((count(*)/(SELECT count(*) FROM data1 WHERE Exited = 0)*100),2) AS '% of Customers'
FROM data1
WHERE Exited = 0
GROUP BY 1
ORDER BY 1;

-- Ques3) What is the geography distribution of current customers?
SELECT Geography,round((count(*)/(SELECT count(*) FROM data1 WHERE Exited = 0)*100),2) AS '% of Customers'
FROM data1
WHERE Exited = 0
GROUP BY 1
ORDER BY 2 DESC;

-- Ques4) What is the Credit Score Standards distribution of current customers?
SELECT x.Credit_Score_Standards,round(((Count(*)/(SELECT count(*) FROM data1 WHERE Exited = 0))*100),2) AS '% of Customers'
FROM (
SELECT CreditScore, CASE WHEN CreditScore < 580 THEN 'Poor'
                         WHEN CreditScore >= 580  AND CreditScore < 700 THEN 'Fair'
                         WHEN CreditScore >= 700 AND CreditScore < 800 THEN 'Good'
                         ELSE 'Exceptional' END AS 'Credit_Score_Standards'
FROM data1 WHERE Exited = 0) AS x
GROUP BY 1
ORDER BY 2 DESC;

-- Ques5) What is the average tenure of current active and inactive customers?
SELECT IsActiveMember, round(AVG(tenure),2) AS avg_tenure
FROM data1
WHERE Exited = 0
GROUP BY 1
ORDER BY 2;

-- Ques6) What is the average no of products used by current active customers?
SELECT round(AVG(NumOfProducts),2) AS avg_products_used
FROM data1
WHERE IsActiveMember=1 AND Exited = 0;

-- Ques7) What is the % of current active customers with credit cards?
SELECT round((count(HasCrCard)/(SELECT count(*) FROM data1 WHERE IsActiveMember=1 AND Exited = 0))*100,2) AS '% of Customers'
FROM data1
WHERE IsActiveMember=1 AND HasCrCard=1 AND Exited = 0;


-- Ques8) What is the active/inactive % of current customers?
WITH cte AS(
SELECT IsActiveMember,count(*) AS cnt
FROM data1
WHERE Exited = 0
GROUP BY 1)
SELECT IsActiveMember,
	round(cnt/(SELECT count(IsActiveMember) FROM data1 WHERE Exited = 0)*100,2) AS '% of Customers'
    FROM cte
    GROUP BY 1;
    
-- Ques9) What is the % of exited customers?
SELECT Exited, round(((count(Exited)/(SELECT count(*) FROM data1))*100),2) as '% of Customers'
FROM data1
WHERE Exited = 1;
    
-- Ques10) What is the % of inactive customers in each age group with respect to total population of respective gender and age group?
WITH cte AS (
SELECT geography, gender, age_group, (count(IsActiveMember)-sum(IsActiveMember)) AS no_inactive, count(IsActiveMember) AS total
FROM data1
WHERE exited = 0
GROUP BY 1,2,3
ORDER BY 1,2,3)
SELECT geography, gender, age_group, round(((no_inactive/total)*100),2) AS '% of inactive customers'
FROM cte
GROUP BY 1,2,3
ORDER BY 1,2,3;

-- Ques11) What is the % of current customers with no credit card in each age group with respect to population of respective gender and age group?
WITH cte AS (
SELECT geography, gender, age_group, (count(HasCrCard)-sum(HasCrCard)) AS no_nocreditcard, count(HasCrCard) AS total
FROM data1
WHERE exited = 0
GROUP BY 1,2,3
ORDER BY 1,2,3)
SELECT geography, gender, age_group, round(((no_nocreditcard/total)*100),2) AS '% of customers not having credit card'
FROM cte
GROUP BY 1,2,3
ORDER BY 1,2,3;

-- Ques12) What is the target segment not having credit card for credit card sale with more than average salary of their respective country?
WITH cte AS (
SELECT geography, gender, age_group, (count(HasCrCard)-sum(HasCrCard)) AS no_nocreditcard, count(HasCrCard) AS total
FROM data1
WHERE exited = 0
GROUP BY 1,2,3
ORDER BY 1,2,3),
cte2 AS(
SELECT geography, round(AVG(EstimatedSalary),2) AS country_avg_salary
FROM data1
WHERE exited = 0
GROUP BY 1
ORDER BY 1),
cte3 AS(
SELECT geography, gender, age_group, round(AVG(EstimatedSalary),2) AS grp_avg
FROM data1
WHERE HasCrCard =0 AND Exited = 0
GROUP BY 1,2,3
ORDER BY 1,2,3
)
SELECT cte.geography, cte.gender, cte.age_group, round(((no_nocreditcard/total)*100),2) AS '% of customers not having credit card',
		cte3.grp_avg, cte2.country_avg_salary
FROM ((cte
INNER JOIN cte2 ON cte.geography=cte2.geography)
INNER JOIN cte3 ON cte.geography=cte3.geography AND cte.gender=cte3.gender AND cte.age_group=cte3.age_group)
WHERE cte3.grp_avg>=cte2.country_avg_salary
GROUP BY 1,2,3
ORDER BY 1,2,3;

-- Quse13) WHat is the number of product distribution across current active customers in each country?
SELECT geography,NumOfProducts,round(count(*)/(SELECT count(*) FROM data1 WHERE geography='France' AND exited = 0 AND IsActiveMember = 1)*100,2) AS '% of customers'
FROM data1
WHERE geography='France' AND exited = 0 AND IsActiveMember = 1
GROUP BY 1,2
UNION 
SELECT geography,NumOfProducts,round(count(*)/(SELECT count(*) FROM data1 WHERE geography='Germany' AND exited = 0 AND IsActiveMember = 1)*100,2) AS '% of customers'
FROM data1
WHERE geography='Germany' AND exited = 0 AND IsActiveMember = 1
GROUP BY 1,2
UNION
SELECT geography,NumOfProducts,round(count(*)/(SELECT count(*) FROM data1 WHERE geography='Spain' AND exited = 0 AND IsActiveMember = 1)*100,2) AS '% of customers'
FROM data1
WHERE geography='Spain' AND exited = 0 AND IsActiveMember = 1
GROUP BY 1,2
ORDER BY 1,2,3;

-- Ques14) What is the % of customers who have good credit score but does not have a credit card?
SELECT geography, gender,round(count(*)/(SELECT count(*) FROM data1 WHERE geography ='France' AND  HasCrCard=0 AND exited = 0)*100,2) AS '% of customers having good credit score but not have credit card'
FROM data1
WHERE HasCrCard=0 AND CreditScore > 700 AND geography ='France' AND exited = 0
GROUP BY 1,2
UNION
SELECT geography, gender,round(count(*)/(SELECT count(*) FROM data1 WHERE geography ='Germany' AND  HasCrCard=0 AND exited = 0)*100,2) AS '% of customers having good credit score but not have credit card'
FROM data1
WHERE HasCrCard=0 AND CreditScore > 700 AND geography ='Germany' AND exited = 0
GROUP BY 1,2
UNION
SELECT geography, gender,round(count(*)/(SELECT count(*) FROM data1 WHERE geography ='Spain' AND  HasCrCard=0 AND exited = 0)*100,2) AS '% of customers having good credit score but not have credit card'
FROM data1
WHERE HasCrCard=0 AND CreditScore > 700 AND geography ='Spain' AND exited = 0
GROUP BY 1,2;

----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
