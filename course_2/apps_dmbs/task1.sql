--Задание 2
--запрос, выдающий должности сотрудников
SELECT ENAME, JOB
FROM EMP;

--Задание 3
--количество сотрудников в каждом департаменте
SELECT DEPT.DNAME, COUNT (EMPNO)
FROM DEPT LEFT JOIN EMP ON DEPT.DEPTNO = EMP.DEPTNO
GROUP BY DEPT.DNAME;

--средняя зарплата по каждой должности
SELECT JOB, AVG(SAL)
FROM EMP
GROUP BY JOB;

--Задание 4
--минимальная и максимальная зарплата по каждой должности
SELECT JOB, MIN(SAL), MAX(SAL)
FROM EMP
GROUP BY JOB;

--суммарная зарплата по каждому департаменту
SELECT DEPT.DNAME, SUM(SAL)
FROM DEPT LEFT JOIN EMP ON DEPT.DEPTNO = EMP.DEPTNO
GROUP BY DEPT.DNAME;

--Задание 5
--все возможные пары менеджеров
SELECT A.ENAME AS MANAGER1, B.ENAME AS MANAGER2
FROM EMP A, EMP B
WHERE A.EMPNO < B.EMPNO AND A.JOB = 'MANAGER' AND B.JOB = 'MANAGER';
