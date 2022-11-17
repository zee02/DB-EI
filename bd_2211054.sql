-- Ficha 1

-- 1
SELECT nome,marca FROM produto;

-- 2
SELECT nome,marca FROM produto ORDER BY nome ASC;

-- 3
SELECT id, cod, nome, concelho_id, data_abertura FROM loja ORDER BY data_abertura ASC;

-- 4
SELECT nome as nome_do_produto,id as id_do_produto FROM produto WHERE preco_unit_atual > 10 ORDER BY preco_unit_atual DESC;

-- 5
SELECT nome as nome_da_loja, concelho_id as concelho FROM loja WHERE concelho_id IN (0603, 1009) ORDER BY concelho_id ASC;

-- 6
SELECT marca FROM produto WHERE marca = 'QINGSTON';
UPDATE produto SET marca = 'KINGSTON' WHERE marca = 'QINGSTON';

-- 7
UPDATE produto SET categoria_id = 30 WHERE id = 1060;
-- N�o � poss�vel fazer a altera��o porque esta � chave estrangeira, ou seja, obt�m o seu valor de outra tabela.

-- 8
INSERT INTO categoria (id, nome, categoria_pai_id) VALUES (25, 'RATOS', 6);

-- 9
INSERT INTO produto (id, nome, marca, preco_unit_atual, iva, categoria_id) VALUES (2005, 'Rato SCULPT MOBILE FLAME RED', 'Microsoft', 25.56, 23, 25);

-- 10
DELETE produto WHERE nome = 'LIXO';

-- 11
DELETE venda WHERE id = 1000;
-- N�o � poss�vel remover este registo porque este � usado por outra tabela, linha_venda.
DELETE linha_venda WHERE venda_id = 1000;
DELETE venda WHERE id = 1000;

-- 12
COMMIT;

-- 13
DELETE distrito WHERE nome = 'Lisboa';
SELECT nome FROM distrito WHERE nome = 'Lisboa';
ROLLBACK;
-- As opera��es realizadas anteriormente n�o foram revertidas porque estas j� tinham sido cometidas na al�nea 12.

-- Ficha 2

-- 1

SELECT nome, preco_unit_atual FROM produto WHERE preco_unit_atual > 9.99 ORDER BY preco_unit_atual ASC;

-- 2
SELECT nome, categoria_id FROM produto WHERE marca IS NULL;

-- 3
SELECT nome || ' [' || MARCA || ']' AS produtos_com_marca FROM produto WHERE marca IS NOT NULL ORDER BY marca ASC;

-- 4
SELECT nome FROM categoria WHERE id = 1 OR categoria_pai_id = 1;

-- 5
SELECT nome, preco_unit_atual AS "preco sem iva", preco_unit_atual * (iva * 0.01 + 1) AS "preco com iva" FROM produto WHERE categoria_id = 6 OR categoria_id = 20;

-- 6
SELECT nome || ' -> ' || preco_unit_atual || ' �' AS "produto/preco", marca FROM produto WHERE marca != 'KINGSTON' OR marca IS NULL;

-- 7
SELECT cod, TO_CHAR(data_abertura, 'YYYY') AS "Ano de abertura" FROM loja ORDER BY TO_CHAR(data_abertura, 'YYYY') DESC;

-- 8
SELECT UPPER(nome), ROUND(preco_unit_atual, 1) AS preco_arrendondado FROM produto WHERE categoria_id = 7 OR categoria_id = 18;

-- 9
SELECT id, LOWER(nome) AS nome, CASE WHEN categoria_pai_id IS NULL THEN 'n/a' ELSE TO_CHAR(categoria_pai_id) END AS cat_pai FROM categoria;

-- 10
SELECT nome FROM loja WHERE TO_CHAR(data_abertura, 'YYYY') > 1999 AND nome != 'online';

-- 11
SELECT nome, preco_unit_atual, ROUND(preco_unit_atual * (iva * 0.01), 2) AS valor_do_iva_por_unidade FROM produto WHERE LOWER(nome) LIKE '%ma��%';

-- 12
SELECT nome, TRUNC(CURRENT_DATE - data_abertura) AS dias_vida FROM loja WHERE LOWER(nome) LIKE '%contente%';
SELECT nome, TRUNC(MONTHS_BETWEEN(CURRENT_DATE, data_abertura)) AS dias_vida FROM loja WHERE LOWER(nome) LIKE '%contente%';
SELECT nome, TRUNC(MONTHS_BETWEEN(CURRENT_DATE, data_abertura) / 12) AS dias_vida FROM loja WHERE LOWER(nome) LIKE '%contente%';

