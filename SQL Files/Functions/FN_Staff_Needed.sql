CREATE FUNCTION get_required_staff(p_tickets INT, p_specialty INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_multiplier INT;
    DECLARE v_required INT;

    SET v_multiplier = get_specialty_multiplier(p_specialty);
    SET v_required = CEIL(v_multiplier * p_tickets / 200);

    RETURN v_required;
END;
