# Relatório Técnico — Sistema de Delivery de Comida

## Informações do Projeto

| Campo | Descrição |
|---|---|
| **Disciplina** | Banco de Dados |
| **Curso** | Engenharia da Computação |
| **SGBD utilizado** | MySQL |
| **Data de entrega** | 02 de julho de 2026 |

---

## 1. Introdução

Este relatório descreve o desenvolvimento de um banco de dados relacional para um sistema de delivery de comida, inspirado em plataformas como iFood e Rappi. O sistema tem como objetivo gerenciar o cadastro de clientes, restaurantes, produtos, entregadores e pedidos, oferecendo uma estrutura de dados consistente, normalizada e eficiente para suportar as operações da plataforma.

O projeto foi desenvolvido utilizando MySQL como Sistema Gerenciador de Banco de Dados (SGBD), com toda a implementação realizada em SQL puro, contemplando a definição da estrutura (DDL), a inserção de dados de exemplo (DML) e a elaboração de consultas representativas.

---

## 2. Descrição do Sistema

O sistema modela uma plataforma de delivery de comida com as seguintes funcionalidades principais:

- **Cadastro de clientes** com múltiplos endereços de entrega
- **Cadastro de restaurantes** com categorias culinárias (pizza, japonesa, hamburguer, etc.)
- **Gerenciamento de cardápio** com produtos vinculados a cada restaurante
- **Registro de pedidos** com rastreamento de status (pendente, em preparo, a caminho, finalizado, cancelado)
- **Controle de entregadores** e atribuição às entregas
- **Histórico de itens** por pedido com preço registrado no momento da compra

---

## 3. Modelagem do Banco de Dados

### 3.1 Entidades e Atributos

O banco de dados é composto por 9 tabelas, cada uma representando uma entidade do domínio do sistema:

| Tabela | Descrição | Registros inseridos |
|---|---|---|
| cliente | Usuários da plataforma | 15 |
| endereco | Endereços de entrega dos clientes | 15 |
| restaurante | Estabelecimentos cadastrados | 15 |
| categoria | Tipos de culinária | 15 |
| restaurante_categoria | Associação N:N entre restaurante e categoria | 22 |
| produto | Itens do cardápio | 15 |
| entregador | Profissionais de entrega | 15 |
| pedido | Pedidos realizados | 15 |
| item_pedido | Itens que compõem cada pedido | 15 |

### 3.2 Relacionamentos

O modelo contempla os seguintes relacionamentos:

**Relacionamentos 1:N (um para muitos):**
- `cliente` → `endereco`: um cliente pode ter múltiplos endereços de entrega
- `cliente` → `pedido`: um cliente pode realizar múltiplos pedidos
- `restaurante` → `produto`: um restaurante pode ter múltiplos produtos no cardápio
- `restaurante` → `pedido`: um restaurante pode receber múltiplos pedidos
- `entregador` → `pedido`: um entregador pode realizar múltiplas entregas
- `endereco` → `pedido`: um endereço pode ser destino de múltiplos pedidos

**Relacionamentos N:N (muitos para muitos):**
- `restaurante` ↔ `categoria`: implementado pela tabela associativa `restaurante_categoria`. Um restaurante pode atuar em várias categorias culinárias, e uma categoria pode agrupar vários restaurantes.
- `pedido` ↔ `produto`: implementado pela tabela associativa `item_pedido`. Um pedido pode conter vários produtos, e um produto pode aparecer em vários pedidos.

### 3.3 Normalização

O banco de dados foi projetado respeitando as três primeiras formas normais:

- **1FN:** todas as colunas armazenam valores atômicos, sem repetição de grupos ou arrays
- **2FN:** todos os atributos não-chave dependem funcionalmente da chave primária completa de sua tabela
- **3FN:** não há dependências transitivas entre atributos não-chave

---

## 4. Restrições de Integridade

As restrições aplicadas garantem a consistência e a confiabilidade dos dados:

### Chaves primárias (PRIMARY KEY)
Todas as 9 tabelas possuem chave primária definida com `AUTO_INCREMENT`, garantindo identificadores únicos e gerados automaticamente.

### Chaves estrangeiras (FOREIGN KEY)
Todos os relacionamentos entre tabelas são implementados com chaves estrangeiras explícitas, acompanhadas das cláusulas `ON DELETE` e `ON UPDATE`:

| Relacionamento | ON DELETE | ON UPDATE |
|---|---|---|
| endereco → cliente | CASCADE | CASCADE |
| produto → restaurante | CASCADE | CASCADE |
| restaurante_categoria → restaurante | CASCADE | CASCADE |
| restaurante_categoria → categoria | CASCADE | CASCADE |
| item_pedido → pedido | CASCADE | CASCADE |
| item_pedido → produto | RESTRICT | CASCADE |
| pedido → cliente | RESTRICT | CASCADE |
| pedido → restaurante | RESTRICT | CASCADE |
| pedido → endereco | RESTRICT | CASCADE |
| pedido → entregador | SET NULL | CASCADE |

