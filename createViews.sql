-- set my schema as default schema
SET SCHEMA FN3MI0700022;

-- Employees view: shows information about the employees in dependence of
-- in which team and in which company he or she works.
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

-- executes the Employees view query
SELECT * FROM "Employees" WHERE C_NAME = 'Nexus Dynamics';

-- Tasks view: Shows information for all tasks that deadline is after current date
-- in other word shows information about all unfinished tasks.
CREATE VIEW "Tasks" AS
SELECT * FROM FN3MI0700022.EXECUTABLES
WHERE DEADLINE > CURRENT_DATE;

-- executes the Tasks view query
SELECT * FROM "Tasks";

-- Bugs view: Shows information about all bugs that still blocks any task.
CREATE VIEW "Bugs" AS
SELECT * FROM "Bugs"
WHERE FN3MI0700022."Bugs".UNBLOCKING_DATE > FN3MI0700022."Bugs".BLOCKING_DATE;

-- executes the Bugs view query
SELECT * FROM "Bugs";

-- inserts new record in Bugs table
INSERT INTO Bugs(TID, SCENARIO, PROJECT_ID, BLOCKING_DATE, UNBLOCKING_DATE)
VALUES(7, 'new bug scenario 2025', 10, '2024-04-22', '2025-01-05');

-- re-executes the Bugs view query
SELECT * FROM "Bugs";