-- 13
SELECT venda_id, id AS linha_de_venda, produto_id, preco_unit_venda * unidades - CASE WHEN desconto_unit_euros IS NULL THEN 0 ELSE desconto_unit_euros END AS valor_pago FROM linha_venda WHERE venda_id = 1459;

-- 14
SELECT id, nome, iva, CASE WHEN iva = 6 THEN 'reduzido' WHEN iva = 12 THEN 'interm�dio' WHEN iva = 23 THEN 'normal' END AS taxa_iva FROM produto WHERE preco_unit_atual < 15 ORDER BY iva, nome;

-- Ficha 3

-- 1
SELECT nome AS produto_nome, categoria_id AS produto_cat_id FROM produto WHERE iva = 23 ORDER BY nome;
SELECT produto.nome AS produto_nome, produto.categoria_id AS produto_cat_id, categoria.id AS categoria_id, categoria.nome AS categoria_nome FROM produto JOIN categoria ON produto.categoria_id = categoria.id WHERE produto.iva = 23 ORDER BY produto.nome;

-- 2
SELECT id AS loja_id, nome AS loja_nome, concelho_id AS loja_concelho FROM loja WHERE nome = 'online';
SELECT loja.id AS loja_id, loja.nome AS loja_nome, loja.concelho_id AS loja_concelho, concelho.nome AS concelho_nome FROM loja JOIN concelho ON loja.concelho_id = concelho.id WHERE loja.nome = 'online';
SELECT loja.id AS loja_id, loja.nome AS loja_nome, loja.concelho_id AS loja_concelho, concelho.nome AS concelho_nome, distrito.nome AS distrito_nome FROM loja JOIN concelho ON loja.concelho_id = concelho.id JOIN distrito ON concelho.distrito_id = distrito.id WHERE loja.nome = 'online';

-- 3
SELECT produto.id AS produto_id, produto.nome AS produto_nome, categoria.nome AS categoria_nome FROM produto JOIN categoria ON produto.categoria_id = categoria.id WHERE categoria.nome = 'PERIF�RICOS' OR categoria.nome = 'ARMAZENAMENTO';

-- 4
SELECT venda.id AS id, loja.nome AS loja_nome, produto.id AS produto_id, produto.nome AS produto_nome, linha_venda.unidades AS unidades FROM venda 
JOIN loja ON venda.loja_id = loja.id 
JOIN linha_venda ON linha_venda.venda_id = venda.id 
JOIN produto ON produto.id = linha_venda.produto_id 
WHERE venda.data = '01-JUL-21' AND loja.nome = 'Modelo Eiras';

-- 5 
SELECT venda.id AS venda_id, to_char(venda.data, 'yyyy/MONTH') AS m�s FROM venda WHERE to_char(venda.data, 'YYYY-mm') = '2021-06';
SELECT venda.id AS venda_id, to_char(venda.data, 'yyyy/MONTH') AS m�s, linha_venda.produto_id AS produto_id FROM venda JOIN linha_venda ON linha_venda.venda_id = venda.id WHERE to_char(venda.data, 'YYYY-mm') = '2021-06';
SELECT venda.id AS venda_id, to_char(venda.data, 'yyyy/MONTH') AS m�s, linha_venda.produto_id AS produto_id FROM venda LEFT JOIN linha_venda ON linha_venda.venda_id = venda.id WHERE to_char(venda.data, 'YYYY-mm') = '2021-06';

-- 6
SELECT categoria.nome AS categ_nome, produto.nome AS prod_nome FROM produto RIGHT JOIN categoria ON categoria.id = produto.categoria_id WHERE categoria.nome IN('CEREAIS', 'FRUTAS E LEGUMES', 'FRUTOS SECOS') ORDER BY categoria.nome;

-- 7
SELECT UPPER(concelho.nome) AS concelho_nome FROM concelho;
SELECT UPPER(concelho.nome) AS concelho_nome FROM concelho JOIN loja ON loja.concelho_id = concelho.id;
SELECT UPPER(concelho.nome) AS concelho_nome FROM concelho MINUS SELECT UPPER(concelho.nome) AS concelho_nome FROM concelho JOIN loja ON loja.concelho_id = concelho.id;

-- 8
SELECT linha_venda.produto_id FROM linha_venda WHERE to_char(data, 'dd-mm-yy') = '30-06-21' INTERSECT SELECT linha_venda.produto_id FROM linha_venda WHERE to_char(data, 'dd-mm-yy') = '01-07-21';

-- 9
SELECT '[D]' || UPPER(distrito.nome) AS regi�es FROM distrito UNION SELECT '[C]' || LOWER(concelho.nome) AS regi�es FROM concelho ORDER BY 1 DESC; 

-- Ficha 4

