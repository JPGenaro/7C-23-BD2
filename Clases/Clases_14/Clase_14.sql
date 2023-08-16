#1
SELECT CONCAT(c.first_name, ' ', c.last_name) AS nombre_completo,
       a.address AS direccion,
       city.city AS ciudad
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ON a.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Argentina';

#2
SELECT film.title AS titulo_pelicula,
       language.name AS idioma,
       CASE
           WHEN film.rating = 'G' THEN 'General Audience (G) - All Ages Admitted'
           WHEN film.rating = 'PG' THEN 'Parental Guidance Suggested (PG) - Some Material May Not Be Suitable for Children'
           WHEN film.rating = 'PG-13' THEN 'Parents Strongly Cautioned (PG-13) - Some Material May Be Inappropriate for Children Under 13'
           WHEN film.rating = 'R' THEN 'Restricted (R) - Restricted to Viewers Over 17 or 18 (varies by jurisdiction)'
           WHEN film.rating = 'NC-17' THEN 'Adults Only (NC-17) - No One 17 and Under Admitted'
           ELSE 'Not Rated'
       END AS clasificacion
FROM film
JOIN language ON film.language_id = language.language_id;

#3
SELECT film.title AS titulo_pelicula,
       film.release_year AS ano_estreno
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE CONCAT(actor.first_name, ' ', actor.last_name) LIKE 'Ricardo Ford';

#4
SELECT film.title AS titulo_pelicula,
       CONCAT(customer.first_name, ' ', customer.last_name) AS nombre_cliente,
       IF(rental.return_date IS NOT NULL, 'Sí', 'No') AS devuelto
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN customer ON rental.customer_id = customer.customer_id
WHERE MONTH(rental.rental_date) IN (5, 6);

#5
/* La función CAST se utiliza para convertir un valor de un tipo de dato a otro. 
La sintaxis general es: CAST(expresion AS tipo_de_dato). 
Aquí, expresion es el valor que deseas convertir, y tipo_de_dato es el tipo de dato al que deseas convertirlo. 
*/
SELECT film_id, title, CAST(release_year AS CHAR) AS release_year_char
FROM film;

/* La función CONVERT es similar a CAST y se usa para la conversión de tipos de datos en SQL. 
Sin embargo, la sintaxis puede variar entre diferentes sistemas de gestión de bases de datos.
En algunos sistemas, como Microsoft SQL Server, CONVERT se utiliza con una sintaxis similar a CAST, 
pero en otros sistemas, como MySQL, su sintaxis es más flexible y versátil.
*/
SELECT film_id, title, CONVERT(price, UNSIGNED) AS price_integer
FROM film;

#6
/* NVL:
La función NVL es específica de Oracle. Se utiliza para reemplazar un valor nulo por un valor predeterminado 
en una expresión. La sintaxis general es: NVL(expresion, valor_predeterminado).

ISNULL:
La función ISNULL es específica de Microsoft SQL Server. Devuelve el primer valor si no es nulo, de lo contrario, 
devuelve el segundo valor. La sintaxis es: ISNULL(expresion, valor_si_nulo).

IFNULL:
La función IFNULL es específica de MySQL. Devuelve el primer valor si no es nulo, de lo contrario, 
devuelve el segundo valor. La sintaxis es: IFNULL(expresion, valor_si_nulo).

COALESCE:
La función COALESCE es más estándar y está presente en varios sistemas de gestión de bases de datos, 
incluido PostgreSQL. Devuelve el primer valor no nulo de la lista de argumentos. La sintaxis es: 
COALESCE(valor1, valor2, ..., valorN).

*/

#Ejemplo de NVL
SELECT NVL(column_name, 'Valor Predeterminado') FROM table_name;

#Ejemplo de IsNull
SELECT ISNULL(column_name, 'Valor Si Nulo') FROM table_name;

#Ejemplo de IfNull
SELECT IFNULL(column_name, 'Valor Si Nulo') FROM table_name;

#Ejemplo de Coalesce
SELECT COALESCE(column_name1, column_name2, 'Valor Si Todos Son Nulos') FROM table_name;
