# Taller practico SQL2

*Jhon Arley Roa*
*Juan Diego Rojas*

## Caso de Uso 1: Gestion de inventario de bicicletas.

Este caso de uso describe cómo el sistema gestiona el inventario de bicicletas, permitiendo agregar nuevas bicicletas, actualizar la información existente y eliminar bicicletas que ya no están disponibles.

#### Agregar nueva bicicleta

```sql
CALL add_bike(2, 1750.32, 7);
```

#### Actualizar bicicleta

```sql
CALL update_bike(1, 1999.99, 20)
```

#### Eliminar bicicleta

```sql
CALL delete_bike(1)
```

## Caso de Uso 2: Registro de Ventas

Este caso de uso describe el proceso de registro de una venta de bicicletas, incluyendo la creación de una nueva venta, la selección de las bicicletas vendidas y el cálculo del total de la venta.

#### Añadir venta

```sql
SET @id_sale = 0;
CALL sale_register('100548745', @id_sale);
```

#### Añadir sale details

```sql
CALL sale_detail_register (@id_sale, 2, 1);
CALL sale_detail_register (@id_sale, 1, 1);
```

## caso de Uso 3: Gestion de Proveedores y Repuestos

Este caso de uso describe cómo el sistema gestiona la información de proveedores y repuestos, permitiendo agregar nuevos proveedores y repuestos, actualizar la información existente y eliminar proveedores y repuestos que ya no están activos.

#### Añadir proveedor

```sql
SET @id_supplier = 0;
CALL add_supplier("proveedor nacional de bicicletas", 1, 313023297, 1, "nationalsupplier@gmail.com", 1, @id_supplier);
```

#### añadir respuesto

```sql
SET @id_spare = 0;
CALL add_spare("llanta todoterreno", "llanta hecha para bicicletas de montaña, de 16'", 100, 50, @id_supplier, @id_spare);
```

#### actualizar proveedor

```sql
CALL update_supplier(@id_supplier, "proveedor internacional de bicicletas", 1, "internationalsupplier@gmail.com", 2);
```

#### actualizar repuesto

```sql
CALL update_spare(@id_spare, "llanta bmx", "llanta hecha para bicicletas de bmx, de 12'", 101, 90, @id_supplier);
```

#### eliminar proveedor

```sql
CALL delete_supplier(@id_supplier);
```

#### eliminar repuesto

```sql
CALL delete_spare(@id_spare);
```

## Caso de Uso 4: Consulta de Historial de Ventas por Cliente

Este caso de uso describe cómo el sistema permite a un usuario consultar el historial de ventas de un cliente específico, mostrando todas las compras realizadas por el cliente y los detalles de cada venta.

#### ver ventas 

```sql
SET @id_customer = '100548745';
CALL show_sales(@id_customer);
```

#### detalles de una venta

```sql
CALL show_table_details(1, @id_customer);
```

## Caso de Uso 5: Gestión de Compras de Repuestos

Este caso de uso describe cómo el sistema gestiona las compras de repuestos a
proveedores, permitiendo registrar una nueva compra, especificar los repuestos comprados y actualizar el stock de repuestos.

#### Registrar una compra

```sql
SET @id_purchase = 0;
CALL purchase_register('BMC45485', @id_purchase)
```

#### Registrar detalles de una compra

```sql
CALL purchase_detail_register (@id_purchase, 2, 1);
CALL purchase_detail_register (@id_purchase, 1, 1);
```
# Casos de Uso con Subconsultas

## Caso de Uso 6: Consulta de Bicicletas Más Vendidas por Marca

Este caso de uso describe cómo el sistema permite a un usuario consultar las bicicletas más vendidas por cada marca.

