\! clear
DROP DATABASE brianair;
CREATE DATABASE brianair;
use brianair;

--Drop all tables as necessary
--DROP TABLE IF EXISTS table_name” resp. “DROP PROCEDURE IF EXISTS proc_name
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS ticket CASCADE;
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS reservation CASCADE;
DROP TABLE IF EXISTS flight CASCADE;
DROP TABLE IF EXISTS weeklyschedule CASCADE;
DROP TABLE IF EXISTS profitfactor CASCADE;
DROP TABLE IF EXISTS weekdayfactor CASCADE;
DROP TABLE IF EXISTS froute CASCADE; -- named froute instead of route
DROP TABLE IF EXISTS airport CASCADE;
DROP TABLE IF EXISTS contact CASCADE;
DROP TABLE IF EXISTS passenger CASCADE;
DROP TABLE IF EXISTS passportOnReservation CASCADE;
SET FOREIGN_KEY_CHECKS=1;

SELECT 'Creating tables' AS 'Message';

CREATE TABLE passenger
    (passnr INT NOT NULL,
    firstName VARCHAR(30),
    lastName VARCHAR(30),
    CONSTRAINT pk_passenger PRIMARY KEY(passnr))
    ENGINE=InnoDB;

CREATE TABLE passportOnReservation
    (passport INT NOT NULL,
     reservation_nr INT NOT NULL,
     CONSTRAINT pk_passportOnReservation PRIMARY KEY(passport, reservation_nr)
    )
     ENGINE=InnoDB;

CREATE TABLE contact
    (cpassnr INT NOT NULL,
    phone BIGINT,
    email VARCHAR(30),
    CONSTRAINT pk_contact PRIMARY KEY(cpassnr)) 
    ENGINE=InnoDB;
    
CREATE TABLE weeklyschedule
    (year INT NOT NULL,
    day VARCHAR(10) NOT NULL,
    routeid INT,
    dep_time TIME,
    wsid INT NOT NULL AUTO_INCREMENT,
    CONSTRAINT pk_weekly_schedule PRIMARY KEY(wsid),
    -- Primary key Day from wdf is pointing here thus
    -- day needs to be unique.
    CONSTRAINT unique_time_routeId UNIQUE(year, day, routeId, dep_time)) 
    ENGINE=InnoDB;
    
CREATE TABLE weekdayfactor
    (year INT,
    day VARCHAR(10),
    weekdayfactor DOUBLE,
    CONSTRAINT pk_weekdayfactor PRIMARY KEY(day)) 
    ENGINE=InnoDB;

CREATE TABLE froute
    (routeid INT NOT NULL AUTO_INCREMENT,
    fromcode VARCHAR(3),
    tocode VARCHAR(3),
    routeprice DOUBLE,
    year INT,
    CONSTRAINT pk_froute PRIMARY KEY(routeid)) 
    ENGINE=InnoDB;

CREATE TABLE airport
    (code VARCHAR(3),
    name VARCHAR(30),
    country VARCHAR(30),
    CONSTRAINT pk_airport PRIMARY KEY(code)) 
    ENGINE=InnoDB;


CREATE TABLE flight
    (flightnr INT NOT NULL AUTO_INCREMENT,
    vacantseats INT DEFAULT 40,
    week INT,
    year INT,
    wsid INT NOT NULL,
    CONSTRAINT pk_flight PRIMARY KEY(flightnr)) 
    ENGINE=InnoDB;

CREATE TABLE profitfactor
    (year INT,
    profitfactor DOUBLE,
    CONSTRAINT pk_profitfactor PRIMARY KEY(year)) 
    ENGINE=InnoDB;

CREATE TABLE reservation
    (rid INT NOT NULL AUTO_INCREMENT,
    flightnr INT,
    cpassnr INT,
    CONSTRAINT pk_rid PRIMARY KEY(rid)) 
    ENGINE=InnoDB;

CREATE TABLE booking
    (bookingid INT,
    ccnr BIGINT,
    cch VARCHAR(30),
    totalprice DOUBLE,
    CONSTRAINT pk_bookingid PRIMARY KEY(bookingid)) 
    ENGINE=InnoDB;

