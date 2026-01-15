Analysis performed using SQL in Google BigQuery
Key Insights
  · Most churn occurs within the first 1-2 months after initial purchase.
  · Earlier cohorts retain customers more effectively, suggesting higher customer quality.
  · Retention stabilizes after month three, indicating a loyal core customeer base.
  
SQL Code

WITH first_orders AS (
  SELECT
    customer_id,
    DATE_TRUNC(MIN(order_date), MONTH) AS cohort_month
  FROM portfolio_analysis.orders_native
  GROUP BY customer_id
),

customer_month_activity AS (
  SELECT
    o.customer_id,
    f.cohort_month,
    DATE_TRUNC(o.order_date, MONTH) AS activity_month
  FROM portfolio_analysis.orders_native o
  JOIN first_orders f
    ON o.customer_id = f.customer_id
),

cohort_table AS (
  SELECT
    cohort_month,
    DATE_DIFF(activity_month, cohort_month, MONTH) AS months_since_first_purchase,
    customer_id
  FROM customer_month_activity
)

SELECT
  cohort_month,
  months_since_first_purchase,
  COUNT(customer_id) AS customers
FROM cohort_table
GROUP BY cohort_month, months_since_first_purchase
ORDER BY cohort_month, months_since_first_purchase;
      
