--cria um stream da tabela com as linhas já existentes na mesma
CREATE OR REPLACE STREAM openmeteo_archive_stream 
ON TABLE dev_raw.openmeteo.openmeteo_raw_archive
  SHOW_INITIAL_ROWS = TRUE,
  APPEND_ONLY = FALSE;
  
--vamos testar:
SELECT * FROM openmeteo_archive_stream;

--vamos consumir nosso stream:
CREATE OR REPLACE table tabela_teste_stream as SELECT * FROM openmeteo_archive_stream;

--agora o confere no stream de novo.
--ele estará vazio por ter sido consumido
SELECT * FROM openmeteo_archive_stream;

--vamos mexer nos dados:
UPDATE dev_raw.openmeteo.openmeteo_raw_archive
SET temperature_2m = 17
WHERE temperature_2m = 16.6;

--agora o confere no stream de novo:
 SELECT s.METADATA$ACTION, s.* FROM openmeteo_archive_stream s;

-- Deleta um registro
DELETE FROM dev_raw.openmeteo.openmeteo_raw_archive
WHERE temperature_2m = 14.9;

 --2 linhas novas devem ter aparecido
 --vou por a ação na frente para que fique mais facil identifica-las
  SELECT s.METADATA$ACTION, s.* FROM openmeteo_archive_stream s;

