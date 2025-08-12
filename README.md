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

## Etapa 2: Criação das Tabelas Brutas (Raw Tables)

### O que é uma tabela no Snowflake?

Uma **tabela** é o objeto onde os dados são efetivamente armazenados. É organizada em colunas e linhas, e cada coluna tem um tipo de dado específico, como números, textos ou datas.

### Como usamos as tabelas neste projeto?

Neste passo, criamos as tabelas que irão armazenar os dados brutos recebidos diretamente das APIs, sem transformação ou limpeza, para garantir a integridade dos dados originais.

### Tabelas criadas

- Para a API **OPENMETEO**, foram criadas duas tabelas em ambientes de Desenvolvimento (DEV) e Homologação (HML):
  - `openmeteo_raw_archive`: Guarda dados históricos ou arquivados da API.
  - `openmeteo_raw_forecast`: Guarda dados de previsão meteorológica.

### Por que criar tabelas em múltiplos ambientes?

Ter as mesmas tabelas em DEV e HML permite que possamos testar inserções, permissões (grants) e processos de forma segura antes de levar para produção.

### Inserção de dados de exemplo

No ambiente DEV, inserimos alguns registros de teste para validar a estrutura das tabelas e facilitar o desenvolvimento inicial. Esses dados simulam uma resposta típica da API Open-Meteo.

---

### Script 2: Example Tables

O Script "02 - Example Tables" contém todos os comandos para criar as tabelas descritas acima e os inserts de teste no ambiente de desenvolvimento.

---


