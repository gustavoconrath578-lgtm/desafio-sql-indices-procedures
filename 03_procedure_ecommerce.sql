-- PARTE 2B - PROCEDURE PARA O BANCO E-COMMERCE
-- Script independente para demonstracao em MySQL 8.x.

CREATE DATABASE IF NOT EXISTS ecommerce_desafio
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce_desafio;

CREATE TABLE IF NOT EXISTS produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL,
    CONSTRAINT ck_produtos_preco CHECK (preco >= 0),
    CONSTRAINT ck_produtos_estoque CHECK (estoque >= 0)
) ENGINE = InnoDB;

DROP PROCEDURE IF EXISTS sp_gerenciar_produto;
DELIMITER $$

CREATE PROCEDURE sp_gerenciar_produto(
    IN p_opcao INT,
    IN p_id INT,
    IN p_nome VARCHAR(100),
    IN p_preco DECIMAL(10,2),
    IN p_estoque INT
)
BEGIN
    -- p_opcao: 1=inserir, 2=atualizar, 3=excluir, 4=consultar.
    IF p_opcao = 1 THEN
        INSERT INTO produtos (nome, preco, estoque)
        VALUES (p_nome, p_preco, p_estoque);

    ELSEIF p_opcao = 2 THEN
        UPDATE produtos
        SET nome = COALESCE(p_nome, nome),
            preco = COALESCE(p_preco, preco),
            estoque = COALESCE(p_estoque, estoque)
        WHERE id_produto = p_id;

    ELSEIF p_opcao = 3 THEN
        DELETE FROM produtos WHERE id_produto = p_id;

    ELSEIF p_opcao = 4 THEN
        SELECT id_produto, nome, preco, estoque
        FROM produtos
        WHERE p_id IS NULL OR id_produto = p_id
        ORDER BY id_produto;

    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Opcao invalida: use 1, 2, 3 ou 4';
    END IF;
END $$

DELIMITER ;

-- EXEMPLOS DE CHAMADAS (inserir -> consultar -> atualizar -> excluir).
CALL sp_gerenciar_produto(1, NULL, 'Mouse USB', 89.90, 25);
SET @produto_criado = LAST_INSERT_ID();

CALL sp_gerenciar_produto(4, @produto_criado, NULL, NULL, NULL);
CALL sp_gerenciar_produto(2, @produto_criado, 'Mouse sem fio', 99.90, 20);
CALL sp_gerenciar_produto(4, @produto_criado, NULL, NULL, NULL);
CALL sp_gerenciar_produto(3, @produto_criado, NULL, NULL, NULL);
CALL sp_gerenciar_produto(4, NULL, NULL, NULL, NULL);
