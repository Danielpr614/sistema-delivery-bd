# Dicionário de Dados — Sistema de Delivery de Comida

## Informações do Projeto

| Campo | Descrição |
|---|---|
| **Disciplina** | Banco de Dados |
| **Tema** | Sistema de Delivery de Comida |
| **SGBD** | MySQL |
| **Banco de dados** | delivery_db |

---

## Tabela: `cliente`

Armazena os usuários cadastrados na plataforma que realizam pedidos.

| Coluna | Tipo | Nulo | Padrão | Restrição | Descrição |
|---|---|---|---|---|---|
| id_cliente | INT | NÃO | — | PK, AUTO_INCREMENT | Identificador único do cliente |
| nome | VARCHAR(120) | NÃO | — | NOT NULL | Nome completo do cliente |
| email | VARCHAR(120) | NÃO | — | NOT NULL, UNIQUE | E-mail de acesso à plataforma |
| cpf | CHAR(11) | NÃO | — | NOT NULL, UNIQUE | CPF do cliente (apenas dígitos) |
| telefone | VARCHAR(20) | NÃO | — | NOT NULL | Telefone de contato |
| status | CHAR(1) | NÃO | 'A' | CHECK (A, I) | Situação do cadastro: A = Ativo, I = Inativo |

---

## Tabela: `endereco`

Armazena os endereços de entrega vinculados a cada cliente. Um cliente pode ter múltiplos endereços.

| Coluna | Tipo | Nulo | Padrão | Restrição | Descrição |
|---|---|---|---|---|---|
| id_endereco | INT | NÃO | — | PK, AUTO_INCREMENT | Identificador único do endereço |
| id_cliente | INT | NÃO | — | FK → cliente | Cliente ao qual o endereço pertence |
| logradouro | VARCHAR(150) | NÃO | — | NOT NULL | Nome da rua ou avenida |
| numero | VARCHAR(10) | NÃO | — | NOT NULL | Número do imóvel |
| bairro | VARCHAR(80) | NÃO | — | NOT NULL | Bairro do endereço |
| cidade | VARCHAR(80) | NÃO | — | NOT NULL | Cidade do endereço |
| uf | CHAR(2) | NÃO | — | NOT NULL | Sigla do estado (ex: SP, RJ) |
| cep | CHAR(8) | NÃO | — | NOT NULL | CEP sem hífen (apenas dígitos) |

**Relacionamento:** `cliente` (1) → (N) `endereco`
**ON DELETE:** CASCADE — ao excluir o cliente, seus endereços são excluídos automaticamente

---

## Tabela: `restaurante`

Armazena os estabelecimentos cadastrados na plataforma.

| Coluna | Tipo | Nulo | Padrão | Restrição | Descrição |
|---|---|---|---|---|---|
| id_restaurante | INT | NÃO | — | PK, AUTO_INCREMENT | Identificador único do restaurante |
| nome | VARCHAR(120) | NÃO | — | NOT NULL | Nome do estabelecimento |
| cnpj | CHAR(14) | NÃO | — | NOT NULL, UNIQUE | CNPJ sem pontuação (apenas dígitos) |
| telefone | VARCHAR(20) | NÃO | — | NOT NULL | Telefone de contato |
| status | CHAR(1) | NÃO | 'A' | CHECK (A, I) | Situação: A = Ativo, I = Inativo |
| taxa_entrega | DECIMAL(5,2) | NÃO | 0.00 | CHECK (>= 0) | Valor cobrado pela entrega em reais |

---

## Tabela: `categoria`

Armazena os tipos de culinária disponíveis na plataforma (ex: Pizza, Japonesa, Hamburguer).

| Coluna | Tipo | Nulo | Padrão | Restrição | Descrição |
|---|---|---|---|---|---|
| id_categoria | INT | NÃO | — | PK, AUTO_INCREMENT | Identificador único da categoria |
| nome | VARCHAR(60) | NÃO | — | NOT NULL, UNIQUE | Nome da categoria culinária |
| descricao | VARCHAR(200) | NÃO | — | NOT NULL | Descrição breve da categoria |

---

## Tabela: `restaurante_categoria`

Tabela associativa que implementa o relacionamento N:N entre restaurante e categoria. Um restaurante pode pertencer a várias categorias e uma categoria pode agrupar vários restaurantes.

| Coluna | Tipo | Nulo | Padrão | Restrição | Descrição |
|---|---|---|---|---|---|
| id_restaurante | INT | NÃO | — | FK → restaurante | Referência ao restaurante |
| id_categoria | INT | NÃO | — | FK → categoria | Referência à categoria |

**Chave primária composta:** (id_restaurante, id_categoria)
**Relacionamento:** `restaurante` (N) ↔ (N) `categoria`
**ON DELETE:** CASCADE em ambas as chaves estrangeiras

---

## Tabela: `produto`

Armazena os itens do cardápio de cada restaurante.

