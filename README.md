# 🍔 Sistema de Delivery de Comida — Banco de Dados

Projeto Final da disciplina de **Banco de Dados** do curso de Engenharia da Computação.

O sistema modela uma plataforma de delivery de comida, inspirada em aplicativos como iFood e Rappi, gerenciando clientes, restaurantes, cardápios, pedidos e entregadores.

\---

## 👥 Integrantes

|Nome|Matrícula|
|-|-|
|Daniel Pena Rocha|057387|
|Vinícius Neres|082803|

\---

## 🗂️ Estrutura do Repositório

```
sistema-delivery-bd/
├── schema.sql              → DDL: criação do banco e das tabelas
├── dados.sql               → DML: inserção dos dados de exemplo
├── consultas.sql           → 10 consultas SQL comentadas
├── dicionario\\\_de\\\_dados.md  → Descrição detalhada de tabelas e colunas
├── relatorio.md            → Relatório técnico completo do projeto
├── der.png                 → Diagrama Entidade-Relacionamento
└── README.md               → Este arquivo
```

\---

## 🗃️ Banco de Dados

* **SGBD:** MySQL
* **Nome do banco:** `delivery\\\_db`
* **Total de tabelas:** 9
* **Registros por tabela:** 15

### Tabelas

|Tabela|Descrição|
|-|-|
|`cliente`|Usuários cadastrados na plataforma|
|`endereco`|Endereços de entrega vinculados aos clientes|
|`restaurante`|Estabelecimentos cadastrados|
|`categoria`|Tipos de culinária disponíveis|
|`restaurante\\\_categoria`|Relacionamento N:N entre restaurante e categoria|
|`produto`|Itens do cardápio de cada restaurante|
|`entregador`|Profissionais responsáveis pelas entregas|
|`pedido`|Pedidos realizados pelos clientes|
|`item\\\_pedido`|Relacionamento N:N entre pedido e produto|

\---

## ▶️ Como executar

### Pré-requisitos

* MySQL instalado (versão 8.0 ou superior recomendada)
* Cliente MySQL: MySQL Workbench, DBeaver ou terminal

### Passo a passo

1. Clone este repositório:

```bash
git clone https://github.com/Danielpr614/sistema-delivery-bd.git
```

2. Acesse o diretório:

```bash
cd sistema-delivery-bd
```

3. Execute o script de criação do banco:

```bash
mysql -u root -p < schema.sql
```

4. Execute o script de inserção dos dados:

```bash
mysql -u root -p < dados.sql
```

5. Execute as consultas:

```bash
mysql -u root -p delivery\\\_db < consultas.sql
```

> Ou abra os arquivos `.sql` diretamente no MySQL Workbench e execute na ordem: `schema.sql` → `dados.sql` → `consultas.sql`

\---

## 📊 Diagrama Entidade-Relacionamento

!\[Diagrama ER](der.png)

\---

## 📋 Consultas implementadas

|#|Tipo|Descrição|
|-|-|-|
|1|Simples|Clientes ativos em ordem alfabética|
|2|Simples|Restaurantes com taxa de entrega abaixo de R$ 5,00|
|3|Simples|Contagem de pedidos por status|
|4|Simples|Produtos disponíveis em faixa de preço|
|5|Simples|Entregadores ativos por tipo de veículo|
|6|JOIN (3 tabelas)|Pedidos com nome do cliente e do restaurante|
|7|JOIN (3 tabelas)|Itens de cada pedido com valor calculado|
|8|JOIN (3 tabelas)|Categorias de cada restaurante ativo|
|9|JOIN (2 tabelas)|Ranking de clientes por valor gasto|
|10|JOIN (5 tabelas)|Relatório completo das entregas finalizadas|



