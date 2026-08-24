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


## ⚡ Big Data Processing with Apache Spark

To scale the architecture for massive volumes of production transit data (millions of daily trip entries), the pipeline can be transitioned from traditional query engines to distributed cluster computing using **Apache Spark (PySpark)**.

The framework processes the data pipeline via:
* **Distributed Filters**: Eliminating negative fares and passenger outliers rapidly across worker nodes.
* **Lazy Evaluation optimization**: Chaining the cleaning sequences together before executing actions to lower runtime memory usage.
* **Aggregated Grouping**: Running cluster-wide group operations across trip timestamps to export low-latency analytics files.

The core distributed architecture script is available in the root directory under `spark_process.py`.



## 🚀 Live Application & Production Monitoring

### 💻 Interactive Dashboard
The frontend user interface and analytics dashboard are actively deployed and can be accessed live:
* **Live Web App**: [data-stagecoach.lovable.app](https://data-stagecoach.lovable.app)

### 📊 Data Pipeline Infrastructure (Lakeflow Ops)
The backend pipeline operates on a robust data engineering framework tracked via production monitors:
* **Data Scale**: Successfully processes over **73.8M taxi records** with a sustained **91.9% pipeline run success rate**.
* **Ingestion Strategy**: Leverages automated iteration loops (`ForEach`) tracking landing zone metadata to safely convert raw Parquet binaries straight into Delta staging structures with comprehensive schema drift mapping.
* **Relational Warehousing**: Executes merging procedures to pass deduplicated staging rows into production tables dynamically.
