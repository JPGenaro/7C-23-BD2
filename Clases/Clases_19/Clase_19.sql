#1
CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY 'pepe1234';

#2
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';

#3
CREATE TABLE relleno (
    id INT PRIMARY KEY,
    nombre VARCHAR(23),
    descripcion VARCHAR(200)
);

# ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'relleno'
# Esto pasa porque este usuario no tiene permisos para crear dicha tabla

#4
SELECT title FROM sakila.film;

UPDATE sakila.film
SET title = 'Dou'
WHERE title = 'ACADEMY DINOSAUR';
#Si me dejo ;)
UPDATE sakila.film
SET title = 'ACADEMY DINOSAUR'
WHERE title = 'Dou';

#5
REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'localhost';
UPDATE sakila.film
SET title = 'Dou'
WHERE title = 'ACADEMY DINOSAUR';

#ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'
# Este usuario no tiene permisos para hacer la operacion
