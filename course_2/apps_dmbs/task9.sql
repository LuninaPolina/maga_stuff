--временная таблица, в которую происходит чтение из xml файла
DROP TABLE EP_TMP1;
CREATE GLOBAL TEMPORARY TABLE EP_TMP1
(EP_ID NUMBER,
 EP_VALUE NUMBER,
 EP_DATE DATE,
 EP_HOUR NUMBER(2,0),
 CONSTRAINT EP_TMP1_PK PRIMARY KEY (EP_ID) USING INDEX ENABLE)
 ON COMMIT PRESERVE ROWS;
 
--необходимые далее типы
DROP TYPE EP_TABLE1;
DROP TYPE EP_ROW1;
CREATE TYPE EP_ROW1 AS OBJECT (EP_ID NUMBER, EP_VALUE NUMBER, EP_DATE DATE, EP_HOUR NUMBER(2,0));
/
CREATE TYPE EP_TABLE1 AS TABLE OF EP_ROW1; 
/

--заполняем таблицу значениями, собираем статистику и выталкиваем ее строки по одной
CREATE OR REPLACE FUNCTION GET_EP_TMP1
RETURN EP_TABLE1 PIPELINED 
IS PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    EXECUTE IMMEDIATE ('TRUNCATE TABLE EP_TMP1');
    INSERT INTO EP_TMP1
        (SELECT LINE_NUMBER, COL001, TO_DATE(SUBSTR(COL002, 1, 10), 'DD.MM.YYYY'), COL003
        FROM APEX_DATA_PARSER.PARSE (P_CONTENT => (SELECT BLOB_CONTENT FROM APEX_APPLICATION_FILES WHERE FILENAME = 'electric power.xml'), P_FILE_NAME => 'electric power.xml'));

    DBMS_STATS.GATHER_TABLE_STATS('POLINALUNINA','EP_TMP1');
    FOR REC IN (SELECT * FROM EP_TMP1) LOOP
        PIPE ROW (EP_ROW1(REC.EP_ID, REC.EP_VALUE, TO_DATE(TO_CHAR(REC.EP_DATE, 'MM.DD.YYYY'), 'MM.DD.YYYY'), REC.EP_HOUR)); 
    END LOOP;
    COMMIT;
    RETURN;
END;
/

--еще одна временная таблица -- для хранения промежуточных результатов отчета
TRUNCATE TABLE EP_TMP2;
DROP TABLE EP_TMP2;
CREATE GLOBAL TEMPORARY TABLE EP_TMP2
(EP_DATE DATE,
 EP_MORNING NUMBER,
 EP_DAY NUMBER,
 EP_EVENING NUMBER,
 EP_NIGHT NUMBER,
 EP_TOTAL NUMBER,
 CONSTRAINT EP_TMP2_PK PRIMARY KEY (EP_DATE) USING INDEX ENABLE)
 ON COMMIT PRESERVE ROWS;
 
--необходимые далее типы
DROP TYPE EP_TABLE2;
DROP TYPE EP_ROW2;
DROP TYPE EP_ARR;
CREATE TYPE EP_ROW2 AS OBJECT (ID NUMBER, PERIOD VARCHAR2(20), MORNING NUMBER, DAY NUMBER, EVENING NUMBER, NIGHT NUMBER, TOTAL NUMBER);
/
CREATE TYPE EP_TABLE2 AS TABLE OF EP_ROW2; 
/
CREATE TYPE EP_ARR AS VARRAY(5) OF NUMBER;
/

