ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

--создание пользователя-разработчика
CREATE USER DEV_USER  
IDENTIFIED BY D;
GRANT CONNECT, RESOURCE TO DEV_USER;
ALTER USER DEV_USER QUOTA UNLIMITED ON USERS;

--создание профиля для пользователей базы
CREATE PROFILE USER_PROFILE 
LIMIT 
CONNECT_TIME 30
SESSIONS_PER_USER 1;

--создание английского и русского пользователей
CREATE USER ENG_USER  
IDENTIFIED BY E
PROFILE USER_PROFILE;
GRANT CREATE SESSION TO ENG_USER;

CREATE USER RUS_USER  
IDENTIFIED BY R
PROFILE USER_PROFILE;
GRANT CREATE SESSION TO RUS_USER;

--создание таблицы с результатами экзаменов от имени разработчика
CONNECT DEV_USER/D;

CREATE TABLE EXAMS 
    (NAME VARCHAR2(100),
    COURSE VARCHAR2(100),
    CHAIR VARCHAR2(100),
    MARK NUMBER(2,0),
    LANGUAGE VARCHAR(100) INVISIBLE);

INSERT INTO EXAMS (NAME, COURSE, CHAIR, MARK, LANGUAGE)
VALUES ('POLINA', 'MODERN DBMS', 'SOFTWARE ENGINEERING', 3, 'ENGLISH');
INSERT INTO EXAMS (NAME, COURSE, CHAIR, MARK, LANGUAGE)
VALUES ('ПОЛИНА', 'СОВРЕМЕННЫЕ СУБД', 'СИСТЕМНОЕ ПРОГРАММИРОВАНИЕ', 3, 'РУССКИЙ');

--создание синонима для таблицы и выдача на него прав пользователям базы
CONNECT SYSTEM/S;

CREATE PUBLIC SYNONYM EXAMS FOR DEV_USER.EXAMS; 

GRANT SELECT ON EXAMS TO ENG_USER;
GRANT SELECT ON EXAMS TO RUS_USER;

--добавление политики на таблицу: ENG_USER видит только ифнормацию на английском, RUS_USER -- только на русском
CREATE OR REPLACE FUNCTION PRIVACY_POLICY (P_SCHEMA VARCHAR2, P_OBJECT VARCHAR2) 
RETURN VARCHAR2 IS
BEGIN
    IF 
        USER = 'ENG_USER'
    THEN
        RETURN q'[LANGUAGE = 'ENGLISH']';
    ELSE
        RETURN q'[LANGUAGE = 'РУССКИЙ']';    
    END IF;
END;
/

BEGIN
DBMS_RLS.ADD_POLICY (
   OBJECT_SCHEMA => 'DEV_USER', 
   OBJECT_NAME	=> 'EXAMS',
   POLICY_NAME	=> 'EXAMS_POLICY',
   FUNCTION_SCHEMA => 'SYSTEM',
   POLICY_FUNCTION	=> 'PRIVACY_POLICY',
   STATEMENT_TYPES => 'SELECT, INSERT, UPDATE, DELETE',
   UPDATE_CHECK	=> TRUE);
END;
/

--смотрим на содержимое базы от имени каждого из пользователей
CONNECT ENG_USER/E;
SELECT *
FROM EXAMS;

CONNECT RUS_USER/R;
SELECT *
FROM EXAMS;

--удаляем все для того, чтобы скрипт был переиспользуемый
CONNECT SYSTEM/S;

ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

BEGIN
DBMS_RLS.DROP_POLICY('DEV_USER', 'EXAMS', 'EXAMS_POLICY'); 
END;
/

DROP PUBLIC SYNONYM EXAMS;
DROP TABLE DEV_USER.EXAMS;
DROP USER DEV_USER CASCADE;
DROP USER ENG_USER CASCADE;
DROP USER RUS_USER CASCADE;
DROP PROFILE USER_PROFILE CASCADE;