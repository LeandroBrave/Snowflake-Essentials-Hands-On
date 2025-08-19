--Criando DATABASES
CREATE DATABASE DEV_RAW;
CREATE DATABASE DEV_STG;
CREATE DATABASE HML_RAW;
CREATE DATABASE HML_STG;
CREATE DATABASE PRD_RAW;
CREATE DATABASE PRD_STG;

/*
Aqui criamos 6 bancos de dados para organizar nosso ambiente Snowflake em três estágios principais: 

Desenvolvimento (DEV)
Homologação (HML)
Produção (PRD). 

Cada estágio tem dois bancos:
RAW: Dados brutos que são ingeridos diretamente da API — 
STG, ou staging: Dados intermediários preparados para uso. 

Essa separação é fundamental para garantir qualidade e controle do fluxo dos dados.
*/


--Criando SCHEMAS
-- DEV
CREATE SCHEMA DEV_RAW.OPENMETEO;
CREATE SCHEMA DEV_RAW.CAGED;

CREATE SCHEMA DEV_STG.OPENMETEO;
CREATE SCHEMA DEV_STG.CAGED;

-- HML
CREATE SCHEMA HML_RAW.OPENMETEO;
CREATE SCHEMA HML_RAW.CAGED;

CREATE SCHEMA HML_STG.OPENMETEO;
CREATE SCHEMA HML_STG.CAGED;

-- PRD
CREATE SCHEMA PRD_RAW.OPENMETEO;
CREATE SCHEMA PRD_RAW.CAGED;

CREATE SCHEMA PRD_STG.OPENMETEO;
CREATE SCHEMA PRD_STG.CAGED;
/*
Dentro de cada banco, criamos schemas para organizar os dados por origem da API:
Open-Meteo (dados meteorológicos)
CAGED (dados trabalhistas).
Essa estrutura permite manter a separação lógica dos dados, facilitando a governança, o desenvolvimento e a escalabilidade do projeto.
*/

--WAREHOUSES
CREATE WAREHOUSE WH_DEV WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 120 AUTO_RESUME = TRUE INITIALLY_SUSPENDED = TRUE;
CREATE WAREHOUSE WH_HML WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 120 AUTO_RESUME = TRUE INITIALLY_SUSPENDED = TRUE;
CREATE WAREHOUSE WH_PRD WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 120 AUTO_RESUME = TRUE INITIALLY_SUSPENDED = TRUE;

/*
Um warehouse no Snowflake é o motor computacional que executa suas consultas. 
Para controlar custos (FinOps), é importante criar warehouses no menor tamanho possível que atenda a demanda, configurar auto suspend para desligar quando ocioso, e auto resume para ligar automaticamente ao receber queries. Essa prática otimiza gastos sem perder performance.

Criamos três warehouses pequenos e otimizados para cada ambiente. 
O auto_suspend suspende o warehouse após 2 minutos ocioso, evitando custo desnecessário. 
O auto_resume garante que ele seja reativado automaticamente ao receber queries. 
Esse setup deixa o ambiente eficiente em custo e pronto para uso.
*/