--заполняем временную таблицу промежуточными значениями, а затем формируем из них результат в требуемом виде и выталкиваем построчно
CREATE OR REPLACE FUNCTION GET_EP_TMP2
RETURN EP_TABLE2 PIPELINED 
IS 
    M NUMBER; D NUMBER; E NUMBER; N NUMBER; --для сумм значений по morning, day, evening, night
    Q_SUM EP_ARR; Y_SUM EP_ARR; T_SUM EP_ARR; Y_NUM NUMBER; Q_NUM NUMBER; --для сумм значений по quater, year, total
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    EXECUTE IMMEDIATE ('TRUNCATE TABLE EP_TMP2');
    M:= 0; D := 0; E := 0; N := 0; Y_NUM := 2009; Q_NUM := 1;
    Q_SUM := EP_ARR(); Y_SUM := EP_ARR(); T_SUM := EP_ARR();
    Q_SUM.EXTEND(5); Y_SUM.EXTEND(5); T_SUM.EXTEND(5);
    FOR I IN 1..5 LOOP Q_SUM(I) := 0; END LOOP;
    FOR I IN 1..5 LOOP Y_SUM(I) := 0; END LOOP;
    FOR I IN 1..5 LOOP T_SUM(I) := 0; END LOOP;
    FOR REC IN (SELECT * FROM GET_EP_TMP1() ORDER BY EP_ID) LOOP --для каждого дня суммируем значения из EP_TMP1 по morning, day, evening, night 
        IF REC.EP_HOUR < 7 THEN N := N + REC.EP_VALUE;
        ELSIF REC.EP_HOUR < 13 THEN M := M + REC.EP_VALUE;
        ELSIF REC.EP_HOUR < 19 THEN D := D + REC.EP_VALUE;
        ELSE E := E + REC.EP_VALUE; END IF;
        IF REC.EP_HOUR = 24 --если день закончился, то заполняем строку таблицы EP_TMP2 тем, что для него посчитали
        THEN
            INSERT INTO EP_TMP2(EP_DATE, EP_MORNING, EP_DAY, EP_EVENING, EP_NIGHT, EP_TOTAL)
            VALUES(REC.EP_DATE, M, D, E, N, M + D + E + N);
            M := 0; D := 0; E := 0; N := 0;
        END IF;
    END LOOP;
    COMMIT;
    DBMS_STATS.GATHER_TABLE_STATS('POLINALUNINA','EP_TMP2');
    
    FOR REC IN (SELECT * FROM EP_TMP2 ORDER BY EP_DATE) LOOP --формируем результирующие строки
        IF FLOOR(EXTRACT(MONTH FROM REC.EP_DATE) / 4) + 1 <> Q_NUM --если сменился квартал, то выталкиваем строку для прошлого квартала
        THEN
            PIPE ROW(EP_ROW2((Y_NUM - 2009) * 5 + Q_NUM, 'Quarter ' || Q_NUM, ROUND(Q_SUM(1)), ROUND(Q_SUM(2)), ROUND(Q_SUM(3)), ROUND(Q_SUM(4)), ROUND(Q_SUM(5))));
            Q_NUM := Q_NUM + 1;
            FOR I IN 1..5 LOOP Q_SUM(I) := 0; END LOOP;
        END IF;
        IF EXTRACT(YEAR FROM REC.EP_DATE) <> Y_NUM --если сменился год, то выталкиваем строку для прошлого года
    	THEN 
    	    PIPE ROW(EP_ROW2((Y_NUM - 2008) * 5, 'Year ' || Y_NUM, ROUND(Y_SUM(1)), ROUND(Y_SUM(2)), ROUND(Y_SUM(3)), ROUND(Y_SUM(4)), ROUND(Y_SUM(5))));
    	    Y_NUM := Y_NUM + 1;
    	    Q_NUM := 1;
    	    FOR I IN 1..5 LOOP Y_SUM(I) := 0; END LOOP;
        END IF;

        Q_SUM(1) := Q_SUM(1) + REC.EP_MORNING; --после этого обновляем все суммы новыми значениями
        Y_SUM(1) := Y_SUM(1) + REC.EP_MORNING;
        T_SUM(1) := T_SUM(1) + REC.EP_MORNING;
        Q_SUM(2) := Q_SUM(2) + REC.EP_DAY;
        Y_SUM(2) := Y_SUM(2) + REC.EP_DAY;
        T_SUM(2) := T_SUM(2) + REC.EP_DAY;
        Q_SUM(3) := Q_SUM(3) + REC.EP_EVENING;
        Y_SUM(3) := Y_SUM(3) + REC.EP_EVENING;
        T_SUM(3) := T_SUM(3) + REC.EP_EVENING;
        Q_SUM(4) := Q_SUM(4) + REC.EP_NIGHT;
        Y_SUM(4) := Y_SUM(4) + REC.EP_NIGHT;
        T_SUM(4) := T_SUM(4) + REC.EP_NIGHT;
        Q_SUM(5) := Q_SUM(5) + REC.EP_TOTAL;
        Y_SUM(5) := Y_SUM(5) + REC.EP_TOTAL;
        T_SUM(5) := T_SUM(5) + REC.EP_TOTAL;
    END LOOP;    	
    PIPE ROW(EP_ROW2(9, 'Quarter ' || Q_NUM, ROUND(Q_SUM(1)), ROUND(Q_SUM(2)), ROUND(Q_SUM(3)), ROUND(Q_SUM(4)), ROUND(Q_SUM(5))));
    PIPE ROW(EP_ROW2(10, 'Year ' || Y_NUM, ROUND(Y_SUM(1)), ROUND(Y_SUM(2)), ROUND(Y_SUM(3)), ROUND(Y_SUM(4)), ROUND(Y_SUM(5))));
    PIPE ROW(EP_ROW2(11, 'Total', ROUND(T_SUM(1)), ROUND(T_SUM(2)), ROUND(T_SUM(3)), ROUND(T_SUM(4)), ROUND(T_SUM(5))));
    RETURN;
END;
/

--запрос для приложения
SELECT PERIOD, MORNING, DAY, EVENING, NIGHT, TOTAL
FROM GET_EP_TMP2()
ORDER BY ID;