-- 1
SELECT COUNT(*) AS total_categorias FROM categoria;
SELECT COUNT(*) AS total_categorias_com_pai FROM categoria WHERE categoria_pai_id IS NOT NULL;
SELECT COUNT(categoria_pai_id) AS total_categorias_com_pai FROM categoria;
SELECT COUNT(*) - COUNT(categoria_pai_id) AS total_categorias_sem_pai FROM categoria;

-- 2
SELECT COUNT(iva) AS total_produtos_iva23, AVG(preco_unit_atual) AS preco_medio FROM produto WHERE iva = 23;
SELECT COUNT(produto.iva) AS total_produtos_iva23, TRUNC(AVG(produto.preco_unit_atual)) AS preco_medio, SUM(linha_venda.unidades) AS unidades_vendidas FROM produto JOIN linha_venda ON produto.id = linha_venda.produto_id WHERE iva = 23 AND linha_venda.desconto_unit_euros > 0;

-- 3
SELECT MIN(TO_CHAR(data, 'day, dd/MON/YYYY')) AS primeira_venda FROM venda;

-- 4
SELECT categoria.nome AS categoria_nome, COUNT(*) AS total_produtos FROM produto JOIN categoria ON produto.categoria_id = categoria.id WHERE categoria.nome IN ('FRUTAS E LEGUMES','ARMAZENAMENTO') GROUP BY categoria.nome ORDER BY categoria.nome DESC;

-- 5
SELECT TO_CHAR(data, 'YYYY-mm') AS m�s, COUNT(*) AS total_vendas FROM venda GROUP BY TO_CHAR(data, 'YYYY-mm');
SELECT TO_CHAR(data, 'YYYY-mm') AS m�s, loja_id AS loja_id, COUNT(*) AS total_vendas FROM venda GROUP BY TO_CHAR(data, 'YYYY-mm'), loja_id ORDER BY TO_CHAR(data, 'YYYY-mm');

-- 6
SELECT LOWER(concelho.nome) AS concelho_nome, COUNT(*) AS total_lojas FROM loja JOIN concelho ON loja.concelho_id = concelho.id GROUP BY concelho.nome; 

-- 7
SELECT categoria.nome AS categoria_nome, COUNT(*) AS n�mero_de_produtos FROM categoria JOIN produto ON categoria.id = produto.categoria_id GROUP BY categoria.nome HAVING COUNT(*) >= 2; 
SELECT categoria.nome AS categoria_nome, COUNT(*) AS n�mero_de_produtos, MAX(produto.preco_unit_atual) AS produto_mais_caro FROM categoria JOIN produto ON categoria.id = produto.categoria_id GROUP BY categoria.nome HAVING COUNT(*) >= 2 AND MAX(produto.preco_unit_atual) < 20; 

-- 8
SELECT venda_id, SUM(unidades) as total_unidades, SUM(preco_unit_venda * unidades) - SUM(desconto_unit_euros * unidades) as total_pago FROM linha_venda GROUP BY venda_id;

-- Ficha 5

-- 1
SELECT id AS venda_id, TO_CHAR(data, 'yyyy-mm-dd (day)') AS data FROM venda WHERE data != (SELECT MIN(data) FROM venda);

-- 2
SELECT id AS venda_id, TO_CHAR(data, 'yyyy-mm-dd (day)') AS data FROM venda WHERE data != (SELECT MIN(data) FROM venda) AND data != (SELECT MAX(data) FROM venda);

-- 3
SELECT venda.id, TO_CHAR(venda.data, 'YY.mm.dd') AS data, linha_venda.desconto_unit_euros FROM venda JOIN linha_venda ON venda.id = linha_venda.venda_id WHERE linha_venda.desconto_unit_euros = (SELECT MAX(linha_venda.desconto_unit_euros) FROM linha_venda);

-- 4
SELECT id, cod, nome, concelho_id, TO_CHAR(data_abertura, 'dd-MON-YYYY HH24:MI:SS') AS data_abertura FROM loja WHERE id NOT IN (SELECT DISTINCT loja_id FROM venda);

-- 5
SELECT id AS produto_id, nome AS produto_nome, categoria_id FROM produto WHERE preco_unit_atual = (SELECT MIN(preco_unit_atual) FROM produto);

SELECT produto.id AS produto_id, produto.nome AS produto_nome, produto.categoria_id FROM produto JOIN (SELECT categoria_id, MIN(preco_unit_atual) as preco_min FROM produto GROUP BY categoria_id) cat ON produto.categoria_id = cat.categoria_id WHERE produto.preco_unit_atual = cat.preco_min;

