import psycopg2
import csv

# Database connection details
dbname = "covid_db"
user = "postgres"  # replace with your PostgreSQL username
password = "1305"  # replace with your PostgreSQL password
host = "localhost"
port = "5432"

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname=dbname,
    user=user,
    password=password,
    host=host,
    port=port
)
cur = conn.cursor()

# Create the covid table if it doesn't exist
cur.execute("""
    CREATE TABLE IF NOT EXISTS covid (
        iso_code VARCHAR(10),
        location VARCHAR(255),
        date DATE,
        total_cases INTEGER
    );
""")

# Commit the changes
conn.commit()

# Load the transformed data from the CSV file into the table
csv_file = '/home/guru/transformed_covid_data.csv'  # Path to your transformed CSV file

with open(csv_file, 'r') as f:
    # Skip the header row
    next(f)
    # Replace "Unknown" with NULL and load data using COPY command
    def clean_row(row):
        return [
            value if value != "Unknown" else None
            for value in row
        ]
    
    # Read the CSV file and process each row
    reader = csv.reader(f)
    cleaned_rows = [clean_row(row) for row in reader]
    
    # Use the COPY command to insert the cleaned rows
    for row in cleaned_rows:
        cur.execute("""
            INSERT INTO covid (iso_code, location, date, total_cases)
            VALUES (%s, %s, %s, %s)
        """, row)

# Commit the changes and close the connection
conn.commit()
cur.close()
conn.close()

print("Data successfully loaded into the 'covid' table!")


