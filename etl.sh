#!/bin/bash

# Define variables
DATA_URL="https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv"
DATA_FILE="covid_data.csv"
TRANSFORMED_FILE="transformed_covid_data.csv"

echo "Starting ETL process..."

# Step 1: Extract - Download the dataset
echo "Downloading COVID-19 dataset..."
curl -o $DATA_FILE $DATA_URL

# Step 2: Verify - Check if the file was downloaded successfully
if [ ! -f "$DATA_FILE" ]; then
    echo "Error: Data file not found! Exiting..."
    exit 1
fi

echo "File downloaded successfully!"

# Count rows and columns in the downloaded file
ROW_COUNT=$(wc -l < "$DATA_FILE")
COL_COUNT=$(head -n 1 "$DATA_FILE" | awk -F',' '{print NF}')

echo "Downloaded File: $DATA_FILE"
echo "Number of rows: $ROW_COUNT"
echo "Number of columns: $COL_COUNT"

# Step 3: Transform Data
echo "Transforming data..."

# Step 3.1: Select relevant columns (Example: Columns 1, 2, 4, 5)
cut -d',' -f1,2,4,5 "$DATA_FILE" > "$TRANSFORMED_FILE"

# Step 3.2: Handle missing values
sed -i 's/,,/,Unknown,/g' "$TRANSFORMED_FILE"  # Replace empty fields with 'Unknown'
sed -i 's/,$/,Unknown/' "$TRANSFORMED_FILE"    # Replace trailing commas with ',Unknown'

echo "Transformation completed!"

# Count rows and columns in the transformed file
TRANS_ROW_COUNT=$(wc -l < "$TRANSFORMED_FILE")
TRANS_COL_COUNT=$(head -n 1 "$TRANSFORMED_FILE" | awk -F',' '{print NF}')

echo "Transformed File: $TRANSFORMED_FILE"
echo "Number of rows: $TRANS_ROW_COUNT"
echo "Number of columns: $TRANS_COL_COUNT"

echo "Previewing first 5 rows of transformed data:"
head -5 "$TRANSFORMED_FILE"

