OPTIONS (LOAD = 16, SKIP = 2)
LOAD DATA 
CHARACTERSET UTF8
INFILE 'students.csv' "STR ';'"
BADFILE 'test.bad'
DISCARDFILE 'test.dsc'
APPEND
INTO TABLE TEST 
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
	(TEST_NAME_RU,
	TEST_ID "TEST_SEQ.NEXTVAL")