use sakila;

-- Write a query to display for each store its store ID, city, and country.

select store_id, city, country
from sakila.store s
join sakila.address a
on  s.address_id = a.address_id
join sakila.city c 
on a.city_id = c.city_id
join sakila.country co 
on c.country_id  = co.country_id 
group by store_id; 

-- Write a query to display how much business, in dollars, each store brought in.
select st.store_id, sum(amount) as 'Total Business'
from sakila.store s 
join sakila.staff st
on s.store_id = st.store_id 
join sakila.payment p 
on st.staff_id = p.staff_id
group by store_id ;


-- Which film categories are longest?

select category_id, `length` 
from sakila.film_category fc 
join sakila.film f 
on fc.film_id = f.film_id 
group by `length`
order by `length` desc;

select category_id, avg(`length`) 
from sakila.film_category fc 
join sakila.film f 
on fc.film_id = f.film_id 
group by category_id
order by avg(`length`) desc;



-- Display the most frequently rented movies in descending order.
select film_id, title, rental_rate 
from sakila.film f 
order by rental_rate desc;

-- List the top five genres in gross revenue in descending order.

SELECT
c.name AS ' Film Category'
, SUM(p.amount) AS 'Total Sales'
FROM sakila.payment p
INNER JOIN sakila.rental r ON p.rental_id = r.rental_id
INNER JOIN sakila.inventory i ON r.inventory_id = i.inventory_id
INNER JOIN sakila.film f ON i.film_id = f.film_id
INNER JOIN sakila.film_category fc ON f.film_id = fc.film_id
INNER JOIN sakila.category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY 'Total Sales' desc limit 5;

-- Is "Academy Dinosaur" available for rent from Store 1?

select f.title, s.store_id
from sakila.film f 
join sakila.inventory i 
on f.film_id  = i.film_id
join sakila.store s
on i.store_id = s.store_id 
where f.title = 'Academy Dinosaur'
group by store_id;

-- Get all groups of actors that worked together.

select A1.actor_id, A1.first_name, A1.last_name,
A2.actor_id, A2.first_name, A2.last_name,
A1.film_id, A1.title 
from
(select a.actor_id, a.first_name, a.last_name, fa.film_id, f.title
from sakila.actor a
join sakila.film_actor fa 
on a.actor_id  =  fa.actor_id
join sakila.film f 
on f.film_id  = fa.film_id) as A1
join
(select a.actor_id, a.first_name, a.last_name, fa.film_id, f.title
from sakila.actor a
join sakila.film_actor fa 
on a.actor_id  =  fa.actor_id
join sakila.film f 
on fa.film_id  = f.film_id) as A2
on A1.film_id = A2.film_id
where A1.actor_id <> A2.actor_id and A1.film_id = A2.film_id
group by A1.film_id, A1.actor_id, A2.actor_id;


-- Get all pairs of customers that have rented the same film more than 3 times.

select T1.customer_id, T2.customer_id, T1.inventory_id, T1.film_id, T1.title, T1.TimesRented
from 
(select rental.customer_id, inventory.inventory_id, inventory.film_id, film.title, count(inventory.film_id) as 'TimesRented'
from rental
join inventory 
on rental.inventory_id = inventory.inventory_id
join film 
on inventory.film_id = film.film_id
join customer 
on customer.customer_id  = rental.customer_id) as T1
join 
(select rental.customer_id, inventory.inventory_id, inventory.film_id, film.title, count( inventory.film_id) as 'Times Rented'
from rental
join inventory 
on rental.inventory_id = inventory.inventory_id
join film 
on inventory.film_id = film.film_id
join customer 
on customer.customer_id  = rental.customer_id) as T2
where T1.film_id = T2.film_id
group by T1.customer_id, T2.customer_id;
-- I don´t know where to go from here to be quite honest.

-- For each film, list actor that has acted in more films.
select tab1.actor_id, tab1.first_name, tab1.last_name, tab1.film_id, tab1.title
from
(select actor.actor_id, actor.first_name, actor.last_name, film.film_id, film.title 
from film 
join film_actor
on film.film_id = film_actor.film_id 
join actor 
on film_actor.actor_id = actor.actor_id) as tab1
join
(select actor.actor_id, actor.first_name, actor.last_name, film.film_id, film.title 
from film 
join film_actor
on film.film_id = film_actor.film_id 
join actor 
on film_actor.actor_id = actor.actor_id) as tab2
where tab1.actor_id = tab2.actor_id and tab1.film_id <> tab2.film_id
group by tab1.film_id, tab1.actor_id
order by tab1.film_id;



