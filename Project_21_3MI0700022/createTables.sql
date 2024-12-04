set schema FN3MI0700022;
create table COMPANIES
(
    CID           INTEGER generated always as identity
        constraint PK_COMPANIES
            primary key,
    C_NAME        VARCHAR(50)  not null,
    C_ADDRESS     VARCHAR(100) not null,
    C_DESCRIPTION VARCHAR(500)
);

create table PROJECTS
(
    PID           INTEGER generated always as identity
        constraint PK_PROJECTS
            primary key,
    P_NAME        VARCHAR(50),
    P_VERSION     VARCHAR(20),
    RELEASE_DATE  DATE default CURRENT DATE,
    P_DESCRIPTION VARCHAR(350),
    check (P_VERSION LIKE '%_'),
    check (RELEASE_DATE >= TO_DATE('2023-01-01', 'yyyy-mm-dd'))
);

create table TEAMS
(
    TID           INTEGER generated always as identity
        constraint PK_TEAMS
            primary key,
    CID           INTEGER not null
        references COMPANIES(CID),
    T_NAME VARCHAR(50),
    T_DESCRIPTION VARCHAR(350)
);

create table TEAMSWORKON
(
    TEAM_ID INTEGER not null
        references TEAMS (TID),
    P_ID    INTEGER not null
        references PROJECTS (PID)
);

create table USERS
(
    UID      INTEGER generated always as identity
        constraint PK_USERS
            primary key,
    EMAIL    VARCHAR(320) not null
        unique,
    USERNAME VARCHAR(10)  not null
        unique,
    PASSWORD CHAR(64) not null,
    check (EMAIL LIKE '%_@%_.%_'),
    check (USERNAME LIKE '%_'),
    check (PASSWORD LIKE '%_')
);

create table TASKS
(
    TID            INTEGER generated always as identity
        constraint PK_TASKS
            primary key,
    STATUS         CHAR(10) default 'unfinished',
    START_DATE     DATE          default CURRENT DATE,
    T_DESCRIPTION  VARCHAR(350),
    DEFINED_BY_UID INTEGER not null
        references USERS (UID),
    PROJECT_ID     INTEGER not null
        references PROJECTS (PID),
    check (START_DATE >= TO_DATE('2023-01-01', 'yyyy-mm-dd'))
);

create table BUGS
(
    TID             INTEGER generated always as identity
        constraint PK_BTASKS
            primary key
        references TASKS,
    SCENARIO        VARCHAR(600) not null,
    PROJECT_ID      INTEGER      not null,
    BLOCKING_DATE   DATE default CURRENT DATE,
    UNBLOCKING_DATE DATE default CURRENT DATE,
    check(BLOCKING_DATE >= TO_DATE('2023-01-01', 'yyyy-mm-dd')),
    check (UNBLOCKING_DATE >= BLOCKING_DATE)
);

create table EXECUTABLES
(
    TID      INTEGER generated always as identity
        constraint PK_ETASKS
            primary key
        references TASKS(TID),
    DEADLINE DATE default CURRENT DATE,
    check (DEADLINE >= TO_DATE('2023-01-01', 'yyyy-mm-dd'))
);

create table USERS_AMATEURS
(
    UID                  INTEGER generated always as identity
        constraint PK_UAMATEURS
            primary key
        references USERS(UID),
    EMAIL                VARCHAR(320) not null
        unique,
    USERNAME             VARCHAR(10)  not null
        unique,
    PASSWORD             CHAR(64) not null,
    ACTIVITY_DESCRIPTION VARCHAR(350),
    check (EMAIL LIKE '%_@%_.%_'),
    check (USERNAME LIKE '%_'),
    check (PASSWORD LIKE '%_')
);

create table USERS_EMPLOYEES
(
    UID         INTEGER generated always as identity
        constraint PK_UEMPLOYEES
            primary key
        references USERS,
    EMAIL       VARCHAR(320)       not null
        unique,
    USERNAME    VARCHAR(10)        not null
        unique,
    PASSWORD    CHAR(64)       not null,
    SALARY      DOUBLE not null,
    EMP_ADDRESS VARCHAR(100),
    PHONE       CHARACTER(13),
    TEAM_ID     INTEGER            not null
        references TEAMS,
    check (EMAIL LIKE '%_@%_.%_'),
    check (USERNAME LIKE '%_'),
    check (PASSWORD LIKE '%_'),
    CHECK (salary > 0.0)
);

create table WORKSON
(
    UID INTEGER not null
        references USERS,
    TID INTEGER not null
        references TASKS
);