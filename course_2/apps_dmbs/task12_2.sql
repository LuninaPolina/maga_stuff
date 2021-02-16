DROP TABLE FILM_JS;
CREATE TABLE FILM_JS
 (ID NUMBER PRIMARY KEY, 
 JS_DOC VARCHAR2 (1000) 
 CONSTRAINT FILM_JS_CHECK_DOC CHECK (JS_DOC IS JSON));

INSERT INTO FILM_JS(ID, JS_DOC)
VALUES (1,
        '{"name": "Miss Congeniality",
         "year": 2000,
         "genre": ["Comedy", "Action"],
         "directed": "Donald Petrie",
         "produced": "Sandra Bullock",
         "screenplay": ["Marc Lawrence", "Katie Ford", "Caryn Lucas"], 
         "music": "Edward Shearmur",
         "starring": ["Sandra Bullock", "Michael Caine", "Benjamin Bratt", "Candice Bergen", "William Shatner", "Ernie Hudson", "John DiResta", "Heather Burns", "Melissa De Sousa", "Steve Monroe", "Deirdre Quinn", "Wendy Raquel Robinson"],
         "IMDb": 6.3,
         "budget": "$45 million",
         "boxOffice": "$212.8 million"}');

INSERT INTO FILM_JS(ID, JS_DOC)
VALUES (2,
        '{"name": "Harry Potter and the Prisoner of Azkaban",
          "year": 2004,
          "genre": ["Fantasy", "Adventure"],
          "directed": "Alfonso Cuaron",
          "produced": ["David Heyman", "Chris Columbus", "Mark Radcliffe"], 
          "screenplay": "Steve Kloves",
          "music" : "John Williams",
          "starring": ["Daniel Radcliffe", "Rupert Grint", "Emma Watson", "Robbie Coltrane", "Gary Oldman", "Alan Rickman", "Michael Gambon", "Maggie Smith", "Timothy Spall", "David Thewlis", "Tom Felton", "Bonnie Wright"],
          "IMDb": 7.9,
          "budget": "$130 million",
          "boxOffice": "$796.7 million"}');

INSERT INTO FILM_JS(ID, JS_DOC)
VALUES (3,
        '{"name": "Fifty Shades of Grey",
          "year": 2015,
          "genre": ["Romance", "Drama"],
          "directed": "Sam Taylor-Johnson",
          "produced": ["Michael De Luca", "E. L. James", "Dana Brunetti"],
          "screenplay": "Kelly Marcel", 
          "music": "Edward Shearmur",
          "starring": ["Dakota Johnson", "Jamie Dornan", "Jennifer Ehle", "Marcia Gay Harden", "Eloise Mumford", "Victor Rasuk", "Rita Ora", "Max Martini", "Luke Grimes", "Callum Keith Rennie", "Andrew Airlie", "Dylan Neal"],
          "IMDb": 4.1,
          "budget": "$40 million",
          "boxOffice": "$569.7 million"}');

INSERT INTO FILM_JS(ID, JS_DOC)
VALUES (4,
        '{"name": "Sherlock",
          "year": 2010,
          "genre": ["Crime", "Mystery", "Comedy-drama"],
          "directed": ["Mark Gatiss", "Steven Moffat"],
          "produced": ["Mark Gatiss", "Steven Moffat"], 
          "screenplay": ["Mark Gatiss", "Steven Moffat", "Stephen Thompson"],
          "music" : ["David Arnold", "Michael Price"],
          "starring": ["Benedict Cumberbatch", "Martin Freeman", "Rupert Graves", "Una Stubbs", "Louise Brealey", "Andrew Scott", "Mark Gatiss", "Amanda Abbington", "Lara Pulver", "Jonathan Aris", "Lars Mikkelsen", "Sian Brooke"],
          "IMDb": 9.1,
          "budget": "$90 million",
          "boxOffice": "$524 million"}');

INSERT INTO FILM_JS(ID, JS_DOC)
VALUES (5,
        '{"name": "Black Swan",
          "year": 2010,
          "genre": ["Thriller", "Drama"],
          "directed": "Darren Aronofsky",
          "produced": ["Mike Medavoy", "Arnold W. Messer", "Brian Oliver", "Scott Franklin"],
          "screenplay": ["Mark Heyman", "Andres Heinz", "John McLaughlin"], 
          "music": "Clint Mansell",
          "starring": ["Natalie Portman", "Vincent Cassel", "Mila Kunis", "Barbara Hershey", "Winona Ryder", "Benjamin Millepied", "Ksenia Solo", "Kristina Anapau", "Janet Montgomery", "Sebastian Stan ", "Toby Hemingway ", "Sergio Torrado"],
          "IMDb": 8,
          "budget": "$13 million",
          "boxOffice": "$330 million"}');

--запросы для приложения
SELECT P.JS_DOC.name,
       P.JS_DOC.year, 
       REPLACE(REPLACE(REPLACE(REPLACE(P.JS_DOC.genre , '"'), '['), ']'), ',', ', ') AS GENRES, 
       P.JS_DOC.IMDb AS "IMDb"
FROM FILM_JS P
ORDER BY P.JS_DOC.IMDb DESC

SELECT P.JS_DOC.name, 
       TO_NUMBER(REGEXP_REPLACE(P.JS_DOC.budget, '[^0-9.]', '')) AS BUDGET
FROM FILM_JS P

SELECT P.JS_DOC.name, 
       TO_NUMBER(REGEXP_REPLACE(P.JS_DOC.boxOffice, '[^0-9.]', '')) AS BOX_OFFICE
FROM FILM_JS P

SELECT P.JS_DOC.name,
       REPLACE(REPLACE(REPLACE(REPLACE(P.JS_DOC.directed , '"'), '['), ']'), ',', ', ') AS DIRECTORS,
       REPLACE(REPLACE(REPLACE(REPLACE(P.JS_DOC.produced , '"'), '['), ']'), ',', ', ') AS PRODUCERS,
       REPLACE(REPLACE(REPLACE(REPLACE(P.JS_DOC.screenplay , '"'), '['), ']'), ',', ', ') AS SCREENWRITERS,
       REPLACE(REPLACE(REPLACE(REPLACE(P.JS_DOC.music , '"'), '['), ']'), ',', ', ') AS COMPOSERS
FROM FILM_JS P

SELECT *
FROM JSON_TABLE((SELECT JS_DOC FROM FILM_JS WHERE ID = 1) , '$.starring[*]'
                 COLUMNS ("Miss Congeniality" PATH '$'))                    

SELECT *
FROM JSON_TABLE((SELECT JS_DOC FROM FILM_JS WHERE ID = 2) , '$.starring[*]'
                 COLUMNS ("Harry Potter and the Prisoner of Azkaban" PATH '$'))
SELECT *
FROM JSON_TABLE((SELECT JS_DOC FROM FILM_JS WHERE ID = 3) , '$.starring[*]'
                 COLUMNS ("Fifty Shades of Grey" PATH '$'))
                 
SELECT *
FROM JSON_TABLE((SELECT JS_DOC FROM FILM_JS WHERE ID = 4) , '$.starring[*]'
                 COLUMNS ("Sherlock" PATH '$'))
                 
SELECT *
FROM JSON_TABLE((SELECT JS_DOC FROM FILM_JS WHERE ID = 5) , '$.starring[*]'
                 COLUMNS ("Black Swan" PATH '$'))        
                 
                 
                 
                 