```sql
SELECT marca, modelo
FROM (
    SELECT 
        (SELECT name FROM brands WHERE id_brand = m.id_brand) AS marca,
        m.name AS modelo,
        SUM(sd.quantity) AS total_ventas
    FROM models AS m
    JOIN supplier_model AS sm USING (id_model)
    JOIN bikes AS b USING (id_supplier_model)
    JOIN sale_details AS sd USING (id_bike)
    GROUP BY 
        (SELECT name FROM brands WHERE id_brand = m.id_brand),
        m.name
) AS ventas_por_modelo
WHERE total_ventas = (
    SELECT MAX(subconsulta.total_ventas)
    FROM (
        SELECT 
            (SELECT name FROM brands WHERE id_brand = m_sub.id_brand) AS marca,
            m_sub.name AS modelo,
            SUM(sd_sub.quantity) AS total_ventas
        FROM models AS m_sub
        JOIN supplier_model AS sm_sub USING (id_model)
        JOIN bikes AS b_sub USING (id_supplier_model)
        JOIN sale_details AS sd_sub USING (id_bike)
        GROUP BY 
            (SELECT name FROM brands WHERE id_brand = m_sub.id_brand),
            m_sub.name
    ) AS subconsulta
    WHERE subconsulta.marca = ventas_por_modelo.marca
);
```

## Caso de Uso 7: Clientes con Mayor Gasto en un Año Específico

Este caso de uso describe cómo el sistema permite consultar los clientes que han gastado más en un año específico.

```sql
SELECT id_customer, nombre, total_gastado
FROM (
  SELECT c.id_customer,
  CONCAT(c.first_name, ' ', c.last_name) AS nombre, 
  (SELECT SUM(total)
  FROM sales s
  WHERE s.id_customer = c.id_customer
  AND YEAR(s.date) = 2024) AS total_gastado
  FROM customers AS c
) subquery
WHERE total_gastado IS NOT NULL
ORDER BY total_gastado DESC;
```

## Caso de Uso 8: Proveedores con Más Compras en el Último Mes

Este caso de uso describe cómo el sistema permite consultar los proveedores que han recibido más compras en el último mes.

```sql
SELECT id_supplier, proveedor, contacto, compras
FROM (
  SELECT s.id_supplier,
  s.name AS proveedor,
  (SELECT CONCAT(first_name, ' ', middle_name)
  FROM contacts
  WHERE id_contact = s.id_contact) AS contacto,
  (SELECT COUNT(*)
  FROM purchases
  WHERE id_supplier = s.id_supplier
  AND MONTH(date) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))) AS compras
  FROM suppliers s
) subquery
WHERE compras > 0
ORDER BY compras DESC;
```

## Caso de Uso 9: Repuestos con Menor Rotación en el Inventario

Este caso de uso describe cómo el sistema permite consultar los repuestos que han tenido menor rotación en el inventario, es decir, los menos vendidos.

```sql
SELECT s.name, s.price, s.stock,
  (SELECT COUNT(id_spare)
  FROM purchase_details pd
  WHERE pd.id_spare = s.id_spare) AS 'Veces comprado'
FROM spares s
ORDER BY 'Veces comprado' ASC;
```
## Caso de Uso 10: Ciudades con Más Ventas Realizadas

Este caso de uso describe cómo el sistema permite consultar las ciudades donde se han realizado más ventas de bicicletas.

```sql
SELECT name,  ventas
FROM (
    SELECT c.name,
    (SELECT COUNT(*)
    FROM sales 
    WHERE id_customer IN (
        SELECT id_customer
        FROM customers 
        WHERE id_city = c.id_city 
    )) AS ventas
    FROM cities AS c
    ) AS ciudad_ventas
ORDER BY ventas DESC;
```

# Casos de Uso con JOINS

## Caso de Uso 11: Consulta de Ventas por Ciudad

Este caso de uso describe cómo el sistema permite consultar el total de ventas realizadas en cada ciudad.

```sql
SELECT c.name, COUNT(s.id_sale) AS ocurrencias
FROM cities AS c
JOIN customers AS cu USING(id_city)
JOIN sales AS s USING(id_customer)
GROUP BY c.id_city, c.name
ORDER BY ocurrencias DESC;
```

## Caso de Uso 12: Consulta de Proveedores por País

Este caso de uso describe cómo el sistema permite consultar los proveedores agrupados por país.

```sql
SELECT c.name AS pais, COUNT(s.id_supplier) AS ocurrencias, GROUP_CONCAT(s.name ORDER BY s.name ASC SEPARATOR ', ') AS proveedores
FROM countries AS c
LEFT JOIN cities AS ci USING (id_country)
LEFT JOIN suppliers AS s USING (id_city)
GROUP BY c.id_country, c.name
ORDER BY numero_de_proveedores DESC, c.name ASC;
```

