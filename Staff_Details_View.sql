CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `concertio`.`staff_details` AS
    SELECT 
        `s`.`ID` AS `Staff_ID`,
        `s`.`Name` AS `Staff_Name`,
        `sp`.`Name` AS `Specialty_Name`
    FROM
        (`concertio`.`staff` `s`
        JOIN `concertio`.`specialty` `sp` ON ((`s`.`Specialty` = `sp`.`ID`)))