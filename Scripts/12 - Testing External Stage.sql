--listar os arquivos na stage
LIST @METADATA_DB.STAGES.meu_stage_s3;

--é possível fazer querys nos arquivos do s3 usando a stage
SELECT * 
FROM @METADATA_DB.STAGES.meu_stage_s3/
(FILE_FORMAT => 'METADATA_DB.FILE_FORMATS.PARQUET_FORMAT');

SELECT
METADATA$FILENAME AS NOME_ARQUIVO,
$1:time::STRING AS time,
$1:latitude::STRING AS latitude,
$1:longitude::STRING AS longitude,
$1:generationtime_ms::STRING AS generationtime_ms,
$1:utc_offset_seconds::STRING AS utc_offset_seconds,
$1:timezone::STRING AS timezone,
$1:timezone_abbreviation::STRING AS timezone_abbreviation,
$1:elevation::STRING AS elevation,
$1:temperature_2m::STRING AS temperature_2m,
$1:precipitation::STRING AS precipitation,
$1:windspeed_10m::STRING AS windspeed_10m,
$1:cloudcover::STRING AS cloudcover
FROM @METADATA_DB.STAGES.meu_stage_s3/
(FILE_FORMAT => 'METADATA_DB.FILE_FORMATS.PARQUET_FORMAT');

--Agora, um experimento:

--verificando tabela 
 select * from dev_raw.openmeteo.openmeteo_raw_archive 

--copy into permite que os dados do s3 sejam inseridos em uma tabela de estrutura identica
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
);

--segunda conferencia
 select * from dev_raw.openmeteo.openmeteo_raw_archive 