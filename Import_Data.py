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

vitals_df = pd.read_csv(r'/Users/kayliehollander/Downloads/vitalsign.csv')
patient_df = pd.read_csv(r'/Users/kayliehollander/Downloads/edstays.csv')
triage_df = pd.read_csv(r'/Users/kayliehollander/Downloads/triage.csv')

cursor = conn.cursor()

# Merge triage_df with patient_df first in order to allow the "chief complaint" column to be added into the patient table
patient_df = patient_df.merge(
    triage_df[['stay_id', 'chiefcomplaint']],
    on = 'stay_id',
    how = 'left'
)

for _, row in patient_df.iterrows():
    cursor.execute("""
        INSERT INTO er_cdss.patient (visit_id, patient_id, gender, race, chief_complaint)
        VALUES (%s, %s, %s, %s, %s)
        ON CONFLICT (visit_id) DO NOTHING
    """, (row['stay_id'], row['subject_id'], row['gender'], row['race'], row['chiefcomplaint']))


for _, row in triage_df.iterrows():
    cursor.execute("""
        INSERT INTO er_cdss.triage_vitals (visit_id, temperature, heart_rate, respiratory_rate, o2_sat, systolic_bp, diastolic_bp)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT DO NOTHING
    """, (row['stay_id'], row['temperature'], row['heartrate'], row['resprate'], row['o2sat'], row['sbp'], row['dbp']))


for _, row in vitals_df.iterrows():
    cursor.execute("""
        INSERT INTO er_cdss.er_vitals (visit_id, chart_time, temperature, heart_rate, respiratory_rate, o2_sat, systolic_bp, diastolic_bp)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT DO NOTHING
    """, (row['stay_id'], row['charttime'], row['temperature'], row['heartrate'], row['resprate'], row['o2sat'], row['sbp'], row['dbp']))


conn.commit()
cursor.close()
conn.close()