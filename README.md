# 📊 Operation Metrics Analysis

<details>
<summary><b>Project Title</b></summary>

**Operation Metrics Analysis — SQL & Excel-Based Case Study**

Performed SQL-driven operational analytics on job and user datasets to uncover key performance metrics, engagement trends, and anomalies.  
The project includes two case studies:
1. **Job Data Analysis** — focuses on throughput and workload optimization.  
2. **Investigating Metric Spike** — explores user growth, retention, and engagement metrics.

</details>

---
<details>
<summary><b>Business Understanding</b></summary>

The goal of this project is to analyze organizational and user activity data to extract **actionable operational insights**.  
Both case studies focus on identifying **performance trends, retention patterns, and engagement anomalies** that can inform process improvements and marketing strategies.

**Key Business Questions:**
- What are the peak operational times and throughput trends?  
- Which languages or segments show imbalanced workloads?  
- How do user engagement and retention evolve over time?  
- What factors contribute to metric anomalies or engagement drops?

**Impact:**  
The insights generated can guide **resource allocation**, **localization strategy**, and **engagement optimization** for better business decisions.

</details>

---

<details>
<summary><b>Data Understanding</b></summary>

The dataset consists of two main segments:

### **Case Study 1: Job Data Analysis**
- Contains job records, timestamps, and language details.
- Used to measure throughput, job reviews per hour, and language share.
- Cleaned using **Excel**, imported into **MySQL**, and stored in a database named `operation_metrics_case1`.

### **Case Study 2: Investigating Metric Spike**
- Includes three datasets:
  - `users.csv` → User details  
  - `events.csv` → Activity logs  
  - `email_events.csv` → Email engagement records  
- Structured into the database `operation_metrics_case_study2` for relational analysis.

**Data Cleaning:**  
- Removed missing/duplicate records in Excel.  
- Normalized timestamps and standardized event formats.  
- Imported data using MySQL’s **Uploads** method for efficiency.

</details>
---

<details>
<summary><b>Technologies</b></summary>

| Tool | Purpose |
|------|----------|
| **MySQL Workbench 8.0.43** | Query execution, data analysis |
| **Microsoft Excel** | Data cleaning, preprocessing |
| **Power BI (optional)** | Visualization and dashboards |
| **SQL** | KPI calculations and insights generation |
| **GitHub** | Version control and project documentation |

</details>

---

<details>
<summary><b>Setup</b></summary>

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/operation-metrics-analysis.git
   ```
2. Open MySQL Workbench and create the following databases:
   - `operation_metrics_case1`
   - `operation_metrics_case_study2`
3. Import the CSV files from the `data/` folder using:
   ```sql
   LOAD DATA INFILE 'path_to_csv'
   INTO TABLE table_name
   FIELDS TERMINATED BY ','
   IGNORE 1 ROWS;
   ```
4. Run the SQL scripts in the `/sql/` folder.

</details>

---

<details>
<summary><b>Approach</b></summary>

### **Case Study 1: Job Data Analysis**
1. Cleaned and imported data into MySQL.  
2. Computed KPIs:
   - Jobs reviewed per hour  
   - 7-day rolling throughput average  
   - Language share percentage  
3. Identified peak dates and resource imbalance patterns.  
4. Recommended automation of throughput tracking.

### **Case Study 2: Investigating Metric Spike**
1. Combined multiple user activity tables using SQL joins.  
2. Measured:
   - Weekly user engagement  
   - User growth trend  
   - Retention per cohort  
   - Engagement by device  
   - Email open/click rates  
3. Discovered engagement anomalies and retention opportunities.

</details>

---

<details>
<summary><b>Status</b></summary>

✅ **Completed**  
- SQL scripts finalized  
- Results documented in PDF and README  
- Visuals pending Power BI/Excel dashboard upload  

📈 **Next Steps:**  
- Build a live dashboard for throughput and engagement metrics  
- Integrate automation for rolling KPI updates  

</details>

---
