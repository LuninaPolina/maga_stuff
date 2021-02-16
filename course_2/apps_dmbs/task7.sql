DROP TABLE VISIT CASCADE CONSTRAINTS;
DROP SEQUENCE VISIT_SEQ;
DROP TABLE DOCTOR CASCADE CONSTRAINTS;
DROP SEQUENCE DOCTOR_SEQ;
DROP TABLE PATIENT CASCADE CONSTRAINTS;
DROP SEQUENCE PATIENT_SEQ;

CREATE TABLE DOCTOR
(ID NUMBER(4,0),
 NAME VARCHAR2(200),
 SPECIALTY VARCHAR2(200),
 HIRE_DATE DATE,
 OFFICE NUMBER(4,0),
 PHONE VARCHAR2(200),
 EMAIL VARCHAR2(200),
 CONSTRAINT DOCTOR_PK PRIMARY KEY(ID));

CREATE SEQUENCE DOCTOR_SEQ
START WITH 1
INCREMENT BY 1
CACHE 20
ORDER;
 
INSERT INTO DOCTOR(ID, NAME, SPECIALTY, HIRE_DATE, OFFICE, PHONE, EMAIL)
VALUES(DOCTOR_SEQ.NEXTVAL, 'Ivanova A.P.', 'Therapist', TO_DATE('2000/12/1', 'yyyy/mm/dd'), 123, '731213', 'ivanova@mail.ru');
INSERT INTO DOCTOR(ID, NAME, SPECIALTY, HIRE_DATE, OFFICE, PHONE, EMAIL)
VALUES(DOCTOR_SEQ.NEXTVAL, 'Petuchov L.A.', 'Therapist', TO_DATE('2017/6/20', 'yyyy/mm/dd'), 17, '730554', 'petushok20@gmail.com');
INSERT INTO DOCTOR(ID, NAME, SPECIALTY, HIRE_DATE, OFFICE, PHONE, EMAIL)
VALUES(DOCTOR_SEQ.NEXTVAL, 'Mishkin M.M.', 'Therapist', TO_DATE('2005/11/8', 'yyyy/mm/dd'), 15, '731111', 'michail@mail.ru');
INSERT INTO DOCTOR(ID, NAME, SPECIALTY, HIRE_DATE, OFFICE, PHONE, EMAIL)
VALUES(DOCTOR_SEQ.NEXTVAL, 'Lomonosov L.N.', 'Pediatrician', TO_DATE('2020/1/1', 'yyyy/mm/dd'), 3, '733773', 'lomonosov@gmail.com');
INSERT INTO DOCTOR(ID, NAME, SPECIALTY, HIRE_DATE, OFFICE, PHONE, EMAIL)
VALUES(DOCTOR_SEQ.NEXTVAL, 'Aibolit D.D.', 'Pediatrician', TO_DATE('2000/11/2', 'yyyy/mm/dd'), 170, '730000', 'dobry_doctor20@gmail.com');
INSERT INTO DOCTOR(ID, NAME, SPECIALTY, HIRE_DATE, OFFICE, PHONE, EMAIL)
VALUES(DOCTOR_SEQ.NEXTVAL, 'Sosiskin S.T.', 'Surgeon', TO_DATE('2003/8/11', 'yyyy/mm/dd'), 45, '730811', 'sosiska@gmail.com');
INSERT INTO DOCTOR(ID, NAME, SPECIALTY, HIRE_DATE, OFFICE, PHONE, EMAIL)
VALUES(DOCTOR_SEQ.NEXTVAL, 'Rediskin T.S.', 'Surgeon', TO_DATE('2003/8/12', 'yyyy/mm/dd'), 54, '731108', 'rediska@gmail.com');
INSERT INTO DOCTOR(ID, NAME, SPECIALTY, HIRE_DATE, OFFICE, PHONE, EMAIL)
VALUES(DOCTOR_SEQ.NEXTVAL, 'Svinieva T.A.', 'Gynecologist', TO_DATE('2011/11/24', 'yyyy/mm/dd'), 101, '735545', 'onk_onk_123@yandex.ru');
INSERT INTO DOCTOR(ID, NAME, SPECIALTY, HIRE_DATE, OFFICE, PHONE, EMAIL)
VALUES(DOCTOR_SEQ.NEXTVAL, 'Petrova A.P.', 'Gynecologist', TO_DATE('2020/3/3', 'yyyy/mm/dd'), 100, '730055', 'petrova@gmail.com');
INSERT INTO DOCTOR(ID, NAME, SPECIALTY, HIRE_DATE, OFFICE, PHONE, EMAIL)
VALUES(DOCTOR_SEQ.NEXTVAL, 'Vodkina D.A.', 'Psychiatrist', TO_DATE('2007/1/27', 'yyyy/mm/dd'), 1, '731234', 'vodochka20@yandex.ru');
INSERT INTO DOCTOR(ID, NAME, SPECIALTY, HIRE_DATE, OFFICE, PHONE, EMAIL)
VALUES(DOCTOR_SEQ.NEXTVAL, 'Lecter H.H.', 'Psychiatrist', TO_DATE('2011/5/17', 'yyyy/mm/dd'), 70, '731200', 'hannibal666@mail.ru');
INSERT INTO DOCTOR(ID, NAME, SPECIALTY, HIRE_DATE, OFFICE, PHONE, EMAIL)
VALUES(DOCTOR_SEQ.NEXTVAL, 'Petrenko P.P.', 'Neurologist', TO_DATE('2001/1/1', 'yyyy/mm/dd'), 152, '731112', 'petr1@mail.ru');

