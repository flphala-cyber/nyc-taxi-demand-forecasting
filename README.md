# NYC Taxi Demand Forecasting

A comprehensive analysis of NYC taxi trip data to identify passenger behavior patterns, fare pricing efficiencies, and peak demand periods to optimize urban mobility.

## 📌 Project Overview

This project explores the NYC Yellow Taxi dataset to uncover operational insights, seasonal demand trends, and pricing structures. By analyzing millions of trip records, the goal is to provide actionable recommendations for fleet optimization and urban transit planning.

## 🧹 Data Cleaning & Transformation Process

To ensure accurate forecasting and reliable analysis, a rigorous data cleaning pipeline was implemented using SQL. The following steps were taken to address anomalies and prepare the dataset:

- **Handling Missing Values**: Identified and removed rows with missing coordinates or critical missing fields like pickup/dropoff times.
- **Filtering Outliers**: Removed records where fare amounts, extra fees, or total amounts were less than or equal to zero.
- **Impossible Trips**: Filtered out rows where trip distance was zero or negative but a fare was charged.
- **Passenger Count**: Excluded records showing zero passengers or impossible configurations (e.g., more than 6 passengers).

## 💻 Key SQL Queries

Below are the core SQL scripts used to clean the dataset and extract operational insights.

### 1. Data Cleaning Pipeline

```sql
SELECT 
    vendor_id, 
    pickup_datetime, 
    dropoff_datetime, 
    passenger_count, 
    trip_distance, 
    fare_amount 
FROM `nyc-taxi-data` 
WHERE fare_amount > 0 
  AND trip_distance > 0 
  AND passenger_count BETWEEN 1 AND 6;
```

### 2. Peak Demand Aggregation

```sql
SELECT 
    EXTRACT(DAYOFWEEK FROM pickup_datetime) AS day_of_week,
    EXTRACT(HOUR FROM pickup_datetime) AS hour_of_day,
    COUNT(*) AS total_trips,
    ROUND(AVG(fare_amount), 2) AS avg_fare,
    ROUND(AVG(trip_distance), 2) AS avg_distance
FROM `nyc-taxi-data`
WHERE fare_amount > 0 AND trip_distance > 0
GROUP BY day_of_week, hour_of_day
ORDER BY total_trips DESC;
```
