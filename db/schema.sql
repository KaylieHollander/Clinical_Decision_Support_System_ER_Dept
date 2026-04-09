CREATE SCHEMA IF NOT EXISTS er_cdss;
 
CREATE TABLE er_cdss.patient(
    visit_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    gender CHAR(1) NOT NULL,
    chief_complaint VARCHAR(200),
    race VARCHAR(175)
);

CREATE TABLE er_cdss.triage_vitals (
    triage_vitals_id SERIAL PRIMARY KEY,
    visit_id INT REFERENCES er_cdss.patient(visit_id),
    temperature DECIMAL,
    heart_rate DECIMAL,
    respiratory_rate DECIMAL,
    o2_sat DECIMAL,
    systolic_bp DECIMAL,
    diastolic_bp DECIMAL
);

CREATE TABLE er_cdss.er_vitals (
    vitals_id SERIAL PRIMARY KEY,
    visit_id INT REFERENCES er_cdss.patient(visit_id),
    chart_time TIMESTAMP,
    temperature DECIMAL,
    heart_rate DECIMAL,
    respiratory_rate DECIMAL,
    o2_sat DECIMAL,
    systolic_bp DECIMAL,
    diastolic_bp DECIMAL
);

CREATE TABLE er_cdss.imaging_orders (
    imaging_orders_id SERIAL PRIMARY KEY,
    visit_id INT REFERENCES er_cdss.patient(visit_id),
    imaging_type VARCHAR(150),
    image_path VARCHAR(260)
);

CREATE TABLE er_cdss.imaging_results (
    imaging_results_id SERIAL PRIMARY KEY,
    visit_id INT REFERENCES er_cdss.patient(visit_id),
    model_used VARCHAR(200),
    finding VARCHAR(350),
    confidence_score DECIMAL
);

CREATE TABLE er_cdss.llm_output (
    llm_output_id SERIAL PRIMARY KEY,
    visit_id INT REFERENCES er_cdss.patient(visit_id),
    differential_diagnosis TEXT,
    time_stamp TIMESTAMP 
);