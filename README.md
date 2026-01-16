# ✈️ Airline Passenger Analysis (SQL Project)

This repository contains an **SQL-based Airline Passenger Analysis Project** built to explore airline operations and passenger travel patterns.  
Using structured SQL queries, the project answers business-driven questions related to **passenger traffic**, **flight trends**, **seat utilization**, and **route performance**.

---

## 📌 Project Overview

The goal of this project is to analyze airline flight data and extract useful insights such as:
- busiest routes and airports  
- most active cities  
- seat utilization efficiency  
- monthly travel demand trends  
- year-over-year growth & decline  

The analysis is performed entirely using SQL on the `airport_data` dataset.

---

## 🛠 Tools & Skills Used

- SQL
- Joins & Aggregations (`SUM`, `COUNT`, `AVG`, `MAX`)
- CTEs (`WITH` clause)
- Window Functions (`LAG`)
- Date-based grouping (Year / Month analysis)
- KPI-based analytics (utilization ratios & growth rates)

---

## 🗃 Dataset / Table Used

### Table: `airports`
Key columns used:
- `Origin_airport`, `Destination_airport`
- `Origin_city`, `Destination_city`
- `Fly_date`
- `Passengers`, `Seats`, `Flights`
- `Distance`

---

## 📊 Key Analysis Performed

### ✅ 1. Route Performance Analysis
- Identified **top routes by passenger traffic**
- Found routes with highest **flight frequency**
- Calculated **top busiest routes using weighted distance**
  - (Passengers × Distance)

### ✅ 2. Seat Utilization Efficiency
- Computed route efficiency using:
  - **Passengers / Seats ratio**
- Identified:
  - most efficient routes (high demand)
  - **underutilized routes** (low passengers but high seat capacity)
- Detected underperforming routes having:
  - at least **10 flights**
  - < **50% utilization**

### ✅ 3. Airport & City Activity Insights
- Found most active:
  - **origin airports**
  - **destination airports**
  - **origin cities**
- Ranked airports by total flights operated

### ✅ 4. Seasonal & Monthly Trend Analysis
- Extracted **monthly passenger and flight trends**
- Identified:
  - **most busy months**
  - **least busy months**
- Helps in understanding peak demand seasons

### ✅ 5. Growth & Decline (Year-over-Year Analysis)
- Compared yearly passenger trends using **window functions**
- Found:
  - routes with **highest YoY passenger increase**
  - routes with **largest YoY decline**
- Performed flight growth analysis for long-term operational trends

---

## ✅ Conclusion

This project successfully demonstrates how SQL can be used to perform real-world airline data analysis and generate meaningful operational insights.

By using advanced SQL concepts like **CTEs, window functions, aggregations, and KPI calculations**, the project provides:
- a clear view of **high demand routes and airports**
- route-level efficiency using **seat utilization**
- seasonal travel patterns for better planning
- growth and decline detection for strategic improvements

Overall, this repository showcases strong SQL analytical skills and practical business understanding required for roles like **Data Analyst / BI Analyst / SQL Developer**.

---

## 👤 Author

**Yash Panchal**  
GitHub: https://github.com/yashpanchal-dev


---
