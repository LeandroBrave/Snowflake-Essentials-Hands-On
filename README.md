# Snowflake Essentials Hands-On

## Etapa 1: Criação da Estrutura Inicial

Neste projeto iremos explorar todas as funcionalidades básicas do snowflake, utilizando um contexto pequeno e bem definido.
Aqui criaremos tabelas para receber dados de APIs públicas. A api OPEN-METEO, de dados metereologicos e a API CAGED, de dados sobre empregabilidade.

### O que é um Database?

No Snowflake, um **database** é como um owner presente nos bancos mais populares, ou seja, um container lógico que organiza seus dados em grupos. Ele serve para agrupar schemas e tabelas relacionadas, facilitando a administração e a segurança dos dados.

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

## Etapa 4 a 6: Concessão de Permissões e Testes de Acesso

Nesta parte do projeto, configuramos as permissões para os diferentes perfis de usuários e validamos o comportamento esperado na prática.

---

### O que são Grants no Snowflake?

- **Grants** são comandos que concedem permissões específicas a roles ou usuários, sobre databases, schemas ou tabelas.

---

### Perfil Engenheiro de Dados (`ENGENHEIRO_DADOS`)

- Recebe **acesso total em DEV** (RAW e STG):
  - Pode criar, modificar, deletar tabelas e dados.  
  - Pode consultar e listar todas as tabelas.  
- Recebe **acesso de leitura em HML e PRD**:
  - Pode consultar dados (`SELECT`) e listar tabelas (`SHOW TABLES`).  
  - **Não pode modificar dados ou objetos** (inserts, updates, deletes falharão).

> Nota: a leitura global permite ao engenheiro validar e analisar dados sem risco de alterar ambientes de homologação ou produção.

---

### Perfil QA (`QA_DADOS`)

- Recebe **acesso de leitura restrito a HML** (RAW e STG):
  - Pode consultar e listar tabelas.  
  - Não tem acesso a DEV nem a PRD.  
- Permissões automáticas (`FUTURE TABLES`) garantem que novas tabelas em HML também sejam visíveis para QA.

---

### Testes práticos de acesso (Script 06)

- Com `ENGENHEIRO_DADOS`:
  - ✅ `SELECT * FROM DEV_RAW.OPENMETEO.FORECAST_TEST` → funciona (leitura e escrita).  
  - ✅ `SHOW TABLES IN DEV_RAW.OPENMETEO` → funciona.  
  - ❌ `DELETE FROM HML_RAW.OPENMETEO.FORECAST_TEST` → **não funciona**, validando a restrição de escrita.  
  - ✅ `SELECT * FROM HML_RAW.OPENMETEO.FORECAST_TEST` → funciona (somente leitura).  

- Com `QA_DADOS`:
  - ✅ `SELECT * FROM HML_RAW.OPENMETEO.FORECAST_TEST` → funciona.  
  - ✅ `SHOW TABLES IN HML_RAW.OPENMETEO` → funciona.  
  - ❌ `SELECT * FROM DEV_RAW.OPENMETEO.FORECAST_TEST` → não funciona.  
  - ❌ `SHOW TABLES IN DEV_RAW.OPENMETEO` → não funciona.  

Esses testes garantem que a política de **“leitura global / escrita restrita”** seja aplicada corretamente.

---

### Por que não cobrimos PRD?

Para não estender demais a demonstração com mais do mesmo, **não configuramos tabelas nem testes em PRD**.  
O foco desta etapa é mostrar como criar roles, atribuir grants e validar acessos sem arriscar alterações em um ambiente de produção.

---

### Referência aos Scripts

- **Script 04 – Data Engineer Grants**: define permissões de leitura/escrita para o Engenheiro de Dados.  
- **Script 05 – QA Grants**: define permissões de leitura para QA.  
- **Script 06 – Testing Grants and Roles**: valida na prática o comportamento das permissões configuradas.

## Etapa 7: Time Travel – Consultas "AT" e "BEFORE"

O **Time Travel** é um recurso nativo do Snowflake que permite acessar versões anteriores de tabelas, schemas e databases.  
Ele possibilita consultar dados como estavam em um momento específico no passado, desfazer alterações acidentais ou auditar históricos.  

### Vantagens principais do Time Travel
- **Recuperação de dados** deletados ou modificados acidentalmente.  
- **Auditoria e rastreabilidade** de alterações em tabelas.  
- **Análises históricas**, com suporte a comparações temporais.  

---

### Configuração do Time Travel
Cada objeto no Snowflake (tabelas, schemas ou databases) pode ter um **período de retenção diferente**, definido em dias.  
Neste experimento:  
- A tabela `openmeteo_raw_archive` no ambiente **DEV_RAW** foi configurada para manter 5 dias de histórico.  
- O schema `dev_raw.openmeteo` foi configurado para manter 7 dias.  
- O database `dev_raw` foi configurado para manter 10 dias.  

Isso permite granularidade: bancos mais críticos podem ter retenções maiores, enquanto tabelas temporárias podem ter retenções menores.

---

### Experimentos com Time Travel

Os testes realizados neste script incluem:  

1. **Registrar o momento atual** para servir como referência temporal.  
2. **Consultar a quantidade de linhas** na tabela em diferentes momentos, comparando o estado atual com o estado anterior.  
3. **Inserir novos registros** e verificar como o Time Travel permite visualizar tanto a versão atualizada da tabela quanto a versão anterior (antes do insert).  
4. **Consultar a tabela retroativamente**, seja com um *timestamp exato* (`AT`) ou com um deslocamento relativo no tempo (`BEFORE`, como "10 minutos atrás").  

Esses experimentos evidenciam como o Snowflake facilita análises históricas e a recuperação de informações sem a necessidade de restaurar backups ou criar cópias adicionais de dados.

### Referência aos Scripts

- **Script 047 – 07 - Time Travel - AT e BEFORE**: Exemplo de querys usando o At e o Before, recursos do time travel do snowflake
