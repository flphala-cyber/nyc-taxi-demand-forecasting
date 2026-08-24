# NYC Taxi Demand Forecasting & Data Engineering Pipeline

An enterprise-grade, end-to-end data engineering pipeline built on **Microsoft Fabric** to ingest, clean, transform, and analyze millions of NYC Yellow Taxi trip records. This project transitions raw transit files through a structured Medallion Architecture into an interactive reporting suite.

🔗 **Live Analytics Dashboard**: [data-stagecoach.lovable.app](https://lovable.app)

---

## 🏗️ Architecture & Pipeline Overview

The project implements a fully automated, metadata-driven architecture across five distinct data layers:

1. **Source Data & Ingestion (Landing)**: Raw monthly data files (`yellow_tripdata_*.parquet` / `.csv`) are loaded directly into the **Microsoft Fabric OneLake** landing zone.
2. **Copy Data Pipeline (`PL_staging_Taxi`)**: A pipeline activity enumerates file paths dynamically using wildcard pathing (`Files/Yellow_Taxi/*.parquet`) and performs a high-performance copy operation from OneLake into a Delta staging table (`stg.yellowtaxi_pl`).
3. **Data Transformation Layer (Staging ➡️ Presentation)**: A **Dataflow Gen2** component (`DF_StagingToPresentation`) cleans anomalies (handling zero/negative values for distance/fares, validating passenger counts between 1 and 6) and outputs optimized, business-ready data to `dbo.nyctaxi_yellow`.
4. **Metadata Logging Center**: Upon transformation success, a Stored Procedure activity triggers `metadata.insert_presentation_metadata`. This maps crucial telemetry records (Pipeline Run ID, table names, rows processed, latest pickup datetimes, and UTC timestamps) into an explicit audit table (`metadata.processing_log`) for full lineage traceability.
5. **Consumption & Reporting Layer**: An automated action triggers a **Power BI Semantic Model refresh** (`YellowTaxi_SemanticModel`) via Direct Lake mode, ensuring zero data latency for executive overviews, operations insights, and downstream web applications.

---

## ⚙️ Orchestration Flow & Dependencies

The processing control loop is governed by conditional pipeline logic (`ProcessToPresentationPipeline`):
* **Step 1: CopyToStaging** ──*(On Success)*──> **Step 2: DF_StagingToPresentation (Dataflow Gen2)**
* **Step 2** ──*(On Success)*──> **Step 3: Insert Metadata Stored Procedure**
* **Step 3** ──*(On Success)*──> **Step 4: Refresh Semantic Model**

*Note: All sequential execution branches rely on strict dependency routing (green success arrows). If a micro-service step fails, subsequent segments halt automatically to prevent downstream data pollution.*

---

## 💻 Core SQL & Data Processing

The transformation rules managed under the hood can be queried directly via the relational warehouse layer.

### 1. Data Cleaning Pipeline
```sql
SELECT 
    vendor_id, 
    pickup_datetime, 
    dropoff_datetime, 
    passenger_count, 
    trip_distance, 
    fare_amount 
FROM `stg.yellowtaxi_pl` 
WHERE fare_amount > 0 
  AND trip_distance > 0 
  AND passenger_count BETWEEN 1 AND 6;
```

### 2. Peak Demand Aggregation Analysis
```sql
SELECT 
    EXTRACT(DAYOFWEEK FROM pickup_datetime) AS day_of_week,
    EXTRACT(HOUR FROM pickup_datetime) AS hour_of_day,
    COUNT(*) AS total_trips,
    ROUND(AVG(fare_amount), 2) AS avg_fare,
    ROUND(AVG(trip_distance), 2) AS avg_distance
FROM `dbo.nyctaxi_yellow`
WHERE fare_amount > 0 AND trip_distance > 0
GROUP BY day_of_week, hour_of_day
ORDER BY total_trips DESC;
```

---

## ⚡ Scalability & Key Benefits

* **End-to-End Automation**: Zero manual intervention from initial landing file detection to final dashboard reporting adjustments.
* **Fault-Tolerant Auditing**: Comprehensive observability tracking rows processed per run to instantly call out pipeline anomalies.
* **Enterprise Security**: Managed natively inside Microsoft Fabric environment with centralized data compliance and governance standards.
