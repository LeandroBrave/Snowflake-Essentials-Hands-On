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

- **Script – 07 - Time Travel - AT e BEFORE**: Exemplo de querys usando o At e o Before, recursos do time travel do snowflake

## Etapa 8: Time Travel – Backup e Recuperação

Além de permitir consultas históricas, o **Time Travel** também fornece mecanismos poderosos de **recuperação de objetos e dados** no Snowflake.  
Isso elimina a necessidade de restaurar backups manuais, já que o próprio banco preserva versões passadas de objetos e seus conteúdos dentro do período de retenção configurado.

---

### Funcionalidades demonstradas

Nesta etapa, exploramos duas situações comuns:

1. **Restauração de objetos (UNDROP)**  
   - O Snowflake permite "desfazer" a exclusão de objetos como tabelas, schemas e até databases.  
   - Isso é feito com o comando `UNDROP`, que devolve o objeto ao estado em que estava no momento do drop.  
   - Dessa forma, mesmo exclusões acidentais podem ser revertidas de forma simples.

2. **Recuperação de dados deletados (AT)**  
   - Após apagar todos os registros de uma tabela, é possível recuperar os dados consultando uma versão passada, utilizando a cláusula `AT`.  
   - Nesse caso, usamos o timestamp de referência obtido no experimento anterior (Etapa 7) para restaurar as linhas ao estado original.  
   - A estratégia aplicada foi realizar um **insert baseado na consulta histórica**, trazendo os dados de volta para a tabela.

---

### Benefícios práticos

- **Segurança operacional**: elimina o risco de perda permanente de dados ou objetos por exclusão acidental.  
- **Simplicidade**: não é necessário recorrer a backups externos ou processos manuais de restauração.  
- **Integração com auditoria**: permite não apenas recuperar, mas também verificar exatamente em que momento ocorreu a alteração indesejada.  

Com esses recursos, o Snowflake oferece uma camada adicional de **resiliência** e **tranquilidade** no gerenciamento de dados.

### Referência aos Scripts

- **Script – 08 - Time Travel - Backup**: Exploração de funcionalidades de backup

## Etapa 09 - Clone

O comando **Clone** no Snowflake permite criar uma cópia de uma tabela, esquema ou banco de dados sem consumir espaço adicional de armazenamento.  
Isso é possível porque o Snowflake utiliza metadados e **time travel** para referenciar os mesmos dados já existentes.  

Esse recurso é muito útil em situações como:  
- **Testes e simulações**: criar um ambiente seguro para validar alterações.  
- **Validações**: verificar dados históricos sem risco de corromper a tabela original.  
- **Economia de armazenamento**: a cópia não duplica fisicamente os dados, apenas cria referências.  

O clone se comporta como uma tabela comum, podendo receber inserções, atualizações ou exclusões sem impactar a tabela original.  

### Referência aos Scripts

- **Script – 09 - Time Travel - Clone**: Clones sem gasto de storage

## 10 - Streams

No Snowflake, um **Stream** é um objeto que captura alterações feitas em uma tabela, permitindo rastrear **inserts, updates e deletes** desde a última vez que o stream foi consultado.  
Ele funciona como um “log incremental” que facilita processos de **ETL/ELT** ou qualquer operação que precise consumir apenas as mudanças ocorridas nos dados.

---

### Conceitos principais

- **SHOW_INITIAL_ROWS**: quando ativado, o stream considera também as linhas já existentes na tabela no momento da criação.  
- **APPEND_ONLY**: define se o stream deve rastrear apenas inserções ou também atualizações e deleções.  

Com isso, é possível consumir alterações de forma controlada, evitando **reprocessamento de dados antigos** e garantindo eficiência em pipelines.

---

### Funcionalidades demonstradas

1. **Criação do stream**: o stream é vinculado a uma tabela específica, monitorando todas as mudanças de acordo com as configurações definidas.  
2. **Consulta ao stream**: antes de consumir, é possível visualizar todas as alterações capturadas.  
3. **Consumo do stream**: os dados do stream podem ser inseridos em uma nova tabela ou processados em ETLs, garantindo que cada alteração seja capturada apenas uma vez.  
4. **Rastreamento de alterações**: após updates ou deletes na tabela original, o stream identifica **o tipo de ação realizada** e mantém um histórico incremental das mudanças.