| Coluna | Tipo | Nulo | Padrão | Restrição | Descrição |
|---|---|---|---|---|---|
| id_produto | INT | NÃO | — | PK, AUTO_INCREMENT | Identificador único do produto |
| id_restaurante | INT | NÃO | — | FK → restaurante | Restaurante ao qual o produto pertence |
| nome | VARCHAR(100) | NÃO | — | NOT NULL | Nome do produto no cardápio |
| descricao | TEXT | SIM | — | — | Descrição detalhada do produto |
| preco | DECIMAL(8,2) | NÃO | — | CHECK (> 0) | Preço unitário do produto em reais |
| disponivel | CHAR(1) | NÃO | 'S' | CHECK (S, N) | Disponibilidade: S = Sim, N = Não |

**Relacionamento:** `restaurante` (1) → (N) `produto`
**ON DELETE:** CASCADE — ao excluir o restaurante, seus produtos são excluídos

---

## Tabela: `entregador`

Armazena os profissionais responsáveis por realizar as entregas.

| Coluna | Tipo | Nulo | Padrão | Restrição | Descrição |
|---|---|---|---|---|---|
| id_entregador | INT | NÃO | — | PK, AUTO_INCREMENT | Identificador único do entregador |
| nome | VARCHAR(120) | NÃO | — | NOT NULL | Nome completo do entregador |
| cpf | CHAR(11) | NÃO | — | NOT NULL, UNIQUE | CPF do entregador (apenas dígitos) |
| veiculo | VARCHAR(30) | NÃO | — | NOT NULL | Tipo de veículo utilizado |
| status | CHAR(1) | NÃO | 'A' | CHECK (A, I) | Situação: A = Ativo, I = Inativo |

---

## Tabela: `pedido`

Armazena os pedidos realizados pelos clientes. Centraliza as referências para cliente, restaurante, endereço e entregador.

| Coluna | Tipo | Nulo | Padrão | Restrição | Descrição |
|---|---|---|---|---|---|
| id_pedido | INT | NÃO | — | PK, AUTO_INCREMENT | Identificador único do pedido |
| id_cliente | INT | NÃO | — | FK → cliente | Cliente que realizou o pedido |
| id_restaurante | INT | NÃO | — | FK → restaurante | Restaurante que recebeu o pedido |
| id_endereco | INT | NÃO | — | FK → endereco | Endereço de entrega selecionado |
| id_entregador | INT | SIM | — | FK → entregador | Entregador designado (pode ser nulo no início) |
| data_pedido | DATETIME | NÃO | CURRENT_TIMESTAMP | NOT NULL | Data e hora em que o pedido foi feito |
| status | CHAR(1) | NÃO | 'P' | CHECK (P,E,C,F,X) | P = Pendente, E = Em preparo, C = A caminho, F = Finalizado, X = Cancelado |
| total | DECIMAL(8,2) | NÃO | 0.00 | CHECK (>= 0) | Valor total do pedido em reais |

**ON DELETE entregador:** SET NULL — se o entregador for removido, o pedido não é perdido
**ON DELETE cliente/restaurante/endereco:** RESTRICT — não permite exclusão enquanto houver pedidos vinculados

---

## Tabela: `item_pedido`

Tabela associativa que implementa o relacionamento N:N entre pedido e produto. Registra quais produtos e em quais quantidades compõem cada pedido.

| Coluna | Tipo | Nulo | Padrão | Restrição | Descrição |
|---|---|---|---|---|---|
| id_item | INT | NÃO | — | PK, AUTO_INCREMENT | Identificador único do item |
| id_pedido | INT | NÃO | — | FK → pedido | Pedido ao qual o item pertence |
| id_produto | INT | NÃO | — | FK → produto | Produto incluído no pedido |
| quantidade | INT | NÃO | — | CHECK (> 0) | Quantidade do produto no pedido |
| preco_unitario | DECIMAL(8,2) | NÃO | — | CHECK (> 0) | Preço do produto no momento do pedido |

**Relacionamento:** `pedido` (N) ↔ (N) `produto`
**Observação:** o `preco_unitario` é armazenado no momento da compra para preservar o histórico, mesmo que o preço do produto seja alterado futuramente.
**ON DELETE pedido:** CASCADE — ao cancelar/excluir um pedido, seus itens são removidos

---

## Relacionamentos — Resumo Geral

| Tabela A | Cardinalidade | Tabela B | Implementação |
|---|---|---|---|
| cliente | 1:N | endereco | FK id_cliente em endereco |
| cliente | 1:N | pedido | FK id_cliente em pedido |
| restaurante | 1:N | produto | FK id_restaurante em produto |
| restaurante | 1:N | pedido | FK id_restaurante em pedido |
| entregador | 1:N | pedido | FK id_entregador em pedido |
| endereco | 1:N | pedido | FK id_endereco em pedido |
| restaurante | N:N | categoria | Tabela associativa restaurante_categoria |
| pedido | N:N | produto | Tabela associativa item_pedido |
