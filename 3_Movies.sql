--CREATING TABLES

-- Consider the schema for Movie Database:
-- ACTOR(Act_id, Act_Name, Act_Gender)
-- DIRECTOR(Dir_id, Dir_Name, Dir_Phone)
-- MOVIES(Mov_id, Mov_Title, Mov_Year, Mov_Lang, Dir_id)
-- MOVIE_CAST(Act_id, Mov_id, Role)
-- RATING(Mov_id, Rev_Stars)

CREATE TABLE ACTOR(
    Act_id NUMBER(4),
    Act_name VARCHAR(20),
    Act_gender CHAR,
    CONSTRAINT MOVIES_PKA PRIMARY KEY (Act_id)
);

CREATE TABLE DIRECTOR (
    Dir_id NUMBER(4),
    Dir_name VARCHAR(20),
    Dir_phone NUMBER(20),
    CONSTRAINT MOVIES_PKB PRIMARY KEY (Dir_id)
);

CREATE TABLE MOVIES (
    Mov_id NUMBER(4),
    Mov_title VARCHAR(20),
    Mov_year NUMBER(4),
    Movie_lang VARCHAR(20),
    Dir_id NUMBER(4),
    CONSTRAINT MOVIES_PKC PRIMARY KEY (Mov_id),
    CONSTRAINT MOVIES_FKA FOREIGN KEY (Dir_id) REFERENCES DIRECTOR (Dir_id)
);

CREATE TABLE MOVIE_CAST (
    Act_id NUMBER(4),
    Mov_id NUMBER(4),
    Role VARCHAR(20),
    CONSTRAINT MOVIES_FKB FOREIGN KEY (Act_id) REFERENCES ACTOR (Act_id),
    CONSTRAINT MOVIES_FKC FOREIGN KEY (Mov_id) REFERENCES MOVIES (Mov_id)
);

CREATE TABLE RATING (
    Mov_id NUMBER(4),
    Rev_stars NUMBER(2),
    CONSTRAINT MOVIES_FKD FOREIGN KEY (Mov_id) REFERENCES MOVIES (Mov_id)
);

--INSERTING VALUES

INSERT INTO ACTOR VALUES (&Act_id , '&Act_name' , '&Act_gender');
INSERT INTO DIRECTOR VALUES (&Dir_id , '&Dir_name' , &Dir_phone);
INSERT INTO MOVIES VALUES (&Mov_id , '&Mov_title' , '&Mov_year','&Mov_lang',&Dir_id);
INSERT INTO MOVIE_CAST VALUES (&Act_id , &Mov_id ,'&Role');
INSERT INTO RATING VALUES (&Mov_id ,&Rev_stars);

--queries

--1

-- List the titles of all movies directed by ‘Hitchcock’.

SELECT M.Mov_title , D.Dir_name
FROM MOVIES M, DIRECTOR D
WHERE M.Dir_id = D.Dir_id AND D.Dir_name = "Steven";

--2

-- Find the movie names where one or more actors acted in two or more movies

SELECT A.Act_name  , M.Mov_id
FROM ACTOR A , MOVIE_CAST M
WHERE M.Act_id = A.Act_id AND  A.Act_id IN (
    SELECT M2.Act_id  FROM MOVIE_CAST M2
    GROUP BY Act_id
    HAVING COUNT(Act_id) > 1
);

--3

-- List all actors who acted in a movie before 2000 and also in a movie after 2015
-- (use JOIN operation).

(
SELECT A.Act_name
FROM ACTOR A JOIN MOVIE_CAST M ON A.Act_id = M.Act_id JOIN MOVIES M1 on M1.Mov_id = M.Mov_id
WHERE M1.Mov_year < 2000
)
INTERSECT
(
SELECT A2.Act_name
FROM ACTOR A2 JOIN MOVIE_CAST M2 ON A2.Act_id = M2.Act_id JOIN MOVIES M3 on M3.Mov_id = M2.Mov_id
WHERE M3.Mov_year >2015
);


--4
-- Find the title of movies and number of stars for each movie that has at least one
-- rating and find the highest number of stars that movie received. Sort the result by
-- movie title.

SELECT M.Mov_title , MAX (R.Rev_stars)
FROM MOVIES M , RATING R,
WHERE M.Mov_id = R.Mov_id
AND M.Mov_id IN(
    SELECT Mov_id 
    FROM RATING
    WHERE Rev_stars > 0
    GROUP BY Mov_id
    HAVING Count(Rev_stars) > 0
)
GROUP BY M.Mov_title
ORDER BY M.Mov_title;

--5
-- Update rating of all movies directed by ‘Steven Spielberg’ to 5.

UPDATE RATING
SET Rev_stars = 5
WHERE Mov_id IN (
    SELECT Mov_id
    FROM Movies
    WHERE Dir_id IN (
        SELECT Dir_id 
        FROM DIRECTOR
        WHERE Dir_name  = 'Steven Spielberg'
    )
);



