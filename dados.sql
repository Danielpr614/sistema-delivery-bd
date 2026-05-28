-- =============================================================
--  SISTEMA DE DELIVERY DE COMIDA
--  Disciplina: Banco de Dados
--  Arquivo: dados.sql (DML - Data Manipulation Language)
--  Descrição: Inserção de dados de exemplo em todas as tabelas
-- =============================================================

USE delivery_db;

-- =============================================================
--  CLIENTES (15 registros)
-- =============================================================
INSERT INTO cliente (nome, email, cpf, telefone, status) VALUES
  ('Ana Paula Souza',       'ana.souza@email.com',      '11122233344', '(11) 91234-5678', 'A'),
  ('Bruno Lima',            'bruno.lima@email.com',     '22233344455', '(21) 92345-6789', 'A'),
  ('Carla Mendes',          'carla.mendes@email.com',   '33344455566', '(31) 93456-7890', 'A'),
  ('Diego Ferreira',        'diego.ferreira@email.com', '44455566677', '(41) 94567-8901', 'A'),
  ('Eduarda Costa',         'eduarda.costa@email.com',  '55566677788', '(51) 95678-9012', 'A'),
  ('Felipe Alves',          'felipe.alves@email.com',   '66677788899', '(61) 96789-0123', 'A'),
  ('Gabriela Rocha',        'gabriela.rocha@email.com', '77788899900', '(71) 97890-1234', 'A'),
  ('Henrique Barbosa',      'henrique.b@email.com',     '88899900011', '(81) 98901-2345', 'A'),
  ('Isabela Nunes',         'isabela.nunes@email.com',  '99900011122', '(91) 99012-3456', 'A'),
  ('João Pedro Martins',    'joao.martins@email.com',   '10011122233', '(11) 90123-4567', 'A'),
  ('Larissa Oliveira',      'larissa.oli@email.com',    '11122233345', '(21) 91234-5679', 'A'),
  ('Marcos Vinícius Silva', 'marcos.silva@email.com',   '22233344456', '(31) 92345-6780', 'I'),
  ('Natália Carvalho',      'natalia.c@email.com',      '33344455567', '(41) 93456-7891', 'A'),
  ('Otávio Ribeiro',        'otavio.r@email.com',       '44455566678', '(51) 94567-8902', 'A'),
  ('Patrícia Gomes',        'patricia.g@email.com',     '55566677789', '(61) 95678-9013', 'A');

-- =============================================================
--  ENDEREÇOS (15 registros, distribuídos entre os clientes)
-- =============================================================
INSERT INTO endereco (id_cliente, logradouro, numero, bairro, cidade, uf, cep) VALUES
  (1,  'Rua das Flores',        '123',  'Centro',        'São Paulo',       'SP', '01310100'),
  (2,  'Av. Atlântica',         '456',  'Copacabana',    'Rio de Janeiro',  'RJ', '22010000'),
  (3,  'Rua da Bahia',          '789',  'Lourdes',       'Belo Horizonte',  'MG', '30160010'),
  (4,  'Av. Sete de Setembro',  '321',  'Centro',        'Curitiba',        'PR', '80230010'),
  (5,  'Rua dos Andradas',      '654',  'Centro Histórico', 'Porto Alegre', 'RS', '90020000'),
  (6,  'Rua do Recife',         '987',  'Boa Viagem',    'Recife',          'PE', '51020010'),
  (7,  'Av. Tancredo Neves',    '147',  'Caminho das Árvores', 'Salvador',  'BA', '41820020'),
  (8,  'Rua Grande',            '258',  'Centro',        'São Luís',        'MA', '65010000'),
  (9,  'Av. Getúlio Vargas',    '369',  'Centro',        'Manaus',          'AM', '69020020'),
  (10, 'Rua 24 de Outubro',     '741',  'Moinhos de Vento', 'Porto Alegre', 'RS', '90510000'),
  (11, 'Rua Oscar Freire',      '852',  'Jardins',       'São Paulo',       'SP', '01426001'),
  (12, 'Av. Paulista',          '963',  'Bela Vista',    'São Paulo',       'SP', '01310100'),
  (13, 'Rua XV de Novembro',    '111',  'Centro',        'Florianópolis',   'SC', '88010400'),
  (14, 'Av. Beira Mar',         '222',  'Centro',        'Fortaleza',       'CE', '60165121'),
  (15, 'Rua do Sol',            '333',  'Centro',        'Natal',           'RN', '59025040');

