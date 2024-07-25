DROP DATABASE IF EXISTS bicicleteria_jr;

CREATE DATABASE bicicleteria_jr;
USE bicicleteria_jr;

CREATE TABLE countries (
    id_country INT AUTO_INCREMENT,
    name VARCHAR(80) UNIQUE NOT NULL,
    phone_code VARCHAR(5) NOT NULL,
    CONSTRAINT pk_id_country PRIMARY KEY (id_country)
);

CREATE TABLE cities (
    id_city INT AUTO_INCREMENT,
    name VARCHAR(80) NOT NULL,
    id_country INT NOT NULL,
    CONSTRAINT pk_id_city PRIMARY KEY (id_city),
    CONSTRAINT fk_id_country_city FOREIGN KEY (id_country)
    REFERENCES countries(id_country) ON DELETE CASCADE
);

CREATE TABLE brands (
    id_brand INT AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    CONSTRAINT pk_id_brand PRIMARY KEY(id_brand)
);

CREATE TABLE models (
    id_model INT AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    id_brand INT NOT NULL,
    CONSTRAINT pk_id_model PRIMARY KEY (id_model),
    CONSTRAINT fk_id_brand_model FOREIGN KEY (id_brand)
    REFERENCES brands(id_brand) ON DELETE CASCADE 
);

CREATE TABLE document_types (
    id_document_type INT AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    CONSTRAINT pk_id_document_type PRIMARY KEY (id_document_type) 
);

CREATE TABLE contacts (
    id_contact VARCHAR(50),
    id_document_type INT,
    first_name VARCHAR(20) NOT NULL,
    middle_name VARCHAR(20),
    last_name VARCHAR(20) NOT NULL,
    second_last_name VARCHAR(20),
    CONSTRAINT pk_id_contact PRIMARY KEY (id_contact),
    CONSTRAINT fk_id_document_type_contact FOREIGN KEY (id_document_type)
    REFERENCES document_types(id_document_type)
);

CREATE TABLE suppliers (
    id_supplier VARCHAR(50),
    name VARCHAR(100) NOT NULL,
    id_contact VARCHAR(50),
    email VARCHAR(100) UNIQUE NOT NULL,
    id_city INT,
    CONSTRAINT pk_id_supplier PRIMARY KEY (id_supplier),
    CONSTRAINT fk_id_contact_supplier FOREIGN KEY (id_contact)
    REFERENCES contacts(id_contact),
    CONSTRAINT fk_id_city_supplier FOREIGN KEY (id_city)
    REFERENCES cities(id_city)
);

CREATE TABLE phone_types (
    id_phone_type INT AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    CONSTRAINT pk_id_phone_type PRIMARY KEY (id_phone_type)
);

CREATE TABLE supplier_model (
    id_supplier_model INT AUTO_INCREMENT,
    id_supplier VARCHAR(50) NOT NULL,
    id_model INT NOT NULL,
    CONSTRAINT pk_id_supplier_model PRIMARY KEY (id_supplier_model),
    CONSTRAINT fk_id_supplier_supplier_model FOREIGN KEY (id_supplier)
    REFERENCES suppliers(id_supplier),
    CONSTRAINT fk_id_model_supplier_model FOREIGN KEY (id_model)
    REFERENCES models(id_model) 
); 

CREATE TABLE suppliers_phone (
    id_suppliers_phone INT AUTO_INCREMENT,
    phone_number VARCHAR(15),
    id_supplier VARCHAR(50),
    id_phone_type INT NOT NULL,
    CONSTRAINT pk_id_suppliers_phone PRIMARY KEY (id_suppliers_phone),
    CONSTRAINT fk_id_phone_type_suppliers_phone FOREIGN KEY (id_phone_type)
    REFERENCES phone_types(id_phone_type),
    CONSTRAINT fk_id_supplier_phone_supplier FOREIGN KEY (id_supplier)
    REFERENCES suppliers(id_supplier)
);

