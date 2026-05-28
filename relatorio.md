# Sistema de Gerenciamento de Delivery de Comida

## Relatório Técnico — Projeto Final de Banco de Dados

\---

**Título:** Sistema de Gerenciamento de Delivery de Comida  
**Disciplina:** Banco de Dados  
**Curso:** Engenharia da Computação  
**Semestre:** 2026.1  
**Integrantes:**

|Nome|Matrícula|
|-|-|
|Daniel Pena Rocha|057387|
|Vinícius Neres|082803|

\---

## 1\. Resumo Executivo

O presente projeto consiste no desenvolvimento de um banco de dados relacional para um sistema de delivery de comida, inspirado em plataformas como iFood e Rappi. O sistema é responsável por gerenciar o cadastro de clientes e seus endereços de entrega, restaurantes e seus cardápios, categorias culinárias, entregadores e o ciclo completo de pedidos, desde a realização até a entrega. Toda a modelagem foi implementada em MySQL, seguindo os princípios de integridade referencial, normalização até a Terceira Forma Normal e boas práticas de projeto de banco de dados relacional.

A solução contempla nove tabelas inter-relacionadas, dois relacionamentos muitos-para-muitos implementados por tabelas associativas, restrições de domínio, unicidade e integridade referencial completas, além de quinze registros de exemplo por tabela e dez consultas SQL representativas do domínio da aplicação. O repositório do projeto está disponível publicamente no GitHub, contendo todos os scripts, o diagrama entidade-relacionamento, o dicionário de dados e este relatório.

\---

## 2\. Domínio e Regras de Negócio

### 2.1 Descrição do Domínio

O sistema modela uma plataforma digital de delivery de comida que conecta clientes, restaurantes e entregadores. Um cliente acessa a plataforma, escolhe um restaurante, seleciona produtos do cardápio, informa o endereço de entrega e realiza o pedido. O sistema registra o pedido, atribui um entregador disponível e acompanha o status da entrega até a finalização.

### 2.2 Entidades Principais

* **Cliente:** usuário cadastrado na plataforma que realiza pedidos.
* **Endereço:** localização de entrega vinculada a um cliente. Um cliente pode ter múltiplos endereços cadastrados.
* **Restaurante:** estabelecimento parceiro cadastrado na plataforma, com cardápio próprio.
* **Categoria:** tipo de culinária que classifica os restaurantes (ex: Pizza, Japonesa, Hamburguer).
* **Produto:** item do cardápio de um restaurante, com nome, descrição, preço e disponibilidade.
* **Entregador:** profissional responsável por realizar as entregas dos pedidos.
* **Pedido:** registro da transação realizada por um cliente em um restaurante.
* **Item do Pedido:** composição detalhada de um pedido, listando produtos e quantidades.

### 2.3 Regras de Negócio

1. Um cliente pode ter um ou mais endereços de entrega cadastrados.
2. Um cliente pode realizar múltiplos pedidos ao longo do tempo.
3. Um restaurante pode pertencer a uma ou mais categorias culinárias, e uma categoria pode agrupar múltiplos restaurantes.
4. Um restaurante pode ter múltiplos produtos em seu cardápio.
5. Um pedido pertence a exatamente um cliente e a exatamente um restaurante.
6. Um pedido pode conter um ou mais produtos, com quantidades variadas — implementado pela tabela associativa `item\_pedido`.
7. O preço do produto é registrado no momento do pedido, preservando o histórico financeiro mesmo que o preço seja alterado futuramente.
8. Um entregador é atribuído ao pedido após sua confirmação; até esse momento, o campo pode ser nulo.
9. O status do pedido evolui sequencialmente: Pendente → Em preparo → A caminho → Finalizado. Um pedido pode ser Cancelado a qualquer momento antes da finalização.
10. Não é permitido excluir um cliente, restaurante ou endereço que possua pedidos vinculados.

\---

## 3\. Diagrama Entidade-Relacionamento

!\[Diagrama Entidade-Relacionamento](der.png)

**Legenda:**

* Retângulos representam as entidades (tabelas) do sistema.
* As linhas conectando as entidades representam os relacionamentos.
* A notação nas extremidades das linhas indica a cardinalidade: `|` para "um" e `<` para "muitos".
* As colunas marcadas com **PK** indicam chave primária e as marcadas com **FK** indicam chave estrangeira.
* As tabelas `restaurante\_categoria` e `item\_pedido` são tabelas associativas que implementam os relacionamentos muitos-para-muitos.

