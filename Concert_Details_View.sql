CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `concertio`.`concert_details` AS
    SELECT 
        `c`.`ID` AS `Concert_ID`,
        `b`.`Name` AS `Band_Name`,
        `s`.`Name` AS `Stadium_Name`
    FROM
        ((`concertio`.`concert` `c`
        JOIN `concertio`.`bands` `b` ON ((`c`.`Band` = `b`.`ID`)))
        JOIN `concertio`.`stadium` `s` ON ((`c`.`Stadium` = `s`.`ID`)))