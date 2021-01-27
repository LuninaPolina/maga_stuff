--Примечание: для наглядности я сначала создаю все необходимое для задания 3, а затем -- для заданий 1 и 2, 
--чтобы в журнале из задания 3 отразилось больше информации

--Задание 3 (часть 1)
--создать триггер для записи в журнал информации о событиях, произошедших в базе

--журнал для хранения необходимой информации о событии
ALTER TRIGGER DATABASE_LOG_TRIGGER DISABLE;
DROP TABLE DATABASE_LOG;
CREATE TABLE DATABASE_LOG
( ID NUMBER(4,0) NOT NULL ENABLE,
  LOG_TIME DATE,
  EVENT_TYPE VARCHAR2(200),
  OBJECT_TYPE VARCHAR(200),
  OBJECT_NAME VARCHAR(200),
  CONSTRAINT DATABASE_LOG_PK PRIMARY KEY (ID),
  CONSTRAINT DATABASE_LOG_CHECK_ET CHECK (EVENT_TYPE IN ('CREATE', 'ALTER', 'DROP')),
  CONSTRAINT DATABASE_LOG_CHECK_OT CHECK (OBJECT_TYPE IN ('TABLE', 'VIEW', 'SEQUENCE')));
 
--секвенция для генерации номера записи в журнале  
DROP SEQUENCE DATABASE_LOG_SEQ;
CREATE SEQUENCE DATABASE_LOG_SEQ
START WITH 1
INCREMENT BY 1
CACHE 2
ORDER;

--процедура, обеспечивающая запись в журнал
CREATE OR REPLACE PROCEDURE DATABASE_LOG_INFO
    (IN_EVENT_TYPE IN VARCHAR2,  
    IN_OBJECT_TYPE IN VARCHAR2,
    IN_OBJECT_NAME IN VARCHAR2)
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO DATABASE_LOG(ID, LOG_TIME, EVENT_TYPE, OBJECT_TYPE, OBJECT_NAME) 
    VALUES(DATABASE_LOG_SEQ.NEXTVAL, CURRENT_DATE, IN_EVENT_TYPE, IN_OBJECT_TYPE, IN_OBJECT_NAME);
    COMMIT;
end DATABASE_LOG_INFO;
/

--тригер, фиксирующий в базе информацию об удалении, изменении и создании таблиц, представлений и последовательностей
CREATE OR REPLACE TRIGGER DATABASE_LOG_TRIGGER
BEFORE CREATE OR ALTER OR DROP ON SCHEMA
BEGIN  
    IF 
        ORA_SYSEVENT IN ('ALTER', 'CREATE', 'DROP') AND ORA_DICT_OBJ_TYPE IN ('TABLE', 'VIEW', 'SEQUENCE')
    THEN
        DATABASE_LOG_INFO(ORA_SYSEVENT, ORA_DICT_OBJ_TYPE, ORA_DICT_OBJ_NAME);
        DBMS_OUTPUT.PUT_LINE('DATABASE_LOG_TRIGGER works');
    END IF;
END;
/

ALTER TRIGGER DATABASE_LOG_TRIGGER ENABLE;

--Задание 1
--создать триггер для автоматической генерации значений в таблицу с использованием секвенции

--создаем таблицу, хранящую данные о клиентах фирмы: уникальный номер, имя, дату регистрации и поле для дополнительной информации
ALTER TRIGGER CLIENTS_TRIGGER_SEQ DISABLE;
DROP TABLE CLIENTS;
CREATE TABLE CLIENTS
( ID NUMBER(4,0) NOT NULL ENABLE,
  NAME VARCHAR2(50),
  REG_DATE DATE,
  ADDITIONAL_INFO VARCHAR2(200),
  CONSTRAINT CLIENTS_PK PRIMARY KEY (ID));

--последовательность для нумерации клиентов
DROP SEQUENCE CLIENTS_SEQ;
CREATE SEQUENCE CLIENTS_SEQ
START WITH 1
INCREMENT BY 1
CACHE 2
ORDER;

--триггер, который при добавлении заменяет пустые поля на автоматически сгенерированные
CREATE OR REPLACE TRIGGER CLIENTS_TRIGGER_SEQ
BEFORE INSERT ON CLIENTS
FOR EACH ROW
BEGIN  
    :NEW.ID := NVL(:NEW.ID, CLIENTS_SEQ.NEXTVAL);
    :NEW.NAME := NVL(:NEW.NAME, 'UNKNOWN_NAME_' || CLIENTS_SEQ.CURRVAL);
    :NEW.REG_DATE := NVL(:NEW.REG_DATE, CURRENT_DATE);
    :NEW.ADDITIONAL_INFO := NVL(:NEW.ADDITIONAL_INFO, 'NO INFO');
    DBMS_OUTPUT.PUT_LINE('CLIENTS_TRIGGER_SEQ works');
END;
/

ALTER TRIGGER CLIENTS_TRIGGER_SEQ ENABLE;

INSERT INTO CLIENTS(NAME, ADDITIONAL_INFO) 
VALUES('POLINA', 'VERY IMPORTANT CLIENT');
INSERT INTO CLIENTS(NAME) 
VALUES('JULIA');

SELECT * FROM CLIENTS;

ALTER TRIGGER CLIENTS_TRIGGER_SEQ DISABLE;

--Задание 2
--создать триггер для автоматической генерации значений в таблицу без использования секвенции (делаем для той же таблицы CLIENTS)
CREATE OR REPLACE TRIGGER CLIENTS_TRIGGER_NOSEQ
BEFORE INSERT ON CLIENTS
FOR EACH ROW
DECLARE 
    AUTO_ID NUMBER;
    ID_EXISTS NUMBER;
BEGIN  
    AUTO_ID := 0;
    ID_EXISTS := 1;
    WHILE ID_EXISTS = 1
    LOOP
        AUTO_ID := AUTO_ID + 1;
        SELECT COUNT(*) INTO ID_EXISTS
        FROM CLIENTS
        WHERE ID = AUTO_ID;
    END LOOP;
    :NEW.ID := NVL(:NEW.ID, AUTO_ID);
    :NEW.NAME := NVL(:NEW.NAME, 'UNKNOWN_NAME_' || AUTO_ID);
    :NEW.REG_DATE := NVL(:NEW.REG_DATE, CURRENT_DATE);
    :NEW.ADDITIONAL_INFO := NVL(:NEW.ADDITIONAL_INFO, 'NO INFO');
    DBMS_OUTPUT.PUT_LINE('CLIENTS_TRIGGER_NOSEQ works');
END;
/

INSERT INTO CLIENTS(NAME, ADDITIONAL_INFO) 
VALUES('MARIA', 'CALL BACK AFTER 6 P.M.');
INSERT INTO CLIENTS(NAME) 
VALUES('MAXIM');

ALTER TRIGGER CLIENTS_TRIGGER_NOSEQ ENABLE;

SELECT * FROM CLIENTS;

ALTER TRIGGER CLIENTS_TRIGGER_NOSEQ DISABLE;

--Задание 3 (часть 2)
--продемонстрируем, как отразилось создание различных объектов из заданий 1 и 2 в журнале
SELECT *
FROM DATABASE_LOG;
ALTER TRIGGER DATABASE_LOG_TRIGGER DISABLE;

--Задание 4
--продемонстрировать все триггеры через соответствующие системные представления
SELECT * 
FROM USER_TRIGGERS;