# Trabalho de Banco de Dados — Índices e Procedures

## Sobre o projeto

Fiz este projeto para praticar duas coisas que vimos em Banco de Dados: a criação de índices para ajudar nas consultas e o uso de procedures para cadastrar, alterar, excluir e consultar informações.

Os exemplos foram feitos em **MySQL 8** e divididos em duas partes.

## Parte 1 — Índices no banco Company

Criei consultas para responder a três perguntas:

- Qual departamento tem mais funcionários?
- Quais departamentos existem em cada cidade?
- Quais funcionários trabalham em cada departamento?

**Por que escolhi esses índices?**

- **`employee (Dno, Lname, Fname)` — BTREE:** ajuda a localizar os funcionários de cada departamento e pode ajudar nas consultas organizadas por nome.
- **`dept_locations (Dlocation, Dnumber)` — BTREE:** foi pensado para buscas por cidade, quando precisamos encontrar os departamentos de um local específico.
- **`department (Dnumber)` — chave primária:** já tem índice, então não criei outro igual.

Escolhi o tipo **BTREE** porque ele funciona bem com as buscas e associações entre tabelas usadas no trabalho. Também evitei criar índices sem necessidade, já que eles ocupam espaço e podem deixar inserções e atualizações mais lentas.

## Parte 2 — Procedures

Criei duas procedures: uma para gerenciar **alunos** no banco de universidade e outra para gerenciar **produtos** no e-commerce.

Em cada uma, um parâmetro define qual ação será realizada:

- **1:** inserir (`INSERT`)
- **2:** atualizar (`UPDATE`)
- **3:** excluir (`DELETE`)
- **4:** consultar (`SELECT`)

Usei `CASE` na procedure de alunos e `IF` na de produtos. Os arquivos também têm exemplos de chamadas com `CALL`.

## Arquivos do projeto

- **`00_company_demo_opcional.sql`:** cria dados de exemplo do Company, caso você ainda não tenha esse banco.
- **`01_company_indices_consultas.sql`:** índices e consultas da primeira parte.
- **`02_procedure_universidade.sql`:** procedure para alunos.
- **`03_procedure_ecommerce.sql`:** procedure para produtos.

## Como executar

Abra os arquivos no **MySQL Workbench**. Se você já tem o banco `company` da atividade, não precisa rodar o arquivo `00`. Depois, execute o arquivo `01` e, em seguida, os arquivos `02` e `03`.

Antes de executar o arquivo `01`, confira se os índices já existem, para não tentar criá-los duas vezes. Os arquivos de procedures criam bancos de teste próprios. Se o professor forneceu outras tabelas, os nomes precisam ser adaptados.

## Conclusão

Com a atividade, entendi melhor que os índices podem facilitar a busca de informações, mas precisam ser escolhidos de acordo com as consultas. Também pratiquei como usar procedures para reunir diferentes operações em um só lugar.
