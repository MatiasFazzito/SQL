CREATE FUNCTION get_specialty_multiplier(p_specialty INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_multiplier INT;

    CASE p_specialty
        WHEN 1 THEN SET v_multiplier = 1; -- paramédicos
        WHEN 2 THEN SET v_multiplier = 1; -- bomberos
        WHEN 3 THEN SET v_multiplier = 3; -- rescatistas
        WHEN 4 THEN SET v_multiplier = 3; -- policías
        ELSE SET v_multiplier = 0;        -- sin asignación
    END CASE;

    RETURN v_multiplier;
END;
