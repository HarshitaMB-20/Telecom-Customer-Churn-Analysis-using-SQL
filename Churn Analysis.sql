CREATE DATABASE telecom_project;
USE telecom_project;

CREATE TABLE customer_raw (
  customer_id VARCHAR(50),
  gender VARCHAR(20),
  age VARCHAR(20),
  married VARCHAR(20),
  dependents VARCHAR(20),
  city VARCHAR(100),
  zip_code VARCHAR(20),
  latitude VARCHAR(50),
  longitude VARCHAR(50),
  referrals VARCHAR(20),
  tenure_months VARCHAR(20),
  offer VARCHAR(50),
  phone_service VARCHAR(20),
  avg_monthly_long_distance VARCHAR(50),
  multiple_lines VARCHAR(20),
  internet_service VARCHAR(50),
  internet_type VARCHAR(50),
  avg_monthly_gb VARCHAR(50),
  online_security VARCHAR(20),
  online_backup VARCHAR(20),
  device_protection VARCHAR(50),
  tech_support VARCHAR(50),
  streaming_tv VARCHAR(20),
  streaming_movies VARCHAR(20),
  streaming_music VARCHAR(20),
  unlimited_data VARCHAR(20),
  contract VARCHAR(50),
  paperless_billing VARCHAR(20),
  payment_method VARCHAR(50),
  monthly_charges VARCHAR(50),
  total_charges VARCHAR(50),
  total_refunds VARCHAR(50),
  total_extra_data_charges VARCHAR(50),
  total_long_distance_charges VARCHAR(50),
  total_revenue VARCHAR(50),
  customer_status VARCHAR(50),
  churn_category VARCHAR(50),
  churn_reason VARCHAR(100)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customer.csv'
INTO TABLE customer_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM customer_raw;

-- How many customers are there in total, and how many customers churned vs not churned?
SELECT
    customer_status,
    COUNT(*) AS total_customers
FROM customer_raw
GROUP BY customer_status;

-- How many customers are there in total, and how are they distributed by customer status
SELECT
    customer_status,
    COUNT(*) AS total_customers
FROM customer_raw
GROUP BY customer_status
ORDER BY total_customers DESC;

-- What is the number of churned vs non-churned customers?
SELECT
    CASE
        WHEN customer_status = 'Churned' THEN 'Churned'
        ELSE 'Not Churned'
    END AS churn_group,
    COUNT(*) AS total_customers
FROM customer_raw
GROUP BY churn_group;

-- How many customers are active, churned, and newly joined?
SELECT
    customer_status,
    COUNT(*) AS total_customers
FROM customer_raw
GROUP BY customer_status;

-- What percentage of customers have churned?
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_percentage
FROM customer_raw;

-- What is the average tenure (in months) of customers based on their status?
SELECT
    customer_status,
    ROUND(AVG(tenure_months), 2) AS avg_tenure_months
FROM customer_raw
GROUP BY customer_status;

-- How many customers are using Internet Service?
SELECT
    COUNT(*) AS internet_service_customers
FROM customer_raw
WHERE internet_service <> 'No';

-- How many customers are using each type of internet service?
SELECT
    internet_type,
    COUNT(*) AS total_customers
FROM customer_raw
WHERE internet_service <> 'No'
GROUP BY internet_type;

-- Which are the top 5 customers with the highest monthly charges?
SELECT
    customer_id,
    monthly_charges
FROM customer_raw
ORDER BY monthly_charges DESC
LIMIT 5;

-- What is the average monthly charge, and how does each customer’s charge compare to the overall average?
SELECT
    customer_id,
    monthly_charges,
    ROUND(AVG(monthly_charges) OVER (), 2) AS overall_avg_monthly_charge
FROM customer_raw
LIMIT 10;

-- Who are the top customers based on monthly charges, and what is their rank?
SELECT
    customer_id,
    monthly_charges,
    RANK() OVER (ORDER BY monthly_charges DESC) AS charge_rank
FROM customer_raw
LIMIT 10;

-- Can we list customers who either churned or recently joined the service?
SELECT customer_id, customer_status
FROM customer_raw
WHERE customer_status = 'Churned'
UNION
SELECT customer_id, customer_status
FROM customer_raw
WHERE customer_status = 'Joined';

-- How many customers are there in each contract type?
SELECT
    contract,
    COUNT(*) AS total_customers
FROM customer_raw
GROUP BY contract
ORDER BY total_customers DESC;

-- Which contract types have the highest number of churned customers?
SELECT
    contract,
    COUNT(*) AS churned_customers
FROM customer_raw
WHERE customer_status = 'Churned'
GROUP BY contract
ORDER BY churned_customers DESC;

-- What is the average monthly charge for each contract type?
SELECT
    contract,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_charges
FROM customer_raw
GROUP BY contract;

-- Do customers with internet service churn more than those without it?
SELECT
    internet_service,
    COUNT(*) AS churned_customers
FROM customer_raw
WHERE customer_status = 'Churned'
GROUP BY internet_service;

-- Are customers with shorter tenure more likely to churn?
SELECT
    CASE
        WHEN tenure_months < 12 THEN 'Less than 1 year'
        WHEN tenure_months BETWEEN 12 AND 24 THEN '1–2 years'
        ELSE 'More than 2 years'
    END AS tenure_group,
    COUNT(*) AS churned_customers
FROM customer_raw
WHERE customer_status = 'Churned'
GROUP BY tenure_group;

-- Who are the top 10 highest-paying customers?
SELECT
    customer_id,
    monthly_charges
FROM customer_raw
ORDER BY monthly_charges DESC
LIMIT 10;

-- Does churn vary by payment method?
SELECT
    payment_method,
    COUNT(*) AS churned_customers
FROM customer_raw
WHERE customer_status = 'Churned'
GROUP BY payment_method
ORDER BY churned_customers DESC;

-- How does average tenure differ between churned and retained customers?
SELECT
    customer_status,
    ROUND(AVG(tenure_months), 2) AS avg_tenure
FROM customer_raw
GROUP BY customer_status;

-- Which cities have the highest number of customers?
SELECT
    city,
    COUNT(*) AS total_customers
FROM customer_raw
GROUP BY city
ORDER BY total_customers DESC
LIMIT 10;

-- How many customers use multiple lines?
SELECT
    multiple_lines,
    COUNT(*) AS total_customers
FROM customer_raw
GROUP BY multiple_lines;







