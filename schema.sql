-- =============================================================
--  SISTEMA DE DELIVERY DE COMIDA
--  Disciplina: Banco de Dados
--  Arquivo: schema.sql (DDL - Data Definition Language)
--  Descrição: Criação do banco de dados e de todas as tabelas
-- =============================================================

-- Cria e seleciona o banco de dados
CREATE DATABASE IF NOT EXISTS delivery_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE delivery_db;

-- =============================================================
--  TABELA: cliente
--  Armazena os usuários que realizam pedidos no sistema
-- =============================================================
CREATE TABLE cliente (
  id_cliente  INT           NOT NULL AUTO_INCREMENT,
  nome        VARCHAR(120)  NOT NULL,
  email       VARCHAR(120)  NOT NULL,
  cpf         CHAR(11)      NOT NULL,
  telefone    VARCHAR(20)   NOT NULL,
  status      CHAR(1)       NOT NULL DEFAULT 'A',  -- A = Ativo, I = Inativo

  CONSTRAINT pk_cliente    PRIMARY KEY (id_cliente),
  CONSTRAINT uq_cli_email  UNIQUE      (email),
  CONSTRAINT uq_cli_cpf    UNIQUE      (cpf),
  CONSTRAINT ck_cli_status CHECK       (status IN ('A', 'I'))
);

