# Snowflake Essentials Hands-On

## Etapa 1: Criação da Estrutura Inicial

Neste projeto iremos explorar todas as funcionalidades básicas do snowflake, utilizando um contexto pequeno e bem definido.
Aqui criaremos tabelas para receber dados de APIs públicas. A api OPEN-METEO, de dados metereologicos e a API CAGED, de dados sobre empregabilidade.

### O que é um Database?

No Snowflake, um **database** é como um owner presente nos bancos mais populares, ou seja, um container lógico que organiza seus dados em grupos. Ele serve para agrupar schemas e tabelas relacionados, facilitando a administração e a segurança dos dados.

### Como usamos os Databases neste projeto?

Neste projeto, criamos seis databases para separar os ambientes de trabalho e os estágios de processamento:

- **DEV (RAW e STG)** (Desenvolvimento): Ambiente para desenvolvimento e testes iniciais  
- **HML (RAW e STG)** (Homologação): Ambiente para validação dos dados e processos antes de produção  
- **PRD (RAW e STG)** (Produção): Ambiente final onde os dados são disponibilizados para uso real  

Para cada ambiente, existem dois databases: um para os dados brutos recebidos das APIs (RAW) e outro para os dados preparados e organizados para análises (STG ou Stage).

### O que é um Schema?

Dentro de um database, o **schema** é uma subdivisão que organiza as tabelas, views e outros objetos de banco de dados. Ele ajuda a categorizar e segmentar os dados para facilitar o desenvolvimento e a governança.

### Como usamos os Schemas neste projeto?

Dentro de cada database, criamos schemas específicos para cada origem de dados, ou seja, para as APIs que alimentam nosso ambiente:

- **OPENMETEO**: Dados meteorológicos  
- **CAGED**: Dados trabalhistas  

Essa estrutura permite que cada fonte de dados seja organizada separadamente, facilitando a manutenção e a escalabilidade do projeto.

### O que é um Warehouse?

Um **warehouse** no Snowflake é o motor computacional que executa consultas e operações sobre os dados. Ele pode ser dimensionado para fornecer mais ou menos poder de processamento, e é cobrado conforme o uso.

### Boas práticas na criação e uso de Warehouses (FinOps)

Para garantir o controle de custos e eficiência, configuramos warehouses com as seguintes práticas:

- Escolher o menor tamanho possível que atenda às demandas (aqui usamos `XSMALL`)  
- Configurar para que desliguem automaticamente após um curto período de inatividade (auto suspend em 2 minutos), evitando custos quando não usados  
- Ativar o auto resume, para que voltem a funcionar automaticamente quando receberem consultas  
- Manter warehouses separados para cada ambiente (DEV, HML e PRD), facilitando o controle individual de recursos e gastos

---

### Script 1: Basic Structures

O Script "01 - Basic Structures" contém os comandos que criam essa estrutura completa de databases, schemas e warehouses, conforme descrito acima. Ele é a base para todas as próximas etapas do projeto, preparando o ambiente para receber, processar e disponibilizar os dados das APIs Open-Meteo e CAGED.

---