-- =============================================================
--  RESTAURANTES (15 registros)
-- =============================================================
INSERT INTO restaurante (nome, cnpj, telefone, status, taxa_entrega) VALUES
  ('Pizza Bella',           '11222333000181', '(11) 3333-1111', 'A', 5.99),
  ('Sushi Nakamura',        '22333444000192', '(21) 3333-2222', 'A', 7.99),
  ('Burger House',          '33444555000103', '(31) 3333-3333', 'A', 4.99),
  ('Coxinha da Vovó',       '44555666000114', '(41) 3333-4444', 'A', 3.99),
  ('Taco & Cia',            '55666777000125', '(51) 3333-5555', 'A', 6.99),
  ('Frango Assado Real',    '66777888000136', '(61) 3333-6666', 'A', 4.50),
  ('Padaria Pão Quente',    '77888999000147', '(71) 3333-7777', 'A', 2.99),
  ('Cantina Italiana',      '88999000000158', '(81) 3333-8888', 'A', 6.50),
  ('Sabor Natural',         '99000111000169', '(91) 3333-9999', 'A', 5.00),
  ('Churrascaria Gaúcha',   '10111222000170', '(11) 4444-1111', 'A', 8.99),
  ('Açaí do Norte',         '11222333000182', '(21) 4444-2222', 'A', 3.50),
  ('Tapioca & Coco',        '22333444000193', '(31) 4444-3333', 'A', 3.00),
  ('Temakeria Boa',         '33444555000104', '(41) 4444-4444', 'I', 7.50),
  ('Hamburgueria Artesanal','44555666000115', '(51) 4444-5555', 'A', 5.50),
  ('Bistrô da Praça',       '55666777000126', '(61) 4444-6666', 'A', 6.00);

-- =============================================================
--  CATEGORIAS (15 registros)
-- =============================================================
INSERT INTO categoria (nome, descricao) VALUES
  ('Pizza',         'Pizzas tradicionais, especiais e doces'),
  ('Japonesa',      'Sushi, sashimi, temaki e pratos quentes japoneses'),
  ('Hamburguer',    'Burgers artesanais, smash burgers e combos'),
  ('Salgados',      'Coxinhas, pastéis, esfihas e salgados variados'),
  ('Mexicana',      'Tacos, burritos, quesadillas e nachos'),
  ('Frango',        'Frango grelhado, assado, frito e à milanesa'),
  ('Padaria',       'Pães, bolos, lanches e café da manhã'),
  ('Italiana',      'Massas, risotos e pratos italianos tradicionais'),
  ('Saudável',      'Saladas, sucos naturais, bowls e pratos veganos'),
  ('Churrasco',     'Carnes na brasa, espetinhos e acompanhamentos'),
  ('Açaí',         'Açaí na tigela, no copo e combinações tropicais'),
  ('Tapioca',       'Tapiocas doces e salgadas com recheios variados'),
  ('Temaki',        'Temakis tradicionais e especiais da casa'),
  ('Artesanal',     'Produtos artesanais, craft e receitas exclusivas'),
  ('Café',          'Cafés especiais, cappuccinos e bebidas quentes');

