CREATE DATABASE pizza;

USE PIZZA;

CREATE TABLE  order_detail (
order_details_id INT PRIMARY KEY,
	order_id INT,	
    pizza_id VARCHAR (150),
	quantity INT );
CREATE TABLE orders(
order_id INT PRIMARY KEY,	
date VARCHAR(155),
time VARCHAR (20)
);



/*Retrieve the total number of orders placed.*/
SELECT COUNT(*) as total_number
FROM orders
;

/*Calculate the total revenue generated from pizza sales.*/
SELECT 
(SUM(order_details.quantity*pizzas.price)) as total_revenue
FROM order_details JOIN pizzas ON order_details.pizza_id=pizzas.pizza_id;

/*Identify the highest-priced pizza.*/
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY price DESC
LIMIT 1;

/*Identify the most common pizza size ordered.*/
SELECT 
    p.size, COUNT(od.order_details_id) AS ordercount
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY ordercount DESC
LIMIT 1;


SELECT *   FROM pizza_types;
/*List the top 5 most ordered pizza types along with their quantities*/
 SELECT 
    pt.name, SUM(od.quantity) AS total_quantity
FROM
    order_details AS od
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;

/*Join the necessary tables to find the total quantity of each pizza 
category ordered*/
SELECT  pt.category,SUM(od.quantity)as total_quantity
FROM order_details as od join pizzas as p ON od.pizza_id=p.pizza_id
JOIN pizza_types as pt  ON pt.pizza_type_id=p.pizza_type_id
GROUP BY pt.category
order by total_quantity DESC;

/*Determine the distribution of orders by hour of the day.*/
SELECT HOUR(time) as hours, COUNT(order_id) AS total_order
FROM orders
GROUP BY hours;

/*Join relevant tables to find the category-wise distribution of pizzas.*/
SELECT category,COUNT(name) AS pizza_distribution
FROM  pizza_types 
GROUP BY category
;

/*Group the orders by date and calculate the 
average number of pizzas ordered per day.*/
SELECT  ROUND(avg(total_order),0) AS average_pizza
FROM
(SELECT 
o.date AS order_date,SUM(od.quantity) AS total_order
FROM orders AS o JOIN  order_details AS od ON o.order_id=od.order_id
GROUP BY order_date)  AS order_quantity;  


/*Determine the top 3 most ordered pizza types based on revenue.*/
SELECT pt.name AS pizza_name,SUM(od.quantity*p.price) AS revenue
FROM pizzas AS p JOIN order_details AS od ON p.pizza_id=od.pizza_id
JOIN pizza_types AS pt ON p.pizza_type_id=pt.pizza_type_id
GROUP BY pizza_name
ORDER BY revenue DESC
LIMIT 3;



/*Calculate the percentage contribution of each pizza type to total revenue.*/
SELECT pt.category AS pizza_name,
SUM(od.quantity*p.price) As revenue,
Round (
     SUM(od.quantity*p.price)*100.0/
     (SELECT SUM(od1.quantity*p1.price)
         FROM order_details AS od1 JOIN pizzas AS p1
         ON od1.pizza_id=p1.pizza_id),2) AS percentege_revenue
FROM order_details AS od JOIN pizzas AS p ON od.pizza_id=p.pizza_id
JOIN pizza_types AS pt ON p.pizza_type_id=pt.pizza_type_id
GROUP BY pizza_name
ORDER BY revenue DESC;

/*Analyze the cumulative revenue generated over time*/
SELECT DATE(o.date) AS order_time,
SUM(od.quantity*p.price) AS revenue,
     SUM(SUM(od.quantity*p.price)) OVER (ORDER BY  DATE(o.date)) AS cumulative_revenue
FROM order_details AS od JOIN pizzas AS p ON od.pizza_id=p.pizza_id
JOIN orders AS o ON o.order_id=od.order_id
GROUP BY order_time
ORDER BY cumulative_revenue ASC;

/*Determine the top 3 most ordered pizza types based on revenue for each pizza category.*/

SELECT name,revenue
FROM
(SELECT name,category,revenue,
RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rn
FROM
(SELECT pt.name,pt.category,
SUM(od.quantity*p.price) AS revenue
FROM order_details AS od JOIN pizzas AS p ON od.pizza_id=p.pizza_id
JOIN pizza_types AS pt ON p.pizza_type_id=pt.pizza_type_id
GROUP BY pt.name,pt.category
ORDER BY revenue DESC) AS total_rank) AS most_rank
WHERE rn<=3 ;
     
     
     
     




