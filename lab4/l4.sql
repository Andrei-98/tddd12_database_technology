\! clear
-- DROP DATABASE brianair;
-- CREATE DATABASE brianair;
-- use brianair;

DROP DATABASE danhu849;
CREATE DATABASE danhu849;
use danhu849;

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
    creditcardnr BIGINT,
    creditcardholder VARCHAR(30),
    totalprice DOUBLE,
    CONSTRAINT pk_bookingid PRIMARY KEY(bookingid)) 
    ENGINE=InnoDB;

CREATE TABLE ticket
    (passnr INT,
    ticketnr INT NOT NULL,
    bookingid INT,
    CONSTRAINT pk_ticketnr PRIMARY KEY(ticketnr),
    CONSTRAINT unique_ticket UNIQUE(passnr, bookingid)) 
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
-- CREATE PROCEDURE getWsidFromWeeklySchedule(OUT out_wsid INT, 
--                             IN in_year INT,
--                             IN in_day VARCHAR(10),  
--                             IN in_dep_time TIME)
-- BEGIN
--   SELECT wsid INTO out_wsid
--   FROM weeklyschedule 
--   WHERE year=in_year
--     AND day=in_day
--     AND dep_time=in_dep_time;
-- END; //


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
DROP FUNCTION IF EXISTS getWsidFromFlightnr;
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


CREATE FUNCTION getWsidFromFlightnr(flightnumber INT)
RETURNS INT
BEGIN
  DECLARE flightWSID INT;

  SELECT wsid INTO flightWSID
  FROM flight
  WHERE flightnr=flightnumber;

  RETURN flightWSID; 
END;//

-- CREATE FUNCTION getRouteIdFromFlightnr(flightnumber INT)
-- RETURNS INT
-- BEGIN
--   DECLARE flightRouteId INT;

--   SELECT routeId INTO flightRouteId
--   FROM flight
--   WHERE flightnr=flightnumber;

--   RETURN flightRouteId; 
-- END;//

CREATE FUNCTION getPriceFromFlightnr(flightnumber INT)
RETURNS DOUBLE
BEGIN
  DECLARE routePrices DOUBLE;
  DECLARE routeIDe INT;
  DECLARE wsIDe INT;

  -- Get wsid from flightNumber in flight.
  SELECT wsid INTO wsIDe
  FROM flight
  WHERE flightnr=flightnumber;

-- Get routeId from wsid in weeklyschedule.
  SELECT routeid INTO routeIDe
  FROM weeklyschedule
  WHERE wsid=wsIDe;

-- Get routeprice from routeId in froute.
  SELECT routeprice INTO routePrices
  FROM froute
  WHERE routeid=routeIDe;

  RETURN routePrices; 
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

CREATE FUNCTION calculatePrice(flightnumber INT)
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
  WHERE ws.wsid=getWsidFromFlightnr(flightnumber);  

  -- FIND OUT YEAR - WORKS
  SELECT ws.year INTO wantedYear
  FROM weeklyschedule AS ws
  WHERE ws.wsid=getWsidFromFlightnr(flightnumber);

  -- FIND OUT vacant seats - WORKS
  SELECT calculateFreeSeats(flightnumber) INTO vacantseats;

  -- SET factor according to weekday and year
  SELECT getWeekdayFactor(wantedDay, wantedYear) INTO dayFactor;

  -- May need to check this one once more
  SET totalPrice=round(routePrice*dayFactor*(40-vacantseats+1)/40*getProfitFactor(wantedYear), 3); 
  
  RETURN totalPrice;
END; //

DELIMITER ;

-- Question 5 - Create trigger to issue unique ticket number for paid reservation
DROP PROCEDURE IF EXISTS addTicket;
DROP TRIGGER IF EXISTS ticketNrGen;

DELIMITER //
CREATE PROCEDURE addTicket(IN bookingID INT, IN ticketnr INT, IN passNbr INT)
BEGIN
  INSERT INTO ticket(passnr, ticketnr, bookingid)
  VALUES (passNbr, ticketnr, bookingID);
END; //


CREATE TRIGGER ticketNrGen
AFTER INSERT ON booking
FOR EACH ROW -- affect only the inserted row
-- NOT FOR REPLICATION no clue what this is you had it
BEGIN
 
  -- Iterate through rows in passportOnReservation where reservation_nr
  -- matches bookingid.

  -- For each row above create a ticket with the passnr INT and bookingid INT

  DECLARE n INT;
  DECLARE i INT;
  DECLARE randSeed DOUBLE;
  DECLARE wantedPassport INT;
  DECLARE newBookingNumber INT;
  DECLARE startingRow INT DEFAULT 0;

  SET newBookingNumber=NEW.bookingid;
  
  SELECT COUNT(reservation_nr=1) INTO n 
  FROM passportOnReservation
  WHERE reservation_nr=newBookingNumber;

  SET i=0;

  WHILE i<n DO 
    SELECT passport INTO wantedPassport
    FROM passportOnReservation 
    WHERE reservation_nr=newBookingNumber
    LIMIT startingRow, 1;

    SET startingRow = startingRow + 1;

    -- DELETE FROM passportOnReservation
    -- WHERE reservation_nr=newBookingNumber
    --   AND passport=wantedPassport;

    SET randSeed = FLOOR(RAND() * 999999);
    CALL addTicket(newBookingNumber, randSeed, wantedPassport);
    SET i = i + 1;
 
  END WHILE;
