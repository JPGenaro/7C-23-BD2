#1
INSERT INTO sakila.customer
(store_id, first_name, last_name, email, address_id, active)
SELECT 1, 'Teoooooooooooooooo', 'Reynaaaa', 'elprofemaskapo3000@gmail.com', MAX(a.address_id), 1
FROM address a
WHERE (SELECT c.country_id
		FROM country c, city c1
		WHERE c.country = "United States"
		AND c.country_id = c1.country_id
		AND c1.city_id = a.city_id);
		

SELECT *
FROM customer
WHERE last_name = "Reynaaaa";

#2
INSERT INTO sakila.rental
(rental_date, inventory_id, customer_id, return_date, staff_id)
SELECT CURRENT_TIMESTAMP, 
		(SELECT MAX(r.inventory_id)
		 FROM inventory r
		 INNER JOIN film USING(film_id)
		 WHERE film.title = "ARABIA DOGMA" -- Put film here
		 LIMIT 1), 
		 600, -- Put user here (in this case is the previous one insterted in excersise 1
		 NULL,
		 (SELECT staff_id
		  FROM staff
		  INNER JOIN store USING(store_id)
		  WHERE store.store_id = 2
		  LIMIT 1);

#3
UPDATE sakila.film
SET release_year='2001'
WHERE rating = "G";

UPDATE sakila.film
SET release_year='2005'
WHERE rating = "PG";

UPDATE sakila.film
SET release_year='2010'
WHERE rating = "PG-13";

UPDATE sakila.film
SET release_year='2015'
WHERE rating = "R";

UPDATE sakila.film
SET release_year='2020'
WHERE rating = "NC-17";

#4
SELECT rental_id, rental_rate, customer_id, staff_id
FROM film
INNER JOIN inventory USING(film_id)
INNER JOIN rental USING(inventory_id)
WHERE rental.return_date IS NULL
LIMIT 1;

UPDATE sakila.rental
SET  return_date=CURRENT_TIMESTAMP
WHERE rental_id=11496;

#5
/* El fragmento de código realiza una serie de operaciones DELETE en varias tablas 
para eliminar una película y todos sus registros relacionados:

Se eliminan los registros de la tabla "payment" que están asociados con los alquileres de la película a eliminar.
Se eliminan los registros de la tabla "rental" que corresponden a los alquileres de la película.
Se eliminan los registros de la tabla "inventory" que están relacionados con los inventarios de la película.
Se eliminan los registros de la tabla "film_actor" que relacionan actores con la película.
Se eliminan los registros de la tabla "film_category" que relacionan categorías con la película.
Finalmente, se elimina el registro de la tabla "film" que representa la película en sí. */

DELETE FROM payment
 WHERE rental_id IN (SELECT rental_id 
                       FROM rental
                      INNER JOIN inventory USING (inventory_id) 
                      WHERE film_id = 1);
 
DELETE FROM rental
 WHERE inventory_id IN (SELECT inventory_id 
                         FROM inventory
                        WHERE film_id = 1);
                        
DELETE FROM inventory WHERE film_id = 1;

DELETE film_actor FROM film_actor WHERE film_id = 1;

DELETE film_category FROM film_category WHERE film_id = 1;

DELETE film FROM film WHERE film_id = 1;

#6
SELECT inventory_id
FROM inventory
WHERE inventory_id NOT IN (
    SELECT inventory_id
    FROM rental
    WHERE return_date IS NULL
)
LIMIT 1;
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (NOW(), 100, 1, NULL, 2);
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (NOW(), 100, 1, NULL, 2);
