--Drop all tables as necessary
--DROP TABLE IF EXISTS table_name” resp. “DROP PROCEDURE IF EXISTS proc_name
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





SELECT 'Creating tables' AS 'Message';

CREATE TABLE passenger
    (passnr INT NOT NULL,
    firstname VARCHAR(30),
    lastname VARCHAR(30),
    CONSTRAINT pk_passenger PRIMARY KEY(passnr))
    ENGINE=InnoDB;

CREATE TABLE contact
    (cpassnr INT NOT NULL,
    phone BIGINT,
    email VARCHAR(30),
    CONSTRAINT pk_contact PRIMARY KEY(cpassnr)) 
    ENGINE=InnoDB;
    
CREATE TABLE weeklyschedule
    (year INT,
    day VARCHAR(10),
    routeid INT,
    dep_time,
    CONSTRAINT pk_weekly_schedule PRIMARY KEY(year))
    -- CONSTRAINT uniq_day UNIQUE(day)) 
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
    vacantseats INT,
    week INT,
    year INT,
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
ALTER TABLE reservation ADD CONSTRAINT fk_reservation_flight FOREIGN KEY (flightnr) REFERENCES flight(flightnr);
ALTER TABLE reservation ADD CONSTRAINT fk_reservation_contact FOREIGN KEY (cpassnr) REFERENCES contact(cpassnr);
ALTER TABLE booking ADD CONSTRAINT fk_booking_reservation FOREIGN KEY (bookingid) REFERENCES reservation(rid);
ALTER TABLE ticket ADD CONSTRAINT fk_ticket_booking FOREIGN KEY (bookingid) REFERENCES booking(bookingid);
ALTER TABLE ticket ADD CONSTRAINT fk_ticket_passenger FOREIGN KEY (passnr) REFERENCES passenger(passnr);

-- Function creation
SELECT 'Creating functions for ass3' AS 'Message';


DROP PROCEDURE IF EXISTS addYear;
DROP PROCEDURE IF EXISTS addDay;
DROP PROCEDURE IF EXISTS addDestination;
DROP PROCEDURE IF EXISTS addRoute;


DELIMITER // 
CREATE PROCEDURE addYear(IN p_year INT, IN p_factor DOUBLE)
BEGIN
INSERT INTO profitfactor(year, profitfactor) VALUES (p_year, p_factor);
END; //

CREATE PROCEDURE addDay(IN in_year INT, IN in_day VARCHAR(10), IN in_factor DOUBLE)
BEGIN
INSERT INTO weekdayfactor(year, day, weekdayfactor) VALUES (in_year, in_day, in_factor);
END; //

CREATE PROCEDURE addDestination(IN in_airport_code VARCHAR(3), IN in_name VARCHAR(30), IN in_country VARCHAR(30))
BEGIN
INSERT INTO airport(code, name, country) VALUES (in_airport_code, in_name, in_country);
END; //

CREATE PROCEDURE addRoute(IN in_departure_airport_code VARCHAR(3), IN in_arrival_airport_code VARCHAR(3), IN in_year INT, IN in_routeprice INT)
BEGIN
INSERT INTO froute(fromcode, tocode, year, routeprice) 
VALUES (in_departure_airport_code, in_arrival_airport_code, in_year, in_routeprice);
END; //

-- 

CREATE PROCEDURE addFlight(IN in_departure_airport_code VARCHAR(3), IN in_arrival_airport_code VARCHAR(3), IN in_year INT, IN in_day INT, IN in_dep_time TIME)
BEGIN
-- Insert into weeklyschedule
INSERT INTO weeklyschedule()
-- Insert into flight

INSERT INTO flight(vacantseats, week, year) 
VALUES (in_departure_airport_code, in_arrival_airport_code, in_year, in_routeprice);
END; //

DELIMITER ;

 

SELECT * from profitfactor;
call addYear(2000, 2.4);
SELECT * from profitfactor;

SELECT * from weekdayfactor;
call addDay(2000, 'Tue', 5.3);
SELECT * from weekdayfactor;

SELECT * from airport;
call addDestination('BAU', 'Baubau Airport', 'Indonesia');
call addDestination('ARN', 'Stockholm Skavsta', 'Sweden');
SELECT * from airport;

SELECT * from froute;
call addRoute('BAU', 'ARN', 2018, 3600);
SELECT * from froute;

