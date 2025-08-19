--O comando clone copia uma tabela sem o consumo extra de storage, mto útil para testes, simulações e validações
--vamos clonar a tabela que estamos usando de exemplo:
CREATE OR REPLACE TABLE dev_raw.openmeteo.openmeteo_raw_archive_cp CLONE dev_raw.openmeteo.openmeteo_raw_archive;

--validar que estão iguais:
SELECT COUNT(*) FROM dev_raw.openmeteo.openmeteo_raw_archive;
SELECT COUNT(*) FROM dev_raw.openmeteo.openmeteo_raw_archive_cp;

--se checarmos a qtd de bytes, podemos ver isso
SELECT table_name, active_bytes
FROM snowflake.account_usage.table_storage_metrics
WHERE table_name IN ('OPENMETEO_RAW_ARCHIVE', 'OPENMETEO_RAW_ARCHIVE_CP')
  AND table_schema = 'OPENMETEO'
  AND table_catalog = 'DEV_RAW';

