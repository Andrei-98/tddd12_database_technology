/*
Lab 2 report <Student_names and liu_id>
*/

/* All non code should be within SQL-comments like this */ 


/*
Drop all user created tables that have been created when solving the lab
*/
DROP TABLE IF EXISTS cheaperthanjbitem CASCADE;


-- /* Have the source scripts in the file so it is easy to recreate!*/

-- SOURCE company_schema.sql;
-- SOURCE company_data.sql;
-- /* EXAMPLE */
-- /*
-- Question 1: Print a message that says "hello world"
-- */

-- SELECT 'hello world!' AS 'message';

-- /* Show the output for every question.
-- +--------------+
-- | message      |
-- +--------------+
-- | hello world! |
-- +--------------+
-- 1 row in set (0.00 sec)
-- */ 
-- /* END EXAMPLE */


-- /*1. List all employees, i.e., all tuples in the jbemployee relation.*/

-- SELECT name
-- FROM jbemployee;

-- /*
-- +--------------------+
-- | name               |
-- +--------------------+
-- | Ross, Stanley      |
-- | Ross, Stuart       |
-- | Edwards, Peter     |
-- | Thompson, Bob      |
-- | Smythe, Carol      |
-- | Hayes, Evelyn      |
-- | Evans, Michael     |
-- | Raveen, Lemont     |
-- | James, Mary        |
-- | Williams, Judy     |
-- | Thomas, Tom        |
-- | Jones, Tim         |
-- | Bullock, J.D.      |
-- | Collins, Joanne    |
-- | Brunet, Paul C.    |
-- | Schmidt, Herman    |
-- | Iwano, Masahiro    |
-- | Smith, Paul        |
-- | Onstad, Richard    |
-- | Zugnoni, Arthur A. |
-- | Choy, Wanda        |
-- | Wallace, Maggie J. |
-- | Bailey, Chas M.    |
-- | Bono, Sonny        |
-- | Schwarz, Jason B.  |
-- +--------------------+
-- */


-- /*2. List the name of all departments in alphabetical order. Note: by “name”
-- we mean the name attribute in the jbdept relation.*/

-- SELECT name 
-- FROM jbdept 
-- ORDER BY name ASC;

-- /*
-- +------------------+
-- | name             |
-- +------------------+
-- | Bargain          |
-- | Book             |
-- | Candy            |
-- | Children's       |
-- | Children's       |
-- | Furniture        |
-- | Giftwrap         |
-- | Jewelry          |
-- | Junior Miss      |
-- | Junior's         |
-- | Linens           |
-- | Major Appliances |
-- | Men's            |
-- | Sportswear       |
-- | Stationary       |
-- | Toys             |
-- | Women's          |
-- | Women's          |
-- | Women's          |
-- +------------------+
-- */


-- /*3. What parts are not in store? Note that such parts have the value 0 (zero)
-- for the qoh attribute (qoh = quantity on hand). **/

-- SELECT name
-- FROM jbparts 
-- WHERE qoh=0;

-- /*
-- +-------------------+
-- | name              |
-- +-------------------+
-- | card reader       |
-- | card punch        |
-- | paper tape reader |
-- | paper tape punch  |
-- +-------------------+
-- */


-- /*4. List all employees who have a salary between 9000 (included) and
-- 10000 (included)? **/

-- SELECT name
-- FROM jbemployee
-- WHERE salary >= 9000 AND salary <= 10000;

-- /*
-- +----------------+
-- | name           |
-- +----------------+
-- | Edwards, Peter |
-- | Smythe, Carol  |
-- | Williams, Judy |
-- | Thomas, Tom    |
-- +----------------+
-- */


-- /*5. List all employees together with the age they had when they started
-- working? Hint: use the startyear attribute and calculate the age in the
-- SELECT clause. **/

-- SELECT name,
-- startyear-birthyear as 'startage'
-- FROM jbemployee;

-- /*
-- +--------------------+----------+
-- | name               | startage |
-- +--------------------+----------+
-- | Ross, Stanley      |       18 |
-- | Ross, Stuart       |        1 |
-- | Edwards, Peter     |       30 |
-- | Thompson, Bob      |       40 |
-- | Smythe, Carol      |       38 |
-- | Hayes, Evelyn      |       32 |
-- | Evans, Michael     |       22 |
-- | Raveen, Lemont     |       24 |
-- | James, Mary        |       49 |
-- | Williams, Judy     |       34 |
-- | Thomas, Tom        |       21 |
-- | Jones, Tim         |       20 |
-- | Bullock, J.D.      |        0 |
-- | Collins, Joanne    |       21 |
-- | Brunet, Paul C.    |       21 |
-- | Schmidt, Herman    |       20 |
-- | Iwano, Masahiro    |       26 |
-- | Smith, Paul        |       21 |
-- | Onstad, Richard    |       19 |
-- | Zugnoni, Arthur A. |       21 |
-- | Choy, Wanda        |       23 |
-- | Wallace, Maggie J. |       19 |
-- | Bailey, Chas M.    |       19 |
-- | Bono, Sonny        |       24 |
-- | Schwarz, Jason B.  |       15 |
-- +--------------------+----------+
-- */