CREATE TABLE ticket
    (passnr INT,
    ticketnr INT NOT NULL AUTO_INCREMENT,
    bookingid INT,
    CONSTRAINT pk_ticketnr PRIMARY KEY(ticketnr)) 
    ENGINE=InnoDB;


-- Foreign key
SELECT 'Altering tables with foreign keys' AS 'Message';

ALTER TABLE contact ADD CONSTRAINT fk_contact_passenger FOREIGN KEY (cpassnr) REFERENCES passenger(passnr);
ALTER TABLE weeklyschedule ADD CONSTRAINT fk_ws_froute FOREIGN KEY (routeid) REFERENCES froute(routeid);
ALTER TABLE weeklyschedule ADD CONSTRAINT fk_ws_pf FOREIGN KEY (year) REFERENCES profitfactor(year);
ALTER TABLE weeklyschedule ADD CONSTRAINT fk_ws_wf FOREIGN KEY (day) REFERENCES weekdayfactor(day);
ALTER TABLE froute ADD CONSTRAINT fk_froute_airport_from FOREIGN KEY (fromcode) REFERENCES airport(code);
ALTER TABLE froute ADD CONSTRAINT fk_froute_airport_to FOREIGN KEY (tocode) REFERENCES airport(code);
ALTER TABLE flight ADD CONSTRAINT fk_flight_ws FOREIGN KEY (year) REFERENCES weeklyschedule(year);
ALTER TABLE flight ADD CONSTRAINT fk_wsid_flight_ws FOREIGN KEY (wsid) REFERENCES weeklyschedule(wsid);
ALTER TABLE reservation ADD CONSTRAINT fk_reservation_flight FOREIGN KEY (flightnr) REFERENCES flight(flightnr);
ALTER TABLE reservation ADD CONSTRAINT fk_reservation_contact FOREIGN KEY (cpassnr) REFERENCES contact(cpassnr);
ALTER TABLE booking ADD CONSTRAINT fk_booking_reservation FOREIGN KEY (bookingid) REFERENCES reservation(rid);
ALTER TABLE ticket ADD CONSTRAINT fk_ticket_booking FOREIGN KEY (bookingid) REFERENCES booking(bookingid);
ALTER TABLE ticket ADD CONSTRAINT fk_ticket_passenger FOREIGN KEY (passnr) REFERENCES passenger(passnr);
ALTER TABLE passportOnReservation ADD CONSTRAINT fk_rmbp_reservation FOREIGN KEY (reservation_nr) REFERENCES reservation(rid);
ALTER TABLE passportOnReservation ADD CONSTRAINT fk_rmbp_passenger FOREIGN KEY (passport) REFERENCES passenger(passnr);

-- Procedure creation
SELECT 'Creating procedures for ass3' AS 'Message';

DROP PROCEDURE IF EXISTS addYear;
DROP PROCEDURE IF EXISTS addDay;
DROP PROCEDURE IF EXISTS addDestination;
DROP PROCEDURE IF EXISTS addRoute;
DROP PROCEDURE IF EXISTS getRouteID;
DROP PROCEDURE IF EXISTS addFlight;
DROP PROCEDURE IF EXISTS getPriceFromFlightnr;

DELIMITER // 
CREATE PROCEDURE addYear(IN p_year INT, 
                         IN p_factor DOUBLE)
BEGIN
  INSERT INTO profitfactor(year, profitfactor)
  VALUES (p_year, p_factor);
END; //


CREATE PROCEDURE addDay(IN in_year INT, 
                        IN in_day VARCHAR(10), 
                        IN in_factor DOUBLE)
BEGIN
  INSERT INTO weekdayfactor(year, day, weekdayfactor)
  VALUES (in_year, in_day, in_factor);
END; //


CREATE PROCEDURE addDestination(IN in_airport_code VARCHAR(3), 
                                IN in_name VARCHAR(30), 
                                IN in_country VARCHAR(30))
BEGIN
  INSERT INTO airport(code, name, country)
  VALUES (in_airport_code, in_name, in_country);
END; //