## Caso de Uso 13: Compras de Repuestos por Proveedor

Este caso de uso describe cómo el sistema permite consultar el total de repuestos
comprados a cada proveedor.

```sql
SELECT s.id_supplier, s.name AS proveedor, SUM(pd.quantity) AS repuestos_comprados
FROM suppliers AS s
JOIN purchases AS p USING(id_supplier)
JOIN purchase_details AS pd USING(id_purchase)
GROUP BY s.id_supplier, s.name
ORDER BY repuestos_comprados DESC
```

## Caso de Uso 14: Clientes con Ventas en un Rango de Fechas

Este caso de uso describe cómo el sistema permite consultar los clientes que han
realizado compras dentro de un rango de fechas específico.

```sql
SELECT c.id_customer, CONCAT(c.first_name, ' ', c.middle_name), c.email
FROM customers AS c
JOIN sales AS s USING(id_customer)
WHERE s.date BETWEEN '2024-07-01' AND '2024-08-01'
```

# Casos de Uso para Implementar Procedimientos Almacenados

## Caso de Uso 1: Actualización de Inventario de Bicicletas

Este caso de uso describe cómo el sistema actualiza el inventario de bicicletas cuando se realiza una venta.

```sql
CREATE PROCEDURE IF NOT EXISTS sale_register(IN id_customer_ns VARCHAR(50), OUT id_sale_out INT)
BEGIN 
    INSERT INTO sales(id_customer)
    VALUES (id_customer_ns);

    SELECT LAST_INSERT_ID() INTO id_sale_out;
END $$

CREATE PROCEDURE IF NOT EXISTS sale_details_register(IN id_sale_nsd INT, IN id_bike_nsd INT, IN quantity_nsd INT)
BEGIN
    INSERT INTO sale_details(id_sale, id_bike, quantity)
    VALUES (id_sale_nsd, id_bike_nsd, quantity_nsd);
END $$

SET @id_sale = 0;
CALL sale_register('100548745', @id_sale);
CALL purchase_detail_register (@id_purchase, 2, 1);
CALL purchase_detail_register (@id_purchase, 1, 1);
```

## Caso de Uso 2: Registro de Nueva Venta

Este caso de uso describe cómo el sistema registra una nueva venta, incluyendo la creación de la venta y la inserción de los detalles de la venta.

```sql
CREATE PROCEDURE IF NOT EXISTS sale_register(IN id_customer_ns VARCHAR(50), OUT id_sale_out INT)
BEGIN 
    INSERT INTO sales(id_customer)
    VALUES (id_customer_ns);

    SELECT LAST_INSERT_ID() INTO id_sale_out;
END $$

CREATE PROCEDURE IF NOT EXISTS sale_details_register(IN id_sale_nsd INT, IN id_bike_nsd INT, IN quantity_nsd INT)
BEGIN
    INSERT INTO sale_details(id_sale, id_bike, quantity)
    VALUES (id_sale_nsd, id_bike_nsd, quantity_nsd);
END $$

SET @id_sale = 0;
CALL sale_register('100548745', @id_sale);
CALL purchase_detail_register (@id_purchase, 2, 1);
CALL purchase_detail_register (@id_purchase, 1, 1);
```

## Caso de Uso 3: Generación de Reporte de Ventas por Cliente

Este caso de uso describe cómo el sistema genera un reporte de ventas para un cliente específico, mostrando todas las ventas realizadas por el cliente y los detalles de cada venta.

```sql
DELIMITER $$
CREATE PROCEDURE see_customer_sales(IN id_customer_in VARCHAR(50))
BEGIN
    DECLARE customer_exists INT;
    
    SELECT COUNT(*) INTO customer_exists 
    FROM customers 
    WHERE id_customer = id_customer_in;
    
    IF customer_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente no encontrado';
    ELSE
        SELECT 
            s.id_sale, 
            s.date AS sale_date,
            m.name AS bike_model, 
            b.price AS unit_price,
            sd.quantity, 
            (sd.quantity * b.price) AS subtotal,
            s.total AS total_sale
        FROM sales AS s
        JOIN customers AS c USING(id_customer)
        JOIN sale_details AS sd USING (id_sale)
        JOIN bikes AS b USING (id_bike)
        JOIN supplier_model USING (id_supplier_model)
        JOIN models AS m USING (id_model)
        WHERE c.id_customer = id_customer_in
        ORDER BY s.id_sale, m.name;
    END IF;
END $$
DELIMITER ;

CALL see_customer_details('100548745');
```

