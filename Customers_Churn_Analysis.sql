-- 1: Total Customers
      SELECT COUNT(*) AS Total_Customers
      FROM Customer_Churn;

-- 2: Churned Customers
      SELECT COUNT(*) AS Churned_Customers
      FROM Customer_Churn
      WHERE Churn = 'Yes';

-- 3: Churn Rate %
      SELECT CAST(SUM(CASE WHEN Churn='Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Rate
      FROM Customer_Churn;

-- 4: Revenue Lost
      SELECT SUM(CAST(Total_Spend AS BIGINT)) AS Revenue_Lost
      FROM Customer_Churn
      WHERE Churn = 'Yes';

-- 5: Churned vs Retained
      SELECT Churn, COUNT(*) AS Customers
      FROM Customer_Churn
      GROUP BY Churn;

-- 6: Churn rate by Contract Length
      SELECT Contract_Length, COUNT(*) AS Total,
       CAST(SUM(CASE WHEN Churn='Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Rate
      FROM Customer_Churn
      GROUP BY Contract_Length
      ORDER BY Churn_Rate DESC;

-- 7: Churn rate by Subscription Type
      SELECT Subscription_Type, COUNT(*) AS Total,
       CAST(SUM(CASE WHEN Churn='Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Rate
      FROM Customer_Churn
      GROUP BY Subscription_Type
      ORDER BY Churn_Rate DESC;

-- 8: Churn rate by Age Group
      SELECT
      CASE WHEN Age < 25 THEN '18-24' WHEN Age < 35 THEN '25-34'
      WHEN Age < 45 THEN '35-44' WHEN Age < 55 THEN '45-54'
         ELSE '55+' END AS Age_Group,
    COUNT(*) AS Total,
    CAST(SUM(CASE WHEN Churn='Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Rate
     FROM Customer_Churn
     GROUP BY
     CASE WHEN Age < 25 THEN '18-24' WHEN Age < 35 THEN '25-34'
          WHEN Age < 45 THEN '35-44' WHEN Age < 55 THEN '45-54'
         ELSE '55+' END
     ORDER BY MIN(Age);

-- 9: Churn rate by Tenure Group
      SELECT
      CASE WHEN Tenure <= 12 THEN '0-12' WHEN Tenure <= 24 THEN '13-24'
         WHEN Tenure <= 48 THEN '25-48' ELSE '49+' END AS Tenure_Group,
      COUNT(*) AS Total,
      CAST(SUM(CASE WHEN Churn='Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Rate
      FROM Customer_Churn
      GROUP BY
      CASE WHEN Tenure <= 12 THEN '0-12' WHEN Tenure <= 24 THEN '13-24'
         WHEN Tenure <= 48 THEN '25-48' ELSE '49+' END
         ORDER BY MIN(Tenure);

-- 10: Churn rate by Support Calls
       SELECT Support_Calls, COUNT(*) AS Total,
       CAST(SUM(CASE WHEN Churn='Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Rate
       FROM Customer_Churn
       GROUP BY Support_Calls
       ORDER BY Support_Calls;

-- 11: Churn rate by Payment Delay Group
       SELECT
       CASE WHEN Payment_Delay <= 7 THEN '0-7 days'
       WHEN Payment_Delay <= 15 THEN '8-15 days'
         ELSE '16+ days' END AS Delay_Group,
       COUNT(*) AS Total,
       CAST(SUM(CASE WHEN Churn='Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Rate
       FROM Customer_Churn
       GROUP BY
       CASE WHEN Payment_Delay <= 7 THEN '0-7 days'
         WHEN Payment_Delay <= 15 THEN '8-15 days'
         ELSE '16+ days' END
        ORDER BY MIN(Payment_Delay);

-- 12: Avg Spend, Churned vs Retained
       SELECT Churn,
       CAST(AVG(CAST(Total_Spend AS FLOAT)) AS DECIMAL(10,2)) AS Avg_Spend
       FROM Customer_Churn
       GROUP BY Churn;

-- 13: Churn by Gender
       SELECT Gender,
       SUM(CASE WHEN Churn='No'  THEN 1 ELSE 0 END) AS Retained,
       SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned
        FROM Customer_Churn
        GROUP BY Gender;

-- 14: High-risk segments
       SELECT TOP 8 Contract_Length, Subscription_Type,
       COUNT(*) AS Customers,
       SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned,
       CAST(SUM(CASE WHEN Churn='Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Rate
       FROM Customer_Churn
       GROUP BY Contract_Length, Subscription_Type
       HAVING COUNT(*) >= 500
       ORDER BY Churn_Rate DESC;