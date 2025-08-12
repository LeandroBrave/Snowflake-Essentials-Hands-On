# Snowflake-Essentials-Hands-On
Exploração das funcionalidades básicas do snowflake

## Etapa 1: Criação da Estrutura Inicial

Neste passo inicial, preparamos a fundação do nosso ambiente Snowflake para ingestão e processamento dos dados das APIs Open-Meteo e CAGED.

### 1.1 Criação dos Bancos de Dados (Databases)

Criamos 6 databases, divididos em três ambientes principais:

- DEV (Desenvolvimento)  
- HML (Homologação)  
- PRD (Produção)  

Cada ambiente possui um database para dados brutos (RAW) e outro para dados de preparação e staging (STG).

### 1.2 Criação dos Schemas

Em cada database, criamos schemas específicos para separar os dados das duas APIs:

- OPENMETEO  
- CAGED  

Essa organização facilita a governança e o desenvolvimento.

### 1.3 Criação dos Warehouses

Configuramos warehouses pequenas (XSMALL) para cada ambiente, otimizando custo e performance:

- Auto suspend após 2 minutos de inatividade  
- Auto resume automático  
- Inicialmente suspensos para evitar custo ocioso

Com isso, temos a base pronta para começar a ingestão dos dados.
