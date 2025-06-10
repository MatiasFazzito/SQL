CREATE DEFINER=`root`@`localhost` PROCEDURE `asign_staff_to_all_concerts`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_concert_id INT;

    DECLARE cur CURSOR FOR
        SELECT ID FROM concert;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_concert_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        CALL assign_specialty_to_concert(v_concert_id, 1); -- Paramedics
        CALL assign_specialty_to_concert(v_concert_id, 2); -- Firemen
        CALL assign_specialty_to_concert(v_concert_id, 3); -- Rescatists
        CALL assign_specialty_to_concert(v_concert_id, 4); -- Security
    END LOOP;
    CLOSE cur;
END