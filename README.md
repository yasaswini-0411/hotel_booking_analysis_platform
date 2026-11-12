# 🏨 Hotel Booking Analytics Platform

### End-to-End Data Engineering Project | Databricks Lakeflow

## 📌 Project Overview

This project implements an end-to-end data engineering pipeline using Databricks Lakeflow Spark Declarative Pipelines and Medallion Architecture.

It processes hotel booking data, performs data cleaning and transformation, and generates business insights through interactive Databricks AI/BI dashboards.

## 🛠️ Technologies Used

- Databricks
- Apache Spark SQL
- Lakeflow Spark Declarative Pipelines
- Delta Lake
- Unity Catalog
- Databricks AI/BI Dashboards

## 🏗️ Data Architecture

**Raw CSV → Bronze → Silver → Gold → Dashboard**

- **Bronze:** Raw data ingestion using Auto Loader.
- **Silver:** Data cleaning, deduplication, validation, and rejected-record handling.
- **Gold:** Aggregated business metrics for reporting and analytics.

### Gold Pipeline Architecture

<img width="739" height="377" alt="gold_pipeline_architecture" src="https://github.com/user-attachments/assets/abed46f5-5f56-47a2-917c-dc0fa5952468" />

## 📊 Dashboard

The project includes three interactive dashboard pages.

### 1. Executive Overview

Displays total bookings, net revenue, room nights, cancellations, and monthly booking trends.

<img width="744" height="562" alt="image" src="https://github.com/user-attachments/assets/ac62343d-e7bb-494f-9ffc-839066b8699b" />

### 2. Hotels, Rooms & Channels

Analyzes hotel revenue, room type performance, booking channels, cancellation rates, and guest ratings.

<img width="622" height="632" alt="image" src="https://github.com/user-attachments/assets/4b603ab4-61bc-4baf-b22a-fefa654bfe99" />

### 3. Data Quality

Tracks clean records, rejected records, duplicates, and data reconciliation.

<img width="973" height="472" alt="image" src="https://github.com/user-attachments/assets/b3f5354d-6ab7-4a23-b4a1-d4ae6ddec7cd" />

## 📁 Project Files

The repository contains the exported Databricks project files, SQL transformations, and dashboard screenshots.

## 🎯 Key Learnings

- Building ETL pipelines using Databricks Lakeflow
- Implementing Medallion Architecture
- Cleaning and transforming data using Spark SQL
- Creating Gold-layer analytical tables
- Building interactive AI/BI dashboards

## ✅ Conclusion

This project demonstrates how raw hotel booking data can be transformed into reliable, analytics-ready datasets for business reporting and decision-making.