-- /*6. List all employees who have a last name ending with “son”. **/

-- SELECT name
-- FROM jbemployee
-- WHERE name LIKE '%son,%';

-- /*
-- +---------------+
-- | name          |
-- +---------------+
-- | Thompson, Bob |
-- +---------------+
-- */


-- /*7. Which items (note items, not parts) have been delivered by a supplier
-- called Fisher-Price? Formulate this query by using a subquery in the
-- WHERE clause.*/

-- SELECT name 
-- FROM jbitem 
-- WHERE supplier NOT IN (
--     SELECT id 
--     FROM jbsupplier 
--     WHERE name!='Fisher-Price'
-- );

-- /*
-- +-----------------+
-- | name            |
-- +-----------------+
-- | Maze            |
-- | The 'Feel' Book |
-- | Squeeze Ball    |
-- +-----------------+
-- */


-- /*8. Formulate the same query as above, but without a subquery. **/

-- SELECT I.name 
-- FROM jbitem AS I 
-- INNER JOIN jbsupplier as S 
-- ON I.supplier=S.id 
-- WHERE S.name='Fisher-Price';

-- /*
-- +-----------------+
-- | name            |
-- +-----------------+
-- | Maze            |
-- | The 'Feel' Book |
-- | Squeeze Ball    |
-- +-----------------+
-- */


-- /*9. List all cities that have suppliers located in them. 
-- Formulate this query using a subquery in the WHERE clause.*/

-- SELECT name
-- FROM jbcity
-- WHERE id IN (
--     SELECT city
--     FROM jbsupplier
-- ); 
-- /*ORDER BY name ASC;*/

-- /*+----------------+
-- | name           |
-- +----------------+
-- | Amherst        |
-- | Atlanta        |
-- | Boston         |
-- | Dallas         |
-- | Denver         |
-- | Hickville      |
-- | Los Angeles    |
-- | Madison        |
-- | New York       |
-- | Paxton         |
-- | Salt Lake City |
-- | San Diego      |
-- | San Francisco  |
-- | Seattle        |
-- | White Plains   |
-- +----------------+
-- */

-- /*10. What is the name and the color of the parts that are heavier than a 
-- card reader? Formulate this query using a subquery in the WHERE clause. 
-- (The query must not contain the weight of the card reader as a constant;
--  instead, the weight has to be retrieved within the query.)*/

-- SELECT name, color
-- FROM jbparts
-- WHERE weight > (
--     SELECT weight 
--     FROM jbparts 
--     WHERE name='card reader'
-- );

-- /*
-- +--------------+--------+
-- | name         | color  |
-- +--------------+--------+
-- | disk drive   | black  |
-- | tape drive   | black  |
-- | line printer | yellow |
-- | card punch   | gray   |
-- +--------------+--------+
-- */


-- /*11. Formulate the same query as above, but without a subquery. 
-- Again, the query must not contain the weight of the card reader as a constant.*/

-- SELECT A.name, A.color 
-- FROM jbparts as A 
-- JOIN jbparts as B on A.weight > B.weight 
-- AND B.name='card reader';

-- /*
-- +--------------+--------+
-- | name         | color  |
-- +--------------+--------+
-- | disk drive   | black  |
-- | tape drive   | black  |
-- | line printer | yellow |
-- | card punch   | gray   |
-- +--------------+--------+
-- */

-- /*12. What is the average weight of all black parts?*/

-- SELECT AVG(weight)
-- FROM jbparts
-- WHERE color='black';

-- /*
-- +-------------+
-- | AVG(weight) |
-- +-------------+
-- |    347.2500 |
-- +-------------+
-- */


-- /*13. For every supplier in Massachusetts (“Mass”), retrieve the name and the total weight of all parts that the supplier has delivered? Do not forget to take the quantity of delivered parts into account. Note that one row should be returned for each supplier.*/

-- /* NON CTE SOLUTION
-- select T.name, SUM(quan*weight) from (select MAIN.name, MAIN.part, MAIN.quan, P.weight from (SELECT idname.name, S.part, S.quan FROM jbsupply as S INNER JOIN (SELECT id, name FROM jbsupplier WHERE city IN (SELECT id FROM jbcity WHERE state='mass')) as idname ON S.supplier=idname.id) as MAIN LEFT JOIN jbparts as P ON MAIN.part=P.id) as T group by name;
-- CTE SOLUTION BASICALLY THE SAME BUT EASIER TO READ
-- */
-- WITH Supplier_id_name AS 
-- (
--     SELECT id,name 
--     FROM jbsupplier 
--     WHERE city IN 
--         (
--             SELECT id 
--             FROM jbcity 
--             WHERE state='mass'
--         )
-- ),

