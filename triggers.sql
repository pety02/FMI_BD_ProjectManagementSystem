SET SCHEMA FN3MI0700022;

-- A trigger that validates the user data before insert.
CREATE OR REPLACE TRIGGER TRIG_BEFORE_USER_INSERT
    BEFORE INSERT ON FN3MI0700022.USERS
    REFERENCING NEW AS N
    FOR EACH ROW
    BEGIN
        DECLARE V_IS_VALID_DATA BOOLEAN;
        CALL FN3MI0700022.USER_MOD.P_VALIDATE_USER_DATA(N.EMAIL, N.USERNAME, V_IS_VALID_DATA);
        IF V_IS_VALID_DATA = TRUE
            THEN INSERT INTO FN3MI0700022.USERS(EMAIL, USERNAME, PASSWORD)
                 VALUES (N.EMAIL, N.USERNAME, N.PASSWORD);
        END IF;
    END;

-- A trigger that validates the user date before update.
-- To think if the user wants to update only one field in his / her data
-- (example: only email, only username, only password) and of course if
-- he / she wants to update more than one field in the data.
CREATE OR REPLACE TRIGGER TRIG_BEFORE_USER_UPDATE
    BEFORE UPDATE ON FN3MI0700022.USERS
    REFERENCING OLD AS O NEW AS N
    FOR EACH ROW
BEGIN
    DECLARE V_IS_VALID_DATA BOOLEAN;
    CALL FN3MI0700022.USER_MOD.P_VALIDATE_USER_DATA(N.EMAIL, N.USERNAME, V_IS_VALID_DATA);
    IF V_IS_VALID_DATA = TRUE AND O.USERNAME != N.USERNAME AND O.EMAIL != N.EMAIL
    THEN INSERT INTO FN3MI0700022.USERS(EMAIL, USERNAME, PASSWORD)
         VALUES (N.EMAIL, N.USERNAME, N.PASSWORD);
    END IF;
END;

-- A trigger that logs deletions from Projects table
-- (after a definite project is deleted).