
--------------------------------------------------------
-- EXERCISES: Answer using the techniques from above. --
--------------------------------------------------------

-- 1. Join the purchases and purchase_items tables, on purchases.id and purchase_items.purchase_id
SELECT * 
FROM purchases JOIN purchase_items
ON purchases.purchase_id = purchase_items.purchase_id;

-- 2. Modify the last query, aliasing purchases as p and purchase_items as pi.
SELECT * 
FROM purchases p JOIN purchase_items pi
ON p.purchase_id = pi.purchase_id;

-- 3. Using the same join, perform a group by to sum the total quantity of items purchased under each user_id.
SELECT user_id, SUM(quantity) FROM purchase_items JOIN purchases ON purchase_items.purchase_id = purchases.purchase_id GROUP BY purchases.user_id;


SELECT user_id, SUM(quantity) FROM purchases p JOIN purchase_items pi ON p.purchase_id = pi.purchase_id group by user_id;


-- 4. Using the same join, find the average purchase amount from each state.

SELECT p.state, AVG(price * quantity)
FROM purchases p JOIN purchase_items pi
ON p.purchase_id = pi.purchase_id
GROUP BY p.state;

-- 5. Join the purchases and users tables, using an alias for each table.
SELECT *
FROM purchases p JOIN users u
ON p.user_id = u.user_id;

-- 6. Using the above join, filter to just the orders with an Gmail email address OR a buyer named 'Clay'
SELECT *
FROM purchases p JOIN users u
ON p.user_id = u.user_id
WHERE email LIKE '%gmail.com' or name LIKE 'Clay %';

----------------------------------------
-- EXTRA CREDIT: If you finish early. --
----------------------------------------

-- 1. Joins can combine more than two tables. Join the users table,  purchases table, and purchase items table. Remember to use aliases.
SELECT * 
FROM users u JOIN purchases p
ON u.user_id = p.user_id
JOIN purchase_items pi
ON p.purchase_id = pi.purchase_id;


--------------------------------------------------------
-- EXERCISES: Answer using the techniques from above. --
--------------------------------------------------------

-- 1. Find the most recent purchase made by each user.
SELECT user_id, MAX(created_at)
FROM purchases
GROUP BY user_id;


-- 2. Which Jeopardy shows had a question worth more than $4000?


-- 3. Find the oldest purchase made by a user with a yahoo email address.
SELECT  * FROM purchases 
WHERE user_id IN (SELECT user_id FROM users
WHERE email LIKE '%@gmail.com')
ORDER BY created_at
LIMIT 1;

-- 4. Find all the users' emails who made at least one purchase from the state of NY.
SELECT * FROM users WHERE user_id IN
(SELECT user_id FROM purchases WHERE state = 'NY');

SELECT * FROM users WHERE EXISTS
(SELECT * FROM purchases WHERE purchases.user_id = users.user_id
AND state = 'NY');

----------------------------------------
-- EXTRA CREDIT: If you finish early. --
----------------------------------------

-- 1. Use the DATEPART() function to find the number of users created during each day of the week.
--    Hint: Use DW as the first input
SELECT DATE_PART('dow', created_at) AS day, COUNT(*) FROM users
GROUP BY DATE_PART('dow', created_at);

-- 2. How about each day of the month?
SELECT DATE_PART('day', created_at) AS day, COUNT(*) FROM users
GROUP BY DATE_PART('day', created_at);


--------------------------------------------------------
-- EXERCISES: Answer using the techniques from above. --
--------------------------------------------------------

-- 1. First, join the products table to the purchase_items 
--    table. Choose a join that will KEEP products even
--    if they don't have any associated purchase_items.
SELECT *
FROM products AS p
LEFT JOIN purchase_items AS pi
ON p.product_id = pi.product_id;

SELECT *
FROM products pr
LEFT JOIN purchase_items pu
ON pr.product_id = pu.product_id;

-- 2. Were there any products with no purchase? 
--    Query the joined table for rows with NULL quantity. 

