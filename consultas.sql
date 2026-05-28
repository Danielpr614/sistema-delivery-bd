-- =============================================================
--  SISTEMA DE DELIVERY DE COMIDA
--  Disciplina: Banco de Dados
--  Arquivo: consultas.sql
--  Descrição: 10 consultas SQL (5 simples + 5 com JOIN)
-- =============================================================

USE delivery_db;

-- =============================================================
--  CONSULTAS SIMPLES (sem JOIN)
-- =============================================================

-- Consulta 1: Listar todos os clientes ativos em ordem alfabética
-- Objetivo: exibir nome, email e telefone dos clientes com status 'A'
SELECT
  nome,
  email,
  telefone
FROM cliente
WHERE status = 'A'
ORDER BY nome ASC;

-- -----------------------------------------------------------

-- Consulta 2: Listar todos os restaurantes com taxa de entrega abaixo de R$ 5,00
-- Objetivo: encontrar opções mais baratas de entrega para o cliente
SELECT
  nome,
  telefone,
  taxa_entrega
FROM restaurante
WHERE taxa_entrega < 5.00
  AND status = 'A'
ORDER BY taxa_entrega ASC;

-- -----------------------------------------------------------

-- Consulta 3: Contar quantos pedidos cada status possui
-- Objetivo: ter uma visão geral da situação dos pedidos na plataforma
SELECT
  status,
  COUNT(*) AS quantidade
FROM pedido
GROUP BY status
ORDER BY quantidade DESC;

-- -----------------------------------------------------------

-- Consulta 4: Listar os produtos disponíveis com preço entre R$ 10,00 e R$ 50,00
-- Objetivo: filtrar produtos dentro de uma faixa de preço específica
SELECT
  nome,
  descricao,
  preco
FROM produto
WHERE disponivel = 'S'
  AND preco BETWEEN 10.00 AND 50.00
ORDER BY preco ASC;

-- -----------------------------------------------------------

-- Consulta 5: Listar entregadores ativos e o tipo de veículo que utilizam
-- Objetivo: verificar a frota disponível de entregadores
SELECT
  nome,
  veiculo,
  status
FROM entregador
WHERE status = 'A'
ORDER BY veiculo, nome;

-- =============================================================
--  CONSULTAS COM JOIN
-- =============================================================

-- Consulta 6: Listar todos os pedidos com o nome do cliente e do restaurante
-- Tabelas envolvidas: pedido, cliente, restaurante (3 tabelas)
-- Objetivo: visão completa dos pedidos com informações legíveis
SELECT
  p.id_pedido,
  c.nome        AS cliente,
  r.nome        AS restaurante,
  p.data_pedido,
  p.status,
  p.total
FROM pedido p
INNER JOIN cliente     c ON c.id_cliente     = p.id_cliente
INNER JOIN restaurante r ON r.id_restaurante = p.id_restaurante
ORDER BY p.data_pedido DESC;

-- -----------------------------------------------------------

-- Consulta 7: Listar os itens de cada pedido com nome do produto e valor total do item
-- Tabelas envolvidas: item_pedido, pedido, produto (3 tabelas)
-- Objetivo: detalhar a composição de cada pedido
SELECT
  ip.id_pedido,
  pr.nome                                        AS produto,
  ip.quantidade,
  ip.preco_unitario,
  (ip.quantidade * ip.preco_unitario)            AS valor_total_item
FROM item_pedido ip
INNER JOIN pedido  p  ON p.id_pedido  = ip.id_pedido
INNER JOIN produto pr ON pr.id_produto = ip.id_produto
ORDER BY ip.id_pedido, pr.nome;

-- -----------------------------------------------------------

-- Consulta 8: Listar as categorias de cada restaurante ativo
-- Tabelas envolvidas: restaurante, restaurante_categoria, categoria (3 tabelas)
-- Objetivo: mostrar em quais segmentos cada restaurante atua
SELECT
  r.nome  AS restaurante,
  c.nome  AS categoria
FROM restaurante r
INNER JOIN restaurante_categoria rc ON rc.id_restaurante = r.id_restaurante
INNER JOIN categoria             c  ON c.id_categoria    = rc.id_categoria
WHERE r.status = 'A'
ORDER BY r.nome, c.nome;

-- -----------------------------------------------------------

-- Consulta 9: Ranking dos clientes que mais gastaram na plataforma
-- Tabelas envolvidas: cliente, pedido
-- Objetivo: identificar os clientes mais valiosos do sistema
SELECT
  c.nome                  AS cliente,
  COUNT(p.id_pedido)      AS total_pedidos,
  SUM(p.total)            AS valor_total_gasto
FROM cliente c
INNER JOIN pedido p ON p.id_cliente = c.id_cliente
WHERE p.status = 'F'
GROUP BY c.id_cliente, c.nome
ORDER BY valor_total_gasto DESC;

-- -----------------------------------------------------------

-- Consulta 10: Relatório completo de pedidos finalizados com cliente,
--              restaurante, entregador e endereço de entrega
-- Tabelas envolvidas: pedido, cliente, restaurante, entregador, endereco (5 tabelas)
-- Objetivo: visão 360° de cada entrega realizada com sucesso
SELECT
  p.id_pedido,
  c.nome                                          AS cliente,
  r.nome                                          AS restaurante,
  e.nome                                          AS entregador,
  e.veiculo,
  CONCAT(en.logradouro, ', ', en.numero, ' - ',
         en.bairro, ', ', en.cidade, '/', en.uf)  AS endereco_entrega,
  p.data_pedido,
  p.total
FROM pedido p
INNER JOIN cliente     c  ON c.id_cliente     = p.id_cliente
INNER JOIN restaurante r  ON r.id_restaurante = p.id_restaurante
INNER JOIN entregador  e  ON e.id_entregador  = p.id_entregador
INNER JOIN endereco    en ON en.id_endereco   = p.id_endereco
WHERE p.status = 'F'
ORDER BY p.data_pedido DESC;