CREATE PROCEDURE addRoute(IN in_departure_airport_code VARCHAR(3), 
                          IN in_arrival_airport_code VARCHAR(3), 
                          IN in_year INT, IN in_routeprice INT)
BEGIN
  INSERT INTO froute(fromcode, tocode, year, routeprice) 
  VALUES (in_departure_airport_code, in_arrival_airport_code, in_year, in_routeprice);
END; //


CREATE PROCEDURE getRouteID(OUT route_id INT, 
                            IN in_departure_airport_code VARCHAR(3), 
                            IN in_arrival_airport_code VARCHAR(3), 
                            IN in_year INT)
BEGIN
  SELECT routeid INTO route_id
  FROM froute 
  WHERE (fromcode=in_departure_airport_code)
  AND (tocode=in_arrival_airport_code)
  AND (year=in_year);
END; //

-- Get wsid from weeklyschedule
CREATE PROCEDURE getWsidFromWeeklySchedule(OUT out_wsid INT, 
                            IN in_year INT,
                            IN in_day VARCHAR(10),  
                            IN in_dep_time TIME)
BEGIN
  SELECT wsid INTO out_wsid
  FROM weeklyschedule 
  WHERE year=in_year
    AND day=in_day
    AND dep_time=in_dep_time;
END; //


CREATE PROCEDURE addFlight(IN in_departure_airport_code VARCHAR(3), 
                           IN in_arrival_airport_code VARCHAR(3), 
                           IN in_year INT, 
                           IN in_day VARCHAR(10), 
                           IN in_dep_time TIME)
BEGIN
  DECLARE routeID INT DEFAULT -1;
  DECLARE week_cntr INT DEFAULT 1;
  DECLARE wsid INT DEFAULT -1;
  
  CALL getRouteID(routeID, 
                  in_departure_airport_code, 
                  in_arrival_airport_code, 
                  in_year);
  
  INSERT INTO weeklyschedule(year, day, routeid, dep_time)
  VALUES (in_year, in_day, routeID, in_dep_time);

  SELECT last_insert_id() INTO wsid;

  WHILE week_cntr <= 52 DO
    INSERT INTO flight(week, year, wsid)
    VALUES (week_cntr, in_year, wsid);
    SET week_cntr = week_cntr + 1;
  END WHILE;

END; //




DELIMITER ;


SELECT 'Creating functions for ass4' AS 'Message';

DROP FUNCTION IF EXISTS calculateFreeSeats;
DROP FUNCTION IF EXISTS calculatePrice;
DROP FUNCTION IF EXISTS getWeekdayFactor;
DROP FUNCTION IF EXISTS getProfitFactor;
DROP FUNCTION IF EXISTS getRouteIdFromFlightnr;
DROP FUNCTION IF EXISTS getPriceFromFlightnr;

DELIMITER //
CREATE FUNCTION calculateFreeSeats(flightnumber INT)
RETURNS INT
BEGIN
  DECLARE freeseats INT DEFAULT null; -- null when it's wrong/not found.

  SELECT vacantseats INTO freeseats
  FROM flight
  WHERE flight.flightnr=flightnumber;

  RETURN freeseats;
END; //


CREATE FUNCTION getWeekdayFactor(day VARCHAR(10), year INT)
RETURNS DOUBLE
BEGIN
  DECLARE wdFactor DOUBLE;

  SELECT wdf.weekdayfactor INTO wdFactor
  FROM weekdayfactor AS wdf
  WHERE (wdf.day=day) AND (wdf.year=year);

  SELECT
  CASE wdFactor
    WHEN wdFactor=NULL THEN 1.0 -- Should return NULL if not in the table?
    ELSE wdFactor
  END
  INTO wdFactor;

  RETURN wdFactor;
END; //


CREATE FUNCTION getProfitFactor(year INT)
RETURNS DOUBLE
BEGIN
  DECLARE profitFactor DOUBLE;
  
  SELECT pf.profitfactor INTO profitFactor
  FROM profitfactor AS pf
  WHERE (pf.year=year);

  RETURN profitFactor;
END;//


