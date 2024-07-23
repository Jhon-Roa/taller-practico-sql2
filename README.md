# Taller practico SQL2

*Jhon Arley Roa*
*Juan Diego Rojas*

## Caso de Uso 1: Gestion de inventario de bicicletas.

Este caso de uso describe cómo el sistema gestiona el inventario de bicicletas,
permitiendo agregar nuevas bicicletas, actualizar la información existente y eliminar bicicletas que
ya no están disponibles.

#### Agregar nueva bicicleta

```
INSERT INTO bikes (id_model, price, stock)
VALUES (id_model, precio, stock);
```

#### Actualizar bicicleta

```
UPDATE bikes SET price = newPrice, stock = newStock
WHERE id_bike = idACambiar,
SELECT "Ha sido actualizada la bici";
```

#### Eliminar bicicleta

```

```
