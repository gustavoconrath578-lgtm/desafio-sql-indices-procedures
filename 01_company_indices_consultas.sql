-- PARTE 1 - INDICES E CONSULTAS DO BANCO COMPANY
-- Compatibilidade: MySQL 8.x (InnoDB)
-- Execute depois de criar/importar o banco company.
-- Estrutura esperada:
-- department(Dnumber, Dname)
-- employee(Ssn, Fname, Lname, Dno)
-- dept_locations(Dnumber, Dlocation)
-- ATENCAO: os CREATE INDEX devem ser executados apenas uma vez.
-- Se sua base tiver nomes diferentes, adapte os identificadores.

USE company;

-- 1) INDICES
-- BTREE: facilita os JOINs de funcionarios por departamento (Dno)
-- e a leitura dos nomes dentro de cada departamento (Lname, Fname).
-- Nota: uma FK em Dno pode ja ter criado um indice simples automaticamente.
-- Por isso o indice abaixo e composto e so vale a pena se as consultas
-- com nomes ordenados forem frequentes. Verifique SHOW INDEX antes de criar.
CREATE INDEX idx_employee_dno_lname_fname
    ON employee (Dno, Lname, Fname) USING BTREE;

-- BTREE: a PK (Dnumber, Dlocation) costuma atender a busca por Dnumber,
-- mas nao e adequada para pesquisar primeiro por cidade (Dlocation).
-- Este indice serve a consultas frequentes filtradas por cidade.
CREATE INDEX idx_dept_locations_city_dept
    ON dept_locations (Dlocation, Dnumber) USING BTREE;

-- Nao criamos novo indice em department(Dnumber): a chave primaria ja e indexada.
-- Evitamos indices repetidos porque ocupam espaco e aumentam o custo de escrita.

-- Para analisar os indices ja existentes (antes ou depois da criacao):
SHOW INDEX FROM department;
SHOW INDEX FROM employee;
SHOW INDEX FROM dept_locations;

-- 2) CONSULTAS

-- PERGUNTA 1: Qual departamento possui o maior numero de pessoas?
-- LEFT JOIN inclui departamentos sem funcionarios.
-- LIMIT 1 retorna um departamento; em caso de empate, o nome desempata.
SELECT d.Dnumber AS numero_departamento,
       d.Dname AS departamento,
       COUNT(e.Ssn) AS total_funcionarios
FROM department AS d
LEFT JOIN employee AS e ON e.Dno = d.Dnumber
GROUP BY d.Dnumber, d.Dname
ORDER BY total_funcionarios DESC, d.Dname ASC
LIMIT 1;

-- PERGUNTA 2: Quais sao os departamentos por cidade?
-- Um departamento em mais de uma cidade aparecera em linhas distintas.
SELECT dl.Dlocation AS cidade,
       d.Dnumber AS numero_departamento,
       d.Dname AS departamento
FROM dept_locations AS dl
JOIN department AS d ON d.Dnumber = dl.Dnumber
ORDER BY dl.Dlocation, d.Dname;

-- Consulta extra para demonstrar um filtro que pode aproveitar o indice de cidade:
SELECT dl.Dlocation AS cidade, d.Dname AS departamento
FROM dept_locations AS dl
JOIN department AS d ON d.Dnumber = dl.Dnumber
WHERE dl.Dlocation = 'Curitiba'
ORDER BY d.Dname;

-- PERGUNTA 3: Relacao de empregados por departamento.
-- LEFT JOIN mantem os departamentos mesmo se estiverem vazios.
SELECT d.Dnumber AS numero_departamento,
       d.Dname AS departamento,
       e.Ssn AS identificador_funcionario,
       e.Fname AS primeiro_nome,
       e.Lname AS sobrenome
FROM department AS d
LEFT JOIN employee AS e ON e.Dno = d.Dnumber
ORDER BY d.Dname, e.Lname, e.Fname;

-- Opcional: comparar os planos de execucao antes/depois dos indices.
-- EXPLAIN SELECT ... ;
