/* NAKSHATRA MEENA PROJECT 1 SQL SOLUTION CODE */

-- Create schema if it doesn't exist
CREATE DATABASE IF NOT EXISTS project;

-- Use the schema
USE project;

SHOW VARIABLES LIKE 'secure_file_priv';

DROP TABLE IF EXISTS cb;
DROP TABLE IF EXISTS spend;
DROP TABLE IF EXISTS repayment;

-- Customer table
CREATE TABLE cb (
    Sl_No INT,
    Customer VARCHAR(20),
    Age DECIMAL(6,4),
    City VARCHAR(50),
    Credit_Card_Product VARCHAR(20),
    Limits DECIMAL(10,2),
    Company VARCHAR(50),
    Segment VARCHAR(50)
);

ALTER TABLE cb MODIFY COLUMN Age DECIMAL(6,4);

-- Spend table
CREATE TABLE spend (
    Sl_No INT,
    Costomer VARCHAR(20),
    monthss DATE,
    Amount DECIMAL(15,5)
);

ALTER TABLE spend MODIFY Amount DECIMAL(15,5);

-- Repayment table
CREATE TABLE repayment (
    Sl_No INT,
    Costomer VARCHAR(20),
    monthss DATE,
    Amount DECIMAL(20,5)
);

ALTER TABLE repayment MODIFY Amount DECIMAL(15,5);

-- Load cb.csv
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cb.csv'
INTO TABLE cb
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Sl_No, Customer, Age, City, Credit_Card_Product, Limits, Company, Segment);

-- Load spend 1 (1).csv
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/spend 1 (1).csv'
INTO TABLE spend
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Sl_No, Costomer, @monthss, @Amount)
SET 
    monthss = STR_TO_DATE(@monthss, '%Y-%m-%d'),
    Amount = CAST(REPLACE(@Amount, ',', '') AS DECIMAL(15,5));


-- Load repayment.csv
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/repayment.csv'
INTO TABLE repayment
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@Sl_No, @Costomer, @monthss, @Amount, @dummy)
SET 
    Sl_No = @Sl_No,
    Costomer = @Costomer,
    monthss = STR_TO_DATE(@monthss, '%d-%b-%y'),   -- handles 12-Jan-04
    Amount = CAST(REPLACE(@Amount, ',', '') AS DECIMAL(15,5));

SELECT * FROM cb LIMIT 10;
DESCRIBE cb;

SELECT * FROM repayment LIMIT 10;
DESCRIBE repayment;

SELECT * FROM spend LIMIT 10;
DESCRIBE spend;


/* 1 Provide a meaningful treatment to all values where age is less than 18. */
use project;
select * from cb
where age <18;

/* 2 Identity where the repayment is more than the spend then give them a credit of 2% of their surplus */
/* amount in the next month billing. */

SELECT
 SUM(spend.Amount) AS monthly_spend,SUM(repayment.Amount) AS monthly_repayment,(SUM(repayment.Amount) -SUM(spend.Amount)) ,
 CASE
      WHEN SUM(repayment.Amount)>SUM(spend.Amount)  THEN ((SUM(repayment.Amount) -SUM(spend.Amount))* 0.02 )
 ELSE 0
 END as penalty_amount
 FROM spend  
 join repayment  on spend.Costomer = repayment.Costomer 
GROUP BY spend.costomer
;

/* -- 3 Monthly spend of each customer */

SELECT costomer, Month(monthss) AS monthly, SUM(Amount) AS monthly_spend
FROM spend
GROUP BY costomer,Month(monthss) ;

/* -- 4 Monthly repayment of each customer. */

SELECT costomer, Month(monthss) AS monthly, SUM(Amount) AS monthly_repayment
FROM repayment
GROUP BY costomer, Month(monthss);

/* --******* 5 Highest paying 10 customers. */

SELECT Costomer,Amount 
FROM repayment
group by Costomer,Amount
order by Amount desc
;

/* -- 6 People in which segment are spending more money. */

SELECT Segment ,sum(Amount) as spending_money
FROM cb join spend on spend.costomer = cb.customer
group by Segment
order by spending_money desc;

/* -- 7 Which age group is spending more money? */

SELECT SUM(Amount) AS total_spending ,
 CASE
 WHEN Age < 18 THEN 'Under 18'
 WHEN Age >= 18 AND Age < 30 THEN '18-29'
 WHEN Age >= 30 AND Age < 40 THEN '30-39'
 ELSE '40 and above'
 END AS age_group
from cb
join spend on cb.customer = spend.costomer
GROUP BY age_group
ORDER BY total_spending DESC
;

/* 8 Which is the most profitable segment? */

SELECT Segment, SUM(spend.Amount) ,SUM(repayment.Amount) ,
 CASE
 WHEN SUM(repayment.Amount) > SUM(spend.Amount) then 'segment_profit'
 ELSE '0'
 END AS segment_profit
FROM cb 
join spend on cb.customer = spend.costomer
join repayment on cb.customer =repayment.costomer
group by Segment
ORDER BY segment_profit DESC;

/* -- 9 In which category the customers are spending more money? */

SELECT costomer, SUM(Amount) AS Spending
FROM spend
GROUP BY costomer
ORDER BY Spending DESC
LIMIT 10;

/* -- 10 Monthly profit for the bank. */

SELECT
  MONTH(spend.monthss) AS monthly,
  SUM(spend.Amount) AS monthly_spend,
  SUM(cb.limits) AS total_limits,
  CASE
    WHEN SUM(spend.Amount) > SUM(cb.limits) THEN SUM(cb.limits) * 0.02
    ELSE 0
  END AS bank_profit
FROM spend
JOIN cb ON spend.costomer = cb.customer
GROUP BY MONTH(spend.monthss)
ORDER BY monthly;

/* -- 11 Impose an interest rate of 2.9% for each customer for any due amount */

SELECT
 SUM(spend.Amount) AS monthly_spend,SUM(repayment.Amount) AS monthly_repayment,(SUM(repayment.Amount) -SUM(spend.Amount)) ,
 CASE
      WHEN SUM(repayment.Amount)>SUM(spend.Amount)  THEN ((SUM(repayment.Amount) -SUM(spend.Amount))* 2.9 )
 ELSE 0
 END as penalty_amount
 FROM spend  
 join repayment  on spend.Costomer = repayment.Costomer 
GROUP BY spend.costomer
;
