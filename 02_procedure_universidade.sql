-- PARTE 2A - PROCEDURE PARA O BANCO UNIVERSIDADE
-- Script independente para demonstracao em MySQL 8.x.
-- Se voce ja tem um banco universidade com outras tabelas, adapte o modelo.

CREATE DATABASE IF NOT EXISTS universidade_desafio
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE universidade_desafio;

CREATE TABLE IF NOT EXISTS alunos (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    curso VARCHAR(100) NOT NULL
) ENGINE = InnoDB;

DROP PROCEDURE IF EXISTS sp_gerenciar_aluno;
DELIMITER $$

CREATE PROCEDURE sp_gerenciar_aluno(
    IN p_opcao INT,
    IN p_id INT,
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(120),
    IN p_curso VARCHAR(100)
)
BEGIN
    -- p_opcao: 1=inserir, 2=atualizar, 3=excluir, 4=consultar.
    CASE p_opcao
        WHEN 1 THEN
            INSERT INTO alunos (nome, email, curso)
            VALUES (p_nome, p_email, p_curso);

        WHEN 2 THEN
            UPDATE alunos
            SET nome = COALESCE(p_nome, nome),
                email = COALESCE(p_email, email),
                curso = COALESCE(p_curso, curso)
            WHERE id_aluno = p_id;

        WHEN 3 THEN
            DELETE FROM alunos WHERE id_aluno = p_id;

        WHEN 4 THEN
            SELECT id_aluno, nome, email, curso
            FROM alunos
            WHERE p_id IS NULL OR id_aluno = p_id
            ORDER BY id_aluno;

        ELSE
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Opcao invalida: use 1, 2, 3 ou 4';
    END CASE;
END $$

DELIMITER ;

-- EXEMPLOS DE CHAMADAS (inserir -> consultar -> atualizar -> excluir).
-- Usamos LAST_INSERT_ID() para manipular o registro que acabamos de inserir.
CALL sp_gerenciar_aluno(1, NULL, 'Maria Souza',
                        'maria.souza@exemplo.com', 'Engenharia de Software');
SET @aluno_criado = LAST_INSERT_ID();

CALL sp_gerenciar_aluno(4, @aluno_criado, NULL, NULL, NULL);
CALL sp_gerenciar_aluno(2, @aluno_criado, 'Maria S. Souza', NULL, 'Sistemas de Informacao');
CALL sp_gerenciar_aluno(4, @aluno_criado, NULL, NULL, NULL);
CALL sp_gerenciar_aluno(3, @aluno_criado, NULL, NULL, NULL);
CALL sp_gerenciar_aluno(4, NULL, NULL, NULL, NULL);