\---

## 4\. Dicionário de Dados

### Tabela: `cliente`

Armazena os usuários cadastrados na plataforma.

|Atributo|Tipo|Restrições|Descrição|
|-|-|-|-|
|id\_cliente|INT|PK, NOT NULL, AUTO\_INCREMENT|Identificador único do cliente|
|nome|VARCHAR(120)|NOT NULL|Nome completo do cliente|
|email|VARCHAR(120)|NOT NULL, UNIQUE|E-mail de acesso à plataforma|
|cpf|CHAR(11)|NOT NULL, UNIQUE|CPF do cliente (somente dígitos)|
|telefone|VARCHAR(20)|NOT NULL|Telefone de contato|
|status|CHAR(1)|NOT NULL, DEFAULT 'A', CHECK (A, I)|A = Ativo, I = Inativo|

\---

### Tabela: `endereco`

Endereços de entrega vinculados aos clientes.

|Atributo|Tipo|Restrições|Descrição|
|-|-|-|-|
|id\_endereco|INT|PK, NOT NULL, AUTO\_INCREMENT|Identificador único do endereço|
|id\_cliente|INT|FK → cliente, NOT NULL|Cliente proprietário do endereço|
|logradouro|VARCHAR(150)|NOT NULL|Nome da rua ou avenida|
|numero|VARCHAR(10)|NOT NULL|Número do imóvel|
|bairro|VARCHAR(80)|NOT NULL|Bairro do endereço|
|cidade|VARCHAR(80)|NOT NULL|Cidade do endereço|
|uf|CHAR(2)|NOT NULL|Sigla do estado|
|cep|CHAR(8)|NOT NULL|CEP sem hífen|

\---

### Tabela: `restaurante`

Estabelecimentos parceiros cadastrados na plataforma.

|Atributo|Tipo|Restrições|Descrição|
|-|-|-|-|
|id\_restaurante|INT|PK, NOT NULL, AUTO\_INCREMENT|Identificador único do restaurante|
|nome|VARCHAR(120)|NOT NULL|Nome do estabelecimento|
|cnpj|CHAR(14)|NOT NULL, UNIQUE|CNPJ sem pontuação|
|telefone|VARCHAR(20)|NOT NULL|Telefone de contato|
|status|CHAR(1)|NOT NULL, DEFAULT 'A', CHECK (A, I)|A = Ativo, I = Inativo|
|taxa\_entrega|DECIMAL(5,2)|NOT NULL, DEFAULT 0.00, CHECK (>= 0)|Taxa de entrega em reais|

\---

### Tabela: `categoria`

Tipos de culinária disponíveis na plataforma.

|Atributo|Tipo|Restrições|Descrição|
|-|-|-|-|
|id\_categoria|INT|PK, NOT NULL, AUTO\_INCREMENT|Identificador único da categoria|
|nome|VARCHAR(60)|NOT NULL, UNIQUE|Nome da categoria culinária|
|descricao|VARCHAR(200)|NOT NULL|Descrição breve da categoria|

\---

### Tabela: `restaurante\_categoria`

Tabela associativa do relacionamento N:N entre restaurante e categoria.

|Atributo|Tipo|Restrições|Descrição|
|-|-|-|-|
|id\_restaurante|INT|FK → restaurante, NOT NULL|Referência ao restaurante|
|id\_categoria|INT|FK → categoria, NOT NULL|Referência à categoria|

**Chave primária composta:** (id\_restaurante, id\_categoria)

\---

### Tabela: `produto`

Itens do cardápio de cada restaurante.

|Atributo|Tipo|Restrições|Descrição|
|-|-|-|-|
|id\_produto|INT|PK, NOT NULL, AUTO\_INCREMENT|Identificador único do produto|
|id\_restaurante|INT|FK → restaurante, NOT NULL|Restaurante ao qual pertence|
|nome|VARCHAR(100)|NOT NULL|Nome do produto|
|descricao|TEXT|—|Descrição detalhada do produto|
|preco|DECIMAL(8,2)|NOT NULL, CHECK (> 0)|Preço unitário em reais|
|disponivel|CHAR(1)|NOT NULL, DEFAULT 'S', CHECK (S, N)|S = Disponível, N = Indisponível|

\---

### Tabela: `entregador`

Profissionais responsáveis pelas entregas.

