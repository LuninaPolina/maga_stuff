--Задание 1
--представление с номерами и именами сотрудников, которых принимали на работу зимой;
CREATE OR REPLACE VIEW STAFF_WINTER  
AS SELECT EMPNO, ENAME 
FROM EMP
WHERE EXTRACT(MONTH FROM HIREDATE) IN (12,1,2);

SELECT *
FROM STAFF_WINTER;

--представление с именами сотрудников, которые являются непосредственными начальниками не менее, чем трех подчиненных
CREATE OR REPLACE VIEW MGRS_FOR_3  
AS SELECT ENAME
FROM EMP
WHERE EMPNO IN 
    (SELECT MGR
    FROM EMP
    GROUP BY MGR HAVING COUNT(*) >= 3);

SELECT *
FROM MGRS_FOR_3;

SELECT *
FROM USER_VIEWS;

--Задание 2
--создать секвенцию для DEPT1 и заполнить ее первыми 10-ю значениями таблицу
--DROP SEQUENCE DEPT1_SEQ;
--CREATE SEQUENCE DEPT1_SEQ
--START WITH 50
--INCREMENT BY 1
--CACHE 20
--ORDER;

INSERT INTO DEPT1(DEPTNO,  DNAME,  LOC) 
    SELECT DEPT1_SEQ.NEXTVAL, 'DEPARTMENT_' || TO_CHAR(DEPT1_SEQ.CURRVAL), 'SAINT-PETERSBURG'
    FROM DUAL
    CONNECT BY LEVEL <= 10;

SELECT *
FROM DEPT1;

--найти эту секвенцию в системном представлении
SELECT *
FROM USER_SEQUENCES
WHERE SEQUENCE_NAME = 'DEPT1_SEQ';

--Задание 3
--создать  и вызвать функцию, вычисляющую факториал числа А
CREATE OR REPLACE FUNCTION FACTORIAL (A IN NUMBER)
RETURN NUMBER
IS
BEGIN
    IF A = 1 THEN RETURN 1;
    ELSE RETURN A * FACTORIAL(A - 1);
    END IF;
END FACTORIAL;
/

SELECT FACTORIAL(5) FROM DUAL;

--создать и вызвать функцию, считающую количество дней, проработанных сотрудником A
CREATE OR REPLACE FUNCTION WORK_TIME (A IN NUMBER)
RETURN NUMBER
IS
    RES NUMBER;
    HD DATE;
BEGIN
    SELECT HIREDATE INTO HD 
    FROM EMP 
    WHERE EMPNO = A;
    RES := FLOOR(CURRENT_DATE - HD);
    RETURN RES;
END WORK_TIME;
/

 
SELECT WORK_TIME(EMPNO) FROM EMP;

--Задание 4
--создать процедуру со статистикой
CREATE OR REPLACE PROCEDURE STATISTICS
    (EMPS_NUM OUT NUMBER,
    DEPTS_NUM OUT NUMBER,
    JOBS_NUM OUT NUMBER,
    TOTAL_SAL OUT NUMBER)
IS
BEGIN
    SELECT COUNT(*) INTO EMPS_NUM
    FROM EMP;
    SELECT COUNT(*) INTO DEPTS_NUM 
    FROM DEPT;
    SELECT COUNT(UNIQUE(JOB)) INTO JOBS_NUM
    FROM EMP;
    SELECT SUM(SAL) into TOTAL_SAL 
    FROM EMP;
END STATISTICS;
/

--вывести статистику с помощью пакета DBMS_OUTPUT
DECLARE 
    EMPS_NUM NUMBER;
    DEPTS_NUM NUMBER;
    JOBS_NUM NUMBER;
    TOTAL_SAL NUMBER;
BEGIN 
    STATISTICS(EMPS_NUM, DEPTS_NUM, JOBS_NUM, TOTAL_SAL);
    DBMS_OUTPUT.PUT_LINE('EMPS_NUM = ' || EMPS_NUM);
    DBMS_OUTPUT.PUT_LINE('DEPTS_NUM = ' || DEPTS_NUM);
    DBMS_OUTPUT.PUT_LINE('JOBS_NUM = ' || JOBS_NUM);
    DBMS_OUTPUT.PUT_LINE('TOTAL_SAL = ' || TOTAL_SAL);
END; 
/

--Задание 5
--создать вспомогательную таблицу для сохранения логов работы процедур
DROP TABLE DEBUG_LOG;

CREATE TABLE DEBUG_LOG
( ID NUMBER(2,0) NOT NULL,
  LOG_TIME DATE,
  MESSAGE VARCHAR2(200),
  IN_SOURCE VARCHAR(200),
  CONSTRAINT DEBUG_LOG_PK PRIMARY KEY (ID));

