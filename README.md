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

## Etapa 2: Criação das Tabelas

### O que é uma tabela?

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


## Etapa 3: Criação de Usuários e Roles

### O que são Roles (Funções) no Snowflake?

Uma **role** é um conjunto de permissões que define o que um usuário pode fazer dentro do ambiente Snowflake. Ela facilita a gestão de acesso, permitindo atribuir e revogar privilégios de forma centralizada e organizada.

### Hierarquia de Roles

Roles podem ser organizadas em hierarquias, onde uma role pode herdar permissões de outras. Isso simplifica o gerenciamento, agrupando funções semelhantes ou relacionadas.

### O que são Usuários no Snowflake?

Um **usuário** representa uma pessoa ou serviço que acessa o Snowflake. Cada usuário possui credenciais, uma role padrão e um warehouse padrão para executar suas tarefas.

### Como usamos Roles e Usuários neste projeto?

Criamos roles para diferentes perfis da equipe:

- **ORG_ROLE**: Role organizacional que agrega outras funções  
- **ENGENHEIRO_DADOS**: Responsável pela construção e manutenção dos pipelines de dados  
- **ANALISTA_NEGOCIOS**: Usuário que consome os dados para análises e tomada de decisão  
- **QA_DADOS**: Responsável por validar a qualidade dos dados  

Criamos usuários de exemplo e atribuímos a eles roles e warehouses padrão para simular diferentes perfis de acesso e garantir o controle seguro dos recursos.

### Concessão de permissões (Grants)

As roles recebem permissões específicas, como o uso de warehouses, garantindo que cada usuário tenha acesso apenas ao que for necessário para sua função.

---

### Script 03 - Users and Roles

O Script "03 - Users and Roles" cria as roles, usuários, define hierarquias e concede os acessos necessários, estabelecendo o modelo de segurança e governança do ambiente Snowflake.

---

## Etapa 4: Concessão de Permissões para o Engenheiro de Dados

### O que são Grants no Snowflake?

**Grants** são comandos que concedem permissões específicas para roles ou usuários sobre objetos do banco de dados, como databases, schemas e tabelas. Eles definem o que cada perfil pode fazer, garantindo segurança e governança.

### Como configuramos os Grants para o Engenheiro de Dados?

Para o perfil **ENGENHEIRO_DADOS**, garantimos acesso completo aos ambientes de desenvolvimento, permitindo criar, alterar e deletar dados e objetos nos databases RAW e STG. Isso inclui:

- Permissões totais em todos os databases, schemas e tabelas dos ambientes DEV_RAW e DEV_STG  
- Grants automáticos para futuros schemas e tabelas nesses ambientes, garantindo que permissões sejam aplicadas automaticamente a novos objetos criados  

Para os ambientes de Homologação (HML) e Produção (PRD), o Engenheiro de Dados possui apenas permissão de leitura, permitindo consultar dados sem risco de alterações não autorizadas.

### Por que essa configuração?

Esse modelo promove segurança e boas práticas, garantindo que alterações e desenvolvimento sejam realizados apenas no ambiente DEV, enquanto homologação e produção ficam protegidos contra modificações acidentais.

---

### Script 04 - Data Engineer Grants

O Script "04 - Data Engineer Grants" configura as permissões detalhadas acima, estabelecendo o controle de acesso para o perfil de Engenheiro de Dados dentro do projeto.

---