SELECT * FROM products AS p LEFT JOIN purchase_items AS pi ON p.product_id=pi.product_id where quantity IS NULL;

SELECT * FROM products pr LEFT OUTER JOIN purchase_items pu ON pr.product_id = pu.product_id WHERE quantity is NULL;


-- 3. Now add a groupby to find the average quantity that
--    each product was purchased in.

SELECT title, avg(quantity) FROM products AS p LEFT JOIN purchase_items AS pi ON p.product_id=pi.product_id group by title;

SELECT title, AVG(quantity) FROM products AS p LEFT JOIN purchase_items AS pi ON p.product_id = pi.product_id GROUP BY p.title;

SELECT pr.product_id, AVG(quantity) FROM products pr LEFT OUTER JOIN purchase_items pu ON pr.product_id = pu.product_id GROUP BY pr.product_id;


-- 4. Let's find the total number of items associated with each user.
SELECT user_id, count(quantity) FROM purchases AS p LEFT JOIN purchase_items AS pi ON p.purchase_id=pi.purchase_id group by user_id;

SELECT user_id, SUM(quantity) FROM purchases AS p RIGHT JOIN purchase_items AS pi ON p.purchase_id = pi.purchase_id GROUP BY user_id ORDER BY user_id;

--------------------------------------------------------
-- EXERCISES: Answer using the techniques from above. --
--------------------------------------------------------

-- 0. Select all the names associated with purchases made after
--    2010-01-01, and all the emails associated with users made after 2010-01-01.
SELECT name, email
FROM purchases AS p
JOIN users AS u
ON p.user_id = u.user_id
WHERE p.created_at > '2010-01-01 00:00:00-00' AND u.created_at > '2010-01-01 00:00:00-00';

SELECT created_at, email FROM users
WHERE created_at > '2010-01-01'
UNION 
SELECT created_at, name FROM purchases
WHERE created_at > '2010-01-01';


-- 1. Write a conditional that will categorize each purchase as
--    'West Coast' (if it was ordered from CA, OR, or WA) or 'Other'

select purchase_id, state, 
	CASE 
		WHEN (state = 'CA' or state = 'OR' or state = 'WA')
		THEN 'West Coast'
		ELSE 'Other'
	END 
FROM purchases;

SELECT state,
CASE WHEN (state = 'CA' or state = 'OR' or state = 'WA')
THEN 'West Coast'
ELSE 'Other'
END FROM purchases;

SELECT state, CASE 
	WHEN (state IN ('CA', 'OR', 'WA')) THEN 'West Coast'
	ELSE 'Other'
	END
FROM purchases;

-- 2. Modify the last query with a group by statement, to find
--    the number of purchases among West Coast states vs Others.
select count(purchase_id), state, CASE WHEN (state = 'CA' or state = 'OR' or state = 'WA')
						   THEN 'West Coast'
						   ELSE 'Other'
						   END FROM purchases group by state;


SELECT COUNT(purchase_id),
CASE WHEN (state = 'CA' or state = 'OR' or state = 'WA')
THEN 'West Coast'
ELSE 'Other'
END AS result FROM purchases
GROUP BY result;


SELECT CASE 
	WHEN (state IN ('CA', 'OR', 'WA')) THEN 'West Coast'
	ELSE 'Other'
	END AS coast, COUNT(*)
FROM purchases
GROUP BY CASE 
	WHEN (state IN ('CA', 'OR', 'WA')) THEN 'West Coast'
	ELSE 'Other'
	END;
-- 3. Write a conditional to divide users into three groups, based on
--    their created_at: early for before 2009-06-01,  majority for between 2009-06-01 and 2010-01-01 late for after 2010-01-01

SELECT user_id,
CASE WHEN (created_at < '2009-06-01 00:00:00-00')
THEN 'early'
WHEN (created_at > '2009-06-01 00:00:00-00' AND created_at < '2010-01-01 00:00:00-00')
THEN 'majority'
ELSE 'late'
END FROM users;