|Atributo|Tipo|Restrições|Descrição|
|-|-|-|-|
|id\_entregador|INT|PK, NOT NULL, AUTO\_INCREMENT|Identificador único do entregador|
|nome|VARCHAR(120)|NOT NULL|Nome completo do entregador|
|cpf|CHAR(11)|NOT NULL, UNIQUE|CPF do entregador (somente dígitos)|
|veiculo|VARCHAR(30)|NOT NULL|Tipo de veículo utilizado|
|status|CHAR(1)|NOT NULL, DEFAULT 'A', CHECK (A, I)|A = Ativo, I = Inativo|

\---

### Tabela: `pedido`

Pedidos realizados pelos clientes na plataforma.

|Atributo|Tipo|Restrições|Descrição|
|-|-|-|-|
|id\_pedido|INT|PK, NOT NULL, AUTO\_INCREMENT|Identificador único do pedido|
|id\_cliente|INT|FK → cliente, NOT NULL|Cliente que realizou o pedido|
|id\_restaurante|INT|FK → restaurante, NOT NULL|Restaurante do pedido|
|id\_endereco|INT|FK → endereco, NOT NULL|Endereço de entrega selecionado|
|id\_entregador|INT|FK → entregador, NULL|Entregador designado|
|data\_pedido|DATETIME|NOT NULL, DEFAULT CURRENT\_TIMESTAMP|Data e hora do pedido|
|status|CHAR(1)|NOT NULL, DEFAULT 'P', CHECK (P,E,C,F,X)|P=Pendente, E=Em preparo, C=A caminho, F=Finalizado, X=Cancelado|
|total|DECIMAL(8,2)|NOT NULL, DEFAULT 0.00, CHECK (>= 0)|Valor total do pedido em reais|

\---

### Tabela: `item\_pedido`

Tabela associativa do relacionamento N:N entre pedido e produto.

|Atributo|Tipo|Restrições|Descrição|
|-|-|-|-|
|id\_item|INT|PK, NOT NULL, AUTO\_INCREMENT|Identificador único do item|
|id\_pedido|INT|FK → pedido, NOT NULL|Pedido ao qual o item pertence|
|id\_produto|INT|FK → produto, NOT NULL|Produto incluído no pedido|
|quantidade|INT|NOT NULL, CHECK (> 0)|Quantidade do produto|
|preco\_unitario|DECIMAL(8,2)|NOT NULL, CHECK (> 0)|Preço do produto no momento da compra|

\---

## 5\. Justificativa da Normalização

O banco de dados foi projetado em conformidade com as três primeiras formas normais, conforme descrito a seguir.

### Primeira Forma Normal (1FN)

Uma relação está na 1FN quando todos os seus atributos contêm apenas valores atômicos, sem grupos repetitivos ou atributos multivalorados.

No modelo desenvolvido, todos os atributos armazenam um único valor por célula. Por exemplo, um cliente pode ter múltiplos endereços de entrega, mas esses endereços não foram armazenados como uma lista dentro da tabela `cliente`. Em vez disso, foi criada uma tabela separada `endereco` com uma chave estrangeira `id\_cliente`, garantindo a atomicidade dos dados.

### Segunda Forma Normal (2FN)

Uma relação está na 2FN quando está na 1FN e todos os atributos não-chave dependem funcionalmente da chave primária completa.

A 2FN é especialmente relevante em tabelas com chave primária composta. Tome como exemplo a tabela `item\_pedido`, cuja chave primária é composta por `(id\_pedido, id\_produto)`. Os atributos `quantidade` e `preco\_unitario` dependem da combinação completa das duas chaves, e não apenas de uma delas isoladamente. Não há dependências parciais no modelo.

**Exemplo de decomposição:** se o nome do produto fosse armazenado diretamente em `item\_pedido`, haveria dependência parcial, pois o nome depende apenas de `id\_produto`, não do par `(id\_pedido, id\_produto)`. Por isso, o nome do produto permanece exclusivamente na tabela `produto`, sendo acessado via JOIN quando necessário.

### Terceira Forma Normal (3FN)

Uma relação está na 3FN quando está na 2FN e não existem dependências transitivas entre atributos não-chave.

No modelo desenvolvido, nenhum atributo não-chave depende de outro atributo não-chave. Por exemplo, na tabela `pedido`, o campo `total` representa o valor total do pedido e não é calculado a partir de outros atributos da mesma tabela, como `quantidade` ou `preco\_unitario`, que pertencem à tabela `item\_pedido`. Essa separação elimina qualquer dependência transitiva.

\---

## 6\. Catálogo de Consultas