CREATE TABLE PATIENT
(ID NUMBER(4,0),
 NAME VARCHAR2(200),    
 GENDER VARCHAR2(200),
 BIRTH_DATE DATE,
 REG_DATE DATE,
 PHONE VARCHAR2(200),
 EMAIL VARCHAR2(200),
 CONSTRAINT PATIENT_PK PRIMARY KEY(ID),
 CONSTRAINT PATIENT_CHECK_GENDER CHECK(GENDER IN('Male', 'Female')));
 
CREATE SEQUENCE PATIENT_SEQ
START WITH 1
INCREMENT BY 1
CACHE 20
ORDER;

INSERT INTO PATIENT(ID, NAME, GENDER, BIRTH_DATE, REG_DATE, PHONE, EMAIL)
VALUES(PATIENT_SEQ.NEXTVAL, 'Lavandova A.G.', 'Female', TO_DATE('1998/1/15', 'yyyy/mm/dd'), TO_DATE('2020/1/1', 'yyyy/mm/dd'), '738864', 'love66@mail.ru');
INSERT INTO PATIENT(ID, NAME, GENDER, BIRTH_DATE, REG_DATE, PHONE, EMAIL)
VALUES(PATIENT_SEQ.NEXTVAL, 'Palatochkin E.F.', 'Male', TO_DATE('1997/7/11', 'yyyy/mm/dd'), TO_DATE('2021/1/1', 'yyyy/mm/dd'), '731317', 'pal_ef@mail.ru');
INSERT INTO PATIENT(ID, NAME, GENDER, BIRTH_DATE, REG_DATE, PHONE, EMAIL)
VALUES(PATIENT_SEQ.NEXTVAL, 'Palatochkina R.P.', 'Female', TO_DATE('1998/11/20', 'yyyy/mm/dd'), TO_DATE('2021/1/1', 'yyyy/mm/dd'), '731317', 'pal_rp@mail.ru');
INSERT INTO PATIENT(ID, NAME, GENDER, BIRTH_DATE, REG_DATE, PHONE, EMAIL)
VALUES(PATIENT_SEQ.NEXTVAL, 'Kruzhko A.A.', 'Male', TO_DATE('2005/3/30', 'yyyy/mm/dd'), TO_DATE('2007/5/17', 'yyyy/mm/dd'), '731175', 'krug_30@mail.ru');
INSERT INTO PATIENT(ID, NAME, GENDER, BIRTH_DATE, REG_DATE)
VALUES(PATIENT_SEQ.NEXTVAL, 'Shimansky A.K.', 'Male', TO_DATE('2017/2/17', 'yyyy/mm/dd'), TO_DATE('2020/2/17', 'yyyy/mm/dd'));
INSERT INTO PATIENT(ID, NAME, GENDER, BIRTH_DATE, REG_DATE)
VALUES(PATIENT_SEQ.NEXTVAL, 'Rozovaya E.P.', 'Female', TO_DATE('2020/3/3', 'yyyy/mm/dd'), TO_DATE('2020/5/3', 'yyyy/mm/dd'));
INSERT INTO PATIENT(ID, NAME, GENDER, BIRTH_DATE, REG_DATE, PHONE, EMAIL)
VALUES(PATIENT_SEQ.NEXTVAL, 'Rozovaya O.A.', 'Female', TO_DATE('1980/6/13', 'yyyy/mm/dd'), TO_DATE('2017/5/27', 'yyyy/mm/dd'), '739045', 'pinky1306@mail.ru');
INSERT INTO PATIENT(ID, NAME, GENDER, BIRTH_DATE, REG_DATE, PHONE, EMAIL)
VALUES(PATIENT_SEQ.NEXTVAL, 'Rozoviy P.G.', 'Male', TO_DATE('1982/11/1', 'yyyy/mm/dd'), TO_DATE('2017/7/2', 'yyyy/mm/dd'), '739045', 'pinky0111@mail.ru');