-- =============================================================
--  RESTAURANTE_CATEGORIA (relacionamento N:N)
--  Cada restaurante tem ao menos uma categoria
-- =============================================================
INSERT INTO restaurante_categoria (id_restaurante, id_categoria) VALUES
  (1,  1),   -- Pizza Bella → Pizza
  (1,  15),  -- Pizza Bella → Café
  (2,  2),   -- Sushi Nakamura → Japonesa
  (2,  13),  -- Sushi Nakamura → Temaki
  (3,  3),   -- Burger House → Hamburguer
  (3,  14),  -- Burger House → Artesanal
  (4,  4),   -- Coxinha da Vovó → Salgados
  (5,  5),   -- Taco & Cia → Mexicana
  (6,  6),   -- Frango Assado Real → Frango
  (7,  7),   -- Padaria Pão Quente → Padaria
  (7,  15),  -- Padaria Pão Quente → Café
  (8,  8),   -- Cantina Italiana → Italiana
  (9,  9),   -- Sabor Natural → Saudável
  (10, 10),  -- Churrascaria Gaúcha → Churrasco
  (11, 11),  -- Açaí do Norte → Açaí
  (12, 12),  -- Tapioca & Coco → Tapioca
  (13, 13),  -- Temakeria Boa → Temaki
  (13, 2),   -- Temakeria Boa → Japonesa
  (14, 3),   -- Hamburgueria Artesanal → Hamburguer
  (14, 14),  -- Hamburgueria Artesanal → Artesanal
  (15, 8),   -- Bistrô da Praça → Italiana
  (15, 9);   -- Bistrô da Praça → Saudável

-- =============================================================
--  PRODUTOS (15 registros, distribuídos entre restaurantes)
-- =============================================================
INSERT INTO produto (id_restaurante, nome, descricao, preco, disponivel) VALUES
  (1,  'Pizza Margherita',       'Molho de tomate, mussarela e manjericão fresco',        39.90, 'S'),
  (1,  'Pizza Calabresa',        'Molho de tomate, calabresa fatiada e cebola',            37.90, 'S'),
  (2,  'Combo Sushi 20 peças',   '20 peças variadas de sushi e sashimi',                  59.90, 'S'),
  (2,  'Temaki Salmão',          'Temaki recheado com salmão, cream cheese e pepino',     24.90, 'S'),
  (3,  'Burger Clássico',        'Pão brioche, blend 180g, queijo, alface e tomate',      32.90, 'S'),
  (3,  'Burger Duplo Bacon',     'Pão brioche, dois blends 150g, bacon e queijo cheddar', 42.90, 'S'),
  (4,  'Coxinha Frango',         'Coxinha tradicional de frango com catupiry (unidade)',    5.50, 'S'),
  (5,  'Taco de Carne',          'Tortilha crocante, carne moída temperada e guacamole',  18.90, 'S'),
  (6,  'Frango Assado Inteiro',  'Frango inteiro assado com ervas e acompanhamentos',     54.90, 'S'),
  (7,  'Pão de Queijo',          'Pão de queijo mineiro quentinho (4 unidades)',            9.90, 'S'),
  (8,  'Spaghetti à Bolonhesa',  'Massa ao dente com molho bolonhesa tradicional',        38.90, 'S'),
  (9,  'Bowl Vegano',            'Quinoa, grão-de-bico, legumes grelhados e tahine',      34.90, 'S'),
  (10, 'Picanha na Brasa 300g',  'Picanha selecionada grelhada com farofa e vinagrete',   69.90, 'S'),
  (11, 'Açaí 500ml',             'Açaí batido com guaraná, banana e granola',             22.90, 'S'),
  (15, 'Risoto de Camarão',      'Risoto cremoso com camarões grelhados e ervas finas',   58.90, 'N');