### Consulta 1 — Clientes ativos em ordem alfabética

**Descrição:** lista todos os clientes com status ativo, exibindo nome, e-mail e telefone, ordenados alfabeticamente pelo nome.

```sql
SELECT
  nome,
  email,
  telefone
FROM cliente
WHERE status = 'A'
ORDER BY nome ASC;
```

**Saída esperada:**

|nome|email|telefone|
|-|-|-|
|Ana Paula Souza|ana.souza@email.com|(11) 91234-5678|
|Bruno Lima|bruno.lima@email.com|(21) 92345-6789|
|Carla Mendes|carla.mendes@email.com|(31) 93456-7890|
|...|...|...|

\---

### Consulta 2 — Restaurantes com taxa de entrega abaixo de R$ 5,00

**Descrição:** retorna os restaurantes ativos cuja taxa de entrega é inferior a R$ 5,00, ordenados do mais barato ao mais caro.

```sql
SELECT
  nome,
  telefone,
  taxa\_entrega
FROM restaurante
WHERE taxa\_entrega < 5.00
  AND status = 'A'
ORDER BY taxa\_entrega ASC;
```

**Saída esperada:**

|nome|telefone|taxa\_entrega|
|-|-|-|
|Padaria Pão Quente|(71) 3333-7777|2.99|
|Tapioca \& Coco|(31) 4444-3333|3.00|
|Açaí do Norte|(21) 4444-2222|3.50|
|...|...|...|

\---

### Consulta 3 — Contagem de pedidos por status

**Descrição:** agrupa os pedidos pelo campo status e conta quantos pedidos existem em cada situação.

```sql
SELECT
  status,
  COUNT(\*) AS quantidade
FROM pedido
GROUP BY status
ORDER BY quantidade DESC;
```

**Saída esperada:**

|status|quantidade|
|-|-|
|F|11|
|P|1|
|E|1|
|X|1|

\---

### Consulta 4 — Produtos disponíveis em faixa de preço

**Descrição:** lista os produtos disponíveis com preço entre R$ 10,00 e R$ 50,00, ordenados pelo preço.

```sql
SELECT
  nome,
  descricao,
  preco
FROM produto
WHERE disponivel = 'S'
  AND preco BETWEEN 10.00 AND 50.00
ORDER BY preco ASC;
```

**Saída esperada:**

|nome|descricao|preco|
|-|-|-|
|Taco de Carne|Tortilha crocante, carne moída...|18.90|
|Açaí 500ml|Açaí batido com guaraná...|22.90|
|Temaki Salmão|Temaki recheado com salmão...|24.90|
|...|...|...|

\---

### Consulta 5 — Entregadores ativos por tipo de veículo

**Descrição:** lista os entregadores com status ativo, ordenados pelo tipo de veículo e depois pelo nome.

```sql
SELECT
  nome,
  veiculo,
  status
FROM entregador
WHERE status = 'A'
ORDER BY veiculo, nome;
```

**Saída esperada:**

|nome|veiculo|status|
|-|-|-|
|Fábio Augusto Lima|Bicicleta|A|
|Leonardo Dias Freitas|Bicicleta|A|
|Igor Souza Machado|Carro|A|
|...|...|...|

\---

### Consulta 6 — Pedidos com nome do cliente e do restaurante

**Descrição:** lista todos os pedidos exibindo o nome do cliente e do restaurante envolvidos, ordenados pela data mais recente. Envolve três tabelas: `pedido`, `cliente` e `restaurante`.

```sql
SELECT
  p.id\_pedido,
  c.nome        AS cliente,
  r.nome        AS restaurante,
  p.data\_pedido,
  p.status,
  p.total
FROM pedido p
INNER JOIN cliente     c ON c.id\_cliente     = p.id\_cliente
INNER JOIN restaurante r ON r.id\_restaurante = p.id\_restaurante
ORDER BY p.data\_pedido DESC;
```

**Saída esperada:**

|id\_pedido|cliente|restaurante|data\_pedido|status|total|
|-|-|-|-|-|-|
|15|Patrícia Gomes|Hamburgueria Artesanal|2025-01-24 21:00:00|P|53.90|
|14|Otávio Ribeiro|Burger House|2025-01-23 20:15:00|E|47.89|
|...|...|...|...|...|...|

\---

### Consulta 7 — Itens de cada pedido com valor total do item

**Descrição:** detalha a composição de cada pedido, exibindo o produto, a quantidade e o valor total do item (quantidade × preço unitário). Envolve três tabelas: `item\_pedido`, `pedido` e `produto`.

