# Taller practico SQL2

*Jhon Arley Roa*
*Juan Diego Rojas*

## Caso de Uso 1: Gestion de inventario de bicicletas.

Este caso de uso describe cómo el sistema gestiona el inventario de bicicletas,
permitiendo agregar nuevas bicicletas, actualizar la información existente y eliminar bicicletas que
ya no están disponibles.

#### Agregar nueva bicicleta

```sql
DELIMITER //
CREATE PROCEDURE add_bike (IN id_model_nb INT, IN price_nb DECIMAL(10,2), IN stock_nb INT, OUT NULL)
BEGIN
    INSERT INTO bikes (id_model, price, stock)
    VALUES (id_model_nb, precio_nb, stock_nb);
END //
DELIMITER ;
```

#### Actualizar bicicleta

```sql
DELIMITER //
CREATE PROCEDURE update_bike (IN id_bike)
UPDATE bikes SET price = newPrice, stock = newStock
WHERE id_bike = idACambiar,
SELECT "Ha sido actualizada la bici";
```

#### Eliminar bicicleta

```sql

```

```sql

```
