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

/*7. Which items (note items, not parts) have been delivered by a supplier
called Fisher-Price? Formulate this query by using a subquery in the
WHERE clause.*/

/*8. Formulate the same query as above, but without a subquery. **/