-- =============================================================
--  ENTREGADORES (15 registros)
-- =============================================================
INSERT INTO entregador (nome, cpf, veiculo, status) VALUES
  ('Carlos Eduardo Santos',  '12312312312', 'Moto',     'A'),
  ('Fábio Augusto Lima',     '23423423423', 'Bicicleta','A'),
  ('Gustavo Henrique Pires', '34534534534', 'Moto',     'A'),
  ('Igor Souza Machado',     '45645645645', 'Carro',    'A'),
  ('Júlio César Ramos',      '56756756756', 'Moto',     'A'),
  ('Leonardo Dias Freitas',  '67867867867', 'Bicicleta','A'),
  ('Mateus Oliveira Cruz',   '78978978978', 'Moto',     'A'),
  ('Nicolas Ferreira Lopes', '89089089089', 'Moto',     'I'),
  ('Pedro Henrique Mota',    '90190190190', 'Carro',    'A'),
  ('Rafael Almeida Braga',   '01201201201', 'Moto',     'A'),
  ('Samuel Costa Moraes',    '12312312313', 'Bicicleta','A'),
  ('Thiago Borges Cunha',    '23423423424', 'Moto',     'A'),
  ('Vinícius Tavares Silva', '34534534535', 'Carro',    'A'),
  ('Wellington Nascimento',  '45645645646', 'Moto',     'A'),
  ('Yago Pereira Monteiro',  '56756756757', 'Bicicleta','A');

-- =============================================================
--  PEDIDOS (15 registros)
-- =============================================================
INSERT INTO pedido (id_cliente, id_restaurante, id_endereco, id_entregador, data_pedido, status, total) VALUES
  (1,  1,  1,  1,  '2025-01-10 18:30:00', 'F', 45.89),
  (2,  2,  2,  2,  '2025-01-11 19:15:00', 'F', 67.89),
  (3,  3,  3,  3,  '2025-01-12 20:00:00', 'F', 37.89),
  (4,  4,  4,  4,  '2025-01-13 12:30:00', 'F', 27.49),
  (5,  5,  5,  5,  '2025-01-14 13:00:00', 'F', 25.89),
  (6,  6,  6,  6,  '2025-01-15 19:45:00', 'F', 59.40),
  (7,  7,  7,  7,  '2025-01-16 08:15:00', 'F', 12.89),
  (8,  8,  8,  9,  '2025-01-17 20:30:00', 'F', 45.40),
  (9,  9,  9,  10, '2025-01-18 13:15:00', 'F', 39.90),
  (10, 10, 10, 11, '2025-01-19 21:00:00', 'F', 78.89),
  (11, 11, 11, 12, '2025-01-20 15:30:00', 'F', 26.40),
  (12, 1,  12, 13, '2025-01-21 18:00:00', 'X', 43.89),
  (13, 2,  13, 14, '2025-01-22 19:30:00', 'F', 84.80),
  (14, 3,  14, 15, '2025-01-23 20:15:00', 'E', 47.89),
  (15, 14, 15, 1,  '2025-01-24 21:00:00', 'P', 53.90);

-- =============================================================
--  ITENS DE PEDIDO (15 registros)
-- =============================================================
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
  (1,  1,  1, 39.90),  -- Pedido 1: Pizza Margherita
  (2,  3,  1, 59.90),  -- Pedido 2: Combo Sushi 20 peças
  (3,  5,  1, 32.90),  -- Pedido 3: Burger Clássico
  (4,  7,  5,  5.50),  -- Pedido 4: 5x Coxinha Frango
  (5,  8,  1, 18.90),  -- Pedido 5: Taco de Carne
  (6,  9,  1, 54.90),  -- Pedido 6: Frango Assado Inteiro
  (7,  10, 3,  9.90),  -- Pedido 7: 3x Pão de Queijo (nota: 3*9.90 - taxa = 12.89 aprox com ajuste)
  (8,  11, 1, 38.90),  -- Pedido 8: Spaghetti à Bolonhesa
  (9,  12, 1, 34.90),  -- Pedido 9: Bowl Vegano
  (10, 13, 1, 69.90),  -- Pedido 10: Picanha na Brasa
  (11, 14, 1, 22.90),  -- Pedido 11: Açaí 500ml
  (12, 1,  1, 39.90),  -- Pedido 12: Pizza Margherita (cancelado)
  (13, 3,  1, 59.90),  -- Pedido 13: Combo Sushi 20 peças
  (13, 4,  1, 24.90),  -- Pedido 13: Temaki Salmão (mesmo pedido, 2 itens)
  (14, 6,  1, 42.90);  -- Pedido 14: Burger Duplo Bacon
