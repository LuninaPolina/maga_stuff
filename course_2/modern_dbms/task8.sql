--задаем директорию, даем права разработчику
CREATE OR REPLACE DIRECTORY DATA_PUMP_DIR AS 'C:/app/Polina/product/18.0.0/admin/XE/dpdump/';
GRANT READ, WRITE ON DIRECTORY DATA_PUMP_DIR TO DEV_USER;

--производитм экспорт (в CMD)
--expdp DEV_USER/D schemas=DEV_USER directory=DATA_PUMP_DIR dumpfile=datapump.dmp

--уничтожаем схему
DROP USER DEV_USER CASCADE;

--пересоздаем разработчика
CREATE USER DEV_USER 
IDENTIFIED BY D;
GRANT CONNECT, RESOURCE TO DEV_USER;
ALTER USER DEV_USER QUOTA UNLIMITED ON USERS;
CREATE OR REPLACE DIRECTORY DATA_PUMP_DIR AS 'C:/app/Polina/product/18.0.0/admin/XE/dpdump/';
GRANT READ, WRITE ON DIRECTORY DATA_PUMP_DIR TO DEV_USER;

--импортируем схему из дампа (CMD)
--impdp DEV_USER/D schemas=DEV_USER directory=DATA_PUMP_DIR dumpfile=datapump.dmp

--проверяем, что все таблицы на месте

CONNECT DEV_USER/D;
SELECT *
FROM FACULTY;

SELECT *
FROM STUDENT;

SELECT *
FROM TEST;

SELECT * 
FROM STUDENT_TEST;