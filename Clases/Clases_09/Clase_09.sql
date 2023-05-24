use sakila;

#1
select c.country, c.country_id,  COUNT(ci.city_id) as ciudades
from country c
inner join city  ci on c.country_id = ci.country_id
group by c.country_id, c.country
order by c.country_id, c.country;

#2
select c.country,   COUNT(ci.city_id) as ciudades
from country c
inner join city  ci on c.country_id = ci.country_id
group by  c.country
having count(ci.city_id) > 10
order by ciudades desc;

#3
select concat(c.first_name, " ", c.last_name) as nombre, a.address, (select count(*) from rental r where c.customer_id = r.customer_id) as "Peliculas rentadas",
(select sum(p.amount) from payment p where c.customer_id = p.customer_id) as Dinerogastado
from customer c
join address a on c.address_id = a.address_id
group by c.first_name, c.last_name, a.address, c.customer_id
order by Dinerogastado desc;

#4
select c.name , avg(f.length) as DuracionPromedio 
from film f join film_category fc on fc.film_id = f.film_id 
join category c on fc.category_id = c.category_id
group by c.name
order by DuracionPromedio DESC;

#5
select f.rating, COUNT(p.payment_id) as Ventas
from film f
join inventory i on i.film_id = f.film_id
join rental r on r.inventory_id = i.inventory_id
join payment p on p.rental_id = r.rental_id 
group by rating
order by Ventas desc;