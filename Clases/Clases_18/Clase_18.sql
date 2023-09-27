#1
DELIMITER //
CREATE FUNCTION ObtenerCantCopias(pelicula_id INT, tienda_id INT) RETURNS INT
NO SQL
BEGIN
    DECLARE cantidad INT;
    
    SELECT COUNT(*) INTO cantidad
    FROM inventory AS inv
    INNER JOIN film AS f ON inv.film_id = f.film_id
    WHERE (f.film_id = pelicula_id OR f.title = pelicula_id) AND inv.store_id = tienda_id;
    
    RETURN cantidad;
END //
DELIMITER ;


#2
DELIMITER //
CREATE PROCEDURE ObtenerClientesPais(IN pais VARCHAR(40), OUT lista_clientes VARCHAR(2000))
BEGIN
    DECLARE hecho INT DEFAULT 0;
    DECLARE nombre_cliente VARCHAR(30);
    DECLARE apellido_cliente VARCHAR(30);
    DECLARE cliente_cursor CURSOR FOR
        SELECT first_name, last_name
        FROM customer
        WHERE country = pais;
    
    SET lista_clientes = '';

    OPEN cliente_cursor;
    
    read_loop: LOOP
        FETCH cliente_cursor INTO nombre_cliente, apellido_cliente;
        
        IF hecho = 1 THEN
            LEAVE read_loop;
        END IF;
        
        SET lista_clientes = CONCAT(lista_clientes, nombre_cliente, ' ', apellido_cliente, ';');
    END LOOP;

    CLOSE cliente_cursor;
    
    IF lista_clientes <> '' THEN
        SET lista_clientes = LEFT(lista_clientes, LENGTH(lista_clientes) - 1);
    END IF;
    
END //
DELIMITER ;

#3
/* 
INVENTORY STOCK

La función "inventory_en_stock" se utiliza para verificar si una película específica está 
actualmente en stock en una tienda determinada. 
Esta función devuelve un valor booleano, 1 si hay copias 
en stock de la película en la tienda y 0 si no hay copias disponibles.

Ejemplo de uso:
SELECT inventory_en_stock(1, 2);


FILM STOCK

El procedimiento "film_in_stock" se utiliza para devolver un conjunto de 
resultados que muestra las películas en stock en una tienda específica. 
Toma como parámetro la identificación de la tienda y utiliza un cursor para recorrer 
el inventario y devolver información sobre las películas en stock en esa tienda.

Ejemplo de uso:
CALL film_in_stock(2);
*/