--Задание 1
--посмотреть содержимое первых 10 строк системного представления ALL_TABLES
SELECT * 
FROM ALL_TABLES
WHERE ROWNUM <= 10;

--определить количество доступных таблиц
SELECT COUNT(TABLE_NAME)
FROM ALL_TABLES;

--получить список таблиц получить список таблиц, которые есть в ALL_TABLES, но отсутствует в USER_TABLES
SELECT TABLE_NAME
FROM ALL_TABLES
WHERE ROWNUM <= 10
MINUS
SELECT TABLE_NAME
FROM USER_TABLES;

--вывести первые 10 строк содержимого таблицы STMT_AUDIT_OPTION_MAP, подходящей под наше условие
SELECT *
FROM STMT_AUDIT_OPTION_MAP
WHERE ROWNUM <= 10;

--Задание 2
--посмотреть, сколько правил целостности есть в схеме
SELECT COUNT(*) 
FROM USER_CONSTRAINTS;

--добавили ограничение на зп без явного именования
ALTER TABLE EMP 
ADD CHECK (SAL BETWEEN 500 and 5000);

--нашли данное ограничение и вывели его имя (это работает очень долго, поэтому на самом деле я смотрела в браузере объектов, но вроде бы запрос верный)
--SELECT CONSTRAINT_NAME
--FROM USER_CONSTRAINTS
--WHERE SEARCH_CONDITION_VC = 'SAL BETWEEN 500 and 5000';

--удалили ограничение по имени
--ALTER TABLE EMP
--DROP CONSTRAINT SYS_C0098768671;

--добавили такое же ограничение, но теперь с явным именем
ALTER TABLE EMP 
ADD CONSTRAINT CHECK_SAL CHECK (SAL BETWEEN 500 and 5000);

--убедились, что оно отображается в системном представлении
SELECT *
FROM USER_CONSTRAINTS;

ALTER TABLE EMP 
DROP CONSTRAINT CHECK_SAL;

--Задание 3
--содержимое представлений, связанных с индексами
SELECT *
FROM USER_INDEXES;

--количество индексов в схеме
SELECT COUNT(*)
FROM USER_INDEXES;

--создание индексно-организованной таблицы DEPT1
DROP TABLE DEPT1;

CREATE TABLE DEPT1
( DEPTNO NUMBER(2,0) NOT NULL,
  DNAME VARCHAR2(50),
  LOC VARCHAR2(50),
  CONSTRAINT DEPT_PK1 PRIMARY KEY (DEPTNO))
ORGANIZATION INDEX;

INSERT INTO DEPT1

SELECT *
FROM DEPT;
