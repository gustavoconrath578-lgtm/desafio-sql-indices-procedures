-- OPCIONAL: banco minimo de testes para a Parte 1.
-- Nao execute se a atividade ja forneceu um banco company preenchido.
-- Este script usa a estrutura classica de company com tres tabelas necessarias.

CREATE DATABASE IF NOT EXISTS company
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE company;

CREATE TABLE IF NOT EXISTS department (
    Dnumber INT PRIMARY KEY,
    Dname VARCHAR(60) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS employee (
    Ssn CHAR(9) PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    Dno INT NOT NULL,
    CONSTRAINT fk_employee_department
        FOREIGN KEY (Dno) REFERENCES department(Dnumber)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS dept_locations (
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(60) NOT NULL,
    PRIMARY KEY (Dnumber, Dlocation),
    CONSTRAINT fk_locations_department
        FOREIGN KEY (Dnumber) REFERENCES department(Dnumber)
) ENGINE = InnoDB;

INSERT IGNORE INTO department (Dnumber, Dname) VALUES
    (1, 'Administracao'),
    (2, 'Tecnologia'),
    (3, 'Recursos Humanos');

INSERT IGNORE INTO employee (Ssn, Fname, Lname, Dno) VALUES
    ('000000001', 'Ana', 'Lima', 1),
    ('000000002', 'Paulo', 'Souza', 2),
    ('000000003', 'Joana', 'Silva', 2),
    ('000000004', 'Lucas', 'Costa', 2),
    ('000000005', 'Beatriz', 'Alves', 3),
    ('000000006', 'Marcelo', 'Rocha', 3),
    ('000000007', 'Cristina', 'Medeiros', 2);

INSERT IGNORE INTO dept_locations (Dnumber, Dlocation) VALUES
    (1, 'Curitiba'),
    (2, 'Curitiba'),
    (2, 'Londrina'),
    (3, 'Maringa');
