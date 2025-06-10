CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `concertio`.`asignation_details` AS
    SELECT 
        `a`.`ID` AS `Asignation_ID`,
        `stf`.`Name` AS `Staff_Name`,
        `std`.`Name` AS `Stadium_Name`
    FROM
        (((`concertio`.`asignation` `a`
        JOIN `concertio`.`staff` `stf` ON ((`a`.`Staff` = `stf`.`ID`)))
        JOIN `concertio`.`concert` `c` ON ((`a`.`Concert` = `c`.`ID`)))
        JOIN `concertio`.`stadium` `std` ON ((`c`.`Stadium` = `std`.`ID`)))