--создать для нее секвенцию
DROP SEQUENCE DEBUG_LOG_SEQ;
CREATE SEQUENCE DEBUG_LOG_SEQ
START WITH 1
INCREMENT BY 1
CACHE 2
ORDER;

--создать процедуру, определяющую даты приема самого старого и самого нового сотрудников
CREATE OR REPLACE PROCEDURE GET_DATES
    (OLDEST_EMP_HD OUT DATE,
    NEWEST_EMP_HD OUT DATE)
IS
BEGIN
    SELECT MIN(HIREDATE) INTO OLDEST_EMP_HD
    FROM EMP;
    SELECT MAX(HIREDATE) INTO NEWEST_EMP_HD
    FROM EMP;
END GET_DATES;
/

--вызвать процедуру, зафиксировать результат в DEBUG_LOG
DECLARE 
    OLDEST_EMP_HD DATE;
    NEWEST_EMP_HD DATE;
BEGIN 
    GET_DATES(OLDEST_EMP_HD, NEWEST_EMP_HD);
    INSERT INTO DEBUG_LOG(ID, LOG_TIME, MESSAGE, IN_SOURCE) 
    VALUES(DEBUG_LOG_SEQ.NEXTVAL, CURRENT_DATE, 'OLDEST_EMP_HD = ' || OLDEST_EMP_HD || '; NEWEST_EMP_HD = ' || NEWEST_EMP_HD, 'GET_DATES ');
END; 
/

SELECT *
FROM DEBUG_LOG;

--Задание 6
--создать процедуру для фиксации динамических ошибок
CREATE OR REPLACE PROCEDURE LOG_INFO
    (IN_INFO_MESSAGE IN VARCHAR2,  
    IN_SOURCE IN VARCHAR2)
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO DEBUG_LOG(ID, LOG_TIME, MESSAGE, IN_SOURCE) 
    VALUES(DEBUG_LOG_SEQ.NEXTVAL, CURRENT_DATE, IN_INFO_MESSAGE, IN_SOURCE);
    COMMIT;
end LOG_INFO;
/

--создать функции, в которых может произойти ошибка и зафиксировать в логе

--функция, вычисляющая квадратные корни
CREATE OR REPLACE FUNCTION TEST_FUNCTION_1 (A IN NUMBER, B IN NUMBER)
RETURN NUMBER
IS
    RES NUMBER;
BEGIN
    RES := SQRT(A) + SQRT(B);
    RETURN RES;
END TEST_FUNCTION_1;
/

DECLARE 
    A NUMBER;
    B NUMBER;
    RES NUMBER;
BEGIN 
    A := -2;
    B := 3;
    SELECT TEST_FUNCTION(A, B) INTO RES
    FROM DUAL;  
    LOG_INFO('RES = ' || RES, 'TEST_FUNCTION_1');
    EXCEPTION
        WHEN OTHERS THEN
           LOG_INFO(SQLERRM, 'TEST_FUNCTION_1');
END; 
/

--функция, выдающая номер какого-нибудь сотрудника, имеющего должность A
CREATE OR REPLACE FUNCTION TEST_FUNCTION_2 (A IN VARCHAR2)
RETURN NUMBER
IS
    RES NUMBER;
BEGIN
    SELECT EMPNO INTO RES 
    FROM EMP 
    WHERE JOB = A;
    RETURN RES;
END TEST_FUNCTION_2;
/

DECLARE 
    A VARCHAR2(50);
    RES NUMBER;
BEGIN 
    A := 'ANALYST';
    SELECT TEST_FUNCTION_2(A) INTO RES
    FROM DUAL;  
    LOG_INFO('RES = ' || RES, 'TEST_FUNCTION_2');
    EXCEPTION
        WHEN OTHERS THEN
           LOG_INFO(SQLERRM, 'TEST_FUNCTION_2');
END; 
/

--процедура, удаляющая представление А
CREATE OR REPLACE PROCEDURE TEST_PROCEDURE (A VARCHAR2)
IS
BEGIN
    EXECUTE IMMEDIATE 'DROP VIEW ' || A;
END TEST_PROCEDURE;
/

--вызвать процедуру, зафиксировать результат в DEBUG_LOG
DECLARE
    A VARCHAR2(50);
BEGIN 
    A := 'SOME_VIEW';
    TEST_PROCEDURE(A);
    LOG_INFO(A || ' DROPPED ', 'TEST_PROCEDURE');
    EXCEPTION
        WHEN OTHERS THEN
           LOG_INFO(SQLERRM, 'TEST_PROCEDURE');
END; 
/

--проверяем, что все правильно записалось
SELECT *
FROM DEBUG_LOG;