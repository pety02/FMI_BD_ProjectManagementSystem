SET SCHEMA FN3MI0700022;

-- A trigger that validates the user data before insert.
CREATE OR REPLACE TRIGGER TRIG_BEFORE_USER_INSERT
    BEFORE INSERT ON FN3MI0700022.USERS
    REFERENCING NEW AS N
    FOR EACH ROW
BEGIN
    DECLARE V_IS_VALID_DATA BOOLEAN;

    -- Call the validation procedure
    CALL FN3MI0700022.USER_MOD.P_VALIDATE_USER_DATA(N.EMAIL, N.USERNAME,
                                                    V_IS_VALID_DATA);

    -- Signal an error if data is invalid
    IF V_IS_VALID_DATA = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Validation failed: Email or Username is not unique.';
    END IF;
END;

-- trigger execution - signal error that the username or email is not unique
INSERT INTO FN3MI0700022.USERS(EMAIL, USERNAME, PASSWORD)
VALUES ('dummyaddress@outlook.com', 'speedy423', '123456');

-- trigger execution - inserts successfully a user
INSERT INTO FN3MI0700022.USERS(EMAIL, USERNAME, PASSWORD)
VALUES ('dummy@outlook.com', 'new423', '123456');

SET SCHEMA FN3MI0700022;

-- A trigger that validates the user date before update.
CREATE OR REPLACE TRIGGER TRIG_BEFORE_USER_UPDATE
    BEFORE UPDATE ON FN3MI0700022.USERS
    REFERENCING OLD AS O NEW AS N
    FOR EACH ROW
BEGIN
    DECLARE V_IS_VALID_DATA BOOLEAN;

    SET V_IS_VALID_DATA = O.USERNAME != N.USERNAME OR O.EMAIL != N.EMAIL;

    -- Signal an error if data is invalid
    IF V_IS_VALID_DATA = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Validation failed: Email or Username is not unique.';
    END IF;

    -- Optionally, check for specific fields being updated
    IF O.EMAIL = N.EMAIL AND O.USERNAME = N.USERNAME AND O.PASSWORD = N.PASSWORD THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No changes detected in the update operation.';
    END IF;
END;

-- trigger execution - successfully updates the user with a definite username
UPDATE FN3MI0700022.USERS U SET U.EMAIL = 'newaddress@gmail.com' WHERE U.USERNAME = 'new423';

SET SCHEMA FN3MI0700022;

-- A trigger that logs deletions from Projects table
-- (after a definite project is deleted).
CREATE TABLE DELETED_PROJECTS_LOG (
    PID INTEGER GENERATED ALWAYS AS IDENTITY
    CONSTRAINT PK_DEL_PROJECTS
    PRIMARY KEY,
    P_NAME VARCHAR(50),
    P_VERSION VARCHAR(20),
    RELEASE_DATE DATE DEFAULT CURRENT_DATE,
    P_DESCRIPTION VARCHAR(350),
    CHECK (P_VERSION LIKE '%_'),
    CHECK (RELEASE_DATE >= DATE('2023-01-01'))
);

SET SCHEMA FN3MI0700022;

-- A trigger that logs data for the deleted project after the project deletion.
CREATE OR REPLACE TRIGGER TRIG_LOG_AFTER_PROJECT_DELETION
    AFTER DELETE ON FN3MI0700022.PROJECTS
    REFERENCING OLD AS O
    FOR EACH ROW
BEGIN
    INSERT INTO FN3MI0700022.DELETED_PROJECTS_LOG(P_NAME, P_VERSION, P_DESCRIPTION)
        VALUES (O.P_NAME, O.P_VERSION, O.P_DESCRIPTION);
END;

-- deletes all connections to the project before executing the next line,
-- then executes the project deletion line and after the deletion in the
-- FN3MI0700022.DELETED_PROJECTS_LOG table will appear a log for this
-- deleted project
DELETE FROM FN3MI0700022.PROJECTS P WHERE P.PID = 1;