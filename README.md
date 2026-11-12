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

![Gold Pipeline Architecture](screenshots/gold_pipeline_architecture.png)

## 📊 Dashboard

The project includes three interactive dashboard pages.

### 1. Executive Overview

Displays total bookings, net revenue, room nights, cancellations, and monthly booking trends.

![Executive Overview](screenshots/dashboard_overview.png)

### 2. Hotels, Rooms & Channels

Analyzes hotel revenue, room type performance, booking channels, cancellation rates, and guest ratings.

![Hotels, Rooms & Channels](screenshots/dashboard_hotels_rooms_channels.png)

### 3. Data Quality

Tracks clean records, rejected records, duplicates, and data reconciliation.

![Data Quality](screenshots/dashboard_data_quality.png)

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