-- Supplier_id_name_quan AS
-- (
--     SELECT Supplier_id_name.name,
--          S.part,
--          S.quan
--     FROM jbsupply AS S
--     INNER JOIN Supplier_id_name
--     ON S.supplier=Supplier_id_name.id
-- ),

-- Name_quan_weigth AS
-- (
--     SELECT Supplier_id_name_quan.name,
--          Supplier_id_name_quan.part,
--          Supplier_id_name_quan.quan,
--          P.weight
--     FROM Supplier_id_name_quan
--     LEFT JOIN jbparts AS P
--     ON Supplier_id_name_quan.part=P.id
-- )

-- SELECT Name_quan_weigth.name, 
--     SUM(quan*weight)
-- FROM Name_quan_weigth
-- GROUP BY name;

-- /*
-- +--------------+------------------+
-- | name         | SUM(quan*weight) |
-- +--------------+------------------+
-- | DEC          |             3120 |
-- | Fisher-Price |          1135000 |
-- +--------------+------------------+
-- */


/*14. Create a new relation with the same attributes as the jbitems relation by using the CREATE TABLE command where you define every attribute explicitly (i.e., not as a copy of another table). Then, populate this new relation with all items that cost less than the average price for all items. Remember to define the primary key and foreign keys in your table!*/

-- CREATE TABLE cheaperthanjbitem
-- (
--     id int,
--     name varchar(255),
--     dept int,
--     price int,
--     qoh int,
--     supplier int,

--     constraint pk_id
--     primary key(id),

--     constraint fk_supplier
--     FOREIGN KEY (supplier) REFERENCES jbsupplier(id)
-- );

-- INSERT INTO cheaperthanjbitem
-- SELECT * 
-- FROM jbitem
-- WHERE price<(SELECT AVG(price) FROM jbitem);

-- SELECT * from cheaperthanjbitem;

/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
*/

/*15. Create a view that contains the items that cost less than the average price for items. */
-- DROP VIEW IF EXISTS view_cheaper CASCADE;


-- CREATE VIEW view_cheaper AS
-- SELECT * 
-- FROM jbitem
-- WHERE price<(SELECT AVG(price) FROM jbitem);

-- SELECT * FROM view_cheaper;

/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
*/


/*16. What is the difference between a table and a view? One is static and the other is dynamic. Which is which and what do we mean by static respectively dynamic?

The table is static in the sense where if a result table has been queried and the original table changes values the queried table won't change unless another query is made. 

On the contrary a virtual view updates automatically if any of the date the view is made up from change. Also a View can be virual so as that it does not exist in db memory.


/*17. Create a view that calculates the total cost of each debit, by considering price and quantity of each bought item. (To be used for charging customer accounts). The view should contain the sale identifier (debit) and the total cost. In the query that defines the view, capture the join condition in the WHERE clause (i.e., do not capture the join in the FROM clause by using keywords inner join, right join or left join).*/
DROP VIEW IF EXISTS debit_view CASCADE;
/*
WITH item_price AS (
    SELECT D.debit, D.item, D.quantity, I.price
    FROM jbsale AS D, jbitem AS I
    WHERE D.item=I.id
), 

total_price AS (
    SELECT debit, SUM(quantity*price)
    FROM item_price
    GROUP BY debit
)
*/
-- CREATE VIEW debit_view AS
-- (
--     SELECT item_price.debit, SUM(item_price.quantity
--     * item_price.price) AS 'total price'
--     FROM (
--         SELECT D.debit, D.item, D.quantity, I.price
--         FROM jbsale AS D, jbitem AS I
--         WHERE D.item=I.id
--         ) AS item_price
--     GROUP BY item_price.debit
-- );
-- SELECT * FROM debit_view;

/*18. Do the same as in the previous point, but now capture the join conditions in the FROM clause by using only left, right or inner joins. Hence, the WHERE clause must not contain any join condition in this case. Motivate why you use type of join you do (left, right or inner), and why this is the correct one (in contrast to the other types of joins).*/

/*
We use a left join because the jbsale contains all the columns that we want to keep. Meanwhile the other table jbsale has only a couple of columns that we are interested in. 
*/

CREATE VIEW debit_view AS
(
    SELECT item_price.debit, SUM(item_price.quantity
    * item_price.price) AS 'total price'
    FROM (
            SELECT debit, item, quantity, price
            FROM jbsale
            LEFT JOIN jbitem as I 
            ON item = I.id 
        ) AS item_price
    GROUP BY item_price.debit
);

SELECT * FROM debit_view;
/*
+--------+-------------+
| debit  | total price |
+--------+-------------+
| 100581 |        2050 |
| 100582 |        1000 |
| 100586 |       13446 |
| 100592 |         650 |
| 100593 |         430 |
| 100594 |        3295 |
+--------+-------------+
*/


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