CREATE TABLE VISIT
(ID NUMBER(4,0), 
 DOCTOR_ID NUMBER(4,0),
 PATIENT_ID NUMBER(4,0),
 VISIT_DATE DATE,
 DIAGNOSIS VARCHAR2(200),
 ADDITIONAL VARCHAR2(500),
 CONSTRAINT VISIT_PK PRIMARY KEY(ID),
 CONSTRAINT VISIT_FK_D FOREIGN KEY(DOCTOR_ID) REFERENCES DOCTOR(ID),
 CONSTRAINT VISIT_FK_P FOREIGN KEY(PATIENT_ID) REFERENCES PATIENT(ID));
 
CREATE SEQUENCE VISIT_SEQ
START WITH 1
INCREMENT BY 1
CACHE 20
ORDER;

INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 1, 1, TO_DATE('2020/2/2', 'yyyy/mm/dd'), 'SARS');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 1, 1, TO_DATE('2021/1/12', 'yyyy/mm/dd'), 'Otitis');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 1, 1, TO_DATE('2021/2/1', 'yyyy/mm/dd'), 'Sinusitis');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS, ADDITIONAL)
VALUES(VISIT_SEQ.NEXTVAL, 2, 3, TO_DATE('2021/2/1', 'yyyy/mm/dd'), 'Covid', 'CT scan recommended');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 2, 3, TO_DATE('2021/1/25', 'yyyy/mm/dd'), 'Recovered');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 3, 7, TO_DATE('2021/1/25', 'yyyy/mm/dd'), 'Angina');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 3, 8, TO_DATE('2021/2/1', 'yyyy/mm/dd'), 'Angina');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 4, 5, TO_DATE('2021/2/3', 'yyyy/mm/dd'), 'Angina');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 4, 5, TO_DATE('2020/12/30', 'yyyy/mm/dd'), 'SARS');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 5, 6, TO_DATE('2021/1/11', 'yyyy/mm/dd'), 'Cold');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 5, 6, TO_DATE('2021/1/20', 'yyyy/mm/dd'), 'Angina');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS, ADDITIONAL)
VALUES(VISIT_SEQ.NEXTVAL, 6, 5, TO_DATE('2021/2/2', 'yyyy/mm/dd'), 'Bruised ankle', 'x-ray recommended');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 6, 3, TO_DATE('2021/1/20', 'yyyy/mm/dd'), 'Concussion');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 7, 2, TO_DATE('2021/1/20', 'yyyy/mm/dd'), 'Appendicitis');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 7, 4, TO_DATE('2021/1/20', 'yyyy/mm/dd'), 'Appendicitis');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS, ADDITIONAL)
VALUES(VISIT_SEQ.NEXTVAL, 8, 3, TO_DATE('2020/1/20', 'yyyy/mm/dd'), 'Pregnancy', 'Check every 2 weeks!');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 8, 3, TO_DATE('2021/1/27', 'yyyy/mm/dd'), 'Pregnancy check');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 8, 3, TO_DATE('2021/2/4', 'yyyy/mm/dd'), 'Pregnancy check');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS, ADDITIONAL)
VALUES(VISIT_SEQ.NEXTVAL, 9, 1, TO_DATE('2021/2/1', 'yyyy/mm/dd'), 'Inflammation', 'Shedule blood test');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 10, 4, TO_DATE('2021/1/1', 'yyyy/mm/dd'), 'Depression');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 10, 4, TO_DATE('2021/2/1', 'yyyy/mm/dd'), 'Depression');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 11, 2, TO_DATE('2021/2/4', 'yyyy/mm/dd'), 'OCD');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS, ADDITIONAL)
VALUES(VISIT_SEQ.NEXTVAL, 11, 7, TO_DATE('2021/1/15', 'yyyy/mm/dd'), 'Healthy', 'Annual medical examination');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS, ADDITIONAL)
VALUES(VISIT_SEQ.NEXTVAL, 11, 8, TO_DATE('2021/1/16', 'yyyy/mm/dd'), 'Healthy', 'Annual medical examination');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 12, 2, TO_DATE('2020/12/1', 'yyyy/mm/dd'), 'Migraine');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS)
VALUES(VISIT_SEQ.NEXTVAL, 12, 2, TO_DATE('2021/1/1', 'yyyy/mm/dd'), 'Recovered');
INSERT INTO VISIT(ID, DOCTOR_ID, PATIENT_ID, VISIT_DATE, DIAGNOSIS, ADDITIONAL)
VALUES(VISIT_SEQ.NEXTVAL, 12, 6, TO_DATE('2021/2/3', 'yyyy/mm/dd'), 'Healthy', 'Examination for kindergarten');