---

### Benefícios práticos

- **ETL incremental simplificado**: só processa linhas que mudaram, economizando tempo e recursos.  
- **Rastreabilidade completa**: cada alteração (inserção, atualização ou exclusão) é registrada e pode ser auditada.  
- **Segurança e consistência**: permite validar alterações antes de impactar tabelas de destino, garantindo integridade do pipeline.

---

### Referência aos Scripts

- **Script – 10 - Streams**: Criação e consumo de streams para rastrear alterações na tabela `openmeteo_raw_archive`.

## 11 - External Stages

No Snowflake, um **External Stage** funciona como um ponteiro para um **armazenamento externo** (como S3, Azure Blob ou GCP), permitindo que o Snowflake **leia e escreva arquivos diretamente** sem precisar mover dados manualmente para dentro do banco.  

Isso é muito útil para pipelines de ingestão, exportação de dados e integração com ferramentas de ETL ou analytics.

---

### Componentes do External Stage

1. **Storage Integration**  
   - Configuração que permite ao Snowflake acessar o storage externo de forma segura.  
   - No caso da AWS (nosso exemplo), utiliza **roles do IAM**, evitando expor credenciais sensíveis diretamente.  

2. **Stage**  
   - Representa uma referencia dentro do Snowflake a algum repositorio de dados.  
   - Pode ser **interno** (dentro do Snowflake) ou **externo** (S3, Azure, GCP).  

3. **File Format**  
   - Define o formato dos arquivos que serão lidos ou escritos no stage, como `PARQUET`, `CSV` ou `JSON`.  
   - Pode incluir compressão, opções de parsing e conversão de tipos de dados.  

4. **Bucket / Container**  
   - Local físico no provedor de cloud (ex: bucket S3) onde os arquivos estão armazenados.  

---

### Setup necessário na AWS (S3)

Para que o stage funcione corretamente, alguns passos são necessários:

- **Criar bucket S3**  
  - Definir a região adequada para reduzir latência.  
  - Configurar versionamento ou lifecycle se desejado.  

- **Criar Role IAM**
  - Criaremos um usuário e uma role que representarão o snowflake 
  - Permissões mínimas: `s3:GetObject`, `s3:PutObject`, `s3:ListBucket` no bucket escolhido.  
  - Configurar trust relationship na role do snowflake permitindo que o Snowflake assuma essa role.
  <img width="1889" height="752" alt="image" src="https://github.com/user-attachments/assets/0afb4bd6-64d3-4b8d-ace3-b24f67513991" />


- **Criar Storage Integration no Snowflake**  
  - Conecta o Snowflake à role IAM e ao bucket de forma segura.  

- **Criar File Format reutilizável**  
  - Para padronizar leitura e escrita de arquivos em pipelines.  

- **Criar Stage apontando para o bucket**  
  - Associar a Storage Integration e o File Format criados.  

- **Grants**  
  - Conceder permissões de uso do database, schemas, file formats e stages para os papéis correspondentes (ex.: engenheiros, admins).  

---

### Benefícios práticos

- **Integração simplificada com cloud storage**: evita movimentação manual de arquivos.  
- **Segurança**: acesso controlado via roles do IAM e Storage Integration.  
- **Reuso**: file formats e stages podem ser reutilizados em múltiplos pipelines e projetos.  

### Referência aos Scripts

- **Script – 11 - External Stages**: Criação e configuração de storage integration, file formats e stage externo para S3.

## 12 - Testing External Stage

Após criar o stage externo e a storage integration, é importante validar seu funcionamento realizando testes práticos de leitura e ingestão de arquivos.

---

### Funcionalidades exploradas

1. **Listagem de arquivos no stage**  
   - Podemos verificar quais arquivos estão disponíveis diretamente no bucket através do stage criado no Snowflake.  
   - Isso permite garantir que os dados que queremos consumir realmente estão acessíveis.  

