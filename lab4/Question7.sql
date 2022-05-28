/******************************************************************************************
 Question 7, Correct representation in the view.
 This is a test script that tests that the interface of the BryanAir back-end works
 correctly. More specifically it tests that flights and reservations are added correctly and
 that the number of seats and price is calculated correctly. This is done by checking against a 
 previous (correct) response to the query from an external database. 
**********************************************************************************************/

SELECT "Checking that bookings and flights are added correctly by checking the view" as "Message";
/*Fill the database with flights */
SELECT "Step1, fill the database with flights" AS "Message";
CALL addYear(2010, 2.3);
CALL addYear(2011, 2.5);
CALL addDay(2010,"Monday",1);
CALL addDay(2010,"Tuesday",1.5);
CALL addDay(2011,"Saturday",2);
CALL addDay(2011,"Sunday",2.5);
CALL addDestination("MIT","Minas Tirith","Mordor");
CALL addDestination("HOB","Hobbiton","The Shire");
CALL addRoute("MIT","HOB",2010,2000);
CALL addRoute("HOB","MIT",2010,1600);
CALL addRoute("MIT","HOB",2011,2100);
CALL addRoute("HOB","MIT",2011,1500);
CALL addFlight("MIT","HOB", 2010, "Monday", "09:00:00");
CALL addFlight("HOB","MIT", 2010, "Tuesday", "10:00:00");
CALL addFlight("MIT","HOB", 2011, "Sunday", "11:00:00");
CALL addFlight("HOB","MIT", 2011, "Sunday", "12:00:00");

SELECT "Step2, add a bunch of bookings to the flights" AS "Message";
CALL addReservation("MIT","HOB",2010,1,"Monday","09:00:00",3,@a); 
CALL addPassenger(@a,00000001,"Frodo Baggins"); 
CALL addContact(@a,00000001,"frodo@magic.mail",080667989); 
CALL addPassenger(@a,00000002,"Sam Gamgee"); 
CALL addPassenger(@a,00000003,"Merry Pippins");
CALL addPayment (@a, "Gandalf", 6767); -- fails
CALL addReservation("MIT","HOB",2010,1,"Monday","09:00:00",3,@b); 
CALL addPassenger(@b,00000011,"Nazgul1"); 
CALL addContact(@b,00000011,"Nazgul@darkness.mail",666); 
CALL addPassenger(@b,00000012,"Nazgul2"); 
CALL addPassenger(@b,00000013,"Nazgul3");
CALL addPayment (@b, "Saruman", 6868); -- fails

SELECT "Step3, check that the results are correct. If so the next query should return the empty set. If any line is returned then this is either missing, incorrect or additional to what the database should contain" AS "Message";
SELECT departure_city_name, destination_city_name, departure_time, departure_day,departure_week, departure_year, nr_of_free_seats, current_price_per_seat
FROM (
SELECT departure_city_name, destination_city_name, departure_time, departure_day,departure_week, departure_year, nr_of_free_seats, current_price_per_seat FROM allFlights
UNION ALL
SELECT departure_city_name, destination_city_name, departure_time, departure_day,departure_week, departure_year, nr_of_free_seats, current_price_per_seat FROM TDDD37.Question7CorrectResult
) res
GROUP BY departure_city_name, destination_city_name, departure_time, departure_day,departure_week, departure_year, nr_of_free_seats, current_price_per_seat
HAVING count(*) = 1;


-- +---------------------+-----------------------+----------------+---------------+----------------+----------------+------------------+------------------------+
-- | departure_city_name | destination_city_name | departure_time | departure_day | departure_week | departure_year | nr_of_free_seats | current_price_per_seat |
-- +---------------------+-----------------------+----------------+---------------+----------------+----------------+------------------+------------------------+
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |              1 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |              2 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |              3 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |              4 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |              5 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |              6 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |              7 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |              8 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |              9 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             10 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             11 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             12 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             13 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             14 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             15 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             16 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             17 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             18 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             19 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             20 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             21 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             22 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             23 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             24 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             25 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             26 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             27 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             28 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             29 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             30 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             31 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             32 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             33 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             34 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             35 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             36 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             37 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             38 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             39 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             40 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             41 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             42 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             43 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             44 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             45 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             46 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             47 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             48 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             49 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             50 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             51 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 10:00:00       | Tuesday       |             52 |           2010 |               40 |                    138 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |              1 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |              2 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |              3 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |              4 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |              5 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |              6 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |              7 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |              8 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |              9 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             10 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             11 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             12 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             13 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             14 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             15 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             16 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             17 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             18 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             19 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             20 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             21 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             22 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             23 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             24 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             25 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             26 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             27 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             28 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             29 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             30 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             31 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             32 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             33 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             34 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             35 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             36 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             37 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             38 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             39 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             40 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             41 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             42 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             43 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             44 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             45 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             46 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             47 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             48 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             49 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             50 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             51 |           2011 |               40 |                234.375 |
-- | Hobbiton            | Minas Tirith          | 12:00:00       | Sunday        |             52 |           2011 |               40 |                234.375 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |              1 |           2010 |               34 |                    805 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |              2 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |              3 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |              4 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |              5 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |              6 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |              7 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |              8 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |              9 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             10 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             11 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             12 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             13 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             14 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             15 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             16 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             17 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             18 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             19 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             20 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             21 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             22 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             23 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             24 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             25 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             26 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             27 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             28 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             29 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             30 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             31 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             32 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             33 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             34 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             35 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             36 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             37 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             38 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             39 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             40 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             41 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             42 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             43 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             44 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             45 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             46 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             47 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             48 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             49 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             50 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             51 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 09:00:00       | Monday        |             52 |           2010 |               40 |                    115 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |              1 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |              2 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |              3 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |              4 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |              5 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |              6 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |              7 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |              8 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |              9 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             10 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             11 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             12 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             13 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             14 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             15 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             16 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             17 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             18 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             19 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             20 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             21 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             22 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             23 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             24 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             25 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             26 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             27 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             28 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             29 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             30 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             31 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             32 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             33 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             34 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             35 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             36 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             37 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             38 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             39 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             40 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             41 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             42 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             43 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             44 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             45 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             46 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             47 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             48 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             49 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             50 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             51 |           2011 |               40 |                328.125 |
-- | Minas Tirith        | Hobbiton              | 11:00:00       | Sunday        |             52 |           2011 |               40 |                328.125 |
-- +---------------------+-----------------------+----------------+---------------+----------------+----------------+------------------+------------------------+