CREATE OR REPLACE PROCEDURE ADD_DOCTOR (NAME IN VARCHAR2, SPECIALTY IN VARCHAR2, HIRE_DATE IN DATE, OFFICE IN NUMBER, PHONE IN VARCHAR, EMAIL IN VARCHAR)
IS
BEGIN
    INSERT INTO DOCTOR(ID, NAME, SPECIALTY, HIRE_DATE, OFFICE, PHONE, EMAIL)
    VALUES(DOCTOR_SEQ.NEXTVAL, NAME, SPECIALTY, HIRE_DATE, OFFICE, PHONE, EMAIL);
END;
/
CREATE OR REPLACE PROCEDURE ADD_PACIENT (NAME IN VARCHAR2, GENDER IN VARCHAR2, BIRTH_DATE IN DATE, REG_DATE IN DATE, PHONE IN VARCHAR, EMAIL IN VARCHAR)
IS
BEGIN
    INSERT INTO PATIENT(ID, NAME, GENDER, BIRTH_DATE, REG_DATE, PHONE, EMAIL)
    VALUES(PATIENT_SEQ.NEXTVAL, NAME, GENDER, BIRTH_DATE, REG_DATE, PHONE, EMAIL);
END;
/

--запросы для приложения
SELECT PATIENT.ID, PATIENT.NAME, COUNT(*) AS VISITS
FROM VISIT LEFT JOIN PATIENT
ON VISIT.PATIENT_ID = PATIENT.ID
GROUP BY PATIENT.ID, PATIENT.NAME
ORDER BY PATIENT.ID ASC;

SELECT DOCTOR.ID, DOCTOR.NAME, COUNT(*) AS PATIENTS
FROM VISIT LEFT JOIN DOCTOR
ON VISIT.DOCTOR_ID = DOCTOR.ID
GROUP BY DOCTOR.ID, DOCTOR.NAME
ORDER BY DOCTOR.ID ASC;

SELECT SPECIALTY, COUNT(*) AS PATIENTS
FROM VISIT LEFT JOIN DOCTOR
ON VISIT.DOCTOR_ID = DOCTOR.ID
GROUP BY SPECIALTY;

