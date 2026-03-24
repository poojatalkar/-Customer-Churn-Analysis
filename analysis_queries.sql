--KPI
--1 — Churn Rate

WITH churn_calc AS (
    SELECT
        COUNT(Customer_ID)       AS Total_Customers,
        SUM(CASE WHEN Customer_Status = 'Churned' 
            THEN 1 ELSE 0 END)   AS Churned_Customers
    FROM prod_churn
)
SELECT
    Total_Customers,
    Churned_Customers,
    ROUND(Churned_Customers * 100.0 / Total_Customers, 2) AS Churn_Rate_Percentage
FROM churn_calc;


--2 — Retention Rate

WITH churn_calc as (
   select
         count(Customer_ID) as 	Total_customers,
		 sum(case 
		         when customer_status = 'Stayed' 
				 then 1 else 0 end) as Retained_Customers
		 from prod_churn
)
select Total_customers, Retained_Customers,
       round(Retained_Customers*100.0/Total_customers,2) as Retention_Rate_Percentage
FROM churn_calc;
		 

--3 — Revenue Impact
WITH revenue_calc AS (
    SELECT
        SUM(Total_Revenue)                                              AS Total_Revenue,
        SUM(CASE WHEN Customer_Status = 'Stayed' 
            THEN Total_Revenue ELSE 0 END)                             AS Revenue_Retained,
        SUM(CASE WHEN Customer_Status = 'Churned' 
            THEN Total_Revenue ELSE 0 END)                             AS Revenue_Lost,
        SUM(CASE WHEN Customer_Status = 'Joined' 
            THEN Total_Revenue ELSE 0 END)                             AS Revenue_Joiners
    FROM prod_churn
)
SELECT
    ROUND(Total_Revenue, 2)                                            AS Total_Revenue,
    ROUND(Revenue_Retained, 2)                                         AS Revenue_Retained,
    ROUND(Revenue_Lost, 2)                                             AS Revenue_Lost,
    ROUND(Revenue_Joiners, 2)                                          AS Revenue_Joiners,
    ROUND(Revenue_Lost * 100.0 / Total_Revenue, 2)                     AS Revenue_Lost_Pct
FROM revenue_calc;