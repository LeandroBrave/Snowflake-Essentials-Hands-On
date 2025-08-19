-- função undrop
--para esta demonstração, vamos dropar a tabela:
drop table dev_raw.openmeteo.openmeteo_raw_archive;

--checando se o drop ocorreu, erro esperado:
select * from dev_raw.openmeteo.openmeteo_raw_archive

--o snowflake permite que vc "desdrope" a tabela:
undrop table dev_raw.openmeteo.openmeteo_raw_archive

--checando se a tabela foi desdropada:
select * from dev_raw.openmeteo.openmeteo_raw_archive

--Recuperando linhas deletadas com o AT:
--Primeiro, vou deletar tudo
delete from dev_raw.openmeteo.openmeteo_raw_archive

--depois, conferir se foi tudo deletado mesmo
select * from dev_raw.openmeteo.openmeteo_raw_archive;

--agora, o backup usando a função AT, do momento usado no script passado:
INSERT INTO dev_raw.openmeteo.openmeteo_raw_archive
SELECT * 
FROM dev_raw.openmeteo.openmeteo_raw_archive 
AT (TIMESTAMP => '2025-07-31 17:00:28.624 -0700');

--vamos conferir:
select * from dev_raw.openmeteo.openmeteo_raw_archive 

