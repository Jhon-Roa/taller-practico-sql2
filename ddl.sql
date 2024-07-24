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

CREATE TABLE contacts (
    id_contact VARCHAR(50),
    first_name VARCHAR(20) NOT NULL,
    middle_name VARCHAR(20),
    last_name VARCHAR(20) NOT NULL,
    second_last_name VARCHAR(20),
    CONSTRAINT pk_id_contact PRIMARY KEY (id_contact)
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
    phone_number INT(15),
    id_phone_type INT NOT NULL,
    CONSTRAINT pk_id_suppliers_phone PRIMARY KEY (id_suppliers_phone),
    CONSTRAINT fk_id_phone_type_suppliers_phone FOREIGN KEY (id_phone_type)
    REFERENCES phone_types(id_phone_type)
);

CREATE TABLE bikes (
    id_bike INT AUTO_INCREMENT,
    id_supplier_model INT,
    price DECIMAL(10,2) UNSIGNED  NOT NULL,
    stock INT UNSIGNED DEFAULT 0,
    CHECK (price > 0.00),
    CONSTRAINT pk_id_bike PRIMARY KEY (id_bike),
    CONSTRAINT fk_id_supplier_model_bikes FOREIGN KEY (id_supplier_model)
    REFERENCES supplier_model(id_supplier_model)
);

CREATE TABLE document_types (
    id_document_type INT AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    CONSTRAINT pk_id_document_type PRIMARY KEY (id_document_type) 
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
    unit_price DECIMAL(10,2),
    CHECK (quantity > 0),
    CONSTRAINT pk_id_sale_details PRIMARY KEY (id_sale_details),
    CONSTRAINT fk_id_sale_sale_details FOREIGN KEY (id_sale)
    REFERENCES sales(id_sale) ON DELETE CASCADE, 
    CONSTRAINT fk_id_bike_sale_details FOREIGN KEY (id_bike)
    REFERENCES bikes(id_bike)
);

DELIMITER $$
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

    UPDATE sale_details
    SET unit_price = unit_price_t
    WHERE id_sale_details = NEW.id_sale_details;

    UPDATE sales 
    SET total = unit_price_t * NEW.quantity
    WHERE id_sale = NEW.id_sale;
END $$

DELIMITER ;