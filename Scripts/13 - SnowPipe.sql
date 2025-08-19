--criar o pipe
CREATE OR REPLACE PIPE dev_raw.openmeteo.pipe_openmeteo_raw_archive
  AUTO_INGEST = TRUE
  AS
  COPY INTO dev_raw.openmeteo.openmeteo_raw_archive
FROM (
  SELECT
    $1:time::TIMESTAMP AS time,
    $1:latitude::FLOAT AS latitude,
    $1:longitude::FLOAT AS longitude,
    $1:generationtime_ms::FLOAT AS generationtime_ms,
    $1:utc_offset_seconds::INT AS utc_offset_seconds,
    $1:timezone::STRING AS timezone,
    $1:timezone_abbreviation::STRING AS timezone_abbreviation,
    $1:elevation::FLOAT AS elevation,
    $1:temperature_2m::FLOAT AS temperature_2m,
    $1:precipitation::FLOAT AS precipitation,
    $1:windspeed_10m::FLOAT AS windspeed_10m,
    $1:cloudcover::INT AS cloudcover
  FROM @METADATA_DB.STAGES.meu_stage_s3/
  (FILE_FORMAT => 'METADATA_DB.FILE_FORMATS.PARQUET_FORMAT')
)
ON_ERROR = 'SKIP_FILE';


SHOW PIPES LIKE 'pipe_openmeteo_raw_archive';
--arn:aws:sqs:us-east-2:654496907303:sf-snowpipe-AIDAZQYYOIATZW25FEPBU-_RxAuHUp_zpPgNhYGOuTRQ

select count(*) From dev_raw.openmeteo.openmeteo_raw_archive


-- Pausar
ALTER PIPE dev_raw.openmeteo.pipe_openmeteo_raw_archive SET PIPE_EXECUTION_PAUSED = TRUE;

-- Ativar novamente
ALTER PIPE dev_raw.openmeteo.pipe_openmeteo_raw_archive SET PIPE_EXECUTION_PAUSED = FALSE

--recarrega o pipe
ALTER PIPE pipe_openmeteo_raw_archive REFRESH;



