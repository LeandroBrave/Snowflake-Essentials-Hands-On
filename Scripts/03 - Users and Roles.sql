--ROLES ou Funções
CREATE ROLE ORG_ROLE;

CREATE ROLE ENGENHEIRO_DADOS;
CREATE ROLE ANALISTA_NEGOCIOS;
CREATE ROLE QA_DADOS;

--hierarquia de roles
GRANT ROLE ENGENHEIRO_DADOS TO ROLE ORG_ROLE;
GRANT ROLE QA_DADOS TO ROLE ORG_ROLE;
GRANT ROLE ORG_ROLE TO ROLE ACCOUNTADMIN;

/*
Uma role é um conjunto de permissões que define o que um usuário pode fazer dentro do ambiente Snowflake. 
Ela facilita a gestão de acesso, permitindo atribuir e revogar privilégios de forma centralizada e organizada.
*/

--Usuários de exemplo
CREATE USER ana_eng PASSWORD='Senha123' DEFAULT_ROLE=ENGENHEIRO_DADOS DEFAULT_WAREHOUSE=WH_DEV;
CREATE USER joao_bi PASSWORD='Senha123' DEFAULT_ROLE=ANALISTA_NEGOCIOS DEFAULT_WAREHOUSE=WH_HML;
CREATE USER maria_qa PASSWORD='Senha123' DEFAULT_ROLE=QA_DADOS DEFAULT_WAREHOUSE=WH_HML;

CREATE USER admin_org PASSWORD = 'SenhaForte123' DEFAULT_ROLE = ORG_ROLE DEFAULT_WAREHOUSE = WH_DEV;

/*
Um usuário representa uma pessoa ou serviço que acessa o Snowflake. 
Cada usuário possui credenciais, uma role padrão e um warehouse padrão para executar suas tarefas.
*/

--Atribuindo as roles pros usuarios
GRANT ROLE ENGENHEIRO_DADOS TO USER ana_eng;
GRANT ROLE ANALISTA_NEGOCIOS TO USER joao_bi;
GRANT ROLE QA_DADOS TO USER maria_qa;
GRANT ROLE ORG_ROLE TO USER admin_org;

--Grants para warehouses
GRANT USAGE ON WAREHOUSE WH_DEV TO ROLE ENGENHEIRO_DADOS;
GRANT USAGE ON WAREHOUSE WH_HML TO ROLE QA_DADOS;
GRANT USAGE ON WAREHOUSE WH_HML TO ROLE ANALISTA_NEGOCIOS;
GRANT USAGE ON WAREHOUSE WH_PRD TO ROLE ANALISTA_NEGOCIOS;