CREATE FUNCTION getRouteIdFromFlightnr(flightnumber INT)
RETURNS INT
BEGIN
  DECLARE flightRouteId INT;

  SELECT f.routeid INTO flightRouteId
  FROM flight AS f
  WHERE f.flightnr=flightnumber;

  RETURN flightRouteId; 
END;//


CREATE FUNCTION getPriceFromFlightnr(flightnumber INT)
RETURNS DOUBLE
BEGIN
  DECLARE routePrice DOUBLE;

  SELECT fr.routeprice INTO routePrice
  FROM froute AS fr
  WHERE fr.routeid=getRouteIdFromFlightnr(flightnumber);

  RETURN routePrice; 
END;//

-- The flight pricing depends on
-- • the start and stop destination which (together) has a route price,
-- • the day of the week. BrianAir has the same weekday pricing factor for all
-- flights regardless of destination, e.g. factor 4.7 on Fridays and Sundays,
-- factor 1 on Tuesdays, etc.
-- • the number of already confirmed/booked passengers on the flight. The
-- more passengers are booked the more expensive the flight becomes.
-- • what profit BrianAir wants to make on the flights. This factor is the same
-- for all flights.

-- Pricing factors (including profitfactor) and route prices can change when the
-- schedule changes, once per year!

CREATE FUNCTION calculatePrice(flightnumber INT) -- Still TODO
RETURNS DOUBLE
-- RETURNS VARCHAR(10)
-- RETURNS INT
BEGIN
  DECLARE vacantseats INT DEFAULT 0;
  DECLARE totalPrice DOUBLE DEFAULT 0.0;
  DECLARE routePrice DOUBLE DEFAULT 0.0;
  DECLARE wantedDay VARCHAR(10);
  DECLARE wantedYear INT;
  DECLARE dayFactor DOUBLE DEFAULT 1.0;	   

  -- FIND OUT ROUTE PRICE - WORKS
  SET routePrice=getPriceFromFlightnr(flightnumber);
  
  -- FIND OUT DAY - WORKS
  SELECT ws.day INTO wantedDay
  FROM weeklyschedule AS ws
  WHERE ws.routeid=getRouteIdFromFlightnr(flightnumber);  

  -- FIND OUT YEAR - WORKS
  SELECT ws.year INTO wantedYear
  FROM weeklyschedule AS ws
  WHERE ws.routeid=getRouteIdFromFlightnr(flightnumber);

  -- FIND OUT vacant seats - WORKS
  SELECT calculateFreeSeats(flightnumber) INTO vacantseats;

  -- SET factor according to weekday and year
  SELECT getWeekdayFactor(wantedDay, wantedYear) INTO dayFactor;

  -- May need to check this one once more
  SET totalPrice=round(routePrice*dayFactor*(40-vacantseats+1)/40*getProfitFactor(wantedYear), 0); 
  
  RETURN totalPrice;
END; //

DELIMITER ;

-- Question 5 - Create trigger to issue unique ticket number for paid reservation
DROP PROCEDURE IF EXISTS addTicket;
DROP TRIGGER IF EXISTS ticketNrGen;

DELIMITER //
CREATE PROCEDURE addTicket(IN bookingID INT, IN passNbr INT, IN ticketNbr INT)
BEGIN
  INSERT INTO ticket(passnr, ticketnr, bookingid)
  VALUES (passNbr, ticketNbr, bookingID);
END; //


-- CREATE TRIGGER ticketNrGen
-- ON ticket
-- AFTER INSERT ON booking
-- NOT FOR REPLICATION
-- BEGIN

-- END; //

DELIMITER ;
-- ##############################################################
-- Question 6
DROP FUNCTION IF EXISTS getFlightNr;

DELIMITER //

CREATE FUNCTION getFlightNr(in_week INT, in_year INT, in_wsid INT)
RETURNS INT
BEGIN
  DECLARE return_flight_nr INT;

  SELECT flightnr INTO return_flight_nr
  FROM flight
  WHERE week=in_week
    AND year=in_year
    AND wsid=in_wsid;

  RETURN return_flight_nr;
END; //

DELIMITER ;

DROP PROCEDURE IF EXISTS getFlightNr;
DROP PROCEDURE IF EXISTS addReservation;

