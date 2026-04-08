CREATE SCHEMA IF NOT EXISTS er_cdss;

CREATE TABLE er_cdss.patient (
    patient_id INT PRIMARY KEY,
    gender CHAR NOT NULL,
    chief_complaint VARCHAR(200),
    race VARCHAR(175)
);

CREATE TABLE er_cdss.vitals (
    visit_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES er_cdss(patient_id),
    temperature DECIMAL,
    heart_rate DECIMAL,
    respiratory_rate DECIMAL,
    o2_sat DECIMAL,
    systolic_bp DECIMAL,
    diastolic_bp DECIMAL
);

CREATE TABLE er_cdss.imaging_orders (
    visit_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES er_cdss(patient_id),
    imaging_type VARCHAR(150),
    image_path VARCHAR(260)
);

CREATE TABLE er_cdss.imaging_results (
    visit_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES er_cdss(patient_id),
    model_used VARCHAR(200),
    finding VARCHAR(350),
    confidence_score DECIMAL
);

CREATE TABLE er_cdss.llm_output (
    visit_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES er_cdss(patient_id),
    differential_diagnosis TEXT,
    time_stamp TIMESTAMP 
);