ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
DROP TABLE ArtistX CASCADE CONSTRAINTS;
DROP TABLE INSTRUMENT CASCADE CONSTRAINTS;
DROP TABLE ALBUM CASCADE CONSTRAINTS;
DROP TABLE SONG CASCADE CONSTRAINTS;
DROP TABLE RAPPER CASCADE CONSTRAINTS;
DROP TABLE PLAYS CASCADE CONSTRAINTS;
DROP TABLE THREAD CASCADE CONSTRAINTS;
DROP TABLE SINGER CASCADE CONSTRAINTS;
DROP TABLE PRODUCER CASCADE CONSTRAINTS;
DROP TABLE Creates CASCADE CONSTRAINTS;
DROP SEQUENCE comment_id_seq;
DROP SEQUENCE song_id_seq;

CREATE SEQUENCE comment_id_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE song_id_seq
START WITH 1
INCREMENT BY 1;

CREATE TABLE ArtistX (
    artistName VARCHAR(255) PRIMARY KEY,
    artistOrigin VARCHAR(255),
    artistDescription CLOB,
    monthlyListeners INT
);

CREATE TABLE Rapper (
    artistName VARCHAR(255) PRIMARY KEY,
    rapStyle VARCHAR(255),
    FOREIGN KEY (artistName) REFERENCES ArtistX(artistName) ON DELETE CASCADE
);

CREATE TABLE Instrument (
    instrumentName VARCHAR(255) PRIMARY KEY,
    origin VARCHAR(255)
);

CREATE TABLE Plays (
    artistName VARCHAR(255) NOT NULL,
    instrumentName VARCHAR(255),
    yearsExperience INT,
    FOREIGN KEY (artistName) REFERENCES ArtistX(artistName) ON DELETE CASCADE, 
    PRIMARY KEY (artistName, instrumentName),
    FOREIGN KEY (instrumentName) REFERENCES Instrument(instrumentName)
);

CREATE TABLE Album (
    albumName VARCHAR(255),
    artist VARCHAR(255) DEFAULT NULL, 
    dateCreated DATE DEFAULT NULL,   
    PRIMARY KEY (albumName, artist),
    FOREIGN KEY (artist) REFERENCES ArtistX(artistName) ON DELETE CASCADE
);


CREATE TABLE Song (
    songID INT PRIMARY KEY,
    songName VARCHAR(255),
    artistName VARCHAR(255),
    albumName VARCHAR(255),
    numOfListeners INT,
    FOREIGN KEY (albumName, artistName) REFERENCES Album(albumName, artist) ON DELETE CASCADE
); 

CREATE OR REPLACE TRIGGER BeforeInsertSong
BEFORE INSERT ON Song
FOR EACH ROW
DECLARE
    album_exists NUMBER;
BEGIN

    SELECT song_id_seq.NEXTVAL
    INTO :new.songID
    FROM dual;

    SELECT COUNT(*)
    INTO album_exists
    FROM Album
    WHERE albumName = :NEW.albumName AND artist = :NEW.artistName;


    IF album_exists = 0 THEN
        INSERT INTO Album (albumName, artist)
        VALUES (:NEW.albumName, :NEW.artistName);
    END IF;
END;
/


CREATE TABLE Thread (
    commentID INT CHECK (commentID > 0) PRIMARY KEY,
    commentedBy VARCHAR(255),
    description VARCHAR(1000)
);

CREATE OR REPLACE TRIGGER thread_before_insert
BEFORE INSERT ON Thread
FOR EACH ROW
BEGIN
    SELECT comment_id_seq.NEXTVAL
    INTO :new.commentID
    FROM dual;
END;
/



CREATE TABLE Singer (
    artistName VARCHAR(255) PRIMARY KEY,
    vocalRange VARCHAR(255),
    FOREIGN KEY (artistName) REFERENCES ArtistX(artistName) ON DELETE CASCADE
);

CREATE TABLE Producer (
    artistName VARCHAR(255) PRIMARY KEY,
    FOREIGN KEY (artistName) REFERENCES ArtistX(artistName) ON DELETE CASCADE
);


CREATE TABLE Creates (
    songID INT,
    albumName VARCHAR(255),
    artist VARCHAR(255),
    PRIMARY KEY (songID, albumName, artist),
    FOREIGN KEY (songID) REFERENCES Song(songID) ON DELETE CASCADE,
    FOREIGN KEY (albumName, artist) REFERENCES Album(albumName, artist) ON DELETE CASCADE,
    FOREIGN KEY (artist) REFERENCES ArtistX(artistName) ON DELETE CASCADE
);




