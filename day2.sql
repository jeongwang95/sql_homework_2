-- 1. List all customers who live in Texas (use JOINs)
SELECT customer_id, first_name, last_name
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
WHERE district = 'Texas';

-- using SubQueries
SELECT customer_id, first_name, last_name
FROM customer
WHERE address_id IN (
	SELECT address_id
	FROM address
	WHERE city_id IN (
		SELECT city_id
		FROM city
		WHERE district = 'Texas'
	)
);

-- 2. Get all payments above $6.99 with the Customer's Full Name
SELECT first_name, last_name, amount
FROM customer
INNER JOIN payment
ON customer.customer_id = payment.customer_id
WHERE amount > 6.99;

-- 3. Show all customers names who have made payments over $175
-- (use subqueries)
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 175
);
-- using joins
SELECT customer.customer_id, first_name, last_name, SUM(amount)
FROM customer
INNER JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
HAVING SUM(amount) > 175;

-- 4. List all customers that live in Nepal 
-- (use the city/country table)
-- using join
SELECT customer_id, first_name, last_name
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE country = 'Nepal';

-- using SubQuery
SELECT customer_id, first_name, last_name
FROM customer
WHERE address_id IN (
	SELECT address_id
	FROM address
	WHERE city_id IN (
		SELECT city_id
		FROM city
		WHERE country_id IN (
			SELECT country_id
			FROM country
			WHERE country = 'Nepal'
		)
	)
);

-- 5. Which staff member had the most transactions?
SELECT payment.staff_id, first_name, last_name, COUNT(payment.staff_id) as transactions
FROM payment
INNER JOIN staff
ON payment.staff_id = staff.staff_id
GROUP BY payment.staff_id, first_name, last_name
ORDER BY COUNT(payment.staff_id) DESC
LIMIT 1;

-- 6. How many movies of each rating are there?
SELECT rating, COUNT(film_id)
FROM film
GROUP BY rating;

-- 7. Show all customers who have made a single payment
-- above $6.99 (Use Subqueries)
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	WHERE amount > 6.99
	GROUP BY customer_id
	HAVING COUNT(customer_id) = 1
);

-- using joins
SELECT payment.customer_id, first_name, last_name
FROM customer
INNER JOIN payment
ON customer.customer_id = payment.customer_id
WHERE amount > 6.99
GROUP BY payment.customer_id, first_name, last_name
HAVING COUNT(payment.customer_id) = 1;

-- 8. How many free rentals did our stores give away?
SELECT COUNT(amount) as free_rental_count
FROM payment
WHERE amount = 0;
