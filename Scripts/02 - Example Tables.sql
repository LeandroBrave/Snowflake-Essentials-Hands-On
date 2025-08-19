--Criando tabelas de exemplo
CREATE TABLE dev_raw.OPENMETEO.openmeteo_raw_archive (
    time TIMESTAMP, 
    latitude FLOAT, 
    longitude FLOAT, 
    generationtime_ms FLOAT,  
    utc_offset_seconds INTEGER, 
    timezone STRING,  
    timezone_abbreviation STRING, 
    elevation FLOAT, 
    temperature_2m FLOAT, 
    precipitation FLOAT,  
    windspeed_10m FLOAT,  
    cloudcover INTEGER   
);

CREATE TABLE dev_raw.OPENMETEO.openmeteo_raw_forecast (
    time TIMESTAMP NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    generationtime_ms DOUBLE PRECISION,
    utc_offset_seconds INTEGER,
    timezone TEXT,
    timezone_abbreviation TEXT,
    elevation DOUBLE PRECISION,
    temperature_2m DOUBLE PRECISION,
    precipitation DOUBLE PRECISION,
    windspeed_10m DOUBLE PRECISION,
    cloudcover INTEGER
);
/*
Tabelas são objetos onde os dados são efetivamente armazenados. 
É organizada em colunas e linhas, e cada coluna tem um tipo de dado específico, como números, textos ou datas.
*/

--inserts de teste, usarei pra testar os grants e as roles
INSERT INTO dev_raw.OPENMETEO.openmeteo_raw_archive (
    time, latitude, longitude, generationtime_ms,
    utc_offset_seconds, timezone, timezone_abbreviation, elevation,
    temperature_2m, precipitation, windspeed_10m, cloudcover
) VALUES
(CURRENT_TIMESTAMP, -23.5, -46.5, 0.062346458435058594, 0, 'GMT', 'GMT', 737.0, 16.6, 0.0, 4.0, 28),
(CURRENT_TIMESTAMP, -23.5, -46.5, 0.062346458435058594, 0, 'GMT', 'GMT', 737.0, 15.7, 0.0, 3.9, 6),
(CURRENT_TIMESTAMP, -23.5, -46.5, 0.062346458435058594, 0, 'GMT', 'GMT', 737.0, 14.9, 0.0, 3.8, 5),
(CURRENT_TIMESTAMP, -23.5, -46.5, 0.062346458435058594, 0, 'GMT', 'GMT', 737.0, 14.2, 0.0, 3.6, 4);

INSERT INTO dev_raw.OPENMETEO.openmeteo_raw_forecast (
    time, latitude, longitude, generationtime_ms,
    utc_offset_seconds, timezone, timezone_abbreviation, elevation,
    temperature_2m, precipitation, windspeed_10m, cloudcover
) VALUES
(CURRENT_TIMESTAMP, -23.5, -46.5, 0.062346458435058594, 0, 'GMT', 'GMT', 737.0, 16.6, 0.0, 4.0, 28),
(CURRENT_TIMESTAMP, -23.5, -46.5, 0.062346458435058594, 0, 'GMT', 'GMT', 737.0, 15.7, 0.0, 3.9, 6),
(CURRENT_TIMESTAMP, -23.5, -46.5, 0.062346458435058594, 0, 'GMT', 'GMT', 737.0, 14.9, 0.0, 3.8, 5),
(CURRENT_TIMESTAMP, -23.5, -46.5, 0.062346458435058594, 0, 'GMT', 'GMT', 737.0, 14.2, 0.0, 3.6, 4);

/*
O comando insert "inserta" dados na tabela.
Utilizamos ele acima para criar dados amostrais em algumas tabelas.
*/

--Criando tabelas de exemplo hml
CREATE TABLE hml_raw.OPENMETEO.openmeteo_raw_archive (
    time TIMESTAMP, 
    latitude FLOAT, 
    longitude FLOAT, 
    generationtime_ms FLOAT,  
    utc_offset_seconds INTEGER, 
    timezone STRING,  
    timezone_abbreviation STRING, 
    elevation FLOAT, 
    temperature_2m FLOAT, 
    precipitation FLOAT,  
    windspeed_10m FLOAT,  
    cloudcover INTEGER   
);

CREATE TABLE hml_raw.OPENMETEO.openmeteo_raw_forecast (
    time TIMESTAMP NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    generationtime_ms DOUBLE PRECISION,
    utc_offset_seconds INTEGER,
    timezone TEXT,
    timezone_abbreviation TEXT,
    elevation DOUBLE PRECISION,
    temperature_2m DOUBLE PRECISION,
    precipitation DOUBLE PRECISION,
    windspeed_10m DOUBLE PRECISION,
    cloudcover INTEGER
);

