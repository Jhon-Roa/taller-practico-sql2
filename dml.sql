INSERT INTO countries (name, phone_code) VALUES
('Colombia', '+57'),
('Estados Unidos', '+1'),
('Argentina', '+54'),
('Mexico','+52');

INSERT INTO cities (name, id_country) VALUES
('Bucaramanga', 1),
('Medellin', 1),
('Buenos Aires', 3),
('Denver', 2),
('Queretaro', 4),
('New York', 2),
('La Plata', 3),
('Cordoba', 1),
('Rosario', 3),
('Tamaulipas', 4);

INSERT INTO brands (name) VALUES
('Giant'),
('Canyon'),
('BMC'),
('Orbea'),
('Trek');

INSERT INTO models (name, id_brand) VALUES
('Comfort', 1),
('Citadina', 5),
('Rendimiento', 4),
('Velocidad', 2),
('Montaña', 3),
('Urbana', 4),
('Artistica', 5),
('Camuflaje', 1),
('Gamer', 3);

INSERT INTO document_types (name) VALUES
('Cedula'),
('Pasaporte'),
('Pasaporte diplomatico');

INSERT INTO contacts (id_contact, id_document_type, first_name, middle_name, last_name, second_last_name) VALUES
('UK598715', 3, 'Julian', NULL, 'Casablancas', NULL,),
('100052748', 1, 'Miguel', 'Camilo', 'Mora', 'Prince'),
('967485214', 1, 'Jhon', NULL, 'Roa', 'Pimentel'),
('2364859', 2, 'Petro', NULL, 'Sneider', NULL);

INSERT INTO suppliers (id_supplier, name, id_contact, email) VALUES
('BMC45485', 'Concentrados', 2, 'concen@sol.com'),
('TK42195', 'Milherreros', 1, 'herr.mil@milherr.com'),
('H1005188GF6', 'Juan Piezas', 4,'piezas@juanp.com');

INSERT INTO phone_types (name) VALUES
('Mobile'),
('Fax'),
('Direct Line');

INSERT INTO supplier_model (id_supplier, id_model) VALUES
(1, 1),
(1, 3),
(1, 5),
(1, 7),
(1, 9),
(2, 7),
(2, 8),
(2, 9),
(3, 2),
(3, 5),
(3, 6),
(3, 4);

INSERT INTO suppliers_phone (phone_number, id_supplier, id_phone_type) VALUES
('351845748', 1, 1),
('415888', 1, 2),
('3115749635', 2, 1),
('7856432', 2, 3),
('53250641',3, 1),
('551234', 3, 2),
('6540192', 3, 3);

INSERT INTO bikes (id_supplier_model, price, stock) VALUES
(1, 1545.90, 5),
(2, 2000.00, 7),
(3, 450.42, 3),
(4, 783.23, 7),
(5, 799.20, 3),
(7, 4200.50, 6);

INSERT INTO customers (id_customer, id_document_type, first_name, middle_name, last_name, second_last_name, email, phone_number, id_city) VALUES
('100548745', 1, 'Juan', 'Mario', 'Ñengo', 'Flow', 'flow@mail.com', '31546285', 2),
('102045215', 1, 'Maria', NULL, 'Cimientos', 'Verdolaga', 'verdo@laga.com', '415965858', 4),
('5698547', 2, 'Lobezna', 'Tatiana', 'Pimentel', NULL, 'latatiana@lob.com', '4857485', 5);

INSERT INTO sales (id_customer) VALUES
(1),
(2),
(1),
(3),
(3);

INSERT INTO sale_details (id_sale, id_bike, quantity) VALUES
(1, 3, 5),
(1, 1, 2),
(1, 5, 3),
(1, 9, 12);

INSERT INTO spares (name, description, price, stock, id_supplier) VALUES
('7 cambios shimano', 'lorem lorem lorem lorem', 124.30, 12, 2),
('Discos 17-32', 'lorem lorem lorem lorem', 69.00, 8, 1),
('Llantas montañera', 'Lorem lorem lorem', 45.84, 9, 3);

INSERT INTO purchases (id_supplier, total) VALUES
(2, 12400.00),
(1, 8000.34),
(1, 250.60),
(1, 1532.00),
(2, 3201.45);

INSERT INTO purchase_details (id_purchase, id_spare, quantity) VALUES
(1, 2, 4),
(1, 3, 7),
(2,1,4);
