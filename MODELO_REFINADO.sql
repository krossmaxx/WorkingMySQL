CREATE DATABASE E_commerce;
use E_commerce;

-- Criação da Tabela de Clientes
CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(50),
    Minit CHAR(3),
    Lname VARCHAR(50),
    CPF CHAR(11),
    Address VARCHAR(200),
    clientType ENUM('Pessoa Física', 'Pessoa Jurídica') NOT NULL,
    CONSTRAINT unique_cpf_client UNIQUE (CPF)
);

-- Índice para consultar o CPF, pode ter uso frequente!
CREATE INDEX idx_clients_cpf ON clients(CPF);

-- Tabela para clientes Pessoa Física (PF)
CREATE TABLE client_pf (
    idClient INT PRIMARY KEY,
    RG CHAR(9) NOT NULL,
    birthDate DATE,
    CONSTRAINT fk_client_pf FOREIGN KEY (idClient) REFERENCES clients(idClient)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Índice para consultar pelo RG
CREATE INDEX idx_client_pf_rg ON client_pf(RG);

-- Tabela para clientes Pessoa Jurídica (PJ)
CREATE TABLE client_pj (
    idClient INT PRIMARY KEY,
    CNPJ CHAR(14) NOT NULL,
    companyName VARCHAR(255),
    CONSTRAINT fk_client_pj FOREIGN KEY (idClient) REFERENCES clients(idClient)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT unique_cnpj UNIQUE (CNPJ)
);

-- Índice para consultar pelo CNPJ
CREATE INDEX idx_client_pj_cnpj ON client_pj(CNPJ);

-- Tabela de Produtos
CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(50),
    classification_kids BOOL DEFAULT FALSE,
    category ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    avaliation FLOAT DEFAULT 0,
    size VARCHAR(10)
);

-- Tabela de Pagamentos
CREATE TABLE payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    typePayment ENUM('Boleto', 'Cartão', 'Dois cartões'),
    limitAvailable FLOAT,
    CONSTRAINT fk_payment_client FOREIGN KEY (idClient) REFERENCES clients(idClient)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabela de Pedidos
CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    paymentCash BOOL DEFAULT FALSE,
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) REFERENCES clients(idClient)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabela de Entrega
CREATE TABLE delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    deliveryStatus ENUM('Aguardando envio', 'Em transporte', 'Entregue') DEFAULT 'Aguardando envio',
    trackingCode VARCHAR(50),
    CONSTRAINT fk_delivery_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabela de Estoque de Produtos
CREATE TABLE productStorage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

-- Tabela de Fornecedores
CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL, 
    contact VARCHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- Índice para consultar pelo CNPJ de fornecedores
CREATE INDEX idx_supplier_cnpj ON supplier(CNPJ);

-- Tabela de Vendedores
CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ VARCHAR(14),  -- Mudança para VARCHAR
    CPF VARCHAR(11),   -- Mudança para VARCHAR
    location VARCHAR(255),
    contact VARCHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

-- Índices para consultar pelo CPF e CNPJ dos vendedores
CREATE INDEX idx_seller_cnpj ON seller(CNPJ);
CREATE INDEX idx_seller_cpf ON seller(CPF);

-- Tabela de Vendas dos Vendedores
CREATE TABLE productSeller (
    idPseller INT,
    idPproduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPseller, idPproduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPseller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idPproduct) REFERENCES product(idProduct)
);

-- Tabela de Produtos em Pedidos
CREATE TABLE productOrder (
    idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_productorder_order FOREIGN KEY (idPOorder) REFERENCES orders(idOrder)
);

-- Tabela de Armazém de Produtos
CREATE TABLE storageLocation (
    idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct, idLstorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES productStorage(idProdStorage)
);

-- Tabela de Produtos e seus Fornecedores
CREATE TABLE productSupplier (
    idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPsProduct) REFERENCES product(idProduct)
);

-- Inserção de clientes Pessoa Física - PF
INSERT INTO clients (Fname, Minit, Lname, CPF, Address, clientType)
VALUES 
    ('Maria', 'M', 'Silva', '12345678901', 'Rua Silva da Prata 29, Carangola - Cidade das Flores', 'Pessoa Física'),
    ('Matheus', 'O', 'Pimentel', '98765432109', 'Rua Alameda 289, Centro - Cidade das Flores', 'Pessoa Física'),
    ('Ricardo', 'F', 'Silva', '45678913210', 'Avenida Alameda Vinha 1009, Centro - Cidade das Flores', 'Pessoa Física'),
    ('Julia', 'S', 'França', '78912345611', 'Rua Lareiras 861, Centro - Cidade das Flores', 'Pessoa Física'),
    ('Roberta', 'G', 'Assis', '98745631122', 'Avenida Koller 19, Centro - Cidade das Flores', 'Pessoa Física'),
    ('Isabela', 'M', 'Cruz', '65478912333', 'Rua Alameda das Flores 28, Centro - Cidade das Flores', 'Pessoa Física');