CREATE TABLE bikes (
    id_bike INT AUTO_INCREMENT,
    id_supplier_model INT UNIQUE,
    price DECIMAL(10,2) UNSIGNED  NOT NULL,
    stock INT UNSIGNED DEFAULT 0,
    CHECK (price > 0.00),
    CONSTRAINT pk_id_bike PRIMARY KEY (id_bike),
    CONSTRAINT fk_id_supplier_model_bikes FOREIGN KEY (id_supplier_model)
    REFERENCES supplier_model(id_supplier_model)
);

CREATE TABLE customers (
    id_customer VARCHAR(50),
    id_document_type INT NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    middle_name VARCHAR(20),
    last_name VARCHAR(20) NOT NULL,
    second_last_name VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number INT(15) NOT NULL,
    id_city INT,
    CONSTRAINT pk_id_customer PRIMARY KEY (id_customer),
    CONSTRAINT fk_id_document_type_customer FOREIGN KEY (id_document_type)
    REFERENCES document_types(id_document_type),
    CONSTRAINT fk_id_city_customer FOREIGN KEY (id_city)
    REFERENCES cities(id_city)
);

CREATE TABLE sales (
    id_sale INT AUTO_INCREMENT,
    date DATE DEFAULT (CURDATE()),
    id_customer VARCHAR(50) NOT NULL,
    total DECIMAL(10, 2) DEFAULT 0,
    CONSTRAINT pk_id_sale PRIMARY KEY (id_sale),
    CONSTRAINT fk_id_customer_sale FOREIGN KEY (id_customer)
    REFERENCES customers(id_customer)
);

CREATE TABLE sale_details (
    id_sale_details INT AUTO_INCREMENT,
    id_sale INT NOT NULL,
    id_bike INT NOT NULL,
    quantity INT UNSIGNED DEFAULT 1,
    CHECK (quantity > 0),
    CONSTRAINT pk_id_sale_details PRIMARY KEY (id_sale_details),
    CONSTRAINT fk_id_sale_sale_details FOREIGN KEY (id_sale)
    REFERENCES sales(id_sale) ON DELETE CASCADE,
    CONSTRAINT fk_id_bike_sale_details FOREIGN KEY (id_bike)
    REFERENCES bikes(id_bike)
);

CREATE TABLE spares (
    id_spare INT AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    price DECIMAL(10,2) UNSIGNED  NOT NULL,
    stock INT UNSIGNED DEFAULT 0,
    id_supplier VARCHAR(50),
    CONSTRAINT pk_id_spare PRIMARY KEY (id_spare),
    CONSTRAINT fk_id_supplier_spare FOREIGN KEY (id_supplier)
    REFERENCES suppliers(id_supplier)
);

CREATE TABLE purchases (
    id_purchase INT AUTO_INCREMENT,
    date DATE DEFAULT (CURDATE()),
    id_supplier VARCHAR(50) NOT NULL,
    total DECIMAL(10,2) DEFAULT 0,
    CONSTRAINT pk_id_purchase PRIMARY KEY (id_purchase),
    CONSTRAINT fk_id_supplier_purchase FOREIGN KEY (id_supplier)
    REFERENCES suppliers(id_supplier)
);

CREATE TABLE purchase_details (
    id_purchase_details INT AUTO_INCREMENT,
    id_purchase INT NOT NULL,
    id_spare INT NOT NULL,
    quantity INT UNSIGNED DEFAULT 1,
    CHECK (quantity > 0),
    CONSTRAINT pk_id_purchase_details PRIMARY KEY (id_purchase_details),
    CONSTRAINT fk_id_purchase_purchase_details FOREIGN KEY (id_purchase)
    REFERENCES purchases(id_purchase) ON DELETE CASCADE,
    CONSTRAINT fk_id_spare_purchase_details FOREIGN KEY (id_spare)
    REFERENCES spares(id_spare)
);

DELIMITER $$
-- triggers
CREATE TRIGGER after_delete_city
AFTER DELETE ON cities
FOR EACH ROW
BEGIN
    UPDATE suppliers
    SET id_city = NULL
    WHERE id_city = OLD.id_city;

    UPDATE customers 
    SET id_city = NULL
    WHERE id_city = OLD.id_city;