DELIMITER //

-- Create reservation on specific flight
CREATE PROCEDURE addReservation(IN in_departure_airport_code VARCHAR(3),
                                IN in_arrival_airport_code VARCHAR(3),
                                IN in_year INT,
                                IN in_week INT,
                                IN in_day VARCHAR(10),
                                IN in_time TIME,
                                IN in_number_of_passengers INT,
                                OUT output_reservation_number INT)
BEGIN
  DECLARE vacantSeats INT;
  DECLARE the_wsid INT;
  DECLARE flightnumber INT;
  DECLARE routeID INT;

  CALL getRouteID(routeID, 
                  in_departure_airport_code, 
                  in_arrival_airport_code, 
                  in_year);

  -- Make sure that in_year, in_day and in_time match up with 
  -- year, day and dep_time in weeklyscheedule.
  SELECT wsid INTO the_wsid
  FROM weeklyschedule
  WHERE (year=in_year
    AND day=in_day
    AND dep_time=in_time);

  IF (the_wsid IS NULL) THEN
    SELECT "There exist no flight for the given route, date and time"
    AS 'Message';
  ELSE

    -- -- Get flightnumber from the info we have as input.
    SET flightnumber = getFlightNr(in_week, in_year, the_wsid);

    SET vacantSeats = calculateFreeSeats(flightnumber);
    IF ( vacantSeats >= in_number_of_passengers ) THEN
      INSERT INTO reservation(flightnr)
      VALUE (flightnumber);
      SELECT last_insert_id() INTO output_reservation_number;
    ELSE
      SELECT "There are not enough seats available on the chosen flight"
      AS 'Message';
    END IF;
  END IF;
END; //


CREATE PROCEDURE addPassenger(IN in_reservation_nr INT, 
                              IN in_passport_number INT,
                              IN in_name VARCHAR(30))
BEGIN
  DECLARE inFirstName VARCHAR(30);
  DECLARE inLastName VARCHAR(30);
  DECLARE isPass INT;
  DECLARE reservationExists INT;

  SELECT rid INTO reservationExists
  FROM reservation
  WHERE rid=in_reservation_nr;

  IF reservationExists IS NOT NULL THEN
    
    SET inFirstName = SUBSTRING_INDEX(in_name, ' ', 1);
    SET inLastName = SUBSTRING_INDEX(in_name, ' ', -1);

    SELECT passnr 
    INTO isPass
    FROM passenger 
    WHERE passnr=in_passport_number;

    IF isPass IS NULL THEN
      INSERT INTO passenger(passnr, firstName, lastName)
      VALUES (in_passport_number, 
              inFirstName,
              inLastName);

      INSERT INTO passportOnReservation(passport, reservation_nr)
      VALUES (in_passport_number, in_reservation_nr);
    ELSE
      INSERT INTO passportOnReservation(passport, reservation_nr)
      VALUES (in_passport_number, in_reservation_nr);
    END IF;
  ELSE    
    SELECT "The given reservation number does not exist" AS "Message";
  END IF;
END //


DROP FUNCTION IF EXISTS getContactPassportNr;

CREATE FUNCTION getContactPassportNr(in_phone BIGINT, in_email VARCHAR(30))
RETURNS INT
BEGIN
  DECLARE contactPassNr INT;

  SELECT cpassnr INTO contactPassNr
  FROM contact
  WHERE phone=in_phone
    AND email=in_email;

  RETURN cpassnr;
END //


DROP PROCEDURE IF EXISTS addContact;

CREATE PROCEDURE addContact(IN in_reservation_nr INT, 
                            IN in_passport_number INT,
                            IN in_email VARCHAR(30),
                            IN in_phone BIGINT)
