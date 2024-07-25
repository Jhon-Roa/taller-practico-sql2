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
SELECT b.name, 
  (SELECT m.name 
  FROM models m 
  WHERE m.id_brand = b.id_brand) AS model_name,
  (SELECT SUM(sd.quantity)
  FROM models m
  JOIN supplier_model sm ON m.id_model = sm.id_model
  JOIN bikes bk ON sm.id_supplier_model = bk.id_supplier_model
  JOIN sales_details sd ON bk.id_bike = sd.id_bike
  WHERE m.id_brand = b.id_brand) AS total_quantity
FROM brands b;
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
  FROM customers c
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
GROUP BY s.id_supplier, proveedor
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

```

## Caso de Uso 4: Registro de Compra de Repuestos

Este caso de uso describe cómo el sistema registra una nueva compra de repuestos a un proveedor.

```sql
```

## Caso de Uso 5: Generación de Reporte de Inventario

Este caso de uso describe cómo el sistema genera un reporte de inventario de bicicletas y repuestos.

```sql
```

## Caso de Uso 6: Actualización Masiva de Precios

Este caso de uso describe cómo el sistema permite actualizar masivamente los precios de todas las bicicletas de una marca específica.

```sql
```

## Caso de Uso 7: Generación de Reporte de Clientes por Ciudad

Este caso de uso describe cómo el sistema genera un reporte de clientes agrupados por ciudad.

```sql
```

## Caso de Uso 8: Verificación de Stock antes de Venta

Este caso de uso describe cómo el sistema verifica el stock de una bicicleta antes de permitir la venta.

```sql
```

## Caso de Uso 9: Registro de Devoluciones

Este caso de uso describe cómo el sistema registra la devolución de una bicicleta por un cliente.

```sql
```

## Caso de Uso 10: Generación de Reporte de Compras por Proveedor

Este caso de uso describe cómo el sistema genera un reporte de compras realizadas a un proveedor específico, mostrando todos los detalles de las compras.

```sql
```

## Caso de Uso 11: Calculadora de Descuentos en Ventas

Este caso de uso describe cómo el sistema aplica un descuento a una venta antes de registrar los detalles de la venta.

```sql
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