END; // 


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



DELIMITER //
DROP PROCEDURE IF EXISTS addReservation;

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


DROP PROCEDURE IF EXISTS addPassenger;
CREATE PROCEDURE addPassenger(IN in_reservation_nr INT, 
                              IN in_passport_number INT,
                              IN in_name VARCHAR(30))
pros:BEGIN
  DECLARE inFirstName VARCHAR(30);
  DECLARE inLastName VARCHAR(30);
  DECLARE isPass INT;
  DECLARE reservationExists INT;
  DECLARE booking_id INT;

  SELECT rid INTO reservationExists
  FROM reservation
  WHERE rid=in_reservation_nr;

  IF reservationExists IS NOT NULL THEN
    
    SELECT bookingid INTO booking_id
    FROM booking
    WHERE bookingid=in_reservation_nr;
    IF booking_id IS NOT NULL THEN
      SELECT "The booking has already been payed and no futher passengers can be added" AS "MESSAGE";
      LEAVE pros;
    END IF;

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


DROP FUNCTION IF EXISTS getValidReservationId;

CREATE FUNCTION getValidReservationId(in_reservation_nr INT)
RETURNS INT
BEGIN
  DECLARE isValidReservation INT;

  SELECT rid INTO isValidReservation 
  FROM reservation 
  WHERE rid=in_reservation_nr;

  RETURN isValidReservation;
END; //


DROP FUNCTION IF EXISTS passportIsPassengerOnReservation;

CREATE FUNCTION passportIsPassengerOnReservation(in_passport_number INT,
                                                 in_reservation_nr INT)
RETURNS INT
BEGIN
  DECLARE isPassengerOnReservation INT;

  SELECT passport INTO isPassengerOnReservation
  FROM passportOnReservation
  WHERE passport=in_passport_number
    AND reservation_nr=in_reservation_nr;

  RETURN isPassengerOnReservation;
END; //



DROP PROCEDURE IF EXISTS addContact;

CREATE PROCEDURE addContact(IN in_reservation_nr INT, 
                            IN in_passport_number INT,
                            IN in_email VARCHAR(30),
                            IN in_phone BIGINT)
sp: BEGIN
  DECLARE contactAlreadyExists INT;

  IF getValidReservationId(in_reservation_nr) IS NULL THEN
    SELECT "The given reservation number does not exist" AS "Message";
    LEAVE sp;
  END IF;

  IF passportIsPassengerOnReservation(in_passport_number, in_reservation_nr) IS NULL
  THEN
    SELECT "The person is not a passenger of the reservation" AS "Message";
    LEAVE sp;
  ELSE
    SELECT cpassnr INTO contactAlreadyExists
    FROM contact
    WHERE cpassnr=in_passport_number;

    IF contactAlreadyExists IS NULL THEN
      INSERT INTO contact(cpassnr, phone, email)
      VALUES (in_passport_number, in_phone, in_email);
    END IF;

    UPDATE reservation
    SET
      cpassnr=in_passport_number
    WHERE
      rid=in_reservation_nr;
  END IF;
END; //


DROP FUNCTION IF EXISTS reservedSeatsOnReservationNr;
CREATE FUNCTION reservedSeatsOnReservationNr(in_reservation_nr INT)
RETURNS INT
BEGIN
  DECLARE reservedSeats INT;

  SELECT COUNT(*) INTO reservedSeats
  FROM passportOnReservation
  WHERE reservation_nr=in_reservation_nr;

  RETURN reservedSeats;
END; //


DROP FUNCTION IF EXISTS getContactForReservation;
CREATE FUNCTION getContactForReservation(in_reservation_nr INT)
RETURNS INT
BEGIN
  DECLARE contactPassNr INT;

  SELECT cpassnr INTO contactPassNr
  FROM reservation
  WHERE rid=in_reservation_nr;

  RETURN contactPassNr;
END; //


DROP PROCEDURE IF EXISTS addPayment;
CREATE PROCEDURE addPayment(IN in_reservation_nr INT,
                            IN in_credit_card_holder_name VARCHAR(30),
                            IN in_credit_card_nr BIGINT)
