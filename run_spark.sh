#!/bin/bash
# run_spark.sh
# Bash script to run the Spark streaming job

echo "Starting Spark Streaming Job..."

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PY_SCRIPT="$SCRIPT_DIR/datapipeline/real_time_streaming_data_pipeline.py"

# Check if spark-submit is available
if ! command -v spark-submit &> /dev/null; then
    echo "ERROR: spark-submit not found in PATH"
    echo ""
    echo "Please install Apache Spark and add it to your PATH, or run:"
    echo "  pip install pyspark==3.0.1"
    echo "  python $PY_SCRIPT"
    echo ""
    echo "For detailed setup instructions, see SETUP.md"
    exit 1
fi

if [ ! -f "$PY_SCRIPT" ]; then
    echo "ERROR: Python script not found at $PY_SCRIPT"
    exit 1
fi

echo "Submitting Spark job with required packages..."
echo ""

spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.0.1,org.postgresql:postgresql:42.2.16 "$PY_SCRIPT"
