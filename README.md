
# 🧪 ETL Pipeline for COVID-19 Data (Bash + Python + PostgreSQL)

## 📘 Executive Summary

This project demonstrates a complete ETL (Extract, Transform, Load) pipeline that automates the ingestion of global COVID-19 data, transforms it for analysis, and loads it into a PostgreSQL database. The pipeline was developed as part of the *Data Acquisition and Management* course under the guidance of Instructor Muhammad Shahin, as a PGDM Predictive Analytics assignment at the University of Winnipeg.

---

## 🛠️ Technologies Used

- **Bash scripting**
- **Python 3** (`psycopg2` for PostgreSQL interaction)
- **PostgreSQL**
- **Crontab** (Linux job scheduler)

---

## 📂 Project Structure

```
.
├── etl.sh                   # Shell script to perform ETL
├── load_data.py            # Python script to load CSV into PostgreSQL
├── transformed_covid_data.csv # Cleaned & transformed data
├── covid_data.csv          # Raw data file from source
├── cron.log                # (Optional) Log file created by cron job
└── README.md               # Project description (this file)
```

---

## 🔄 ETL Process Overview

### 1. **Extraction**  
- **Tool:** `curl` (in Bash)
- **Purpose:** Fetch live COVID-19 dataset from [Our World In Data](https://github.com/owid/covid-19-data).
- **Output:** `covid_data.csv`

### 2. **Transformation**
- **Tool:** `cut`, `sed` (in Bash)
- **Purpose:**
  - Select only essential columns: `iso_code`, `location`, `date`, `total_cases`
  - Replace missing or empty values with `'Unknown'`
- **Output:** `transformed_covid_data.csv`

### 3. **Loading**
- **Tool:** `psycopg2` (Python)
- **Purpose:** Create table `covid` in `covid_db` and load cleaned data
- **Method:** Use `copy_from()` to bulk load CSV into PostgreSQL

### 4. **Automation (Cron Job)**
- **Tool:** `crontab`
- **Purpose:** Automate ETL execution at scheduled intervals
- **Status:** Configured to run every 2 minutes for testing, and later adjusted to run daily at `12:10 AM`.

### 5. **Logging**
- **Tool:** Cron log redirection
- **Purpose:** Monitor execution and debug failures
- **Command Example:**
  ```bash
  */2 * * * * /home/guru/etl.sh >> /home/guru/cron.log 2>&1
  ```

---

## 🚀 How to Run

### Requirements:
- Python 3
- PostgreSQL server running on `localhost`
- `psycopg2` installed:
  ```bash
  pip install psycopg2
  ```

### Steps:

1. **Run the ETL script manually:**
   ```bash
   bash etl.sh
   ```

2. **Load data into PostgreSQL:**
   ```bash
   python3 load_data.py
   ```

3. **Automate with Cron:**
   ```bash
   crontab -e
   ```

   Then add:
   ```bash
   */2 * * * * /home/guru/etl.sh >> /home/guru/cron.log 2>&1
   ```

---

## ✅ Outputs & Screenshots

- Data downloaded and cleaned successfully
- Database `covid_db` created
- Table `covid` populated with valid entries
- Cron job tested with 2-minute interval and reconfigured for daily automation
- Log file (`cron.log`) captures successful ETL execution

---

## 🧩 Conclusion

This ETL pipeline is a modular, automated solution for real-time COVID-19 data ingestion and storage. By leveraging Bash for orchestration, Python for database loading, and cron for automation, the system is scalable and reliable. It can be adapted to other datasets and extended with additional transformation logic or analytical dashboards.
