--Drop all tables as necessary
--DROP TABLE IF EXISTS table_name” resp. “DROP PROCEDURE IF EXISTS proc_name
DROP TABLE IF EXISTS ticket CASCADE;
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS reservation CASCADE;
DROP TABLE IF EXISTS profitfactor CASCADE;
DROP TABLE IF EXISTS flight CASCADE;
DROP TABLE IF EXISTS weekdayfactor CASCADE;
DROP TABLE IF EXISTS weeklyschedule CASCADE;
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
    wsday VARCHAR(3),
    routeid INT,
    CONSTRAINT pk_weekly_schedule PRIMARY KEY(year),
    CONSTRAINT uniq_day UNIQUE(wsday)) 
    ENGINE=InnoDB;
    
CREATE TABLE weekdayfactor
    (weekdayfactor DOUBLE,
    wfday VARCHAR(3),
    CONSTRAINT pk_weekdayfactor PRIMARY KEY(wfday)) 
    ENGINE=InnoDB;

CREATE TABLE froute
    (routeid INT NOT NULL AUTO_INCREMENT,
    routeprice DOUBLE,
    fromcode VARCHAR(3),
    tocode VARCHAR(3),
    CONSTRAINT pk_froute PRIMARY KEY(routeid)) 
    ENGINE=InnoDB;

CREATE TABLE airport
    (country VARCHAR(30),
    code VARCHAR(3),
    name VARCHAR(30),
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
    (profitfactor DOUBLE,
    year INT,
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
ALTER TABLE froute ADD CONSTRAINT fk_froute_airport_from FOREIGN KEY (fromcode) REFERENCES airport(code);
ALTER TABLE froute ADD CONSTRAINT fk_froute_airport_to FOREIGN KEY (tocode) REFERENCES airport(code);
ALTER TABLE flight ADD CONSTRAINT fk_flight_ws FOREIGN KEY (year) REFERENCES weeklyschedule(year);
ALTER TABLE profitfactor ADD CONSTRAINT fk_pf_ws FOREIGN KEY (year) REFERENCES weeklyschedule(year);
ALTER TABLE weekdayfactor ADD CONSTRAINT fk_wf_ws FOREIGN KEY (wfday) REFERENCES weeklyschedule(wsday);
ALTER TABLE reservation ADD CONSTRAINT fk_reservation_flight FOREIGN KEY (flightnr) REFERENCES flight(flightnr);
ALTER TABLE reservation ADD CONSTRAINT fk_reservation_contact FOREIGN KEY (cpassnr) REFERENCES contact(cpassnr);
ALTER TABLE booking ADD CONSTRAINT fk_booking_reservation FOREIGN KEY (bookingid) REFERENCES reservation(rid);
ALTER TABLE ticket ADD CONSTRAINT fk_ticket_booking FOREIGN KEY (bookingid) REFERENCES booking(bookingid);
ALTER TABLE ticket ADD CONSTRAINT fk_ticket_passenger FOREIGN KEY (passnr) REFERENCES passenger(passnr);