### Restrições de unicidade (UNIQUE)
- `cliente.email`: impede dois clientes com o mesmo e-mail
- `cliente.cpf`: impede duplicidade de CPF de clientes
- `restaurante.cnpj`: impede duplicidade de CNPJ de restaurantes
- `entregador.cpf`: impede duplicidade de CPF de entregadores
- `categoria.nome`: impede categorias com nomes duplicados

### Restrições de domínio (CHECK)
- `cliente.status`: somente 'A' (Ativo) ou 'I' (Inativo)
- `restaurante.status`: somente 'A' ou 'I'
- `restaurante.taxa_entrega`: valor maior ou igual a zero
- `produto.preco`: valor estritamente positivo
- `produto.disponivel`: somente 'S' (Sim) ou 'N' (Não)
- `entregador.status`: somente 'A' ou 'I'
- `pedido.status`: somente 'P', 'E', 'C', 'F' ou 'X'
- `pedido.total`: valor maior ou igual a zero
- `item_pedido.quantidade`: valor estritamente positivo
- `item_pedido.preco_unitario`: valor estritamente positivo

### Valores padrão (DEFAULT)
- `cliente.status`: 'A' (novo cliente já cadastrado como ativo)
- `restaurante.status`: 'A'
- `restaurante.taxa_entrega`: 0.00
- `produto.disponivel`: 'S'
- `entregador.status`: 'A'
- `pedido.status`: 'P' (novo pedido começa como pendente)
- `pedido.data_pedido`: CURRENT_TIMESTAMP (data e hora automáticas)
- `pedido.total`: 0.00

---

## 5. Decisões de Projeto

### Armazenamento do preço no item_pedido
O campo `preco_unitario` em `item_pedido` armazena o preço do produto no momento em que o pedido foi realizado. Essa decisão preserva o histórico financeiro correto mesmo que o preço do produto seja alterado futuramente no cardápio.

### Entregador como campo opcional no pedido
O campo `id_entregador` em `pedido` aceita valor nulo (`NULL`), pois no momento em que o pedido é criado, o entregador ainda não foi designado. A atribuição ocorre em um momento posterior, quando o pedido sai para entrega.

### CHAR vs VARCHAR
Campos com tamanho fixo e conhecido, como CPF (11 dígitos), CNPJ (14 dígitos), CEP (8 dígitos), UF (2 caracteres) e campos de status (1 caractere), foram definidos como `CHAR` para otimizar o armazenamento. Campos com tamanho variável utilizam `VARCHAR`.

### Chave primária composta em restaurante_categoria
A tabela associativa `restaurante_categoria` utiliza chave primária composta `(id_restaurante, id_categoria)`, o que impede que o mesmo restaurante seja associado à mesma categoria mais de uma vez, sem a necessidade de uma coluna `id` adicional.

---

## 6. Consultas Implementadas

Foram desenvolvidas 10 consultas SQL, sendo 5 simples e 5 com JOIN, conforme detalhado no arquivo `consultas.sql`:

| Consulta | Tipo | Descrição |
|---|---|---|
| 1 | Simples | Clientes ativos em ordem alfabética |
| 2 | Simples | Restaurantes com taxa de entrega abaixo de R$ 5,00 |
| 3 | Simples | Contagem de pedidos por status |
| 4 | Simples | Produtos disponíveis em faixa de preço |
| 5 | Simples | Entregadores ativos por tipo de veículo |
| 6 | JOIN (3 tabelas) | Pedidos com nome do cliente e do restaurante |
| 7 | JOIN (3 tabelas) | Itens de cada pedido com valor calculado |
| 8 | JOIN (3 tabelas) | Categorias de cada restaurante ativo |
| 9 | JOIN (2 tabelas) | Ranking de clientes por valor gasto |
| 10 | JOIN (5 tabelas) | Relatório completo das entregas finalizadas |

---

## 7. Estrutura do Repositório

```
sistema-delivery-bd/
├── schema.sql              → DDL: criação do banco e das tabelas
├── dados.sql               → DML: inserção dos dados de exemplo
├── consultas.sql           → 10 consultas SQL comentadas
├── dicionario_de_dados.md  → Descrição detalhada de tabelas e colunas
├── relatorio.md            → Este relatório técnico
├── der.png                 → Diagrama Entidade-Relacionamento
└── README.md               → Visão geral do projeto
```

---

## 8. Conclusão

O banco de dados desenvolvido atende a todos os requisitos do projeto, contemplando 9 tabelas inter-relacionadas em 3ª Forma Normal, dois relacionamentos N:N implementados por tabelas associativas, restrições de integridade completas e 10 consultas SQL representativas do domínio do sistema. A escolha do tema de delivery de comida permitiu modelar um cenário próximo à realidade, com entidades e relacionamentos naturais e facilmente compreensíveis.
