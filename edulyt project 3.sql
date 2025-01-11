use credit_banking_3;





set sql_safe_updates = 0 ;

select * from customer_info;


select * from credit_transactions ;



UPDATE customer_info
SET Age = 18
WHERE Age < 18;






UPDATE credit_transactions
SET Selling_price = Price * 0.95
WHERE Price = Selling_Price AND Coupon_ID IS NOT NULL;







update credit_transactions set Selling_price = Price where  Coupon_ID is null ; 








ALTER TABLE credit_transactions
RENAME COLUMN Date  TO Purchase_Date;





UPDATE credit_transactions
SET Return_Date = DATE_ADD(Purchase_Date, INTERVAL 1 DAY)
WHERE Return_Date <= Purchase_Date;







UPDATE credit_transactions
SET Purchase_Date = STR_TO_DATE(Purchase_Date, '%m-%d-%Y %H:%i:%s');


ALTER TABLE credit_transactions
MODIFY COLUMN Purchase_Date DATETIME;




UPDATE credit_transactions
SET Purchase_Date = STR_TO_DATE(Purchase_Date, '%m %d %y');



SELECT Purchase_Date
FROM credit_transactions
WHERE STR_TO_DATE(Purchase_Date, '%m %d %y') IS NULL;





ALTER TABLE credit_transactions ADD COLUMN New_Purchase_Date DATETIME;




ALTER TABLE credit_transactions ADD COLUMN New_Return_Date DATETIME;


CREATE TABLE credit_transactions_backup AS SELECT * FROM credit_transactions;

CREATE TABLE customer_info_backup AS SELECT * FROM customer_info ;













UPDATE credit_transactions
SET New_Purchase_Date = select  Purchase_Date from credit_transactions;




UPDATE credit_transactions
SET New_Purchase_Date = STR_TO_DATE(Purchase_Date, '%m/%d/%Y');
    
    
    
    
    
    
    
    ALTER TABLE credit_transactions DROP COLUMN Purchase_Date;
ALTER TABLE credit_transactions CHANGE New_Purchase_Date Purchase_Date DATETIME;
    
    
    
    UPDATE credit_transactions
SET New_Return_Date = STR_TO_DATE(Return_Date, '%m/%d/%Y');
    
    
    ALTER TABLE credit_transactions DROP COLUMN New_Return_Date;
    
    
    select * from credit_transactions;




UPDATE credit_transactions
SET New_Return_Date = 
    CASE
        WHEN Return_Date = '' OR Return_Date IS NULL THEN NULL
        WHEN STR_TO_DATE(Return_Date, '%m/%d/%Y') IS NOT NULL
            THEN STR_TO_DATE(Return_Date, '%m/%d/%Y')
        WHEN STR_TO_DATE(Return_Date, '%Y-%m-%d') IS NOT NULL
            THEN STR_TO_DATE(Return_Date, '%Y-%m-%d')
        ELSE NULL
    END;






ALTER TABLE credit_transactions 
DROP COLUMN Return_Date,
CHANGE New_Return_Date Return_Date DATETIME;



UPDATE credit_transactions
SET Selling_price = Price
WHERE Coupon_ID IS NULL;





select * from credit_transactions
 where Coupon_ID is  null;




desc credit_transactions;










UPDATE credit_transactions
SET Transaction_ID = 999999
WHERE Transaction_ID IN (
    SELECT Transaction_ID
    FROM (
        SELECT Transaction_ID
        FROM credit_transactions
        GROUP BY Transaction_ID
        HAVING COUNT(*) > 1
    ) AS duplicates
);rollback;

rollback;



UPDATE credit_transactions AS ct
JOIN credit_transactions_backup AS bt ON ct.Product_ID = bt.Product_ID
SET ct.Transaction_ID = bt.Transaction_ID;





SELECT Transaction_ID, COUNT(*)
FROM credit_transactions
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;









set autocommit = on;


commit;

alter table credit_transactions drop column Transaction_id ;


alter table credit_transactions add column Transaction_id int primary key auto_increment ;










alter table credit_transactions modify column Coupon_ID varchar(20);


select * from credit_transactions where Coupon_ID = ' ' ;



select * from credit_transactions where Selling_price = price ;






update credit_transactions set Selling_price = Price where Coupon_ID is null;




set sql_safe_updates = 0 ;




select * from credit_transactions where Coupon_ID not like "_____" ;




update credit_transactions set Selling_price = Price   where Coupon_ID not like "_____" ;