INSERT INTO ArtistX VALUES ('Ariana Grande', 'USA', 'American singer and actress', 5000000);
INSERT INTO ArtistX VALUES ('Ed Sheeran', 'UK', 'British singer-songwriter', 3000000);
INSERT INTO ArtistX VALUES ('Post Malone', 'USA', 'American rapper and singer', 2500000);
INSERT INTO ArtistX VALUES ('Drake', 'Canada', 'Canadian rapper and singer', 6000000);


INSERT INTO Rapper VALUES ('Post Malone', 'Trap');
INSERT INTO Rapper VALUES ('Drake', 'Emo Rap');


INSERT INTO Instrument VALUES ('Guitar', 'Spain');
INSERT INTO Instrument VALUES ('Vocal', 'World');

INSERT INTO Plays VALUES ('Ariana Grande', 'Vocal', 6);
INSERT INTO Plays VALUES ('Ed Sheeran', 'Guitar', 7);
INSERT INTO Plays VALUES ('Ed Sheeran', 'Vocal', 6);



INSERT INTO Album VALUES ('Divide', 'Ed Sheeran', '2017-03-03');
INSERT INTO Album VALUES ('Thank U, Next', 'Ariana Grande', '2019-02-08');


INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Shape of You', 'Ed Sheeran', 'Divide', 2345678);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Eraser', 'Ed Sheeran', 'Divide', 1987654);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Dive', 'Ed Sheeran', 'Divide', 1456789);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Perfect', 'Ed Sheeran', 'Divide', 2876543);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Castle on the Hill', 'Ed Sheeran', 'Divide', 1678901);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Galway Girl', 'Ed Sheeran', 'Divide', 1234567);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Happier', 'Ed Sheeran', 'Divide', 2345678);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('New Man', 'Ed Sheeran', 'Divide', 1987654);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Perfect', 'Ed Sheeran', 'Divide', 2000000);
INSERT INTO Creates VALUES (1, 'Divide', 'Ed Sheeran');
INSERT INTO Creates VALUES (2, 'Divide', 'Ed Sheeran');
INSERT INTO Creates VALUES (3, 'Divide', 'Ed Sheeran');
INSERT INTO Creates VALUES (4, 'Divide', 'Ed Sheeran');
INSERT INTO Creates VALUES (5, 'Divide', 'Ed Sheeran');
INSERT INTO Creates VALUES (6, 'Divide', 'Ed Sheeran');
INSERT INTO Creates VALUES (7, 'Divide', 'Ed Sheeran');
INSERT INTO Creates VALUES (8, 'Divide', 'Ed Sheeran');
INSERT INTO Creates VALUES (9, 'Divide', 'Ed Sheeran');

INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Imagine', 'Ariana Grande', 'Thank U, Next', 2123456);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Needy', 'Ariana Grande', 'Thank U, Next', 1896543);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('NASA', 'Ariana Grande', 'Thank U, Next', 1765432);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Bloodline', 'Ariana Grande', 'Thank U, Next', 1654321);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Fake Smile', 'Ariana Grande', 'Thank U, Next', 1543210);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Bad Idea', 'Ariana Grande', 'Thank U, Next', 1432109);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Make Up', 'Ariana Grande', 'Thank U, Next', 1321098);
INSERT INTO Song(songName, artistName, albumName, numOfListeners) VALUES ('Ghostin', 'Ariana Grande', 'Thank U, Next', 1210987);

INSERT INTO Creates VALUES (10, 'Thank U, Next', 'Ariana Grande');
INSERT INTO Creates VALUES (11, 'Thank U, Next', 'Ariana Grande');
INSERT INTO Creates VALUES (12, 'Thank U, Next', 'Ariana Grande');
INSERT INTO Creates VALUES (13, 'Thank U, Next', 'Ariana Grande');
INSERT INTO Creates VALUES (14, 'Thank U, Next', 'Ariana Grande');
INSERT INTO Creates VALUES (15, 'Thank U, Next', 'Ariana Grande');
INSERT INTO Creates VALUES (16, 'Thank U, Next', 'Ariana Grande');
INSERT INTO Creates VALUES (17, 'Thank U, Next', 'Ariana Grande');

INSERT INTO Singer VALUES ('Ed Sheeran', 'Tenor');
INSERT INTO Singer VALUES ('Ariana Grande', 'Soprano');
COMMIT;