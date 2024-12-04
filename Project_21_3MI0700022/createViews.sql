CREATE VIEW "Employees" AS
SELECT FN3MI0700022.USERS_EMPLOYEES.EMAIL,
       FN3MI0700022.USERS_EMPLOYEES.USERNAME,
       FN3MI0700022.USERS_EMPLOYEES.EMP_ADDRESS,
       FN3MI0700022.USERS_EMPLOYEES.PHONE,
       FN3MI0700022.USERS_EMPLOYEES.SALARY,
       FN3MI0700022.TEAMS.T_NAME,
       FN3MI0700022.COMPANIES.C_NAME
FROM FN3MI0700022.USERS_EMPLOYEES, FN3MI0700022.TEAMS, FN3MI0700022.COMPANIES
WHERE FN3MI0700022.USERS_EMPLOYEES.TEAM_ID = FN3MI0700022.TEAMS.TID AND
      FN3MI0700022.TEAMS.CID = FN3MI0700022.COMPANIES.CID;

SELECT * FROM "Employees" WHERE C_NAME = 'Nexus Dynamics';

CREATE VIEW "Tasks" AS
SELECT * FROM FN3MI0700022.EXECUTABLES
WHERE DEADLINE > CURRENT_DATE;

SELECT * FROM "Tasks";
DROP VIEW "Tasks";

CREATE VIEW "Bugs" AS
SELECT * FROM "Bugs"
WHERE FN3MI0700022."Bugs".UNBLOCKING_DATE > FN3MI0700022."Bugs".BLOCKING_DATE;

SELECT * FROM Bugs;
INSERT INTO Bugs(SCENARIO, PROJECT_ID, BLOCKING_DATE, UNBLOCKING_DATE)
VALUES('new bug scenario', 10, '2023-04-22', '2023-05-31');
SELECT * FROM Bugs;