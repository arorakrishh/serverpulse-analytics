# Quick Start Guide

Get the ServerPulse Analytics platform running in under 5 minutes!

## Prerequisites
- Docker Desktop installed and running
- Python 3.8+ installed
- 8GB RAM available

## 3-Step Setup

### Step 1: Start Services (30 seconds)
```bash
# Windows PowerShell
.\run_demo.ps1

# Linux/macOS
chmod +x run_demo.sh && ./run_demo.sh
```

### Step 2: Start Simulator (10 seconds)
Open a new terminal:
```bash
pip install kafka-python requests
python data_center_server_live_status/data_center_server_live_status_simulator.py
```

### Step 3: Start Spark Job (10 seconds)
Open another terminal:
```bash
# Windows
.\run_spark.ps1

# Linux/macOS (requires Spark installed)
spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.0.1,org.postgresql:postgresql:42.2.16 datapipeline/real_time_streaming_data_pipeline.py
```

## View Results
Open http://localhost:8000 in your browser to see the live dashboard!

## What's Happening?
1. **Simulator** generates fake server status events
2. **Kafka** streams the events
3. **Spark** processes and aggregates the data
4. **PostgreSQL** stores the results
5. **Dashboard** visualizes everything in real-time

## Stop Everything
```bash
docker-compose down
# Press Ctrl+C in simulator and Spark terminals
```

## Need Help?
- Full documentation: [README.md](README.md)
- Detailed setup: [SETUP.md](SETUP.md)
- Issues: Open a GitHub issue

---


