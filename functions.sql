SET SCHEMA FN3MI0700022;

-- A function that returns all bugs in a project full data as a table.
-- This function can be used to make an audit of the bugs in a definite
-- project by its ID.
CREATE OR REPLACE FUNCTION F_GET_ALL_BUGS_IN_PROJECT(PID INT)
    RETURNS TABLE
            (
                TID             INT,
                SCENARIO        VARCHAR(600),
                PROJECT_ID      INT,
                BLOCKING_DATE   DATE,
                UNBLOCKING_DATE DATE
            )
    LANGUAGE SQL
    RETURN SELECT B.TID, B.SCENARIO, B.PROJECT_ID, B.BLOCKING_DATE, B.UNBLOCKING_DATE
            FROM FN3MI0700022.BUGS B
            WHERE B.PROJECT_ID = PID;



-- A function that returns all teams in a definite company tasks. This function can be
-- used for audit of all tasks that a definite company works on.
CREATE OR REPLACE FUNCTION F_GET_ALL_TEAMS_IN_A_COMPANY_TASKS(P_CID INT)
    RETURNS TABLE
            (
                TEAM_ID          INT,
                TEAM_NAME        VARCHAR(50),
                TASK_STATUS      CHAR(10),
                TASK_START_DATE  DATE,
                TASK_DESCRIPTION VARCHAR(350),
                DEFINED_BY_USER  VARCHAR(10),
                PROJECT_NAME     VARCHAR(50),
                PROJECT_VERSION  VARCHAR(20)
            )
    RETURN
        SELECT T.TID,
               T.T_NAME,
               TSK.STATUS,
               TSK.START_DATE,
               TSK.T_DESCRIPTION,
               U.USERNAME,
               P.P_NAME,
               P.P_VERSION
        FROM FN3MI0700022.TEAMS T
                 LEFT JOIN FN3MI0700022.TEAMSWORKON TW
                           ON T.TID = TW.TEAM_ID
                 LEFT JOIN FN3MI0700022.PROJECTS P
                           ON TW.P_ID = P.PID
                 LEFT JOIN FN3MI0700022.TASKS TSK
                           ON TSK.PROJECT_ID = P.PID
                 LEFT JOIN FN3MI0700022.USERS U
                           ON TSK.DEFINED_BY_UID = U.UID
        WHERE TW.P_ID = P_CID;