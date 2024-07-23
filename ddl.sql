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
    CONTRAINT pk_id_brand PRIMARY KEY(id_brand)
);

CREATE TABLE models (
    id_model INT AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    id_brand INT NOT NULL,
    CONSTRAINT pk_id_model PRIMARY KEY (id_model),
    CONSTRAINT fk_id_brand_model FOREIGN KEY (id_brand)
    REFERENCES brands(id_brand) ON DELETE CASCADE
);

CREATE TABLE bikes (
    id_bike INT AUTO_INCREMENT,
    id_model INT,
    price DECIMAL(10,2) UNSIGNED  NOT NULL,
    stock INT UNSIGNED DEFAULT 0,
    CHECK price > 0.00,
    CONSTRAINT pk_id_bike PRIMARY KEY (id_bike),
    CONSTRAINT fk_id_model FOREIGN KEY (id_model)
    REFERENCES models(id_model)
);

CREATE TABLE document_types (
    id_document_type INT AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    CONSTRAINT pk_id_document_type PRIMARY KEY (id_document_type) 
)

CREATE TABLE customers (
    id_customer VARCHAR(50),
    id_document_type INT(),
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    id_city INT NOT NULL,
    CONSTRAINT pk_id_customer PRIMARY KEY (id_customer),
    CONSTRAINT fk_id_document_type_customer FOREIGN KEY (id_document_type)
    REFERENCES document_types(id_document_type),
    CONSTRAINT fk_id_city_customer FOREIGN KEY (id_city)
    REFERENCES cities(id_city)
);
