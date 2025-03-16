/******************************
File: proc_create_tables.sql
Last Update: 2/1/2025
Description: This script defines the tables and constraints
             for the PICKEM_DB database.
******************************/

USE PICKEM_DB;

DELIMITER //

DROP PROCEDURE IF EXISTS PROC_CREATE_TABLES //

CREATE PROCEDURE PROC_CREATE_TABLES ()
BEGIN

    CREATE TABLE IF NOT EXISTS SCORING (
        PICK_WEIGHT     CHAR(1)         NOT NULL,
        REWARD          TINYINT         NOT NULL,
        PENALTY         TINYINT         NOT NULL,

        CONSTRAINT PK_SCORING PRIMARY KEY (PICK_WEIGHT)
    );
    CALL PROC_LOAD_SCORING('L', 1, 0);
    CALL PROC_LOAD_SCORING('M', 5, -2);
    CALL PROC_LOAD_SCORING('H', 10, -7);


    CREATE TABLE IF NOT EXISTS USERS (
        USER_ID         INT             NOT NULL    AUTO_INCREMENT,
        USERNAME        VARCHAR(25)     NOT NULL,
        PWDHASH         VARCHAR(25)     NOT NULL,
        FAVORITE_TEAM	VARCHAR(25)		NULL,
        NOTIFICATION_PREF   CHAR(1)     NULL,
        EMAIL_ADDRESS   VARCHAR(75)     NULL,
        PHONE           VARCHAR(10)     NULL,
        
        CONSTRAINT PK_USERS PRIMARY KEY (USER_ID)
    );


    CREATE TABLE IF NOT EXISTS BOX_SCORES (
        GAME_ID         VARCHAR(25)     NOT NULL,
        TEAM_ID         VARCHAR(25)     NOT NULL,
        Q1_SCORE        SMALLINT        NULL,
        Q2_SCORE        SMALLINT        NULL,
        Q3_SCORE        SMALLINT        NULL,
        Q4_SCORE        SMALLINT        NULL,
        OVERTIME        SMALLINT        NULL,
        TOTAL           SMALLINT        NULL,

        CONSTRAINT PK_GAME_BOX_SCORES PRIMARY KEY (GAME_ID, TEAM_ID)
    );


    CREATE TABLE IF NOT EXISTS LOCATIONS (
        STADIUM         VARCHAR(50)     NOT NULL,
        CITY            VARCHAR(50)     NOT NULL,
        STATE           VARCHAR(20)     NULL,
        LATITUDE        DECIMAL(19,16)  NULL,
        LONGITUDE       DECIMAL(19,16)  NULL,

        CONSTRAINT PK_LOCATIONS PRIMARY KEY (STADIUM, CITY)
    );


    CREATE TABLE IF NOT EXISTS RECORDS (
        TEAM_ID         VARCHAR(25)     NOT NULL,
        RECORD_TYPE     VARCHAR(10)     NOT NULL,
        WINS            TINYINT         NULL,
        LOSSES          TINYINT         NULL,
        TIES            TINYINT         NULL,

        CONSTRAINT PK_TEAM_RECORD PRIMARY KEY (TEAM_ID, RECORD_TYPE)
    );


    CREATE TABLE IF NOT EXISTS TEAM_STATS (
        TEAM_ID         VARCHAR(25)     NOT NULL,
        TYPE            VARCHAR(100)    NOT NULL,
        VALUE           VARCHAR(25)     NULL,

        CONSTRAINT PK_TEAM_STATS PRIMARY KEY (TEAM_ID, TYPE)
    );


    CREATE TABLE IF NOT EXISTS ODDS (
        GAME_ID         VARCHAR(25)     NOT NULL,
        GAME_CODE       VARCHAR(50)     NOT NULL,
        SOURCE          VARCHAR(10)     NULL,
        AWAY_MONEYLINE  VARCHAR(5)      NULL,
        HOME_MONEYLINE  VARCHAR(5)      NULL,
        AWAY_SPREAD     VARCHAR(5)      NULL,
        HOME_SPREAD     VARCHAR(5)      NULL,
        OVER_UNDER      VARCHAR(5)      NULL,
        AWAY_WIN_PERCENTAGE VARCHAR(5)  NULL,
        HOME_WIN_PERCENTAGE VARCHAR(5)  NULL,

        CONSTRAINT PK_GAME_ODDS PRIMARY KEY (GAME_ID, GAME_CODE)
    );


    CREATE TABLE IF NOT EXISTS TEAMS (
        TEAM_ID         	VARCHAR(25)     NOT NULL,
        CBS_CODE        	VARCHAR(50)     NOT NULL,
        ESPN_CODE       	VARCHAR(50)     NOT NULL,
        FOX_CODE        	VARCHAR(50)     NOT NULL,
        VEGAS_CODE      	VARCHAR(50)     NOT NULL,
        CONFERENCE_CODE 	VARCHAR(25)     NULL,
        CONFERENCE_NAME 	VARCHAR(50)     NULL,
        DIVISION_NAME   	VARCHAR(50)     NULL,
        TEAM_NAME       	VARCHAR(50)     NULL,
        TEAM_MASCOT     	VARCHAR(50)     NULL,
        POWER_CONFERENCE   	BOOLEAN         NULL,
        TEAM_LOGO_URL   	VARCHAR(100)	NULL,
        PRIMARY_COLOR		VARCHAR(10)		NULL,
        ALTERNATE_COLOR		VARCHAR(10)		NULL,

        CONSTRAINT PK_TEAMS PRIMARY KEY (TEAM_ID)
    );


    CREATE TABLE IF NOT EXISTS GAMES (
        GAME_ID         VARCHAR(25)     NOT NULL,
        LEAGUE          VARCHAR(5)      NOT NULL,
        WEEK            TINYINT         NOT NULL,
        YEAR            YEAR            NOT NULL,
        CBS_CODE        VARCHAR(50)     NOT NULL,
        ESPN_CODE       VARCHAR(50)     NOT NULL,
        FOX_CODE        VARCHAR(50)     NOT NULL,
        VEGAS_CODE      VARCHAR(50)     NOT NULL,
        AWAY_TEAM_ID    VARCHAR(25)     NOT NULL,
        HOME_TEAM_ID    VARCHAR(25)     NOT NULL,
        DATE            DATE            NULL,
        TIME            TIME            NULL,
        TV_COVERAGE     VARCHAR(25)     NULL,
        STADIUM         VARCHAR(50)     NULL,
        CITY            VARCHAR(50)     NULL,
        STATE           VARCHAR(50)     NULL,
        GAME_FINISHED   BOOLEAN         NOT NULL,

        CONSTRAINT PK_GAMES PRIMARY KEY (GAME_ID),
        CONSTRAINT FK_AWAY_BOX_SCORES
            FOREIGN KEY (GAME_ID, AWAY_TEAM_ID) REFERENCES BOX_SCORES(GAME_ID, TEAM_ID),
        CONSTRAINT FK_HOME_BOX_SCORES
            FOREIGN KEY (GAME_ID, HOME_TEAM_ID) REFERENCES BOX_SCORES(GAME_ID, TEAM_ID),
        CONSTRAINT FK_GAME_LOCATIONS
            FOREIGN KEY (STADIUM, CITY) REFERENCES LOCATIONS(STADIUM, CITY),
        CONSTRAINT FK_AWAY_TEAM
            FOREIGN KEY (AWAY_TEAM_ID) REFERENCES TEAMS(TEAM_ID),
        CONSTRAINT FK_HOME_TEAM
            FOREIGN KEY (HOME_TEAM_ID) REFERENCES TEAMS(TEAM_ID)
    );


    CREATE TABLE IF NOT EXISTS PICKS (
        USER_ID         INT             NOT NULL,
        GAME_ID         VARCHAR(25)     NOT NULL,
        TEAM_PICKED     VARCHAR(25)     NULL,
        PICK_WEIGHT     CHAR(1)         NULL,

        CONSTRAINT PK_PICKS PRIMARY KEY (USER_ID, GAME_ID),
        CONSTRAINT FK_USERPICK 
            FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID),
        CONSTRAINT FK_GAME_PICK
            FOREIGN KEY (GAME_ID) REFERENCES GAMES(GAME_ID),
        CONSTRAINT FK_PICKSCORE 
            FOREIGN KEY (PICK_WEIGHT) REFERENCES SCORING(PICK_WEIGHT)
    );


END //

DELIMITER ;