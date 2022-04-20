/*
Lab 2 report <Student_names and liu_id>
*/

/* All non code should be within SQL-comments like this */ 


/*
Drop all user created tables that have been created when solving the lab
*/

DROP TABLE IF EXISTS custom_table CASCADE;


/* Have the source scripts in the file so it is easy to recreate!*/

SOURCE company_schema.sql;
SOURCE company_data.sql;
/* EXAMPLE */
/*
Question 1: Print a message that says "hello world"
*/

SELECT 'hello world!' AS 'message';

/* Show the output for every question.
+--------------+
| message      |
+--------------+
| hello world! |
+--------------+
1 row in set (0.00 sec)
*/ 
/* END EXAMPLE */


/*1. List all employees, i.e., all tuples in the jbemployee relation.*/

SELECT name
FROM jbemployee;

/*
+--------------------+
| name               |
+--------------------+
| Ross, Stanley      |
| Ross, Stuart       |
| Edwards, Peter     |
| Thompson, Bob      |
| Smythe, Carol      |
| Hayes, Evelyn      |
| Evans, Michael     |
| Raveen, Lemont     |
| James, Mary        |
| Williams, Judy     |
| Thomas, Tom        |
| Jones, Tim         |
| Bullock, J.D.      |
| Collins, Joanne    |
| Brunet, Paul C.    |
| Schmidt, Herman    |
| Iwano, Masahiro    |
| Smith, Paul        |
| Onstad, Richard    |
| Zugnoni, Arthur A. |
| Choy, Wanda        |
| Wallace, Maggie J. |
| Bailey, Chas M.    |
| Bono, Sonny        |
| Schwarz, Jason B.  |
+--------------------+
*/


/*2. List the name of all departments in alphabetical order. Note: by “name”
we mean the name attribute in the jbdept relation.*/

SELECT name 
FROM jbdept 
ORDER BY name ASC;

/*
+------------------+
| name             |
+------------------+
| Bargain          |
| Book             |
| Candy            |
| Children's       |
| Children's       |
| Furniture        |
| Giftwrap         |
| Jewelry          |
| Junior Miss      |
| Junior's         |
| Linens           |
| Major Appliances |
| Men's            |
| Sportswear       |
| Stationary       |
| Toys             |
| Women's          |
| Women's          |
| Women's          |
+------------------+
*/


/*3. What parts are not in store? Note that such parts have the value 0 (zero)
for the qoh attribute (qoh = quantity on hand). **/

SELECT name
FROM jbparts 
WHERE qoh=0;

/*
+-------------------+
| name              |
+-------------------+
| card reader       |
| card punch        |
| paper tape reader |
| paper tape punch  |
+-------------------+
*/


/*4. List all employees who have a salary between 9000 (included) and
10000 (included)? **/

SELECT name
FROM jbemployee
WHERE salary >= 9000 AND salary <= 10000;

/*
+----------------+
| name           |
+----------------+
| Edwards, Peter |
| Smythe, Carol  |
| Williams, Judy |
| Thomas, Tom    |
+----------------+
*/


/*5. List all employees together with the age they had when they started
working? Hint: use the startyear attribute and calculate the age in the
SELECT clause. **/

SELECT name,
startyear-birthyear as 'startage'
FROM jbemployee;

/*
+--------------------+----------+
| name               | startage |
+--------------------+----------+
| Ross, Stanley      |       18 |
| Ross, Stuart       |        1 |
| Edwards, Peter     |       30 |
| Thompson, Bob      |       40 |
| Smythe, Carol      |       38 |
| Hayes, Evelyn      |       32 |
| Evans, Michael     |       22 |
| Raveen, Lemont     |       24 |
| James, Mary        |       49 |
| Williams, Judy     |       34 |
| Thomas, Tom        |       21 |
| Jones, Tim         |       20 |
| Bullock, J.D.      |        0 |
| Collins, Joanne    |       21 |
| Brunet, Paul C.    |       21 |
| Schmidt, Herman    |       20 |
| Iwano, Masahiro    |       26 |
| Smith, Paul        |       21 |
| Onstad, Richard    |       19 |
| Zugnoni, Arthur A. |       21 |
| Choy, Wanda        |       23 |
| Wallace, Maggie J. |       19 |
| Bailey, Chas M.    |       19 |
| Bono, Sonny        |       24 |
| Schwarz, Jason B.  |       15 |
+--------------------+----------+
*/

/*6. List all employees who have a last name ending with “son”. **/

