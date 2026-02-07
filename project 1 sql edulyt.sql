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

SELECT sum(Amount) as Spending 
FROM spend
GROUP BY typess
ORDER BY Spending DESC
;

/* -- 10 Monthly profit for the bank. */

SELECT
 Month(monthss) AS monthly,SUM(Amount) AS monthly_spend,limits,
 CASE
 WHEN SUM(Amount) > limits THEN (limits* 0.02 )
 ELSE 0
 END as bank_profit
 FROM spend as a
 join cb as b on a.costomer = b.customer 
GROUP BY Month(monthss)
;

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
