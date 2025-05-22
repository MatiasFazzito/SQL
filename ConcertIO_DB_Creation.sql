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
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`Staff`)
        REFERENCES `staff` (`ID`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB4;

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