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

INSERT INTO bike_type (name) VALUES
('Montaña'),
('Carretera'),
('Electrica'),
('Hibrida');

INSERT INTO models (name, id_bike_type, id_brand) VALUES
('gn125', 1, 1),
('mt-02', 1, 5),
('hd-C2016', 3, 4),
('avenger b220', 4, 2),
('mont giant', 4, 3),
('thousand sunny', 2, 4),
('merry', 2, 5),
('oro jackson', 4, 1),
('xebec', 2, 3);

INSERT INTO document_types (name) VALUES
('Cedula'),
('Pasaporte'),
('Pasaporte diplomatico');

INSERT INTO contacts (id_contact, id_document_type, first_name, middle_name, last_name, second_last_name) VALUES
('UK598715', 3, 'Julian', NULL, 'Casablancas', NULL),
('100052748', 1, 'Miguel', 'Camilo', 'Mora', 'Prince'),
('967485214', 1, 'Jhon', NULL, 'Roa', 'Pimentel'),
('2364859', 2, 'Petro', NULL, 'Sneider', NULL);

INSERT INTO suppliers (id_supplier, name, id_contact, email, id_city) VALUES
('BMC45485', 'Concentrados', '100052748', 'concen@sol.com', 1),
('TK42195', 'Milherreros', 'UK598715', 'herr.mil@milherr.com', 2),
('H1005188GF6', 'Juan Piezas', '2364859','piezas@juanp.com', 3);

INSERT INTO phone_types (name) VALUES
('Mobile'),
('Fax'),
('Direct Line');

INSERT INTO supplier_model (id_supplier, id_model) VALUES
('BMC45485', 1),
('BMC45485', 3),
('BMC45485', 5),
('BMC45485', 7),
('BMC45485', 9),
('BMC45485', 7),
('H1005188GF6', 8),
('TK42195', 9),
('TK42195', 2),
('H1005188GF6', 5),
('TK42195', 6),
('TK42195', 4);

INSERT INTO suppliers_phone (phone_number, id_supplier, id_phone_type) VALUES
('351845748', 'BMC45485', 1),
('415888', 'BMC45485', 2),
('3115749635', 'TK42195', 1),
('7856432', 'TK42195', 3),
('53250641', 'H1005188GF6', 1),
('551234', 'H1005188GF6', 2),
('6540192', 'H1005188GF6', 3);


INSERT INTO bikes (id_supplier_model, price, stock) VALUES
(1, 1545.90, 500),
(2, 2000.00, 700),
(3, 450.42, 300),
(4, 783.23, 700),
(5, 799.20, 300),
(7, 4200.50, 600);

INSERT INTO customers (id_customer, id_document_type, first_name, middle_name, last_name, second_last_name, email, phone_number, id_city) VALUES
('100548745', 1, 'Juan', 'Mario', 'Ñengo', 'Flow', 'flow@mail.com', '31546285', 2),
('102045215', 1, 'Maria', NULL, 'Cimientos', 'Verdolaga', 'verdo@laga.com', '415965858', 4),
('5698547', 2, 'Lobezna', 'Tatiana', 'Pimentel', NULL, 'latatiana@lob.com', '4857485', 5);

INSERT INTO sales (id_customer, date) VALUES
('100548745', '2024-01-01');

INSERT INTO sales (id_customer) VALUES
('100548745'),
('102045215'),
('5698547'),
('102045215');

INSERT INTO sale_details (id_sale, id_bike, quantity) VALUES
(1, 3, 5),
(3, 1, 2),
(2, 5, 3),
(1, 4, 12);

INSERT INTO spares (name, description, price, stock, id_supplier) VALUES
('7 cambios shimano', 'lorem lorem lorem lorem', 124.30, 102, 'BMC45485'),
('7 cambios shimano', 'lorem lorem lorem lorem', 124.30, 102, 'H1005188GF6'),
('7 cambios shimano', 'lorem lorem lorem lorem', 124.30, 102, 'BMC45485');

INSERT INTO purchases (id_supplier) VALUES
('TK42195'),
('BMC45485'),
('BMC45485'),
('BMC45485'),
('H1005188GF6');

INSERT INTO purchase_details (id_purchase, id_spare, quantity) VALUES
(5, 2, 4),
(2, 3, 7),
(3, 1, 4);
