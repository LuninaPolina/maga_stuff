OPTIONS (SKIP=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'students.csv'
BADFILE 'student.bad'
DISCARDFILE 'student.dsc'
APPEND
INTO TABLE STUDENT
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
	(GROUP_CODE,
  	STUDENT_ID,
  	FACULTY_LETTER "SUBSTR(:GROUP_CODE,1,1)")