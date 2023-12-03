ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
DROP TABLE ARTISTX CASCADE CONSTRAINTS;
DROP TABLE INSTRUMENT CASCADE CONSTRAINTS;
DROP TABLE ALBUM CASCADE CONSTRAINTS;
DROP TABLE SONG CASCADE CONSTRAINTS;
DROP TABLE EVENTS CASCADE CONSTRAINTS;
DROP TABLE RAPPER CASCADE CONSTRAINTS;
DROP TABLE PLAYS CASCADE CONSTRAINTS;
DROP TABLE THREAD CASCADE CONSTRAINTS;
DROP TABLE SINGER CASCADE CONSTRAINTS;
DROP TABLE PRODUCER CASCADE CONSTRAINTS;
DROP TABLE CREATES CASCADE CONSTRAINTS;


CREATE TABLE EVENTS (
    eventName VARCHAR(255),
    eventDate DATE,
    eventLocation VARCHAR(255),
    PRIMARY KEY (eventName, eventDate)
);

CREATE TABLE ARTISTX (
    artistName VARCHAR(255) PRIMARY KEY,
    artistOrigin VARCHAR(255),
    artistDescription CLOB,
    monthlyListeners INT
);


CREATE TABLE RAPPER (
    artistName VARCHAR(255) PRIMARY KEY,
    rapStyle VARCHAR(255),
    FOREIGN KEY (artistName) REFERENCES ArtistX(artistName)
);

CREATE TABLE INSTRUMENT (
    instrumentName VARCHAR(255) PRIMARY KEY,
    origin VARCHAR(255)
);

CREATE TABLE PLAYS (
    artistName VARCHAR(255) NOT NULL,
    instrumentName VARCHAR(255),
    yearsExperience INT,
    PRIMARY KEY (artistName, instrumentName),
    FOREIGN KEY (artistName) REFERENCES ArtistX(artistName),
    FOREIGN KEY (instrumentName) REFERENCES Instrument(instrumentName)
);

CREATE TABLE ALBUM (
    albumName VARCHAR(255),
    artist VARCHAR(255),
    dateCreated DATE,
    PRIMARY KEY (albumName, artist),
    FOREIGN KEY (artist) REFERENCES ArtistX(artistName)
);


CREATE TABLE SONG (
    songID INT PRIMARY KEY,
    songName VARCHAR(255),
    dateCreated DATE,
    artistName VARCHAR(255),
    albumName VARCHAR(255),
    isPartOf VARCHAR(255),
    numOfListeners INT,
    FOREIGN KEY (albumName, artistName) REFERENCES Album(albumName, artist)
);

CREATE TABLE THREAD (
    commentID INT PRIMARY KEY,
    commentedBy VARCHAR(255),
    commentText CLOB,
);


CREATE TABLE SINGER (
    artistName VARCHAR(255) PRIMARY KEY,
    vocalRange VARCHAR(255),
    FOREIGN KEY (artistName) REFERENCES ArtistX(artistName)
);

CREATE TABLE PRODUCER (
    artistName VARCHAR(255) PRIMARY KEY,
    FOREIGN KEY (artistName) REFERENCES ArtistX(artistName)
);


CREATE TABLE CREATES (
    songID INT,
    albumName VARCHAR(255),
    artist VARCHAR(255),
    PRIMARY KEY (songID, albumName, artist),
    FOREIGN KEY (songID) REFERENCES Song(songID),
    FOREIGN KEY (albumName, artist) REFERENCES Album(albumName, artist),
    FOREIGN KEY (artist) REFERENCES ArtistX(artistName)
);

INSERT INTO EVENTS VALUES ('Ariana Grande Concert', '2021-05-10', 'Madison Square Garden');
INSERT INTO EVENTS VALUES ('Ed Sheeran Concert', '2019-07-22', 'O2 Arena');


INSERT INTO ARTISTX VALUES ('Ariana Grande', 'USA', 'American singer and actress', 5000000);
INSERT INTO ARTISTX VALUES ('Ed Sheeran', 'UK', 'British singer-songwriter', 3000000);
INSERT INTO ARTISTX VALUES ('Post Malone', 'USA', 'American rapper and singer', 2500000);
INSERT INTO ARTISTX VALUES ('Drake', 'Canada', 'Canadian rapper and singer', 6000000);


INSERT INTO RAPPER VALUES ('Post Malone', 'Trap');
INSERT INTO RAPPER VALUES ('Drake', 'Emo Rap');


INSERT INTO INSTRUMENT VALUES ('Guitar', 'Spain');
INSERT INTO INSTRUMENT VALUES ('Vocal', 'World');

INSERT INTO PLAYS VALUES ('Ariana Grande', 'Vocal', 6);
INSERT INTO PLAYS VALUES ('Ed Sheeran', 'Guitar', 7);
INSERT INTO PLAYS VALUES ('Ed Sheeran', 'Vocal', 7);



INSERT INTO ALBUM VALUES ('Divide', 'Ed Sheeran', '2017-03-03');
INSERT INTO ALBUM VALUES ('Thank U, Next', 'Ariana Grande', '2019-02-08');

INSERT INTO SONG VALUES (1, 'Shape of you', '2019-01-03', 'Ed Sheeran', 'Divide', 'Pop', 2000000);
INSERT INTO SONG VALUES (2, 'Perfect', '2019-01-03', 'Ed Sheeran', 'Divide', 'Pop', 2000000);
INSERT INTO SONG VALUES (7, 'Thank U, Next', '2019-01-03', 'Ariana Grande', 'Thank U, Next', 'Pop', 2000000);
INSERT INTO SONG VALUES (6, '7 Rings', '2019-01-18', 'Ariana Grande', 'Thank U, Next', 'Pop', 1000000);


INSERT INTO SINGER VALUES ('Ed Sheeran', 'Tenor');
INSERT INTO SINGER VALUES ('Ariana Grande', 'Soprano');

INSERT INTO CREATES VALUES (1, 'Divide', 'Ed Sheeran');
INSERT INTO CREATES VALUES (2, 'Divide', 'Ed Sheeran');
COMMIT;