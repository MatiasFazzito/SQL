-- Schema Creation
DROP SCHEMA IF EXISTS ConcertIO;
CREATE SCHEMA ConcertIO ;

-- Schema Selection
USE concertio ;

-- Necessary table creation

CREATE TABLE `bands` (
    `ID` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(45) NOT NULL,
    `Members` INT NOT NULL,
    `Nationality` VARCHAR(20) NULL,
    `Language` VARCHAR(15) NOT NULL,
    `Genre` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`ID`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB4;

CREATE TABLE `stadium` (
    `ID` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(45) NOT NULL,
    `Country` VARCHAR(15) NOT NULL,
    `Capacity` INT NOT NULL,
    PRIMARY KEY (`ID`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB4;

CREATE TABLE `concert` (
    `ID` INT NOT NULL AUTO_INCREMENT,
    `Tickets_Sold` INT NOT NULL,
    `Band` INT NOT NULL,
    `Stadium` INT NOT NULL,
    PRIMARY KEY (`ID`),
    FOREIGN KEY (`Band`)
        REFERENCES `bands` (`ID`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`Stadium`)
        REFERENCES `stadium` (`ID`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB4;

CREATE TABLE `specialty` (
    `ID` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`ID`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB4;

CREATE TABLE `staff` (
    `ID` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(45) NOT NULL,
    `Gender` VARCHAR(1) NOT NULL,
    `Age` INT NOT NULL,
    `Specialty` INT NOT NULL,
    PRIMARY KEY (`ID`),
    FOREIGN KEY (`Specialty`)
        REFERENCES `specialty` (`ID`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB4;

CREATE TABLE `asignation` (
    `ID` INT NOT NULL AUTO_INCREMENT,
    `Concert` INT NOT NULL,
    `Staff` INT NOT NULL,
    PRIMARY KEY (`ID`),
    FOREIGN KEY (`Concert`)
        REFERENCES `concert` (`ID`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`Staff`)
        REFERENCES `staff` (`ID`)
        ON DELETE CASCADE ON UPDATE CASCADE
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB4;

CREATE TABLE audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(64),
    action_type ENUM('INSERT', 'UPDATE', 'DELETE'),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    old_data JSON,
    new_data JSON
);


DELIMITER $$

CREATE TRIGGER after_concert_insert
AFTER INSERT ON concert
FOR EACH ROW
BEGIN
    CALL assign_specialty_to_concert(NEW.ID, 1); -- Paramédico
    CALL assign_specialty_to_concert(NEW.ID, 2); -- Bombero
    CALL assign_specialty_to_concert(NEW.ID, 3); -- Rescatista
    CALL assign_specialty_to_concert(NEW.ID, 4); -- Policía
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER bands_after_insert
AFTER INSERT ON bands
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, action_type, new_data)
  VALUES ('bands', 'INSERT', JSON_OBJECT('id', NEW.id, 'name', NEW.name));
END$$

CREATE TRIGGER bands_after_update
AFTER UPDATE ON bands
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, action_type, old_data, new_data)
  VALUES ('bands', 'UPDATE',
          JSON_OBJECT('id', OLD.id, 'name', OLD.name),
          JSON_OBJECT('id', NEW.id, 'name', NEW.name));
END$$

CREATE TRIGGER bands_after_delete
AFTER DELETE ON bands
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, action_type, old_data)
  VALUES ('bands', 'DELETE',
          JSON_OBJECT('id', OLD.id, 'name', OLD.name));
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER stadium_after_insert
AFTER INSERT ON stadium
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, action_type, new_data)
  VALUES ('stadium', 'INSERT', JSON_OBJECT('id', NEW.id, 'name', NEW.name, 'capacity', NEW.capacity));
END$$

CREATE TRIGGER stadium_after_update
AFTER UPDATE ON stadium
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, action_type, old_data, new_data)
  VALUES ('stadium', 'UPDATE',
          JSON_OBJECT('id', OLD.id, 'name', OLD.name, 'capacity', OLD.capacity),
          JSON_OBJECT('id', NEW.id, 'name', NEW.name, 'capacity', NEW.capacity));
END$$

CREATE TRIGGER stadium_after_delete
AFTER DELETE ON stadium
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, action_type, old_data)
  VALUES ('stadium', 'DELETE',
          JSON_OBJECT('id', OLD.id, 'name', OLD.name, 'capacity', OLD.capacity));
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER concert_after_insert
AFTER INSERT ON concert
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, action_type, new_data)
  VALUES ('concert', 'INSERT', JSON_OBJECT('id', NEW.id, 'band', NEW.band, 'stadium', NEW.stadium, 'tickets_sold', NEW.tickets_sold));
END$$

CREATE TRIGGER concert_after_update
AFTER UPDATE ON concert
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, action_type, old_data, new_data)
  VALUES ('concert', 'UPDATE',
          JSON_OBJECT('id', OLD.id, 'band', OLD.band, 'stadium', OLD.stadium, 'tickets_sold', OLD.tickets_sold),
          JSON_OBJECT('id', NEW.id, 'band', NEW.band, 'stadium', NEW.stadium, 'tickets_sold', NEW.tickets_sold));
END$$

CREATE TRIGGER concert_after_delete
AFTER DELETE ON concert
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, action_type, old_data)
  VALUES ('concert', 'DELETE',
          JSON_OBJECT('id', OLD.id, 'band', OLD.band, 'stadium', OLD.stadium, 'tickets_sold', OLD.tickets_sold));
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER staff_after_insert
AFTER INSERT ON staff
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, action_type, new_data)
  VALUES ('staff', 'INSERT',
          JSON_OBJECT('id', NEW.id, 'name', NEW.name, 'gender', NEW.gender, 'age', NEW.age, 'specialty', NEW.specialty));
END$$

CREATE TRIGGER staff_after_update
AFTER UPDATE ON staff
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, action_type, old_data, new_data)
  VALUES ('staff', 'UPDATE',
          JSON_OBJECT('id', OLD.id, 'name', OLD.name, 'gender', OLD.gender, 'age', OLD.age, 'specialty', OLD.specialty),
          JSON_OBJECT('id', NEW.id, 'name', NEW.name, 'gender', NEW.gender, 'age', NEW.age, 'specialty', NEW.specialty));
END$$

CREATE TRIGGER staff_after_delete
AFTER DELETE ON staff
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, action_type, old_data)
  VALUES ('staff', 'DELETE',
          JSON_OBJECT('id', OLD.id, 'name', OLD.name, 'gender', OLD.gender, 'age', OLD.age, 'specialty', OLD.specialty));
END$$

DELIMITER ;