SELECT CASE 
	WHEN (created_at < '2009-06-01') THEN 'early'
	WHEN (created_at < '2010-01-01') THEN 'majority'
	ELSE 'late'
	END AS user_type
FROM users;
-- 4. Modify the last query by adding a join against the purchases
--    table. Note: Since created_at exists in both tables, you'll need to prefix with the table name (e.g users.created_at)

SELECT u.user_id,
CASE WHEN (u.created_at < '2009-06-01 00:00:00-00')
THEN 'early'
WHEN (u.created_at > '2009-06-01 00:00:00-00' AND u.created_at < '2010-01-01 00:00:00-00')
THEN 'majority'
ELSE 'late'
END FROM users AS u
JOIN purchases AS p
ON u.user_id = p.user_id;

SELECT CASE 
	WHEN (u.created_at < '2009-06-01') THEN 'early'
	WHEN (u.created_at < '2010-01-01') THEN 'majority'
	ELSE 'late'
	END AS user_type
FROM users AS u
JOIN purchases AS p
ON u.user_id = p.user_id;

-- 5. Add a groupby statement to find which group of customers makes 
--    more purchases: early, majority, or late.

SELECT COUNT(u.user_id), 
CASE WHEN (u.created_at < '2009-06-01 00:00:00-00')
THEN 'early'
WHEN (u.created_at > '2009-06-01 00:00:00-00' AND u.created_at < '2010-01-01 00:00:00-00')
THEN 'majority'
ELSE 'late'
END AS result FROM users AS u
JOIN purchases AS p
ON u.user_id = p.user_id
GROUP BY result;

SELECT CASE WHEN (u.created_at < '2009-06-01') THEN 'early'
	        WHEN (u.created_at < '2010-01-01') THEN 'majority'
		    ELSE 'late'
	   END AS user_type,
	   COUNT(*)
FROM users AS u
JOIN purchases AS p
ON u.user_id = p.user_id
GROUP BY CASE WHEN (u.created_at < '2009-06-01') THEN 'early'
	        WHEN (u.created_at < '2010-01-01') THEN 'majority'
		    ELSE 'late'
			END;





----------------------------------------
-- EXTRA CREDIT: If you finish early. --
----------------------------------------

-- 1. Use DATEPART() and a conditional to categorize purchases as
--    'weekday' and 'weekend'.
--    Hint: DATEPART(DW, column) outputs day of week as a number
--    with Sunday as 0, Saturday as 6.

SELECT CASE 
	WHEN DATE_PART('dow', created_at) IN (0, 6) THEN 'weekend'
	ELSE 'weekday'
	END AS day_type
FROM purchases;

-- 2. Group by state and weekday/weekend to see the number of weekday
--    weekend purchases per state.

SELECT state,
    CASE WHEN DATE_PART('dow', created_at) IN (0, 6) THEN 'weekend'
	ELSE 'weekday'
	END AS day_type,
	COUNT(*) 
FROM purchases
GROUP BY state, CASE WHEN DATE_PART('dow', created_at) IN (0, 6) THEN 'weekend'
	ELSE 'weekday'
	END;
	
	
SELECT DATE_PART('dow', created_at) +1, COUNT(*),
CASE WHEN (DATE_PART('dow', created_at) +1 = 0)
THEN 'Sunday'
WHEN (DATE_PART('dow', created_at) +1 = 1)
THEN 'Monday'
WHEN (DATE_PART('dow', created_at) +1 = 2)
THEN 'Tuesday'
WHEN (DATE_PART('dow', created_at) +1 = 3)
THEN 'Wednesday'
WHEN (DATE_PART('dow', created_at) +1 = 4)
THEN 'Thursday'
WHEN (DATE_PART('dow', created_at) +1 = 5)
THEN 'Friday'
WHEN (DATE_PART('dow', created_at) +1 = 6)
THEN 'Sunday'
 GROUP BY DATE_PART ('dow', created_at) +1; 
END FROM users;


