SET SCHEMA FN3MI0700022;

CREATE OR REPLACE MODULE USER_MOD;

-- A procedure that validates user data. This procedure can be used in the triggers
-- that will validate the user data before insert and before update.
ALTER MODULE USER_MOD PUBLISH PROCEDURE P_VALIDATE_USER_DATA(IN U_EMAIL VARCHAR(320),
                                                             IN U_USERNAME VARCHAR(10),
                                                             OUT V_IS_VALID BOOLEAN);
ALTER MODULE USER_MOD ADD PROCEDURE P_VALIDATE_USER_DATA(IN U_EMAIL VARCHAR(320),
                                                         IN U_USERNAME VARCHAR(10),
                                                         OUT V_IS_VALID BOOLEAN)
BEGIN
    DECLARE V_UID INT;
    DECLARE V_IS_VALID BOOLEAN;
    SET V_UID = (SELECT U.UID FROM FN3MI0700022.USERS U
                              WHERE U.USERNAME = U_USERNAME OR U.EMAIL = U_EMAIL);

    IF V_UID IS NOT NULL
        THEN
            SET V_IS_VALID = FALSE;
            SIGNAL SQLSTATE '70001'
            SET MESSAGE_TEXT = 'Username or email is not unique!';
    ELSE
        SET V_IS_VALID = TRUE;
    END IF;
END;

-- this procedure is tested in the before insert trigger for the FN3MI0700022.USERS table

CREATE OR REPLACE MODULE COMPANIES_MOD;

-- A procedure that will return information about all companies in which amateurs
-- and experienced employees work, the count of amateurs and the count of experienced
-- employees. This information can be used for statistical researches.
ALTER MODULE COMPANIES_MOD PUBLISH PROCEDURE P_GET_ALL_COMPANIES_IN_WHICH_AMATEURS_WORKS_INFO();
ALTER MODULE COMPANIES_MOD ADD PROCEDURE P_GET_ALL_COMPANIES_IN_WHICH_AMATEURS_WORKS_INFO()
BEGIN
    DECLARE V_C_ID INT;
    DECLARE V_C_NAME VARCHAR(50);
    DECLARE V_C_ADDRESS VARCHAR(100);
    DECLARE V_C_DESCRIPTION VARCHAR(500);
    DECLARE V_AMATEURS_EMPLOYEES_CNT INT;
    DECLARE V_EXPERIENCED_EMPLOYEES_CNT INT;

    DECLARE SQLSTATE CHAR(5) DEFAULT '00000';

    DECLARE CURSOR_COMPANIES CURSOR FOR (
        SELECT C.*,
               AMATEURS.AMATEURS_EMPLOYEES_COUNT,
               EXPERIENCED.EXPERIENCED_EMPLOYEES_COUNT
        FROM FN3MI0700022.COMPANIES C
                 LEFT JOIN FN3MI0700022.TEAMS T ON C.CID = T.CID
                 LEFT JOIN (
            SELECT T2.TID, COUNT(*) AS AMATEURS_EMPLOYEES_COUNT
            FROM FN3MI0700022.USERS_AMATEURS UA
                     LEFT JOIN FN3MI0700022.WORKSON ET ON UA.UID = ET.UID
                     LEFT JOIN FN3MI0700022.TEAMS T2 ON ET.TID = T2.TID
            GROUP BY T2.TID
        ) AS AMATEURS ON T.TID = AMATEURS.TID
                 LEFT JOIN (
            SELECT UE.TEAM_ID, COUNT(*) AS EXPERIENCED_EMPLOYEES_COUNT
            FROM FN3MI0700022.USERS_EMPLOYEES UE
            GROUP BY UE.TEAM_ID
        ) AS EXPERIENCED ON T.TID = EXPERIENCED.TEAM_ID
    );

    CALL DBMS_OUTPUT.PUT_LINE('CID, C_NAME, C_ADDRESS, C_DESCRIPTION, AMATEURS_EMPLOYEES_COUNT, ' ||
                              'EXPERIENCED_EMPLOYEES_COUNT');

    OPEN CURSOR_COMPANIES;
    FETCH CURSOR_COMPANIES INTO V_C_ID, V_C_NAME, V_C_ADDRESS, V_C_DESCRIPTION,
        V_AMATEURS_EMPLOYEES_CNT, V_EXPERIENCED_EMPLOYEES_CNT;
    WHILE SQLSTATE = '00000'
        DO
            CALL DBMS_OUTPUT.PUT_LINE(V_C_ID || ', ' || V_C_NAME || ', ' || V_C_ADDRESS || ', '
                || V_C_DESCRIPTION || ', ' || V_AMATEURS_EMPLOYEES_CNT || ', '
                                          || V_EXPERIENCED_EMPLOYEES_CNT);
            FETCH CURSOR_COMPANIES INTO V_C_ID, V_C_NAME, V_C_ADDRESS, V_C_DESCRIPTION,
                V_AMATEURS_EMPLOYEES_CNT, V_EXPERIENCED_EMPLOYEES_CNT;
        END WHILE;
    CLOSE CURSOR_COMPANIES;
END;

-- executes the procedure
CALL FN3MI0700022.COMPANIES_MOD.P_GET_ALL_COMPANIES_IN_WHICH_AMATEURS_WORKS_INFO();

-- A procedure that returns the history of a definite employee on the base of his / her
-- username. This procedure can be used for employees audit.
ALTER MODULE USER_MOD PUBLISH PROCEDURE P_GET_EMPLOYEE_HISTORY_BY_EMPLOYEE_USERNAME(
    IN P_UNM VARCHAR(10), OUT P_CURSOR_EMPLOYEE_HISTORY CURSOR);
ALTER MODULE USER_MOD ADD PROCEDURE P_GET_EMPLOYEE_HISTORY_BY_EMPLOYEE_USERNAME(
    IN P_UNM VARCHAR(10), OUT P_CURSOR_EMPLOYEE_HISTORY CURSOR)
BEGIN
    DECLARE P_CURSOR_EMPLOYEE_HISTORY CURSOR WITH RETURN FOR
        SELECT * FROM FN3MI0700022.USERS_EMPLOYEES E WHERE E.USERNAME = P_UNM;

    OPEN P_CURSOR_EMPLOYEE_HISTORY;
END;