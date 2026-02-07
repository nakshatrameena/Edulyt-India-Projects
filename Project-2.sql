use project_2;
show tables;
-- Provide a meaningful treatment where the Credit Card entries are blank.
    
UPDATE c
SET Credit_card = '0'
WHERE Credit_card = ' ';

UPDATE c
SET Coupon_ID = 0
WHERE Coupon_ID ='';

-- Identity where Price is equal to Selling Price even after having a Coupon Code, apply an automatic 
-- discount of 5% for those entries.
UPDATE c
SET Selling_price = Selling_price * 0.95
WHERE Price = Selling_price AND Coupon_ID IS NOT NULL;

         
-- Make sure that the return date is after the Purchase Date.
ALTER TABLE c
ADD CONSTRAINT check_Return_date
CHECK (Return_date > Dates);

-- If the Coupon ID is NULL, make sure that NO discount is given, the Selling Price should be equal to 
-- Price.

-- Age should be greater than 18 for all the CC holders.
ALTER TABLE ci
ADD CONSTRAINT check_Age
CHECK (Age > 18);


-- Transaction ID should be unique for all
ALTER TABLE c
ADD CONSTRAINT unique_t_id
UNIQUE (t_id);
-- Customer Segmentation Based on Spend in Dollars, based on Swipes, segmentation example below. 
-- You can create more segment as per your wisdom.
Young Females
Mid age Females
Old Females
Young Males
Mid age Males
Old Males



-- Calculate the spend in terms of Product, State and Payment method.
SELECT P_CATEGORY, ci.State, Payment Method, SUM(Price) as spend AS TotalSpend
FROM c join ci on ci.C_ID =c.Credit_card
GROUP BY P_CATEGORY, ci.State, Payment Method;

-- Calculate the highest 5 spending in all above categories.
SELECT P_CATEGORY, ci.State, Payment Method, SUM(Price) as spend AS TotalSpend
FROM c join ci on ci.C_ID =c.Credit_card
GROUP BY P_CATEGORY, ci.State, Payment Method
limit 5;

-- Give your opinion on return category like customers returning the products belongs to which state, 
-- age group, condition, category of the product or is it related to discount.
SELECT State, COUNT(*) AS ReturnCount
FROM returns
GROUP BY State;
SELECT CASE
         WHEN Age <= 18 THEN 'Under 18'
         WHEN Age <= 25 THEN '18-25'
         WHEN Age <= 35 THEN '26-35'
         ELSE 'Over 35'
       END AS AgeGroup,
       COUNT(*) AS ReturnCount
FROM returns
GROUP BY AgeGroup;
SELECT Condition, COUNT(*) AS ReturnCount
FROM returns
GROUP BY Condition;
SELECT ProductCategory, COUNT(*) AS ReturnCount
FROM returns
GROUP BY ProductCategory;
SELECT CASE
         WHEN Discount > 0 THEN 'Discounted'
         ELSE 'Non-Discounted'
       END AS DiscountCategory,
       COUNT(*) AS ReturnCount
FROM returns
GROUP BY DiscountCategory;



-- Create a profile of customers in terms of timing of their order.
SELECT DAYOFWEEK(OrderDate) AS DayOfWeek, COUNT(*) AS OrderCount
FROM orders
GROUP BY DayOfWeek;
SELECT HOUR(OrderTime) AS HourOfDay, COUNT(*) AS OrderCount
FROM orders
GROUP BY HourOfDay;
SELECT MONTH(OrderDate) AS Month, AVG(OrderValue) AS AverageOrderValue
FROM orders
GROUP BY Month;

-- Which payment method is providing more discount for customers?
SELECT PaymentMethod, SUM(DiscountAmount) AS TotalDiscount
FROM transactions
GROUP BY PaymentMethod
ORDER BY TotalDiscount DESC
LIMIT 1;

-- Create a profile for high value items vs low value items and relate that wrt to their number of orders.
SELECT
  CASE
    WHEN item_value >= 100 THEN 'High Value'
    ELSE 'Low Value'
  END AS ItemCategory,
  COUNT(DISTINCT order_id) AS OrderCount
FROM
  items
INNER JOIN
  orders ON items.item_id = orders.item_id
GROUP BY
  ItemCategory;



-- Do you think if merchant provides more discount then can it will lead to increase in number of 
-- orders?
SELECT discount, AVG(order_count) AS avg_order_count
FROM (
  SELECT discount, COUNT(*) AS order_count
  FROM orders
  GROUP BY discount
) AS subquery
GROUP BY discount;







