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
CALL sale_register(1, @id_sale);
```

#### Añadir sale details

```sql
CALL sale_detail_register (@id_sale, 2, 1);
CALL sale_detail_register (@id_sale, 1, 1);
```

## caso de Uso 3: Gestion de Proveedores y Repuestos

Este caso de uso describe cómo el sistema gestiona la información de proveedores y repuestos, permitiendo agregar nuevos proveedores y repuestos, actualizar la información existente y eliminar proveedores y repuestos que ya no están activos.

s