END $$

CREATE TRIGGER after_delete_supplier
AFTER DELETE ON suppliers
FOR EACH ROW
BEGIN
    UPDATE spares
    SET id_supplier = NULL
    WHERE id_supplier = OLD.id_supplier;
END $$

CREATE TRIGGER after_insert_sale_details
AFTER INSERT ON sale_details
FOR EACH ROW 
BEGIN 
    DECLARE available_stock INT;
    DECLARE unit_price_t DECIMAL(10,2);

    SELECT stock, price INTO available_stock, unit_price_t
    FROM bikes
    WHERE id_bike = NEW.id_bike;

    IF available_stock < NEW.quantity THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough stock available for the requested quantity';
    END IF; 

    UPDATE bikes
    SET stock = available_stock - NEW.quantity
    WHERE id_bike = NEW.id_bike;

    UPDATE sales 
    SET total = unit_price_t * NEW.quantity
    WHERE id_sale = NEW.id_sale;
END $$

CREATE TRIGGER after_insert_purchase_details
AFTER INSERT ON purchase_details
FOR EACH ROW 
BEGIN 
    DECLARE available_stock INT;
    DECLARE unit_price_t DECIMAL(10,2);
    DECLARE id_supplier_spare INT;
    DECLARE id_supplier_purchase INT;

    SELECT stock, price INTO available_stock, unit_price_t
    FROM spares
    WHERE id_spare = NEW.id_spare;

    SELECT id_supplier INTO id_supplier_spare
    FROM spares
    WHERE id_spare = NEW.id_spare;

    SELECT id_supplier INTO id_supplier_purchase
    FROM purchases
    WHERE id_purchase = NEW.id_purchase;

    IF available_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough stock available for the requested quantity';
    END IF;

    IF id_supplier_spare != id_supplier_purchase THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The supplier for the spare and purchase does not match';
    END IF; 

    UPDATE spares
    SET stock = available_stock - NEW.quantity
    WHERE id_spare = NEW.id_spare;

    UPDATE purchases 
    SET total = unit_price_t * NEW.quantity
    WHERE id_purchase = NEW.id_purchase;
END $$

-- Procedures for use cases
-- case 1
CREATE PROCEDURE add_bike (IN id_model_nb INT, IN price_nb DECIMAL(10,2), IN stock_nb INT)
BEGIN
    INSERT INTO bikes (id_supplier_model, price, stock)
    VALUES (id_model_nb, precio_nb, stock_nb);
END $$

CREATE PROCEDURE update_bike (IN id_bike_to_change INT, IN newPrice DECIMAL(10,2), IN newStock INT)
BEGIN
    UPDATE bikes
    SET price = newPrice, stock = newStock
    WHERE id_bike = id_bike_to_change;

    SELECT "Ha sido actualizada la bici";
END $$

CREATE PROCEDURE delete_bike (IN id_bike_to_delete INT)
BEGIN
    DELETE FROM bike 
    WHERE id_bike = id_bike_to_delete;
END $$

-- case 2
CREATE PROCEDURE sale_register(IN id_customer_ns VARCHAR(50), OUT id_sale_out INT)
BEGIN 
    INSERT INTO sales(id_customer)
    VALUES (id_customer_ns);

    SELECT LAST_INSERT_ID() INTO id_sale_out;
END $$

CREATE PROCEDURE sale_details_register(IN id_sale_nsd INT, IN id_bike_nsd INT, IN quantity_nsd INT)
BEGIN
    INSERT INTO sale_details(id_sale, id_bike, quantity)
    VALUES (id_sale_nsd, id_bike_nsd, quantity_nsd);
END $$