## Caso de Uso 4: Registro de Compra de Repuestos

Este caso de uso describe cómo el sistema registra una nueva compra de repuestos a un proveedor.

```sql
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS purchase_register(IN id_supplier_ns VARCHAR(50), OUT id_purchase_out INT)
BEGIN 
    INSERT INTO purchases(id_supplier)
    VALUES (id_supplier_ns);

    SELECT LAST_INSERT_ID() INTO id_purchase_out;
END $$

CREATE PROCEDURE IF NOT EXISTS purchase_details_register(IN id_purchase_nsd INT, IN id_spare_nsd INT, IN quantity_nsd INT)
BEGIN
    INSERT INTO purchase_details(id_purchase, id_spare, quantity)
    VALUES (id_purchase_nsd, id_spare_nsd, quantity_nsd);
END $$
DELIMITER ;

SET @id_purchase = 0;
CALL purchase_register('BMC45485', @id_purchase)
CALL purchase_detail_register (@id_purchase, 2, 1);
CALL purchase_detail_register (@id_purchase, 1, 1);
```

## Caso de Uso 5: Generación de Reporte de Inventario

Este caso de uso describe cómo el sistema genera un reporte de inventario de bicicletas y repuestos.

```sql
DELIMITER $$
DELIMITER $$
CREATE PROCEDURE bike_spare_report()
BEGIN
    SELECT 'Reporte de Inventario de Bicicletas' AS report_type;
    SELECT 
        b.id_bike AS 'ID Bicicleta',
        m.name AS Modelo,
        br.name AS Marca,
        b.price AS Precio,
        IF (stock = 0, 'sin stock', stock) AS stock
    FROM bikes AS b
    JOIN supplier_model AS sm USING (id_supplier_model)
    JOIN models AS m USING (id_model)
    JOIN brands AS br USING (id_brand)
    ORDER BY br.name, m.name;

    SELECT 'Reporte de Inventario de Repuestos' AS report_type;
    SELECT 
        s.id_spare AS 'ID Repuesto',
        s.name AS Nombre,
        s.description AS Descripción,
        s.price AS Precio,
        IF (stock = 0, 'sin stock', stock) AS stock
    FROM spares AS s
    ORDER BY s.name;
END $$
DELIMITER ;

CALL bike_spare_report();
```

## Caso de Uso 6: Actualización Masiva de Precios

Este caso de uso describe cómo el sistema permite actualizar masivamente los precios de todas las bicicletas de una marca específica.

```sql
DELIMITER $$
CREATE PROCEDURE increase_brand_prices(IN id_brand_in INT, IN increase DECIMAL(10,2))
BEGIN
  UPDATE bikes 
  SET price = price * (1 + increase/100)
  WHERE id_supplier_model IN (
    SELECT sm.id_supplier_model 
    FROM suppliers_model AS sm
    JOIN models USING(id_model)
    JOIN brands AS b USING(id_brand)
    WHERE b.id_brand = id_brand_in
  );
END $$

CALL increase_brand_prices(1, 20)
DELIMITER ;
```

## Caso de Uso 7: Generación de Reporte de Clientes por Ciudad

Este caso de uso describe cómo el sistema genera un reporte de clientes agrupados por ciudad.

```sql
DELIMITER $$
CREATE PROCEDURE customers_group_by_city ()
BEGIN 
  SELECT c.id_city, c.name AS ciudad, COUNT(cu.id_customer)
  FROM cities
  JOIN customers USING(id_city)
  GROUP BY c.id_city, c.name
  ORDER BY c.id_city;
END $$
DELIMITER ;
```

## Caso de Uso 8: Verificación de Stock antes de Venta

Este caso de uso describe cómo el sistema verifica el stock de una bicicleta antes de permitir la venta.