SELECT 
    CASE 
        WHEN Gender = 'F' AND Age BETWEEN 18 AND 35 THEN 'Young Females'
        WHEN Gender = 'F' AND Age BETWEEN 36 AND 60 THEN 'Mid age Females'
        WHEN Gender = 'F' AND Age > 60 THEN 'Old Females'
        WHEN Gender = 'M' AND Age BETWEEN 18 AND 35 THEN 'Young Males'
        WHEN Gender = 'M' AND Age BETWEEN 36 AND 60 THEN 'Mid age Males'
        WHEN Gender = 'M' AND Age > 60 THEN 'Old Males'
    END AS Segment,
    COUNT(*) AS Count
FROM 
    customer_info
WHERE 
    Age >= 18
    AND Gender IN ('M', 'F')
GROUP BY 
    Segment
ORDER BY 
    Segment;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    SELECT 
    credit_transactions.P_CATEGORY AS Product,
    customer_info.State,
    credit_transactions.payment_method,
    round(SUM(credit_transactions.Selling_price),2) AS Total_Spend
FROM 
    credit_transactions 
JOIN 
    customer_info  ON credit_transactions.Credit_card = customer_info.C_ID
GROUP BY 
    credit_transactions.P_CATEGORY, customer_info.State, credit_transactions.payment_method
ORDER BY 
    Total_Spend DESC;
    
    
    
    
    select * from credit_transactions where Credit_card = 3768 ;
    
    
    
    
    
    SELECT 
    credit_transactions.P_CATEGORY AS Product,
    customer_info.State,
    credit_transactions.payment_method,
    round(SUM(credit_transactions.Selling_price),2) AS Total_Spend
FROM 
    credit_transactions 
JOIN 
    customer_info  ON credit_transactions.Credit_card = customer_info.C_ID
GROUP BY 
    credit_transactions.P_CATEGORY, customer_info.State, credit_transactions.payment_method
ORDER BY 
    Total_Spend DESC
    limit 5 ;
    
    
    
    
    
    
    
    
    
    
    
    SELECT 
    customer_info.State,
    CASE 
        WHEN customer_info.Age < 30 THEN 'Young'
        WHEN customer_info.Age BETWEEN 30 AND 50 THEN 'Middle-aged'
        ELSE 'Senior'
    END AS Age_Group,
    credit_transactions.CONDITION,
    credit_transactions.P_CATEGORY,
    CASE 
        WHEN (credit_transactions.Price - credit_transactions.Selling_price) / credit_transactions.Price > 0.1 THEN 'High Discount'
        WHEN (credit_transactions.Price - credit_transactions.Selling_price) / credit_transactions.Price > 0 THEN 'Low Discount'
        ELSE 'No Discount'
    END AS Discount_Category,
    COUNT(*) AS Return_Count
FROM 
    credit_transactions
JOIN 
    customer_info ON credit_transactions.Credit_card = customer_info.C_ID
WHERE 
    credit_transactions.Return_ind = 1
GROUP BY 
    customer_info.State, Age_Group, credit_transactions.CONDITION, credit_transactions.P_CATEGORY, Discount_Category
ORDER BY 
    Return_Count DESC;
    
    
    
    
    
    
    
    
    
    
    
    SELECT 
    ci.C_ID,
    ci.Name,
    CASE 
        WHEN HOUR(ct.Time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(ct.Time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(ct.Time) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night'
    END AS Order_Time_Category,
    COUNT(*) AS Order_Count
FROM 
    credit_transactions ct
JOIN 
    customer_info ci ON ct.Credit_card = ci.C_ID
GROUP BY 
    ci.C_ID, ci.Name, Order_Time_Category
ORDER BY 
    ci.C_ID, Order_Count DESC;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    SELECT 
    Payment_Method,
    round(AVG(Price - Selling_price),2) AS Avg_Discount,
    round(SUM(Price - Selling_price),2) AS Total_Discount,
    COUNT(*) AS Transaction_Count
FROM 
    credit_transactions
GROUP BY 
    Payment_Method
ORDER BY 
    Avg_Discount DESC;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    SELECT 
    CASE 
        WHEN Selling_price > 1000 THEN 'High Value'
        WHEN Selling_price BETWEEN 100 AND 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Value_Category,
    COUNT(*) AS Order_Count,
   round( AVG(Selling_price),2) AS Avg_Price,
    round(SUM(Selling_price),2) AS Total_Revenue
FROM 
    credit_transactions
GROUP BY 
    Value_Category
ORDER BY 
    Avg_Price DESC;
    
    
    
    
    
    
    
    
    
    
    SELECT 
    Merchant_name,
    round(AVG((Price - Selling_price) / Price) * 100,2) AS Avg_Discount_Percentage,
    COUNT(*) AS Order_Count,
    round(SUM(Selling_price),3) AS Total_Revenue
FROM 
    credit_transactions
GROUP BY 
    Merchant_name
ORDER BY 
    Avg_Discount_Percentage DESC;
    
    
    
    
    
    
    