SELECT VISIT_DATE, NAME
FROM VISIT LEFT JOIN PATIENT
ON PATIENT_ID = PATIENT.ID
WHERE DOCTOR_ID = TO_NUMBER(SUBSTR(:APP_USER, 8));

SELECT 'Month' AS PERIOD, COUNT(DISTINCT PATIENT_ID) AS PATIENTS
FROM VISIT
WHERE DOCTOR_ID = TO_NUMBER(SUBSTR(:APP_USER, 8)) AND EXTRACT(MONTH FROM SYSDATE) = EXTRACT(MONTH FROM VISIT_DATE)
UNION
SELECT 'Year' AS PERIOD, COUNT(DISTINCT PATIENT_ID) AS PATIENTS
FROM VISIT
WHERE DOCTOR_ID = TO_NUMBER(SUBSTR(:APP_USER, 8)) AND EXTRACT(YEAR FROM SYSDATE) = EXTRACT(YEAR FROM VISIT_DATE)
UNION
SELECT 'All time' AS PERIOD, COUNT(DISTINCT PATIENT_ID) AS PATIENTS
FROM VISIT
WHERE DOCTOR_ID = TO_NUMBER(SUBSTR(:APP_USER, 8));

SELECT 'Month' AS PERIOD, COUNT(PATIENT_ID) AS PATIENTS
FROM VISIT
WHERE DOCTOR_ID = TO_NUMBER(SUBSTR(:APP_USER, 8)) AND EXTRACT(MONTH FROM SYSDATE) = EXTRACT(MONTH FROM VISIT_DATE)
UNION
SELECT 'Year' AS PERIOD, COUNT(PATIENT_ID) AS PATIENTS
FROM VISIT
WHERE DOCTOR_ID = TO_NUMBER(SUBSTR(:APP_USER, 8)) AND EXTRACT(YEAR FROM SYSDATE) = EXTRACT(YEAR FROM VISIT_DATE)
UNION
SELECT 'All time' AS PERIOD, COUNT(PATIENT_ID) AS PATIENTS
FROM VISIT
WHERE DOCTOR_ID = TO_NUMBER(SUBSTR(:APP_USER, 8));

SELECT VISIT_DATE, SPECIALTY
FROM VISIT LEFT JOIN DOCTOR
ON DOCTOR_ID = DOCTOR.ID
WHERE PATIENT_ID = TO_NUMBER(SUBSTR(:APP_USER, 9));

SELECT 'Month' AS PERIOD, DOCTOR.SPECIALTY, COUNT(*) AS VISITS
FROM VISIT LEFT JOIN DOCTOR
ON DOCTOR_ID = DOCTOR.ID
WHERE PATIENT_ID = TO_NUMBER(SUBSTR(:APP_USER, 9)) AND EXTRACT(MONTH FROM SYSDATE) = EXTRACT(MONTH FROM VISIT_DATE)
GROUP BY SPECIALTY
UNION
SELECT 'Year' AS PERIOD, DOCTOR.SPECIALTY, COUNT(*) AS VISITS
FROM VISIT LEFT JOIN DOCTOR
ON DOCTOR_ID = DOCTOR.ID
WHERE PATIENT_ID = TO_NUMBER(SUBSTR(:APP_USER, 9)) AND EXTRACT(YEAR FROM SYSDATE) = EXTRACT(YEAR FROM VISIT_DATE)
GROUP BY SPECIALTY
UNION
SELECT 'All time' AS PERIOD, DOCTOR.SPECIALTY, COUNT(*) AS VISITS
FROM VISIT LEFT JOIN DOCTOR
ON DOCTOR_ID = DOCTOR.ID
WHERE PATIENT_ID = TO_NUMBER(SUBSTR(:APP_USER, 9))
GROUP BY SPECIALTY

SELECT *
FROM VISIT
WHERE PATIENT_ID = TO_NUMBER(SUBSTR(:APP_USER, 9));

SELECT *
FROM PATIENT
WHERE ID = TO_NUMBER(SUBSTR(:APP_USER, 9));

SELECT *
FROM DOCTOR
WHERE ID = TO_NUMBER(SUBSTR(:APP_USER, 8));

