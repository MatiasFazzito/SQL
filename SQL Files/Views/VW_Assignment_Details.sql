CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `assignment_details` AS
    SELECT 
        `a`.`ID` AS `Asignation_ID`,
        `stf`.`Name` AS `Staff_Name`,
        `std`.`Name` AS `Stadium_Name`
    FROM
        (((`asignation` `a`
        JOIN `staff` `stf` ON ((`a`.`Staff` = `stf`.`ID`)))
        JOIN `concert` `c` ON ((`a`.`Concert` = `c`.`ID`)))
        JOIN `stadium` `std` ON ((`c`.`Stadium` = `std`.`ID`)))