-- 6
SELECT nome, preco_unit_atual FROM produto WHERE preco_unit_atual > (SELECT preco_unit_atual FROM produto WHERE id = :id_produto_base);
SELECT nome, preco_unit_atual, (SELECT nome FROM produto WHERE id = :id_produto_base) AS produto_base FROM produto WHERE preco_unit_atual > (SELECT preco_unit_atual FROM produto WHERE id = :id_produto_base);

-- 7
SELECT id AS produto_id, nome AS produto_nome, preco_unit_atual FROM produto WHERE preco_unit_atual IN (SELECT DISTINCT preco_unit_atual FROM produto ORDER BY preco_unit_atual DESC OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY);

-- 8
SELECT categoria_id, categoria.nome AS categoria_nome, COUNT(*) AS total_produtos FROM produto JOIN categoria ON produto.categoria_id = categoria.id GROUP BY categoria_id, categoria.nome HAVING COUNT(*) = (SELECT MAX(total_produtos) FROM(SELECT COUNT(*) AS total_produtos FROM produto GROUP BY categoria_id));



-- COMPLETAR Ficha 2 Capitulo 4
-- 
-- 4.a
-- eliminar a tabela caso exista
DROP TABLE cliente CASCADE CONSTRAINTS;
-- CRIAR A TABELA CLIENTE
CREATE TABLE cliente(
id NUMBER(10)   GENERATED AS IDENTITY (START WITH 1 INCREMENT BY 1),
nif             CHAR(9),
nome            VARCHAR2(50) NOT NULL,
data_nasc       DATE,
data_adesao     DATE DEFAULT SYSDATE NOT NULL,
genero          CHAR(1) DEFAULT 'F',
concelho_id     CHAR(4) NOT NULL,
CONSTRAINT pk_cliente_id PRIMARY KEY(id),
CONSTRAINT fk_cliente_concelho FOREIGN KEY(concelho_id) REFERENCES concelho(id),
CONSTRAINT ck_cliente_genero CHECK(genero IN ('F','M','O')),
CONSTRAINT uq_cliente_nif UNIQUE(nif),
CONSTRAINT ck_cliente_nome CHECK (REGEXP_LIKE(nome,'^[A-Z]')),
CONSTRAINT ck_cliente_nif CHECK(REGEXP_LIKE(nif,'^(2|5)\d{8}'))
);
 
-- 4.b)
-- CRIAR CLIENTES
INSERT INTO cliente(nif,nome, data_nasc, concelho_id)
VALUES('220101000','Maria Gargalhada', TO_DATE('1980-10-12','yyyy-mm-dd'),'0603');
INSERT INTO cliente(nif,nome, concelho_id)
VALUES('500102212','Facebook, Lda', '1312');
INSERT INTO cliente(nif,nome, genero,concelho_id)
VALUES('500102253','Anónimo', 'O',(SELECT ID FROM CONCELHO WHERE UPPER(nome)='PORTO'));
 
-- 4.c)
-- ELIMINAR A COLUNA CASO EXISTA(CLIENTE_ID)
ALTER TABLE venda DROP COLUMN cliente_id;
-- CRIAR A COLUNA 
ALTER TABLE  venda ADD (cliente_id NUMBER(10));
 
-- 4.d)
-- ATUALIZAR A COLUNA CLIENTE_ID DA TABELA VENDA
UPDATE venda 
SET    cliente_id=(SELECT id FROM cliente WHERE UPPER(nome)='MARIA GARGALHADA')
WHERE  ID IN (1450, 1451, 1460);
UPDATE venda 
SET    cliente_id=(SELECT id FROM cliente WHERE UPPER(nome)='FACEBOOK, LDA' FETCH FIRST 1 ROWS ONLY)
WHERE  ID IN (1457, 1459);
UPDATE venda 
SET    cliente_id=(SELECT id FROM cliente WHERE UPPER(nome)='ANÓNIMO')
WHERE  cliente_id IS NULL;
 
-- 4.f) REGRA DE INTEGRIDADE REFERENCIAL
-- ADICIONAR UMA RESTRIÇÃO DE CHAVE ESTRANGEIRA (ESTABELECER A INTEGRIDADE REFERENCIAL)
ALTER TABLE venda ADD 
(CONSTRAINT fk_venda_cliente_id 
FOREIGN KEY(cliente_id) REFERENCES cliente(id));
 
-- 5.b) REGRA DE PREENCHIMENTO OBRIGATÓRIO
-- MODIFICAR A COLUNA cliente_id: a coluna passa a ser de preenchimento obrigatório
-- NÃO PODEM EXISTIR VENDAS SEM QUE UM CLIENTE SEJA ASSOCIADO 
ALTER TABLE venda MODIFY cliente_id NUMBER(10) NOT NULL;
