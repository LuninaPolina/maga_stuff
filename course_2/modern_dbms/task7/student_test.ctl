OPTIONS(SKIP = 1)
LOAD DATA 
CHARACTERSET UTF8
INFILE 'students.csv'
BADFILE 'student_test.bad'
DISCARDFILE 'student_test.dsc'
APPEND
INTO TABLE STUDENT_TEST_TMP 
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
  (GROUP_CODE FILLER,
  STUDENT_ID,
  TEST_ID_1,
  TEST_ID_2,
  TEST_ID_3,
  TEST_ID_4,
  TEST_ID_5,
  TEST_ID_6,
  TEST_ID_7,
  TEST_ID_8,
  TEST_ID_9,
  TEST_ID_10,
  TEST_ID_11,
  TEST_ID_12,
  TEST_ID_13,
  TEST_ID_14,
  TEST_ID_15,
  TEST_ID_16)