```sql
CREATE TRIGGER IF NOT EXISTS after_insert_sale_details
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
```

## Caso de Uso 9: Registro de Devoluciones

Este caso de uso describe cómo el sistema registra la devolución de una bicicleta por un cliente.

```sql
DELIMITER $$
CREATE PROCEDURE refund_bike (IN id_bike_in INT, IN id_customer_in VARCHAR(50), IN id_sale_in INT )
BEGIN
  INSERT INTO refunds(id_customer, id_bike, id_sale)
  VALUES (id_customer_in, id_bike_in, id_sale_in);
  
  UPDATE bikes 
  SET stock = stock + 1
  WHERE id_bike = id_bike_in
END
DELIMITER ;
```

## Caso de Uso 10: Generación de Reporte de Compras por Proveedor

Este caso de uso describe cómo el sistema genera un reporte de compras realizadas a un proveedor específico, mostrando todos los detalles de las compras.

```sql
DELIMITER $$
CREATE PROCEDURE see_supplier_buys(IN id_supplier_in VARCHAR(50))
BEGIN
    DECLARE supplier_exists INT;
    
    SELECT COUNT(*) INTO supplier_exists 
    FROM supplier 
    WHERE id_supplier = id_supplier_in;
    
    IF supplier_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Proveedor no encontrado';
    ELSE
        SELECT 
            p.id_purchase,
            p.date AS fecha_compra,
            s.name AS nombre_repuesto,
            s.price AS precio_repuesto
            pd.quantity AS cantidad_comprada,
            (s.price * pd.quantity) AS subtotal,
            p.total AS total_compre
        FROM purchases AS p
        JOIN suppliers AS su USING(id_supplier)
        JOIN purchase_details AS pd USING(id_purchase)
        JOIN spares AS s USING (id_spare)
        WHERE su.id_supplier = id_supplier_in
        ORDER BY p.id_purchase;
    END IF;
END $$
DELIMITER ;
```

## Caso de Uso 11: Calculadora de Descuentos en Ventas

Este caso de uso describe cómo el sistema aplica un descuento a una venta antes de registrar los detalles de la venta.

```sql
DELIMITER $$
CREATE PROCEDURE sale_discount (IN id_customer_in VARCHAR(50), IN id_bike_in INT, IN quantity_in INT, IN discount DECIMAL(10,2))
BEGIN 
  DECLARE last_id_sale INT;

  IF quantity_in > 100 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'discount cant be over 100%'
  END IF;

  
  INSERT INTO sales(id_customer)
  VALUES (id_customer_in);

  SELECT LAST_INSERT_ID() INTO last_id_sale;

  INSERT INTO sale_details(id_sale, id_bike, quantity)
  VALUES (last_id_sale, id_bike_in, quantity_in);

  UPDATE sales
  SET total = (total * (1 - discount / 100))
END $$
DELIMITER ;
```

# Casos de Uso para Funciones de Resumen

## Caso de Uso 1: Calcular el Total de Ventas Mensuales

Este caso de uso describe cómo el sistema calcula el total de ventas realizadas en un mes específico.

```sql
```

## Caso de Uso 2: Calcular el Promedio de Ventas por Cliente

Este caso de uso describe cómo el sistema calcula el promedio de ventas realizadas por un cliente específico.

```sql
```

## Caso de Uso 3: Contar el Número de Ventas Realizadas en un Rango de Fechas

Este caso de uso describe cómo el sistema cuenta el número de ventas realizadas dentro de un rango de fechas específico.

```sql
```

## Caso de Uso 4: Calcular el Total de Repuestos Comprados por Proveedor

Este caso de uso describe cómo el sistema calcula el total de repuestos comprados a un proveedor específico.

```sql
```

## Caso de Uso 5: Calcular el Ingreso Total por Año

Este caso de uso describe cómo el sistema calcula el ingreso total generado en un año específico.

```sql
```
ahorita guarda y hace el pull request
## Caso de Uso 6: Calcular el Número de Clientes Activos en un Mes

Este caso de uso describe cómo el sistema cuenta el número de clientes que han
realizado al menos una compra en un mes específico.

```sql
```