pros: BEGIN
  DECLARE flightNumber INT;
  DECLARE totalPrice INT;
  DECLARE reservedSeats INT;
  DECLARE freeSeats INT;

  IF getValidReservationId(in_reservation_nr) IS NULL THEN
    SELECT "The given reservation number does not exist" AS "Message";
    LEAVE pros;
  ELSEIF getContactForReservation(in_reservation_nr) IS NULL THEN
    SELECT "The reservation has no contact yet" AS "Message";
    LEAVE pros;
  ELSE
    SELECT flightnr INTO flightNumber
    FROM reservation
    WHERE rid=in_reservation_nr;

    SET reservedSeats = reservedSeatsOnReservationNr(in_reservation_nr);

    SET freeSeats = calculateFreeSeats(flightNumber);

    IF freeSeats >= reservedSeats THEN
      -- If uncommented -> overbooking normaly occurs:
      SELECT SLEEP(5) AS 'inside IF freeSeats >= reservedSeats';

      UPDATE flight
      SET vacantseats=calculateFreeSeats(flightNumber)-reservedSeats
      WHERE flightnr=flightNumber;
  

      SET totalPrice = calculatePrice(flightNumber) * reservedSeats;

      INSERT INTO booking(bookingid, creditcardnr, creditcardholder, totalprice)
      VALUES (in_reservation_nr, in_credit_card_nr, in_credit_card_holder_name, totalPrice);      

      
      LEAVE pros;
    ELSE
      SELECT "There are not enough seats available on the flight anymore, deleting reservation" AS "Message";
      LEAVE pros;
    END IF;
  END IF;
END //


DROP FUNCTION IF EXISTS getAirportNameFromCode;
CREATE FUNCTION getAirportNameFromCode(in_code VARCHAR(3))
RETURNS VARCHAR(30)
BEGIN

  DECLARE out_name VARCHAR(30);

  SELECT name INTO out_name
  FROM airport
  WHERE code=in_code;

  RETURN out_name;
END; //


DELIMITER ;

DROP VIEW IF EXISTS allFlights CASCADE;
CREATE VIEW allFlights AS
SELECT 
      getAirportNameFromCode(r.fromcode) as "departure_city_name",
      getAirportNameFromCode(r.tocode) as "destination_city_name",
      w.dep_time as "departure_time",
      w.day as "departure_day",
      f.week as "departure_week",
      f.year as "departure_year",
      f.vacantseats as "nr_of_free_seats",
      calculatePrice(f.flightnr) as "current_price_per_seat"
FROM flight as f
LEFT JOIN weeklyschedule as w ON f.wsid=w.wsid
LEFT JOIN froute as r ON w.routeid=r.routeid;


-- source Question3.sql;
-- source Question6.sql;
-- source Question7.sql;
 source Question10FillWithFlights.sql
-- source Question10MakeBooking.sql

/******************** QUESTION 8 **********************************
A) How can you protect the credit card information in the database from hackers?
• By making sure to be PCI-compliant and only store information absolutely necessary. That information should in turn be encrypted or hashed, preferably with a salt before being stored in the database. Encryption should occur on both the client and server side to decrease the risk of critical information being intercepted.

B) Give three advantages of using stored procedures in the database (and thereby execute them on the server) instead of writing the same functions in the front- end of the system (in for example java-script on a webpage).

1. Security is increased since direct access to the tables is not given. The procedures act as a middle layer limiting what a potential adversary can do when given unauthorized access to the system. Furthermore, the underlying code for the procedures can be encrypted further limiting attack surface.

2. It is faster to execute the procedures server side since servers usually have more resources than client hardware. 

3. Easier to modify stored procedures than front-end functions since changing front-end functions might need the front-end to be temporarily taken down for maintenance and then redeployed.
******************** END QUESTION 8 *********************************/


/******************** QUESTION 9 **********************************
b) It is not visible in B since a transaction has to be commited by A for it to shown in B.  

c) After adding a reservation in A and then trying to DELETE it from B. B gets stuck until A has either commited or rollbacked. In the case of commiting A the reservation will be queued for deletion in B but won't be deleted until B also commits. If B is rollbacked. The DELETE won't happen and A's reservation will be preserved. Modifications in transactions won't be applied until affected transaction commits as they are isolated from other .
******************** END QUESTION 9 *********************************/


/******************** QUESTION 10 **********************************
a) Overbooking did not occur as one reservation was completed before the other one.

b) Yes an overbooking can occur if both sessions reach within the "IF freeSeats >= reservedSeats" inside addPayment without decreasing reservedSeats.

c) By adding the SLEEP(5); command right below the "IF freeSeats >= reservedSeats" many sessions can pass the IF statement and overbooked flights may occur.

d) Our solution locks the tables affected by addPayment only under the time it takes for vacantseats in the table flight to be updated. Immediately after addPayment is complete the locks released.

******************** END QUESTION 10 *********************************/