```sql
SELECT
  ip.id\_pedido,
  pr.nome                             AS produto,
  ip.quantidade,
  ip.preco\_unitario,
  (ip.quantidade \* ip.preco\_unitario) AS valor\_total\_item
FROM item\_pedido ip
INNER JOIN pedido  p  ON p.id\_pedido   = ip.id\_pedido
INNER JOIN produto pr ON pr.id\_produto = ip.id\_produto
ORDER BY ip.id\_pedido, pr.nome;
```

**Saída esperada:**

|id\_pedido|produto|quantidade|preco\_unitario|valor\_total\_item|
|-|-|-|-|-|
|1|Pizza Margherita|1|39.90|39.90|
|2|Combo Sushi 20 peças|1|59.90|59.90|
|4|Coxinha Frango|5|5.50|27.50|
|...|...|...|...|...|

\---

### Consulta 8 — Categorias de cada restaurante ativo

**Descrição:** lista as categorias culinárias de cada restaurante ativo. Demonstra a navegação pelo relacionamento N:N entre restaurante e categoria. Envolve três tabelas: `restaurante`, `restaurante\_categoria` e `categoria`.

```sql
SELECT
  r.nome  AS restaurante,
  c.nome  AS categoria
FROM restaurante r
INNER JOIN restaurante\_categoria rc ON rc.id\_restaurante = r.id\_restaurante
INNER JOIN categoria             c  ON c.id\_categoria    = rc.id\_categoria
WHERE r.status = 'A'
ORDER BY r.nome, c.nome;
```

**Saída esperada:**

|restaurante|categoria|
|-|-|
|Açaí do Norte|Açaí|
|Bistrô da Praça|Italiana|
|Bistrô da Praça|Saudável|
|Burger House|Artesanal|
|Burger House|Hamburguer|
|...|...|

\---

### Consulta 9 — Ranking de clientes por valor gasto

**Descrição:** identifica os clientes que mais gastaram na plataforma considerando apenas pedidos finalizados, exibindo o total de pedidos e o valor acumulado. Envolve duas tabelas: `cliente` e `pedido`.

```sql
SELECT
  c.nome                  AS cliente,
  COUNT(p.id\_pedido)      AS total\_pedidos,
  SUM(p.total)            AS valor\_total\_gasto
FROM cliente c
INNER JOIN pedido p ON p.id\_cliente = c.id\_cliente
WHERE p.status = 'F'
GROUP BY c.id\_cliente, c.nome
ORDER BY valor\_total\_gasto DESC;
```

**Saída esperada:**

|cliente|total\_pedidos|valor\_total\_gasto|
|-|-|-|
|Henrique Barbosa|1|78.89|
|Natália Carvalho|1|84.80|
|João Pedro Martins|1|78.89|
|...|...|...|

\---

### Consulta 10 — Relatório completo das entregas finalizadas

**Descrição:** gera um relatório completo das entregas finalizadas, reunindo informações de cliente, restaurante, entregador e endereço de entrega em uma única consulta. Envolve cinco tabelas: `pedido`, `cliente`, `restaurante`, `entregador` e `endereco`.

```sql
SELECT
  p.id\_pedido,
  c.nome                                         AS cliente,
  r.nome                                         AS restaurante,
  e.nome                                         AS entregador,
  e.veiculo,
  CONCAT(en.logradouro, ', ', en.numero, ' - ',
         en.bairro, ', ', en.cidade,'/', en.uf)  AS endereco\_entrega,
  p.data\_pedido,
  p.total
FROM pedido p
INNER JOIN cliente     c  ON c.id\_cliente     = p.id\_cliente
INNER JOIN restaurante r  ON r.id\_restaurante = p.id\_restaurante
INNER JOIN entregador  e  ON e.id\_entregador  = p.id\_entregador
INNER JOIN endereco    en ON en.id\_endereco   = p.id\_endereco
WHERE p.status = 'F'
ORDER BY p.data\_pedido DESC;
```

**Saída esperada:**

|id\_pedido|cliente|restaurante|entregador|veiculo|endereco\_entrega|data\_pedido|total|
|-|-|-|-|-|-|-|-|
|11|Larissa Oliveira|Açaí do Norte|Thiago Borges Cunha|Moto|Rua Oscar Freire, 852 - Jardins, São Paulo/SP|2025-01-20 15:30:00|26.40|
|10|João Pedro Martins|Churrascaria Gaúcha|Samuel Costa Moraes|Bicicleta|Rua 24 de Outubro, 741 - Moinhos de Vento, Porto Alegre/RS|2025-01-19 21:00:00|78.89|
|...|...|...|...|...|...|...|...|