-- =============================================================
--  TABELA: endereco
--  Endereços de entrega vinculados a um cliente (1:N)
-- =============================================================
CREATE TABLE endereco (
  id_endereco INT           NOT NULL AUTO_INCREMENT,
  id_cliente  INT           NOT NULL,
  logradouro  VARCHAR(150)  NOT NULL,
  numero      VARCHAR(10)   NOT NULL,
  bairro      VARCHAR(80)   NOT NULL,
  cidade      VARCHAR(80)   NOT NULL,
  uf          CHAR(2)       NOT NULL,
  cep         CHAR(8)       NOT NULL,

  CONSTRAINT pk_endereco   PRIMARY KEY (id_endereco),
  CONSTRAINT fk_end_cliente
    FOREIGN KEY (id_cliente)
    REFERENCES cliente (id_cliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- =============================================================
--  TABELA: restaurante
--  Estabelecimentos cadastrados na plataforma
-- =============================================================
CREATE TABLE restaurante (
  id_restaurante INT           NOT NULL AUTO_INCREMENT,
  nome           VARCHAR(120)  NOT NULL,
  cnpj           CHAR(14)      NOT NULL,
  telefone       VARCHAR(20)   NOT NULL,
  status         CHAR(1)       NOT NULL DEFAULT 'A',  -- A = Ativo, I = Inativo
  taxa_entrega   DECIMAL(5,2)  NOT NULL DEFAULT 0.00,

  CONSTRAINT pk_restaurante   PRIMARY KEY (id_restaurante),
  CONSTRAINT uq_rest_cnpj     UNIQUE      (cnpj),
  CONSTRAINT ck_rest_status   CHECK       (status IN ('A', 'I')),
  CONSTRAINT ck_rest_taxa     CHECK       (taxa_entrega >= 0)
);

-- =============================================================
--  TABELA: categoria
--  Tipos de culinária (pizza, japonesa, hamburguer, etc.)
-- =============================================================
CREATE TABLE categoria (
  id_categoria INT           NOT NULL AUTO_INCREMENT,
  nome         VARCHAR(60)   NOT NULL,
  descricao    VARCHAR(200)  NOT NULL,

  CONSTRAINT pk_categoria  PRIMARY KEY (id_categoria),
  CONSTRAINT uq_cat_nome   UNIQUE      (nome)
);

-- =============================================================
--  TABELA: restaurante_categoria
--  Relacionamento N:N entre restaurante e categoria
-- =============================================================
CREATE TABLE restaurante_categoria (
  id_restaurante INT NOT NULL,
  id_categoria   INT NOT NULL,

  CONSTRAINT pk_rest_cat PRIMARY KEY (id_restaurante, id_categoria),
  CONSTRAINT fk_rc_restaurante
    FOREIGN KEY (id_restaurante)
    REFERENCES restaurante (id_restaurante)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_rc_categoria
    FOREIGN KEY (id_categoria)
    REFERENCES categoria (id_categoria)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- =============================================================
--  TABELA: produto
--  Itens do cardápio de cada restaurante (1:N com restaurante)
-- =============================================================
CREATE TABLE produto (
  id_produto     INT           NOT NULL AUTO_INCREMENT,
  id_restaurante INT           NOT NULL,
  nome           VARCHAR(100)  NOT NULL,
  descricao      TEXT,
  preco          DECIMAL(8,2)  NOT NULL,
  disponivel     CHAR(1)       NOT NULL DEFAULT 'S',  -- S = Sim, N = Não

  CONSTRAINT pk_produto      PRIMARY KEY (id_produto),
  CONSTRAINT ck_prod_preco   CHECK       (preco > 0),
  CONSTRAINT ck_prod_disp    CHECK       (disponivel IN ('S', 'N')),
  CONSTRAINT fk_prod_restaurante
    FOREIGN KEY (id_restaurante)
    REFERENCES restaurante (id_restaurante)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- =============================================================
--  TABELA: entregador
--  Profissionais responsáveis pelas entregas
-- =============================================================
CREATE TABLE entregador (
  id_entregador INT           NOT NULL AUTO_INCREMENT,
  nome          VARCHAR(120)  NOT NULL,
  cpf           CHAR(11)      NOT NULL,
  veiculo       VARCHAR(30)   NOT NULL,
  status        CHAR(1)       NOT NULL DEFAULT 'A',  -- A = Ativo, I = Inativo

  CONSTRAINT pk_entregador    PRIMARY KEY (id_entregador),
  CONSTRAINT uq_entr_cpf      UNIQUE      (cpf),
  CONSTRAINT ck_entr_status   CHECK       (status IN ('A', 'I'))
);

-- =============================================================
--  TABELA: pedido
--  Pedidos realizados pelos clientes
-- =============================================================
CREATE TABLE pedido (
  id_pedido      INT           NOT NULL AUTO_INCREMENT,
  id_cliente     INT           NOT NULL,
  id_restaurante INT           NOT NULL,
  id_endereco    INT           NOT NULL,
  id_entregador  INT,
  data_pedido    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status         CHAR(1)       NOT NULL DEFAULT 'P',  -- P = Pendente, E = Em preparo, C = A caminho, F = Finalizado, X = Cancelado
  total          DECIMAL(8,2)  NOT NULL DEFAULT 0.00,

  CONSTRAINT pk_pedido      PRIMARY KEY (id_pedido),
  CONSTRAINT ck_ped_status  CHECK       (status IN ('P', 'E', 'C', 'F', 'X')),
  CONSTRAINT ck_ped_total   CHECK       (total >= 0),
  CONSTRAINT fk_ped_cliente
    FOREIGN KEY (id_cliente)
    REFERENCES cliente (id_cliente)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_ped_restaurante
    FOREIGN KEY (id_restaurante)
    REFERENCES restaurante (id_restaurante)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_ped_endereco
    FOREIGN KEY (id_endereco)
    REFERENCES endereco (id_endereco)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_ped_entregador
    FOREIGN KEY (id_entregador)
    REFERENCES entregador (id_entregador)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

-- =============================================================
--  TABELA: item_pedido
--  Relacionamento N:N entre pedido e produto
--  Registra quais produtos e quantidades compõem cada pedido
-- =============================================================
CREATE TABLE item_pedido (
  id_item        INT          NOT NULL AUTO_INCREMENT,
  id_pedido      INT          NOT NULL,
  id_produto     INT          NOT NULL,
  quantidade     INT          NOT NULL,
  preco_unitario DECIMAL(8,2) NOT NULL,

  CONSTRAINT pk_item_pedido   PRIMARY KEY (id_item),
  CONSTRAINT ck_item_qtd      CHECK       (quantidade > 0),
  CONSTRAINT ck_item_preco    CHECK       (preco_unitario > 0),
  CONSTRAINT fk_item_pedido
    FOREIGN KEY (id_pedido)
    REFERENCES pedido (id_pedido)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_item_produto
    FOREIGN KEY (id_produto)
    REFERENCES produto (id_produto)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);
