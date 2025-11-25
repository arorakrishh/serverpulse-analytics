# Detailed Setup Guide

This guide provides step-by-step instructions for setting up the ServerPulse Analytics project.

## Table of Contents
1. [Prerequisites Installation](#prerequisites-installation)
2. [Project Setup](#project-setup)
3. [Running the Pipeline](#running-the-pipeline)
4. [Verification](#verification)
5. [Troubleshooting](#troubleshooting)

---

## Prerequisites Installation

### 1. Install Docker Desktop

**Windows:**
- Download from https://www.docker.com/products/docker-desktop
- Run the installer
- Restart your computer
- Verify: `docker --version` and `docker-compose --version`

**macOS:**
- Download from https://www.docker.com/products/docker-desktop
- Drag to Applications folder
- Launch Docker Desktop
- Verify: `docker --version` and `docker-compose --version`

**Linux:**
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
```

### 2. Install Python 3.8+

**Windows:**
- Download from https://www.python.org/downloads/
- Run installer (check "Add Python to PATH")
- Verify: `python --version`

**macOS:**
```bash
brew install python3
```

**Linux:**
```bash
sudo apt-get install python3 python3-pip
```

### 3. Install Apache Spark (Optional but Recommended)

**Windows:**
1. Download Spark from https://spark.apache.org/downloads.html
2. Extract to `C:\spark`
3. Set environment variables:
   - `SPARK_HOME=C:\spark`
   - Add `%SPARK_HOME%\bin` to PATH
4. Install Java JDK 8 or 11

**macOS:**
```bash
brew install apache-spark
```

**Linux:**
```bash
wget https://archive.apache.org/dist/spark/spark-3.0.1/spark-3.0.1-bin-hadoop2.7.tgz
tar -xzf spark-3.0.1-bin-hadoop2.7.tgz
sudo mv spark-3.0.1-bin-hadoop2.7 /opt/spark
echo 'export SPARK_HOME=/opt/spark' >> ~/.bashrc
echo 'export PATH=$PATH:$SPARK_HOME/bin' >> ~/.bashrc
source ~/.bashrc
```

---

## Project Setup

### 1. Clone the Repository
```bash
git clone <your-repository-url>
cd serverpulse-analytics
```

### 2. Install Python Dependencies
```bash
pip install kafka-python requests
```

### 3. Verify Docker is Running
```bash
docker ps
```
If you see an error, start Docker Desktop.

---

## Running the Pipeline

### Method 1: Automated (Recommended)

**Windows:**
```powershell
.\run_demo.ps1
```

**Linux/macOS:**
```bash
chmod +x run_demo.sh
./run_demo.sh
```

### Method 2: Manual

**Step 1: Start Infrastructure**
```bash
docker-compose up -d --build
```

**Step 2: Wait for Services**
Wait 30 seconds for all services to initialize.

**Step 3: Start Event Simulator**
Open a new terminal:
```bash
python data_center_server_live_status/data_center_server_live_status_simulator.py
```

**Step 4: Start Spark Job**
Open another terminal:

With spark-submit:
```bash
spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.0.1,org.postgresql:postgresql:42.2.16 datapipeline/real_time_streaming_data_pipeline.py
```

Or with PowerShell script (Windows):
```powershell
.\run_spark.ps1
```

---

## Verification

### 1. Check Docker Containers
```bash
docker ps
```
You should see: `zookeeper`, `kafka`, `postgres`, `dashboard`

### 2. Access Services

| Service | URL | Expected Result |
|---------|-----|-----------------|
| Dashboard | http://localhost:8000 | Django dashboard with charts |
| PostgreSQL | localhost:5432 | Database connection |
| Kafka | localhost:9092 | Kafka broker |
| ZooKeeper | localhost:2181 | Coordination service |

### 3. Verify Data Flow

**Check Kafka topic:**
```bash
docker exec -it kafka kafka-topics --list --bootstrap-server localhost:9092
```
Should show: `server-live-status`

**Check PostgreSQL data:**
```bash
docker exec -it postgres psql -U demouser -d event_message_db -c "SELECT COUNT(*) FROM event_message_detail_agg_tbl;"
```

**Check Dashboard:**
Open http://localhost:8000 and verify charts are updating.

---

## Troubleshooting

### Issue: Port Already in Use

**Solution:**
```bash
# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# Linux/macOS
lsof -ti:8000 | xargs kill -9
```

### Issue: Docker Containers Not Starting

**Solution:**
```bash
docker-compose down
docker-compose up -d --build
docker logs <container-name>
```

### Issue: Kafka Connection Refused

**Solution:**
- Wait 30-60 seconds after starting services
- Check ZooKeeper is running: `docker logs zookeeper`
- Restart Kafka: `docker restart kafka`

### Issue: No Data in Dashboard

**Solution:**
1. Verify simulator is running and sending messages
2. Check Spark job console for errors
3. Query PostgreSQL directly:
   ```bash
   docker exec -it postgres psql -U demouser -d event_message_db -c "SELECT * FROM event_message_detail_agg_tbl LIMIT 5;"
   ```

### Issue: Spark Submit Not Found

**Solution:**
- Install Apache Spark (see Prerequisites)
- Or use PySpark directly:
  ```bash
  pip install pyspark==3.0.1
  python datapipeline/real_time_streaming_data_pipeline.py
  ```

---

## Stopping the Pipeline

**Stop all services:**
```bash
docker-compose down
```

**Stop and remove all data:**
```bash
docker-compose down -v
```

**Stop individual processes:**
- Simulator: Press `Ctrl+C` in the simulator terminal
- Spark Job: Press `Ctrl+C` in the Spark terminal

---

## Next Steps

After successful setup:
1. Explore the dashboard at http://localhost:8000
2. Modify the simulator to generate different event patterns
3. Customize the Spark job for additional transformations
4. Enhance the dashboard with new visualizations

For more information, see the main [README.md](README.md).