SELECT name
FROM jbemployee
WHERE name LIKE '%son,%';

/*
+---------------+
| name          |
+---------------+
| Thompson, Bob |
+---------------+
*/


/*7. Which items (note items, not parts) have been delivered by a supplier
called Fisher-Price? Formulate this query by using a subquery in the
WHERE clause.*/

SELECT name 
FROM jbitem 
WHERE supplier NOT IN (
    SELECT id 
    FROM jbsupplier 
    WHERE name!='Fisher-Price'
);

/*
+-----------------+
| name            |
+-----------------+
| Maze            |
| The 'Feel' Book |
| Squeeze Ball    |
+-----------------+
*/


/*8. Formulate the same query as above, but without a subquery. **/

SELECT I.name 
FROM jbitem AS I 
INNER JOIN jbsupplier as S 
ON I.supplier=S.id 
WHERE S.name='Fisher-Price';

/*
+-----------------+
| name            |
+-----------------+
| Maze            |
| The 'Feel' Book |
| Squeeze Ball    |
+-----------------+
*/


/*9. List all cities that have suppliers located in them. Formulate this query using a subquery in the WHERE clause.*/



/*10. What is the name and the color of the parts that are heavier than a card reader? Formulate this query using a subquery in the WHERE clause. (The query must not contain the weight of the card reader as a constant; instead, the weight has to be retrieved within the query.)


/*11. Formulate the same query as above, but without a subquery. Again, the query must not contain the weight of the card reader as a constant.


/*12. What is the average weight of all black parts?


/*13. For every supplier in Massachusetts (“Mass”), retrieve the name and the total weight of all parts that the supplier has delivered? Do not forget to take the quantity of delivered parts into account. Note that one row should be returned for each supplier.


/*14. Create a new relation with the same attributes as the jbitems relation by using the CREATE TABLE command where you define every attribute explicitly (i.e., not as a copy of another table). Then, populate this new relation with all items that cost less than the average price for all items. Remember to define the primary key and foreign keys in your table!


/*15. Create a view that contains the items that cost less than the average price for items.


/*16. What is the difference between a table and a view? One is static and the other is dynamic. Which is which and what do we mean by static respectively dynamic?


/*17. Create a view that calculates the total cost of each debit, by considering price and quantity of each bought item. (To be used for charging customer accounts). The view should contain the sale identifier (debit) and the total cost. In the query that defines the view, capture the join condition in the WHERE clause (i.e., do not capture the join in the FROM clause by using keywords inner join, right join or left join).


/*18. Do the same as in the previous point, but now capture the join conditions in the FROM clause by using only left, right or inner joins. Hence, the WHERE clause must not contain any join condition in this case. Motivate why you use type of join you do (left, right or inner), and why this is the correct one (in contrast to the other types of joins).


/*19. Oh no! An earthquake!
a) Remove all suppliers in Los Angeles from the jbsupplier table. This will not work right away. Instead, you will receive an error with error code 23000 which you will have to solve by deleting some otherrelated tuples. However, do not delete more tuples from other tables than necessary, and do not change the structure of the tables (i.e., do not remove foreign keys). Also, you are only allowed to use “Los Angeles” as a constant in your queries, not “199” or “900”. b) Explain what you did and why.


/*20. An employee has tried to find out which suppliers have delivered items that have been sold. To this end, the employee has created a view and a query that lists the number of items sold from a supplier. mysql> CREATE VIEW jbsale_supply(supplier, item, quantity) AS
> SELECT jbsupplier.name, jbitem.name, jbsale.quantity
> FROM jbsupplier, jbitem, jbsale
> WHERE jbsupplier.id = jbitem.supplier
> AND jbsale.item = jbitem.id;
Query OK, 0 rows affected (0.01 sec)
mysql> SELECT supplier, sum(quantity) AS sum FROM jbsale_supply
> GROUP BY supplier;
+++
| supplier | sum(quantity) |
+++
| Cannon | 6 |
| LeviStrauss | 1 |
| Playskool | 2 |
| White Stag | 4 |
| Whitman's | 2 |
+++
5 rows in set (0.00 sec)
Now, the employee also wants to include the suppliers that have delivered some items, although for whom no items have been sold so far. In other words, he wants to list all suppliers that have supplied any item, as well as the number of these items that have been sold. Help him! Drop and redefine the jbsale_supply view to also consider suppliers that have delivered items that have never been sold. Hint: Notice that the above definition of jbsale_supply uses an (implicit) inner join that removes suppliers that have not had any of their delivered items sold.
