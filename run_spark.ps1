# run_spark.ps1
# PowerShell script to run the Spark streaming job

Write-Host "Starting Spark Streaming Job..." -ForegroundColor Green

# Get the script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$pyScript = Join-Path $scriptDir "datapipeline\real_time_streaming_data_pipeline.py"

# Check if spark-submit is in PATH
$sparkSubmit = Get-Command spark-submit -ErrorAction SilentlyContinue

if ($null -eq $sparkSubmit) {
    Write-Host "ERROR: spark-submit not found in PATH" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Apache Spark and add it to your PATH, or run:" -ForegroundColor Yellow
    Write-Host "  pip install pyspark==3.0.1" -ForegroundColor Cyan
    Write-Host "  python $pyScript" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "For detailed setup instructions, see SETUP.md" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $pyScript)) {
    Write-Host "ERROR: Python script not found at $pyScript" -ForegroundColor Red
    exit 1
}

Write-Host "Submitting Spark job with required packages..." -ForegroundColor Cyan
Write-Host ""

spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.0.1,org.postgresql:postgresql:42.2.16 "$pyScript"