\---

## 7\. Instruções de Execução

### Pré-requisitos

* MySQL instalado (versão 8.0 ou superior)
* MySQL Workbench ou outro cliente MySQL de sua preferência

### Passo a passo no MySQL Workbench

1. Abra o **MySQL Workbench** e conecte-se à instância local clicando em **Local instance MySQL**
2. No menu superior, acesse **File → Open SQL Script**
3. Selecione o arquivo `schema.sql` e clique em **Abrir**
4. Execute o script pressionando **Ctrl + Shift + Enter** ou clicando no ícone de raio
5. Repita os passos 2 a 4 para o arquivo `dados.sql`
6. Repita os passos 2 a 4 para o arquivo `consultas.sql`

### Passo a passo via terminal

```bash
# 1. Criar o banco e as tabelas
mysql -u root -p < schema.sql

# 2. Inserir os dados de exemplo
mysql -u root -p < dados.sql

# 3. Executar as consultas
mysql -u root -p delivery\_db < consultas.sql
```

### Verificação

Após a execução, para confirmar que o banco foi criado corretamente, execute no MySQL Workbench:

```sql
USE delivery\_db;
SHOW TABLES;
SELECT COUNT(\*) FROM cliente;
```

O resultado deverá exibir as 9 tabelas e 15 registros na tabela `cliente`.

\---

## 8\. Considerações Finais

### Dificuldades encontradas

Durante o desenvolvimento do projeto, a principal dificuldade foi a definição correta das políticas de exclusão (`ON DELETE`) para cada chave estrangeira. Foi necessário analisar caso a caso o impacto de uma exclusão em cascata versus uma restrição, de modo a garantir a integridade dos dados sem comprometer a flexibilidade do sistema. Por exemplo, a exclusão de um entregador não deve apagar os pedidos associados a ele, razão pela qual foi utilizado `ON DELETE SET NULL` nessa relação.

Outra dificuldade foi a modelagem do relacionamento entre pedido e produto, que exigiu a criação da tabela associativa `item\_pedido` com atributos próprios, como `quantidade` e `preco\_unitario`, tornando o relacionamento mais rico e próximo da realidade de uma plataforma de delivery.

### Decisões de projeto

* O campo `preco\_unitario` em `item\_pedido` foi incluído para preservar o histórico de preços no momento da compra, independentemente de alterações futuras no cardápio.
* O campo `id\_entregador` em `pedido` aceita valor nulo, pois o entregador é atribuído apenas após a confirmação do pedido.
* Campos com tamanho fixo e conhecido, como CPF, CNPJ, CEP e UF, foram definidos como `CHAR` para otimizar o armazenamento interno do MySQL.
* A chave primária de `restaurante\_categoria` foi definida como composta por `(id\_restaurante, id\_categoria)`, eliminando a necessidade de uma coluna de identificação adicional e garantindo a unicidade da associação naturalmente.

### Possíveis evoluções

* Implementação de um sistema de avaliações, permitindo que clientes avaliem restaurantes e entregadores após a conclusão do pedido.
* Inclusão de uma tabela de cupons de desconto, com regras de validade e percentual de desconto aplicável por pedido.
* Adição de um histórico de status do pedido, registrando cada transição de estado com data e hora para fins de rastreabilidade.
* Implementação de uma tabela de formas de pagamento, associando cada pedido ao método utilizado pelo cliente.

\---

## 9\. Referências Bibliográficas

ELMASRI, R.; NAVATHE, S. B. **Sistemas de banco de dados**. 7. ed. São Paulo: Pearson, 2019.

HEUSER, C. A. **Projeto de banco de dados**. 6. ed. Porto Alegre: Bookman, 2009.

DATE, C. J. **Introdução a sistemas de banco de dados**. 8. ed. Rio de Janeiro: Elsevier, 2004.

MySQL. **MySQL 8.0 Reference Manual**. Oracle Corporation, 2024. Disponível em: https://dev.mysql.com/doc/refman/8.0/en/. Acesso em: maio 2026.

SILBERSCHATZ, A.; KORTH, H. F.; SUDARSHAN, S. **Sistema de banco de dados**. 6. ed. Rio de Janeiro: Elsevier, 2012.