2. **Consulta direta nos arquivos externos**  
   - O Snowflake permite executar queries diretamente sobre arquivos em S3, sem precisar copiá-los para uma tabela interna.  
   - Podemos ler colunas específicas, aplicar tipos de dados e até obter metadados como o nome do arquivo.  
   - Isso é útil para inspeção rápida de arquivos e validação do conteúdo antes de carregar para tabelas internas.  

3. **Ingestão de dados com COPY INTO**  
   - Após validar o conteúdo dos arquivos, podemos inserir os dados em uma tabela do Snowflake com o comando `COPY INTO`.  
   - O processo converte os dados do formato Parquet para os tipos de dados corretos da tabela, garantindo integridade.  
   - É possível repetir essa operação diversas vezes para simulações de ingestão ou atualização incremental.  

---

### Benefícios práticos

- **Validação segura de dados externos** antes de ingestão.  
- **Flexibilidade de leitura**: consultar arquivos diretamente sem copiar.  
- **Automação de ingestão**: uso de COPY INTO permite pipelines consistentes e repetíveis.  
- **Integração com formatos modernos** como Parquet, preservando compressão e performance.  

### Referência aos Scripts

- **Script – 12 - Testing External Stage**: Testes de listagem, leitura e ingestão de arquivos Parquet de um stage externo S3.


## 13 - Snowpipe – Ingestão Contínua de Dados

O **Snowpipe** é o serviço de ingestão contínua do Snowflake.  
Com ele, arquivos adicionados a um bucket externo (como o S3) podem ser **automaticamente carregados** em tabelas, sem a necessidade de processos manuais ou jobs externos recorrentes.  

---

### Como funciona

1. **Pipe**  
   - Objeto no Snowflake que define a instrução `COPY INTO` que será usada sempre que novos arquivos chegarem ao bucket.  
   - Pode ser configurado com `AUTO_INGEST = TRUE`, permitindo integração direta com notificações do S3.  

2. **Notificações via SQS**  
   - Quando ativado, o Snowflake gera uma **fila SQS (Simple Queue Service)** associada ao pipe.  
   - Essa fila recebe notificações sempre que novos arquivos chegam ao bucket, disparando a ingestão automática.
   - Isso é feito automaticamente e não precisamos nos preocupar com isso.

3. **Monitoramento e controle**  
   - Pipes podem ser pausados, retomados ou forçados a recarregar arquivos manualmente.  
   - Comandos como `SHOW PIPES` permitem verificar o status e obter a ARN da fila SQS necessária para o setup na AWS.  

---

### Passos de configuração no Snowflake

- Criar o **pipe** associado ao stage e à tabela de destino.  
- Ativar `AUTO_INGEST` para habilitar a integração com notificações do S3.  
- Conferir a **ARN da fila SQS** que o Snowflake fornece (via `SHOW PIPES`).  
- Usar comandos administrativos para **pausar**, **reativar** ou **refresh** do pipe, dependendo da necessidade operacional.  

---

### Passos de configuração na AWS

Para que o Snowpipe funcione corretamente, é necessário configurar permissões na AWS:

1. **Habilitar notificações no bucket S3**  
   - Configurar o bucket para enviar eventos de criação de objetos (`s3:ObjectCreated:*`).  
   - Direcionar esses eventos para a fila SQS fornecida pelo Snowflake.  

2. **Permitir acesso do Snowflake à fila SQS**  
   - Editar a **política de acesso da fila SQS** para conceder ao Snowflake permissão de leitura.  
   - O ARN da role Snowflake usada na `STORAGE INTEGRATION` deve estar incluído.  

3. **Garantir alinhamento de regiões**  
   - O bucket S3, a fila SQS e a conta Snowflake devem estar configurados na mesma região da AWS.  

---

### Benefícios práticos

- **Automação completa da ingestão**: elimina a necessidade de jobs externos ou agendamentos.  
- **Baixa latência**: novos arquivos são processados quase em tempo real.  
- **Escalabilidade**: o Snowpipe distribui automaticamente a ingestão, sem necessidade de gerenciar infraestrutura.  
- **Controle operacional**: pipes podem ser pausados, reativados e monitorados conforme a demanda.  

---

### Referência aos Scripts

- **Script – 13 - Snowpipe**: Configuração de ingestão contínua de arquivos via integração Snowflake + AWS S3 + SQS.

