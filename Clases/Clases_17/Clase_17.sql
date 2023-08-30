#1
SET profiling = 1;
SELECT * FROM address WHERE postal_code IN ('45321', '65211');

SELECT * FROM address WHERE postal_code NOT IN ('45321', '65211');

SELECT a.*, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code = '45321';

SET profiling = 0;
SHOW PROFILES;

SET profiling = 1;
CREATE INDEX idx_postal_code ON address (postal_code);
SET profiling = 0;
SHOW PROFILES;

/*  Las consultas que involucran el operador IN, NOT IN y JOIN se beneficiaron del índice, 
ya que la base de datos pudo acceder más eficientemente a los datos necesarios. */

#2
SELECT * FROM actor WHERE first_name = 'John';
SELECT * FROM actor WHERE last_name = 'Smith';
/* Hay diferencia de rendimiento y estas pueden ser algunas razones:
1. Es común que haya un índice en la columna first_name o last_name, 
pero es poco probable que haya índices en ambas columnas al mismo tiempo.
2. Si hay muchos actores con el mismo nombre pero diferentes apellidos (o viceversa), 
una búsqueda puede ser más rápida que la otra debido a la distribución de los datos en la tabla.*/

#3
SELECT * FROM film WHERE description LIKE '%action%';
SELECT * FROM film WHERE MATCH(description) AGAINST('action');

/* Diferencias:
1. El uso de LIKE con patrones de búsqueda de caracteres puede ser más lento en grandes conjuntos de datos,
 ya que necesita escanear todas las filas y comparar caracteres. MATCH...AGAINST es generalmente más rápido 
 en tablas con búsquedas de texto debido a la optimización interna del motor de búsqueda de texto completo.
2. MATCH...AGAINST tiende a ser más preciso en términos de relevancia de la búsqueda. 
Devuelve resultados ordenados por relevancia, lo que es útil cuando deseas mostrar los elementos más 
relevantes primero.
3. LIKE realiza una coincidencia simple basada en patrones de caracteres 
(por ejemplo, %action% busca cualquier descripción que contenga "action" en cualquier lugar).

