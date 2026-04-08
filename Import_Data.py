from dotenv import load_dotenv
import pandas as pd
import psycopg2
import os

load_dotenv()

conn = psycopg2.connect(
    host = os.getenv("DB_HOST"),
    port = os.getenv("DB_PORT"),
    database = os.getenv("DB_NAME"),
    user = os.getenv("DB_USER"),
    password = os.getenv("DB_PASSWORD")
)

df = pd.read_csv("")

cursor = conn.cursor()

for _, row in df.iterrows():
    cursor.execute("""
        INSERT INTO er_cdss.vitals 
            (visit_id, patient_id, temperature, heart_rate, respiratory_rate, o2_sat, systolic_bp, diastolic_bp)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT (patient_id) DO NOTHING
    """, (row['patient_id'], row['temperature'], row['heart_rate'], row['chief_complaint']))

conn.commit()
cursor.close()
conn.close()