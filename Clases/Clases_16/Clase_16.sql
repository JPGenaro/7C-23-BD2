#1
INSERT INTO `employees`(`employeeNumber`, `lastName`, `firstName`, `extension`, `email`, `officeCode`, `reportsTo`, `jobTitle`)
VALUES (2000, 'Nuevo', 'Empleado', 'x1234', NULL, '1', NULL, 'Desarrollador');

#La columna email tiene la restricción NOT NULL, lo que significa que debe contener un valor válido en cada fila.
# Intentar insertar un nuevo empleado con un correo electrónico nulo generará un error y la inserción fallará.

#2
/* CASO 1
En esta consulta, intentas restar 20 de cada valor en la columna employeeNumber. 
Sin embargo, dado que employeeNumber es la clave primaria de la tabla, 
no puedes actualizar valores en esta columna de una manera que cause duplicados o valores negativos. 
Si intentaras restar 20 de cada valor, podrías terminar con valores duplicados y no válidos en la columna.

El resultado de esta consulta depende del estado actual de la tabla y de los valores presentes en 
la columna employeeNumber. Si existen valores duplicados o si los nuevos valores resultantes son inválidos debido 
a la restricción de clave primaria, es probable que la consulta falle con un error.

CASO 2
En esta consulta, intentas sumar 20 a cada valor en la columna employeeNumber. 
Al igual que en el caso anterior, dado que employeeNumber es la clave primaria de la tabla, 
no puedes actualizar valores en esta columna de una manera que cause duplicados.

Si los valores actuales de la columna employeeNumber son únicos y no generan duplicados después de sumarles 20, 
la consulta puede ejecutarse correctamente y actualizará los valores.
*/

#3
ALTER TABLE `employees`
ADD COLUMN `age` INT CHECK (age >= 16 AND age <= 70);

#4
/* 
La integridad referencial en este caso asegura que las relaciones entre estas tablas sean coherentes 
y que no se produzcan referencias a registros inexistentes. Esto significa que:

- Cuando insertas una nueva fila en la tabla `film_actor`, los valores proporcionados para `actor_id` 
y `film_id` deben existir previamente en las tablas `actor` y `film`, respectivamente.
- Si intentas eliminar un registro de la tabla `actor` o `film`, la integridad referencial puede estar 
configurada para realizar ciertas acciones en cascada, como eliminar automáticamente los registros 
correspondientes en la tabla `film_actor`.

En resumen, la integridad referencial en el contexto de las tablas `film`, `actor` 
y `film_actor` en la base de datos Sakila garantiza que las relaciones entre actores y 
películas se mantengan precisas y consistentes, evitando referencias a registros inexistentes y 
asegurando la integridad de los datos.
*/

#5
ALTER TABLE `employees`
ADD COLUMN `lastUpdate` DATETIME DEFAULT NULL,
ADD COLUMN `lastUpdateUser` VARCHAR(50) DEFAULT NULL;
DELIMITER //
CREATE TRIGGER `update_lastUpdate`
BEFORE UPDATE ON `employees`
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = CURRENT_USER();
END;
//
DELIMITER ;

#6
/* Caso 1 
Este disparador actualiza automáticamente la columna last_update en la tabla film_text cada vez 
que se inserta o actualiza una fila en la tabla. El objetivo es mantener un registro de cuándo se realizó 
la última modificación en la descripción de una película.

DELIMITER //
CREATE TRIGGER `update_film_text_last_update`
BEFORE INSERT OR UPDATE ON `film_text`
FOR EACH ROW
BEGIN
    SET NEW.last_update = NOW();
END;
//
DELIMITER ; */

/* Caso 2
Este disparador registra los cambios en la tabla film_text en una tabla de auditoría llamada film_text_audit. 
Cada vez que se inserta, actualiza o elimina una fila en la tabla film_text, 
se registra la operación realizada y los datos anteriores en la tabla de auditoría.

DELIMITER //
CREATE TRIGGER `audit_film_text_changes`
AFTER INSERT OR UPDATE OR DELETE ON `film_text`
FOR EACH ROW
BEGIN
    IF OLD.description != NEW.description OR OLD.title != NEW.title THEN
        INSERT INTO `film_text_audit` (film_id, old_description, new_description, old_title, new_title, action, change_date)
        VALUES (OLD.film_id, OLD.description, NEW.description, OLD.title, NEW.title, 
                CASE
                    WHEN OLD.film_id IS NULL THEN 'INSERT'
                    WHEN NEW.film_id IS NULL THEN 'DELETE'
                    ELSE 'UPDATE'
                END, NOW());
    END IF;
END;
//
DELIMITER ;

*/

