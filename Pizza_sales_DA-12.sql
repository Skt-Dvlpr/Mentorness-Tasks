/*Q1: The total number of orders placed*/
 SELECT COUNT(DISTINCT order_details_id) AS total_orders_placed FROM data_set;

/*Q2: The total revenue generated from pizza sales*/
 SELECT SUM(price) AS total_revenue FROM data_set;

/*Q3: The highest priced pizza.*/
 SELECT DISTINCT(name), price FROM data_set
 WHERE price =((SELECT MAX(price) FROM data_set));

/*Q4: The most common pizza size ordered.*/
 SELECT size, COUNT(size) AS most_common FROM data_set
 GROUP BY size
 ORDER BY most_common DESC
 LIMIT 1;

/*Q5: The top 5 most ordered pizza types along with their quantities.*/
 SELECT name, COUNT(name) AS most_ordered_pizza FROM data_set
 GROUP BY name
 ORDER BY most_ordered_pizza DESC
 LIMIT 5;

/*Q6: The quantity of each pizza category ordered.*/
 SELECT category, COUNT(category) AS quantity_pizza FROM data_set
 GROUP BY category;

/*Q7: The distribution of orders by hours of the day*/
 SELECT Extract(hour from times) AS hours, COUNT(order_id) AS total_orders
 FROM data_set
 GROUP BY hours;

/*Q8: The category-wise distribution of pizzas.*/
 SELECT category, COUNT(DISTINCT(name)) AS order_count
 FROM data_set
 GROUP BY category;  

/*Q9: The average number of pizzas ordered per day.*/
  WITH total_qty_by_date AS 
 (
 SELECT dates, SUM(quantity) AS total_qty
 FROM data_set
 GROUP BY dates
 )
 SELECT ROUND(AVG(total_qty),0)  AS avg_orders_per_day
 FROM total_qty_by_date ;

/*Q10: Top 3 most ordered pizza types based on revenue.*/
 SELECT name, 
 SUM(quantity * price) AS total_revenue
 FROM data_set
 GROUP BY name
 ORDER BY total_revenue DESC
 LIMIT 3;

/*Q11: The percentage contribution of each pizza type to revenue.*/
 WITH total_revenue AS( 
 SELECT name, 
 ROUND(cast(SUM(quantity * price) AS numeric),2) AS revenue
 FROM data_set
 GROUP BY name
 )
 SELECT name, CONCAT(
       ROUND(100 * revenue / sum(revenue) over(),2) ,'%'
        ) AS pct_contribution
 FROM total_revenue;

/* Q12: The cumulative revenue generated over time.*/
 WITH total_revenue AS( 
 SELECT dates, 
 ROUND(cast(SUM(quantity * price) AS numeric),2) AS revenue
 FROM data_set
 GROUP BY dates
 )
 SELECT *,
 ROUND(SUM(revenue) OVER (ORDER BY dates),2)  AS cum_revenue
 FROM total_revenue;

/*Q13: The top 3 most ordered pizza types based on revenue for each pizza category.*/
 WITH Revenue_cal AS(
 SELECT name, category,
 ROUND(CAST(SUM(quantity * price) AS numeric),2) AS total_revenue
 FROM data_set
 GROUP BY name, category
 ),
	 posi_cal AS(
	 SELECT *,RANK() OVER(PARTITION BY category ORDER BY total_revenue DESC) as rankk
	 FROM Revenue_cal
)
SELECT name, category,total_revenue
FROM posi_cal
	 WHERE rankk<4;