BEGIN
  DECLARE isOnReservation INT;
  DECLARE isValidReservation INT;
  
  SELECT rid INTO isValidReservation 
  FROM reservation 
  WHERE rid=in_reservation_nr;

  IF isValidReservation IS NOT NULL THEN

    -- Check if contact is a passenger on the reservation.
    SELECT passport INTO isOnReservation
    FROM passportOnReservation
    WHERE passport=in_passport_number
      AND reservation_nr=in_reservation_nr;

    IF isOnReservation IS NOT NULL THEN

      INSERT INTO contact(cpassnr, phone, email)
      VALUES (in_passport_number, in_phone, in_email);

      UPDATE reservation
      SET
        cpassnr=in_passport_number
      WHERE
        rid=in_reservation_nr;

    ELSE
      SELECT "The person is not a passenger of the reservation" AS "Message";
    END IF;

  ELSE
    SELECT "The given reservation number does not exist" AS "Message";
  END IF;
END //

DELIMITER ;

-- SELECT "Testing answer for 6, handling reservations and bookings" as "Message";
-- SELECT "Filling database with flights" as "Message";
-- /*Fill the database with data */
-- CALL addYear(2010, 2.3);
-- CALL addDay(2010,"Monday",1);
-- CALL addDestination("MIT","Minas Tirith","Mordor");
-- CALL addDestination("HOB","Hobbiton","The Shire");
-- CALL addRoute("MIT","HOB",2010,2000);
-- CALL addFlight("MIT","HOB", 2010, "Monday", "09:00:00");
-- CALL addFlight("MIT","HOB", 2010, "Monday", "21:00:00");

-- SELECT "Test 1: Adding a reservation, expected OK result" as "Message";
-- CALL addReservation("MIT","HOB",2010,1,"Monday","09:00:00",3,@a);
-- SELECT "Check that the reservation number is returned properly (any number will do):" AS "Message",@a AS "Res. number returned"; 


-- ##############################################################
-- TEST lines for Question3.sql
-- SELECT "Trying to add 2 years" AS "Message";
-- CALL addYear(2010, 2.3);
-- CALL addYear(2011, 2.5);
-- SELECT "Trying to add 4 days" AS "Message";
-- CALL addDay(2010,"Monday",1);
-- CALL addDay(2010,"Tuesday",1.5);
-- CALL addDay(2011,"Saturday",2);
-- CALL addDay(2011,"Sunday",2.5);
-- SELECT "Trying to add 2 destinations" AS "Message";
-- CALL addDestination("MIT","Minas Tirith","Mordor");
-- CALL addDestination("HOB","Hobbiton","The Shire");
-- SELECT "Trying to add 4 routes" AS "Message";
-- CALL addRoute("MIT","HOB",2010,2000);
-- CALL addRoute("HOB","MIT",2010,1600);
-- CALL addRoute("MIT","HOB",2011,2100);
-- CALL addRoute("HOB","MIT",2011,1500);
-- SELECT "Trying to add 4 weeklyschedule flights" AS "Message";
-- CALL addFlight("MIT","HOB", 2010, "Monday", "09:00:00");
-- CALL addFlight("HOB","MIT", 2010, "Tuesday", "10:00:00");
-- CALL addFlight("MIT","HOB", 2011, "Sunday", "11:00:00");
-- CALL addFlight("HOB","MIT", 2011, "Sunday", "12:00:00");
-- SELECT * from froute;
-- SELECT * from weeklyschedule;
-- SELECT * from flight;
-- QUESION 3 TEST END #######################################
-- QUESION 4 TEST START #######################################

-- Function tests
-- SELECT calculateFreeSeats(208) AS '4 a) Free seats function';
-- SELECT calculatePrice(34) AS 'Day: Sunday';
-- SELECT calculatePrice(108) AS 'Day: Tuesday';
-- SELECT getWeekdayFactor('Tuesday',2010) AS 'Factor: 1.5';
-- SELECT getWeekdayFactor('Saturday',2011) AS 'Factor: 2';
-- SELECT calculatePrice(101) AS 'Start: 1600';

-- SELECT getPriceFromFlightnr(103) AS 'getPrice Start: 1600';

-- SELECT calculatePrice(207) AS 'Start: 1500';

-- SELECT calculatePrice(50) AS 'Start: 2000';
-- SELECT getRouteIdFromFlight(190) AS 'should be 4';
-- SELECT getRouteIdFromFlight(90) AS 'should be 2';

-- source Question3.sql;
source Question6.sql;
