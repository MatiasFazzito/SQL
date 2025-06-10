CREATE DEFINER=`root`@`localhost` PROCEDURE `assign_specialty_to_concert`(
    IN p_concert_id INT,
    IN p_specialty INT
)
BEGIN
    DECLARE v_tickets INT;
    DECLARE v_staff_id INT;
    DECLARE v_counter INT DEFAULT 0;
    DECLARE v_max INT;
    DECLARE done INT DEFAULT FALSE;

    DECLARE cur CURSOR FOR 
        SELECT ID FROM staff
        WHERE Specialty = p_specialty
          AND ID NOT IN (
              SELECT Staff FROM asignation WHERE Concert = p_concert_id
          );
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Obtener valores
    SELECT Tickets_Sold INTO v_tickets FROM concert WHERE ID = p_concert_id;
    SET v_max = get_required_staff(v_tickets, p_specialty);

    -- Asignación con cursor
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_staff_id;
        IF done THEN LEAVE read_loop; END IF;
        IF v_counter >= v_max THEN LEAVE read_loop; END IF;

        INSERT INTO asignation (Concert, Staff) VALUES (p_concert_id, v_staff_id);
        SET v_counter = v_counter + 1;
    END LOOP;
    CLOSE cur;
END