#1
CREATE OR REPLACE VIEW list_of_customers AS
SELECT
    c.customer_id AS 'Identificación del cliente',
    CONCAT(c.first_name, ' ', c.last_name) AS 'Nombre completo del cliente',
    a.address AS 'DIRECCIÓN',
    a.postal_code AS 'Código postal',
    a.phone AS 'Teléfono',
    ci.city AS 'Ciudad',
    co.country AS 'País',
    CASE c.active
        WHEN 1 THEN 'activa'
        ELSE 'inactiva'
    END AS 'Estado',
    c.store_id AS 'Identificación de la tienda'
FROM
    customer c
    JOIN address a ON c.address_id = a.address_id
    JOIN city ci ON a.city_id = ci.city_id
    JOIN country co ON ci.country_id = co.country_id;
    
#2
CREATE OR REPLACE VIEW detalles_pelicula AS
SELECT
    f.film_id AS 'Identificación de la película',
    f.title AS 'Título',
    f.description AS 'Descripción',
    GROUP_CONCAT(DISTINCT c.name) AS 'Categoría',
    f.rental_rate AS 'Precio',
    f.length AS 'Duración',
    f.rating AS 'Calificación',
    GROUP_CONCAT(DISTINCT a.first_name, ' ', a.last_name) AS 'Actores'
FROM
    film f
    LEFT JOIN film_category fc ON f.film_id = fc.film_id
    LEFT JOIN category c ON fc.category_id = c.category_id
    LEFT JOIN film_actor fa ON f.film_id = fa.film_id
    LEFT JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id, f.title, f.description, f.rental_rate, f.length, f.rating;

#3
CREATE OR REPLACE VIEW sales_by_film_category AS
SELECT
    c.name AS 'category',
    SUM(p.amount) AS 'total_rental'
FROM
    category c
    LEFT JOIN film_category fc ON c.category_id = fc.category_id
    LEFT JOIN film f ON fc.film_id = f.film_id
    LEFT JOIN inventory i ON f.film_id = i.film_id
    LEFT JOIN rental r ON i.inventory_id = r.inventory_id
    LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name;

#4
CREATE OR REPLACE VIEW actor_information AS
SELECT
    a.actor_id AS 'Identificación del actor',
    a.first_name AS 'Nombre',
    a.last_name AS 'Apellido',
    COUNT(fa.film_id) AS 'Cantidad de películas'
FROM
    actor a
    LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

/*5
Definición de la vista: La consulta comienza con la creación de una vista llamada actor_info. Una vista es una consulta almacenada que se comporta como una tabla virtual en la base de datos, lo que significa que podemos consultarla como si fuera una tabla real.

Selección de columnas: La sección SELECT selecciona las columnas que queremos mostrar en la vista. Estas columnas son actor_id, first_name, last_name, y film_info.

Recuperación de datos básicos del actor: Las columnas actor_id, first_name, y last_name provienen directamente de la tabla actor. Estos campos representan la identificación del actor, su nombre y su apellido.

Construcción de film_info utilizando GROUP_CONCAT y subconsulta: La parte más compleja de la consulta es la construcción de la columna film_info, que contiene información sobre las películas en las que actuó cada actor, agrupadas por categoría.

Uso de GROUP_CONCAT: La función GROUP_CONCAT se utiliza para concatenar múltiples valores en una sola cadena. En este caso, concatenamos los nombres de las categorías con las películas en las que actuó cada actor.

Subconsulta para obtener películas agrupadas por categoría: La subconsulta se encuentra dentro de la función CONCAT y es responsable de obtener las películas agrupadas por categoría para cada actor.

SELECT GROUP_CONCAT(...) se utiliza para obtener una lista de títulos de películas concatenados para cada categoría.

La subconsulta se encuentra dentro del SELECT, y se utiliza para obtener las películas agrupadas por categoría para un actor específico.

La subconsulta se conecta a tres tablas: film, film_category, y film_actor, utilizando JOIN para obtener información relevante.

El GROUP BY en la subconsulta agrupa los resultados por categoría, lo que permite que la función GROUP_CONCAT produzca una lista de películas para cada categoría.

LEFT JOIN para incluir actores sin películas: La consulta principal utiliza LEFT JOIN para asegurarse de que incluso los actores que no actuaron en ninguna película estén incluidos en la vista con un valor nulo en la columna film_info.

GROUP BY para agrupar por actor: La consulta principal también utiliza GROUP BY para agrupar los resultados por la identificación del actor, el nombre y el apellido. Esto asegura que obtengamos una fila por actor con la información agregada sobre las películas en las que actuaron.
*/

/*6
Las vistas materializadas son una técnica avanzada de bases de datos que permiten almacenar físicamente el resultado de una consulta compleja en una tabla real, lo que proporciona beneficios significativos en términos de rendimiento y eficiencia. En lugar de calcular los resultados de la consulta cada vez que se llama la vista, la vista materializada almacena los datos y los actualiza periódicamente para mantenerlos actualizados.

Descripción:

Las vistas materializadas son una extensión de las vistas normales en bases de datos.
La diferencia clave es que una vista normal solo define una consulta, mientras que una vista materializada almacena los datos resultantes de la consulta en una tabla real.
Una vez que se crea una vista materializada, los datos en la tabla se pueden consultar como si fueran datos de una tabla real, lo que permite obtener resultados más rápidos para consultas complejas o costosas.
¿Por qué se usan?

Mejora del rendimiento: Al almacenar físicamente los resultados de una consulta, las vistas materializadas eliminan la necesidad de ejecutar la consulta cada vez que se solicita la vista, lo que puede ser especialmente beneficioso para consultas complejas y costosas.
Reducción de carga del servidor: Al reducir la necesidad de recalcular los resultados de una consulta cada vez que se accede a la vista, las vistas materializadas disminuyen la carga en el servidor de bases de datos, lo que puede mejorar la escalabilidad y el rendimiento general del sistema.
Soporte para datos agregados: Las vistas materializadas son útiles para mantener datos agregados precalculados, lo que permite obtener resultados rápidos para informes y análisis.
Alternativas:

Índices: Los índices pueden acelerar las consultas al proporcionar una estructura de datos optimizada para la búsqueda rápida de registros. Sin embargo, los índices no son tan flexibles como las vistas materializadas y solo son efectivos para consultas que se ajustan a los patrones de los índices existentes.
Caché de consultas: Algunos sistemas de bases de datos y aplicaciones utilizan cachés de consultas para almacenar en memoria los resultados de las consultas más frecuentes. Sin embargo, los cachés de consultas solo ofrecen mejoras de rendimiento temporales y pueden ocupar mucha memoria.
DBMS donde existen:

Oracle Database: Oracle es uno de los sistemas de gestión de bases de datos más conocidos que admite vistas materializadas. Ofrece una amplia gama de opciones para administrar vistas materializadas, como actualización programada, actualización bajo demanda, etc.
PostgreSQL: PostgreSQL también admite vistas materializadas desde la versión 9.3. Permite crear vistas materializadas y refrescarlas de acuerdo con una programación específica.
Microsoft SQL Server: SQL Server admite vistas materializadas a través de la característica "Indexed Views". Las vistas materializadas indexadas pueden mejorar significativamente el rendimiento de las consultas.
*/

