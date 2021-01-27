ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

--создание пользователя разработчика
DROP USER DEV_USER CASCADE;
CREATE USER DEV_USER 
IDENTIFIED BY D;
GRANT CONNECT, RESOURCE TO DEV_USER;
ALTER USER DEV_USER QUOTA UNLIMITED ON USERS;

CONNECT DEV_USER/D;

--создание необходимых таблиц от имени разработчика
CREATE TABLE FACULTY(
    FACULTY_LETTER CHAR,
    FACULTY_NAME_RU VARCHAR2(200),
    FACULTY_NAME_EN VARCHAR2(200),
    CONSTRAINT FACULTY_PK PRIMARY KEY (FACULTY_LETTER));

CREATE TABLE STUDENT(
    STUDENT_ID NUMBER,
    GROUP_CODE VARCHAR2(200),
    FACULTY_LETTER CHAR INVISIBLE,
    CONSTRAINT STUDENT_PK PRIMARY KEY (STUDENT_ID),
    CONSTRAINT STUDENT_FK FOREIGN KEY (FACULTY_LETTER) REFERENCES FACULTY (FACULTY_LETTER),
    CONSTRAINT CHECK_STUDENT_GROUP_CODE CHECK (SUBSTR(GROUP_CODE,1,1) = FACULTY_LETTER));

CREATE TABLE TEST(
    TEST_ID NUMBER,
    TEST_NAME_RU VARCHAR2(200),
    TEST_NAME_EN VARCHAR2(200),
    CONSTRAINT TEST_PK PRIMARY KEY (TEST_ID));

CREATE TABLE STUDENT_TEST(
    STUDENT_ID NUMBER,
    TEST_ID NUMBER,
    SCORE NUMBER,
    CONSTRAINT STUDENT_TEST_FK_S FOREIGN KEY (STUDENT_ID) REFERENCES STUDENT (STUDENT_ID),
    CONSTRAINT STUDENT_TEST_FK_T FOREIGN KEY (TEST_ID) REFERENCES TEST (TEST_ID));

--секвенция для нумерации TEST_ID
CREATE SEQUENCE TEST_SEQ
START WITH 1
INCREMENT BY 1
CACHE 20
ORDER;

CONNECT DEV_USER/D;

CREATE TABLE STUDENT_TEST_TMP(
    STUDENT_ID NUMBER,
    TEST_ID_1 NUMBER,
    TEST_ID_2 NUMBER,
    TEST_ID_3 NUMBER,
    TEST_ID_4 NUMBER,
    TEST_ID_5 NUMBER,
    TEST_ID_6 NUMBER,
    TEST_ID_7 NUMBER,
    TEST_ID_8 NUMBER,
    TEST_ID_9 NUMBER,
    TEST_ID_10 NUMBER,
    TEST_ID_11 NUMBER,
    TEST_ID_12 NUMBER,
    TEST_ID_13 NUMBER,
    TEST_ID_14 NUMBER,
    TEST_ID_15 NUMBER,
    TEST_ID_16 NUMBER,
    CONSTRAINT STUDENT_TEST_TMP_FK FOREIGN KEY (STUDENT_ID) REFERENCES STUDENT (STUDENT_ID));

CREATE OR REPLACE TRIGGER STUDENT_TEST_TRIGGER
AFTER INSERT ON STUDENT_TEST_TMP
FOR EACH ROW
DECLARE 
BEGIN  
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 1, :NEW.TEST_ID_1);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 2, :NEW.TEST_ID_2);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 3, :NEW.TEST_ID_3);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 4, :NEW.TEST_ID_4);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 5, :NEW.TEST_ID_5);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 6, :NEW.TEST_ID_6);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 7, :NEW.TEST_ID_7);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 8, :NEW.TEST_ID_8);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 9, :NEW.TEST_ID_9);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 10, :NEW.TEST_ID_10);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 11, :NEW.TEST_ID_11);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 12, :NEW.TEST_ID_12);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 13, :NEW.TEST_ID_13);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 14, :NEW.TEST_ID_14);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 15, :NEW.TEST_ID_15);
    INSERT INTO STUDENT_TEST(STUDENT_ID, TEST_ID, SCORE) VALUES(:NEW.STUDENT_ID, 16, :NEW.TEST_ID_16);
END;
/


--загрузка данных с помощью SQL*Loader (данные команды выполняются в cmd)
--sqlldr userid=DEV_USER/D control=./faculty.ctl
--sqlldr userid=DEV_USER/D control=./student.ctl 
--sqlldr userid=DEV_USER/D control=./test.ctl
--sqlldr userid=DEV_USER/D control=./student_test.ctl

--проверка, что все прошло успешно
CONNECT DEV_USER/D;

SELECT *
FROM FACULTY;

SELECT *
FROM STUDENT;

SELECT *
FROM TEST;

SELECT * 
FROM STUDENT_TEST;