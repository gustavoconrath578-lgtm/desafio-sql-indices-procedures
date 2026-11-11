# Desafio SQL — Índices e Procedures

## Descrição do projeto

Este projeto foi desenvolvido para praticar a criação de índices e o uso de procedures no MySQL. Na primeira parte, foram feitas consultas no cenário **company** para identificar departamentos, cidades e funcionários. Na segunda parte, criei procedures que permitem inserir, atualizar, excluir e consultar registros em exemplos de **universidade** e **e-commerce**.

## Tecnologias

- MySQL 8.x (tabelas InnoDB)
- SQL: `SELECT`, `JOIN`, `GROUP BY`, `CREATE INDEX`, `CREATE PROCEDURE`, `CASE`, `IF` e `CALL`

## Arquivos

| Arquivo | Finalidade |
|---|---|
| `00_company_demo_opcional.sql` | Cria três tabelas e dados de teste, caso não exista o banco `company` |
| `01_company_indices_consultas.sql` | Contém os índices e as três consultas da Parte 1 |
| `02_procedure_universidade.sql` | Cria a tabela de alunos, a procedure e as chamadas de exemplo |
| `03_procedure_ecommerce.sql` | Cria a tabela de produtos, a procedure e as chamadas de exemplo |

## Parte 1 — Índices e consultas no Company

As consultas respondem:

1. **Qual departamento tem mais pessoas?** Usa `COUNT`, `GROUP BY` e `ORDER BY`, retornando o primeiro departamento. Se dois tiverem a mesma quantidade, o nome é usado como desempate.
2. **Quais departamentos estão em cada cidade?** Faz a associação entre `dept_locations` e `department`.
3. **Quais empregados pertencem a cada departamento?** Faz a associação entre `employee` e `department`.

### Índices escolhidos e justificativa

| Tabela | Índice | Tipo | Por que foi escolhido |
|---|---|---|---|
| `employee` | `idx_employee_dno_lname_fname` (`Dno`, `Lname`, `Fname`) | BTREE | Ajuda nas buscas de funcionários por departamento e pode ajudar na ordenação por sobrenome e nome dentro de um departamento. |
| `dept_locations` | `idx_dept_locations_city_dept` (`Dlocation`, `Dnumber`) | BTREE | Favorece pesquisas por cidade, como a consulta adicional filtrando `Dlocation = 'Curitiba'`. |
| `department` | Chave primária já existente (`Dnumber`) | BTREE | Não é necessário criar outro índice para a mesma coluna, pois a chave primária já é indexada. |

**Motivo da escolha:** os campos `Dno`, `Dnumber` e `Dlocation` participam das consultas de associação e filtro. Optei por índices BTREE porque são compatíveis com InnoDB e atendem bem a junções, condições de igualdade e ordenações. Não criei índices em todas as colunas, porque cada índice adicional ocupa espaço e aumenta o trabalho em inserções, atualizações e exclusões.

**Observação:** em muitas estruturas, a chave estrangeira `employee.Dno` já possui um índice simples criado pelo MySQL. O índice composto foi proposto porque as consultas também lidam com sobrenome e nome. Antes de criá-lo em um banco real, é importante verificar `SHOW INDEX FROM employee` e avaliar com `EXPLAIN` se ele vale o custo. Para buscas que sempre listam todas as cidades sem filtrar, o índice de cidade pode não melhorar o tempo de execução.

### Estrutura esperada do banco Company

O arquivo da Parte 1 considera as colunas clássicas:

- `department(Dnumber, Dname)`
- `employee(Ssn, Fname, Lname, Dno)`
- `dept_locations(Dnumber, Dlocation)`

Se o banco fornecido na disciplina tiver nomes diferentes, é preciso adaptar os identificadores no script. **Não é necessário recriar o banco company se ele já estiver disponível.**

## Parte 2 — Procedures de Universidade e E-commerce

Para deixar o exemplo executável sem depender de tabelas externas, os arquivos da Parte 2 criam bases de demonstração chamadas `universidade_desafio` e `ecommerce_desafio`.

### Controle da ação

| Opção | Ação |
|---|---|
| `1` | Inserir registro (`INSERT`) |
| `2` | Atualizar registro (`UPDATE`) |
| `3` | Excluir registro (`DELETE`) |
| `4` | Consultar registro (`SELECT`) |

A procedure da universidade usa `CASE` e trabalha com **alunos** (nome, e-mail, curso). A procedure do e-commerce usa `IF / ELSEIF` e trabalha com **produtos** (nome, preço, estoque). Ambas usam uma variável `p_opcao` para determinar a operação. Para atualizar campos específicos, parâmetros nulos mantêm os valores atuais. Na consulta, um ID nulo lista todos os registros.

Os scripts trazem chamadas `CALL` para demonstrar todas as operações, incluindo a captura do ID criado com `LAST_INSERT_ID()`.

## Como executar

1. Abra o MySQL Workbench ou outro cliente compatível com MySQL 8.
2. Caso **não tenha o banco company**, execute primeiro `00_company_demo_opcional.sql` em uma base de testes vazia. Se já possui o banco `company` da disciplina, ignore esse arquivo.
3. Verifique os índices existentes com `SHOW INDEX FROM employee;` e `SHOW INDEX FROM dept_locations;` para evitar índices repetidos. Execute `01_company_indices_consultas.sql` **uma única vez**, depois de confirmar as colunas e os índices.
4. Execute `02_procedure_universidade.sql`.
5. Execute `03_procedure_ecommerce.sql`.
6. Confira os resultados das consultas e das chamadas das procedures.

> Atenção: os exemplos de procedures fazem `INSERT`, `UPDATE` e `DELETE` em **registros de teste criados pelo próprio script**. Execute em ambiente de estudo. Se houver bases reais de universidade ou e-commerce fornecidas na atividade, adapte o nome do banco, as tabelas e os campos antes de usar.

## Conclusão

O exercício mostra que índices podem melhorar consultas que acessam campos específicos com frequência, mas devem ser escolhidos com cuidado. Já as procedures ajudam a reunir operações de manipulação em uma única rotina com parâmetros e condições, facilitando a reutilização do SQL.

## Referências

- [MySQL — CREATE INDEX](https://dev.mysql.com/doc/refman/8.0/en/create-index.html)
- [MySQL — CREATE PROCEDURE](https://dev.mysql.com/doc/refman/8.4/en/create-procedure.html)