select * from clients;

-- Contagem total de clientes
SELECT COUNT(*) FROM clients;

-- Seleção de nomes e status dos pedidos dos clientes
SELECT Fname, Lname, idOrder, orderStatus
FROM clients c
JOIN orders o ON c.idClient = o.idOrderClient;

-- Nome completo de clientes com pedidos e status
SELECT CONCAT(Fname, ' ', Lname) AS Client, idOrder AS Request, orderStatus AS Status
FROM clients c
JOIN orders o ON c.idClient = o.idOrderClient;

-- Inserção de produtos
INSERT INTO product (Pname, classification_kids, category, avaliation, size)
VALUES 
    ('Fone de ouvido', false, 'Eletrônico', 4, NULL),
    ('Barbie Elsa', true, 'Brinquedos', 3, NULL),
    ('Body Carters', true, 'Vestimenta', 5, NULL),
    ('Microfone Vedo - Youtuber', false, 'Eletrônico', 4, NULL),
    ('Sofá Retrátil', false, 'Móveis', 3, '3x57x80'),
    ('Farinha de arroz', false, 'Alimentos', 2, NULL),
    ('Fire Stick Amazon', false, 'Eletrônico', 3, NULL);
    select * from product;
DELETE p1 
FROM product p1
JOIN product p2 
ON p1.Pname = p2.Pname 
AND p1.idProduct > p2.idProduct;
-- Inserção de novos pedidos
INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
VALUES 
    (1, DEFAULT, 'Compra via app', NULL, 1),
    (2, DEFAULT, 'Compra via app', 50, 0),
    (3, 'Confirmado', NULL, NULL, 1),
    (4, DEFAULT, 'Compra via Web Site', 150, 0);

SELECT * FROM orders;
DELETE o1 
FROM orders o1
JOIN orders o2 
ON o1.idOrderClient = o2.idOrderClient
AND o1.idOrder > o2.idOrder;

select * from orders where idOrder in (2, 3);
-- Inserção de produtos em pedidos
INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity, poStatus)
VALUES 
    (1, 1, 2, NULL),
    (2, 1, 1, NULL),
    (3, 2, 1, NULL);
select * from productOrder;
-- Inserção de estoque de produtos
INSERT INTO productStorage (storageLocation, quantity)
VALUES 
    ('Rio de Janeiro', 1000),
    ('Rio de Janeiro', 500),
    ('São Paulo', 10),
    ('São Paulo', 100),
    ('São Paulo', 10),
    ('Brasília', 60);
select * from productStorage;

INSERT INTO storageLocation (idLproduct, idLstorage, location)
VALUES 
    (1, 2, 'RJ'),
    (2, 6, 'GO');
select * from storageLocation;

INSERT INTO supplier (SocialName, CNPJ, contact)
VALUES 
    ('Almeida e filhos', '12345678912345', '219854741'),
    ('Eletrônicos Silva', '85451964914345', '21985484'),
    ('Eletrônicos Valma', '93456789393469', '21975474');
select * from supplier;

INSERT INTO productSupplier (idPsSupplier, idPsProduct, quantity)
VALUES 
    (1, 1, 500),
    (1, 2, 400),
    (2, 4, 633),
    (3, 3, 5),
    (2, 5, 10);
select * from productSupplier;


INSERT INTO seller (SocialName, AbstName, CNPJ, CPF, location, contact)
VALUES 
    ('Tech Eletronics', NULL, '12345678945632', NULL, 'Rio de Janeiro', '219946287'),
    ('Boutique Durgas', NULL, NULL, '123456783', 'Rio de Janeiro', '219567895'),
    ('Kids World', NULL, '45678912365448', NULL, 'São Paulo', '1198657484');
select * from seller;


INSERT INTO productSeller (idPseller, idPproduct, prodQuantity)
VALUES 
    (1, 6, 80),
    (2, 7, 10);
select * from productSeller;

-- Seleção de clientes e seus pedidos (com join)
SELECT * 
FROM clients c
JOIN orders o ON c.idClient = o.idOrderClient;

-- Contagem de pedidos por cliente
SELECT c.idClient, Fname, Lname, COUNT(*) AS Number_of_orders
FROM clients c
INNER JOIN orders o ON c.idClient = o.idOrderClient
INNER JOIN productOrder p ON p.idPOorder = o.idOrder
GROUP BY idClient;