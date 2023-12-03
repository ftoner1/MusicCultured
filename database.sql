ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
DROP TABLE ArtistX CASCADE CONSTRAINTS;
DROP TABLE INSTRUMENT CASCADE CONSTRAINTS;
DROP TABLE ALBUM CASCADE CONSTRAINTS;
DROP TABLE SONG CASCADE CONSTRAINTS;
DROP TABLE Events CASCADE CONSTRAINTS;
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

CREATE TABLE Events (
    eventName VARCHAR(255),
    eventDate DATE,
    eventLocation VARCHAR(255),
    PRIMARY KEY (eventName, eventDate)
);



CREATE TABLE ArtistX (
    artistName VARCHAR(255) PRIMARY KEY,
    artistOrigin VARCHAR(255),
    artistDescription CLOB,
    monthlyListeners INT
);


CREATE TABLE Rapper (
    artistName VARCHAR(255) PRIMARY KEY,
    rapStyle VARCHAR(255),
    FOREIGN KEY (artistName) REFERENCES ArtistX(artistName)
);

CREATE TABLE Instrument (
    instrumentName VARCHAR(255) PRIMARY KEY,
    origin VARCHAR(255)
);

CREATE TABLE Plays (
    artistName VARCHAR(255) NOT NULL,
    instrumentName VARCHAR(255),
    yearsExperience INT,
    PRIMARY KEY (artistName, instrumentName),
    FOREIGN KEY (artistName) REFERENCES ArtistX(artistName),
    FOREIGN KEY (instrumentName) REFERENCES Instrument(instrumentName)
);

CREATE TABLE Album (
    albumName VARCHAR(255),
    artist VARCHAR(255) DEFAULT NULL,  -- Allowing NULL for automatic entry
    dateCreated DATE DEFAULT NULL,     -- Optional: Date field for album
    PRIMARY KEY (albumName, artist),
    FOREIGN KEY (artist) REFERENCES ArtistX(artistName)
);


CREATE TABLE Song (
    songID INT PRIMARY KEY,
    songName VARCHAR(255),
    dateCreated DATE,
    artistName VARCHAR(255),
    albumName VARCHAR(255),
    numOfListeners INT,
    FOREIGN KEY (albumName, artistName) REFERENCES Album(albumName, artist)
); 

CREATE OR REPLACE TRIGGER BeforeInsertSong
BEFORE INSERT ON Song
FOR EACH ROW
DECLARE
    album_exists NUMBER;
BEGIN
    -- Increment songID from the sequence
    SELECT song_id_seq.NEXTVAL
    INTO :new.songID
    FROM dual;

    -- Check if the album already exists
    SELECT COUNT(*)
    INTO album_exists
    FROM Album
    WHERE albumName = :NEW.albumName AND artist = :NEW.artistName;

    -- If the album does not exist, create a new one
    IF album_exists = 0 THEN
        INSERT INTO Album (albumName, artist)
        VALUES (:NEW.albumName, :NEW.artistName);
    END IF;
END;
/





CREATE TABLE Thread (
    commentID INT CHECK (commentID > 0),
    threadName VARCHAR(255) NOT NULL,
    commentedBy VARCHAR(255),
    description CLOB,
    dateCommented DATE,
    PRIMARY KEY (commentID, threadName)
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
    FOREIGN KEY (artistName) REFERENCES ArtistX(artistName)
);

CREATE TABLE Producer (
    artistName VARCHAR(255) PRIMARY KEY,
    FOREIGN KEY (artistName) REFERENCES ArtistX(artistName)
);


CREATE TABLE Creates (
    songID INT,
    albumName VARCHAR(255),
    artist VARCHAR(255),
    PRIMARY KEY (songID, albumName, artist),
    FOREIGN KEY (songID) REFERENCES Song(songID),
    FOREIGN KEY (albumName, artist) REFERENCES Album(albumName, artist),
    FOREIGN KEY (artist) REFERENCES ArtistX(artistName)
);



INSERT INTO Events VALUES ('Ariana Grande Concert', '2021-05-10', 'Madison Square Garden');
INSERT INTO Events VALUES ('Ed Sheeran Concert', '2019-07-22', 'O2 Arena');


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

INSERT INTO Song(songName, dateCreated, artistName, albumName, numOfListeners) VALUES ('Shape of you', '2019-01-03', 'Ed Sheeran', 'Divide', 2000000);
INSERT INTO Creates VALUES (1, 'Divide', 'Ed Sheeran');

INSERT INTO Song(songName, dateCreated, artistName, albumName, numOfListeners) VALUES ('Perfect', '2019-01-03', 'Ed Sheeran', 'Divide', 2000000);
INSERT INTO Creates VALUES (2, 'Divide', 'Ed Sheeran');
INSERT INTO Song VALUES (3, 'Thank U, Next', '2019-01-03', 'Ariana Grande', 'Thank U, Next', 2000000);
INSERT INTO Creates VALUES (3, 'Thank U, Next', 'Ariana Grande');
INSERT INTO Song VALUES (4, '7 Rings', '2019-01-18', 'Ariana Grande', 'Thank U, Next', 1000000);
INSERT INTO Creates VALUES (4, 'Thank U, Next', 'Ariana Grande');


INSERT INTO Singer VALUES ('Ed Sheeran', 'Tenor');
INSERT INTO Singer VALUES ('Ariana Grande', 'Soprano');



