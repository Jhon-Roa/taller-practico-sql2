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
CALL sale_register(1, @id_sale);
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