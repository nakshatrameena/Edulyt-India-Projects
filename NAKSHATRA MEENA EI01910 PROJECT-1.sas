

/* 1 Provide a meaningful treatment to all values where age is less than 18. */
proc sql;
select * from l.cb
where age <18;
quit;
/* -- 2 Identify where monthly spend is more than the limit and then impose a 2% of penalty of credit limit. */
proc sql;
SELECT 
     Month(Month) AS monthly,SUM(Amount) AS monthly_spend,limits,
    CASE
        WHEN SUM(Amount) > limits THEN (limits* 0.02 )
        ELSE 0
    END  as penalty_amount
  FROM l.spend  as a
  join l.cb as b on  a.costomer = b.customer 
GROUP BY  Month(Month)
;
quit;
/* -- 3 Identity where the repayment is more than the spend then give them a credit of 2% of their credit  */
/* -- limit in the next month biling. */
proc sql;
select
    Customer,Month(Month) AS monthly,SUM(Amount) AS monthly_repayment,limits,
    CASE
        WHEN SUM(Amount) > limits THEN limits* 0.02 
        ELSE 0
    END  as Bonus_amount
FROM l.repayment 
join l.cb on  repayment.Costomer = cb.Customer 
GROUP BY Customer, Month(Month);
quit;


/* -- 4 Monthly spend of each customer */
proc sql;
SELECT costomer, Month(Month) AS monthly, SUM(Amount) AS monthly_spend
FROM l.spend
GROUP BY costomer,Month(Month)  ;
quit;

/* -- 5 Monthly repayment of each customer. */
proc sql;
SELECT costomer, Month(Month) AS monthly, SUM(Amount) AS monthly_repayment
FROM l.repayment
GROUP BY costomer, Month(Month);
quit;

/* --******* 6 Highest paying 10 customers. */

proc sql;
SELECT Costomer,Amount 
FROM l.repayment
group by Costomer,Amount
order by Amount desc
  ;
quit;

/* -- 7 People in which segment are spending more money. */
proc sql;
SELECT Segment ,sum(Amount) as spending_money
FROM l.cb join l.spend on spend.costomer = cb.customer
group by Segment
order by spending_money desc;
quit;

/* -- 8 Which age group is spending more money? */
proc sql;
SELECT SUM(Amount) AS total_spending ,

        CASE
            WHEN Age < 18 THEN 'Under 18'
            WHEN Age >= 18 AND Age < 30 THEN '18-29'
            WHEN Age >= 30 AND Age < 40 THEN '30-39'
            ELSE '40 and above'
         END  AS age_group
from l.cb
join l.spend on cb.customer = spend.costomer
GROUP BY age_group
ORDER BY total_spending DESC
;
quit ;

/* -- *****9 Which is the most profitable segment? */
proc sql;
SELECT Segment, spend.SUM(Amount) ,repayment.SUM(Amount) ,
    CASE
     WHEN SUM(repayment.Amount) > SUM(spend.Amount) AS segment_profit
    ELSE 0 END AS segment_profit
FROM l.cb 
join l.spend on cb.customer = spend.costomer
join l.repayment on cb.customer =repayment.costomer
group by Segment;
quit;

/* -- 10 In which category the customers are spending more money? */
proc sql;
SELECT typess,sum(Amount) as Spending FROM l.spend
GROUP BY typess
ORDER BY Spending DESC
;
quit;

/* -- 11 Monthly profit for the bank. */
proc sql;
SELECT 
     Month(Month) AS monthly,SUM(Amount) AS monthly_spend,limits,
    CASE
        WHEN SUM(Amount) > limits THEN (limits* 0.02 )
        ELSE 0
    END  as bank_profit
  FROM l.spend  as a
  join l.cb as b on  a.costomer = b.customer 
GROUP BY  Month(Month)
;
quit;

/* -- 12   Impose an interest rate of 2.9% for each customer for any due amount */
proc sql;
SELECT cb.customer, Month(Month) AS monthly,SUM(Amount) AS monthly_spend,limits,
    CASE
        WHEN SUM(Amount) > limits THEN (limits* 0.029 )
        ELSE 0
    END  as penalty_amount
    FROM l.spend  as a
  join l.cb as b on  a.Costomer = b.Customer 
 group by Month(Month) ;
 quit;
 proc sql;
 select  cb.customer, Month(Month) AS monthly,SUM(Amount) AS monthly_repayment,limits,
    CASE
        WHEN SUM(Amount) > limits THEN limits* 0.029
        ELSE 0
    END  as Bonus_amount
  from l.repayment
  join l.cb on  repayment.Costomer = cb.Customer
  group by Month(Month);
quit;