-- case 3
CREATE PROCEDURE add_supplier(IN name_ns VARCHAR(50), IN id_contact_ns INT, IN phone_ns VARCHAR(15), IN phone_type_ns INT, IN email_ns VARCHAR(100), IN id_city_ns INT, OUT id_supplier_out VARCHAR(50) )
BEGIN
    INSERT INTO suppliers(name, id_contact, email, id_city)
    VALUES (name_ns, id_contact_ns, email_ns, id_city_ns);

    SELECT LAST_INSERT_ID() INTO id_supplier_out;

    INSERT INTO suppliers_phone(phone_number, id_supplier, id_phone_type )
    VALUES (phone_ns, LAST_INSERT_ID(), phone_type_ns );
END $$

CREATE PROCEDURE add_spare(IN name_ns VARCHAR(50), IN description_ns VARCHAR(200), IN price_ns DECIMAL(10,2), IN stock_ns INT, IN id_supplier_ns VARCHAR(50), OUT id_spare_out INT )
BEGIN 
    INSERT INTO spares(name, description, price, stock, id_supplier)
    VALUES (name_ns, description_ns, price_ns, stock_ns, id_supplier_ns);


    SELECT LAST_INSERT_ID() INTO id_spare_out;
END $$

CREATE PROCEDURE update_supplier(IN id_supplier_ns VARCHAR(50), IN name_ns VARCHAR(50), IN id_contact_ns INT, IN email_ns VARCHAR(100), IN id_city_ns INT)
BEGIN
    UPDATE supplier
    SET name = name_ns, id_contact = id_contact_ns, email = email_ns, id_city = id_city_ns
    WHERE id_supplier = id_supplier_ns;
END $$

CREATE PROCEDURE update_spare(IN id_spare_ns INT, IN name_ns VARCHAR(50), IN description_ns VARCHAR(200), IN price_ns DECIMAL(10,2), IN stock_ns INT)
BEGIN
    UPDATE spares
    SET name = name_ns, description = description_ns, price = price_ns, stock = stock_ns
    WHERE id_supplier = id_spare_ns;
END $$

CREATE PROCEDURE delete_supplier (IN id_supplier_ns varchar(50))
BEGIN
    DELETE FROM suppliers
    WHERE id_supplier = id_supplier_ns;
END $$

CREATE PROCEDURE delete_spare (IN id_spare_ns INT)
BEGIN
    DELETE FROM spares
    WHERE id_spare = id_spare_ns;
END $$

-- case 4
CREATE PROCEDURE show_sales(IN id_customer_ns VARCHAR(50))
BEGIN
    SELECT id_sale, date, total
    FROM sales 
    WHERE id_customer = id_customer_ns
    ORDER BY id_sale;
END $$

CREATE PROCEDURE show_sale_details(IN id_sale_ns INT, IN id_customer_ns VARCHAR(50))
BEGIN
    DECLARE row_count INT DEFAULT 0;

    CREATE TEMPORARY TABLE temp_sale_details AS
    SELECT sd.id_sale_details,
           sd.id_sale,
           b.name,
           b.price,
           sd.quantity
    FROM sale_details AS sd
    JOIN bike AS b USING(id_bike)
    JOIN sales AS s USING(id_sale)
    WHERE sd.id_sale = id_sale_ns
    AND s.id_customer = id_customer_ns
    ORDER BY sd.id_sale_details;

    SELECT COUNT(*) INTO row_count FROM temp_sale_details;

    IF row_count = 0 THEN
        SELECT 'No se encontraron detalles de venta para los parámetros proporcionados.' AS message;
    ELSE
        SELECT * FROM temp_sale_details;
    END IF;

    DROP TEMPORARY TABLE temp_sale_details;
END $$

-- case 5
CREATE PROCEDURE purchase_register(IN id_supplier_ns VARCHAR(50), OUT id_purchase_out INT)
BEGIN 
    INSERT INTO purchases(id_supplier)
    VALUES (id_supplier_ns);

    SELECT LAST_INSERT_ID() INTO id_purchase_out;
END $$

CREATE PROCEDURE purchase_details_register(IN id_purchase_nsd INT, IN id_spare_nsd INT, IN quantity_nsd INT)
BEGIN
    INSERT INTO purchase_details(id_purchase, id_spare, quantity)
    VALUES (id_purchase_nsd, id_spare_nsd, quantity_nsd);
END $$
DELIMITER ;
