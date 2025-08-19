--definir o range do time travel da tabela em 5 dias
ALTER TABLE dev_raw.openmeteo.openmeteo_raw_archive SET DATA_RETENTION_TIME_IN_DAYS = 5;

--tabelas, schemas e databases podem ter ranges diferentes
ALTER SCHEMA dev_raw.openmeteo SET DATA_RETENTION_TIME_IN_DAYS = 7;
ALTER DATABASE dev_raw SET DATA_RETENTION_TIME_IN_DAYS = 10;


--Vamos fazer alguns experimentos
--Primeiro, anote o momento atual:
select CURRENT_TIMESTAMP -- coloque o resultado aqui, ex: 2025-07-31 17:00:28.624 -0700

--Vamos checar quantas linhas a tabela tem agora, provavelmente são 4 (use o timestamp da query anterior)
SELECT count(*) FROM dev_raw.openmeteo.openmeteo_raw_archive AT (TIMESTAMP => '2025-07-31 17:00:28.624 -0700');

--E quais são?
SELECT * FROM dev_raw.openmeteo.openmeteo_raw_archive AT (TIMESTAMP => CURRENT_TIMESTAMP);

--Ok, agora vamos inserir mais uma linha:
INSERT INTO dev_raw.OPENMETEO.openmeteo_raw_archive (
    time, latitude, longitude, generationtime_ms,
    utc_offset_seconds, timezone, timezone_abbreviation, elevation,
    temperature_2m, precipitation, windspeed_10m, cloudcover
) VALUES
(CURRENT_TIMESTAMP, -70.5, -50.5, 0.000346455894058594, 0, 'GMT', 'GMT', 737.0, 16.6, 0.0, 4.0, 28)


--agora um count na tabela, devemos ter cerca de 5 linhas:
select count(*) from dev_raw.openmeteo.openmeteo_raw_archive

--Agora, se eu rodo novamente a query para a foto do momento incial deste experimento,
--provavalmente voltaremos para as 4 linhas:
SELECT count(*) FROM dev_raw.openmeteo.openmeteo_raw_archive AT (TIMESTAMP => '2025-07-31 17:00:28.624 -0700');

--Tambem podemos voltar x segundos no tempo:
SELECT count(*) FROM dev_raw.openmeteo.openmeteo_raw_archive BEFORE (OFFSET => -60*10); -- 10 minutos atrás
