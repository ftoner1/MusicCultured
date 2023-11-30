SET DEFINE OFF:
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';


drop table ARTIST cascade constraints;
drop table ARTIST_VIEWERSHIP cascade constraints;
drop table CLASS cascade constraints;
drop table Events cascade constraints;
drop table EVENT_ATTENDANCE cascade constraints;
drop table EVENT_TICKET cascade constraints;
drop table EVENT_TYPE cascade constraints;
drop table EVENT_VENUE cascade constraints;
drop table GENRE cascade constraints;
drop table INSTRUMENT cascade constraints;
drop table RAPPER_ORIGIN cascade constraints;
drop table Plays_Experience cascade constraints;
drop table Album cascade constraints;
drop table Playlist cascade constraints;
drop table Contains cascade constraints;
drop table HasStyleOf cascade constraints;
drop table HasStyle cascade constraints;
drop table Favorites cascade constraints;
drop table Creates cascade constraints;
drop table Thread cascade constraints;
drop table FriendsWith cascade constraints;
drop table Follows cascade constraints;
drop table HasAttended cascade constraints;
drop table Singer cascade constraints;
drop table Producer cascade constraints;
drop table Plays cascade constraints;


--------------------------------------------------------------------------------
drop table RAPPER_TIME cascade constraints;
drop table Song cascade constraints;
drop table SONG_GENRE cascade constraints;
drop table SONG_VIEWERSHIP cascade constraints;
drop table USERS cascade constraints;
drop table USER_BIRTHDAY cascade constraints;
drop table RAPPER cascade constraints;

CREATE TABLE User_Birthday (
    userBirthday DATE PRIMARY KEY,
    userAge INT
);

CREATE TABLE Users (
    userName VARCHAR(255),
    userEmail VARCHAR(255) PRIMARY KEY,
    userBirthday DATE,
    FOREIGN KEY (userBirthday) REFERENCES User_Birthday(userBirthday)
);

CREATE TABLE Event_Ticket (
    eventLocation VARCHAR(255) PRIMARY KEY,
    minPrice INT
);

CREATE TABLE Event_Attendance (
    maxCapacity INT PRIMARY KEY,
    minPrice INT
);

CREATE TABLE Event_Venue (
    eventLocation VARCHAR(255) PRIMARY KEY,
    maxCapacity INT,
    FOREIGN KEY (maxCapacity) REFERENCES Event_Attendance(maxCapacity)
);

CREATE TABLE Event_Type (
    eventLocation VARCHAR(255) PRIMARY KEY,
    eventType VARCHAR(255)
);

CREATE TABLE Events(
    eventName VARCHAR(255),
    eventDate DATE,
    eventLocation VARCHAR(255),
    PRIMARY KEY (eventName, eventDate),
    FOREIGN KEY (eventLocation) REFERENCES Event_Ticket(eventLocation),
    FOREIGN KEY (eventLocation) REFERENCES Event_Venue(eventLocation),
    FOREIGN KEY (eventLocation) REFERENCES Event_Type(eventLocation)
);

CREATE TABLE Artist_Viewership (
    monthlyListeners INT PRIMARY KEY,
    monthlyEarnings INT
);

CREATE TABLE Artist (
    artistName VARCHAR(255) PRIMARY KEY,
    artistOrigin VARCHAR(255),
    artistDescription CLOB,
    monthlyListeners INT,
    FOREIGN KEY (monthlyListeners) REFERENCES Artist_Viewership(monthlyListeners)
);

CREATE TABLE Rapper_Time (
    rapStyle VARCHAR(255) PRIMARY KEY,
    era INT
);

CREATE TABLE Rapper_Origin (
    rapStyle VARCHAR(255) PRIMARY KEY,
    city VARCHAR(255)
);

CREATE TABLE Rapper (
    artistName VARCHAR(255) PRIMARY KEY,
    rapStyle VARCHAR(255),
    FOREIGN KEY (artistName) REFERENCES Artist(artistName),
    FOREIGN KEY (rapStyle) REFERENCES Rapper_Time(rapStyle),
    FOREIGN KEY (rapStyle) REFERENCES Rapper_Origin(rapStyle)
);

CREATE TABLE Instrument (
    instrumentName VARCHAR(255) PRIMARY KEY,
    origin VARCHAR(255)
);

CREATE TABLE Plays_Experience (
    yearsExperience INT PRIMARY KEY,
    skillLevel VARCHAR(255)
);

CREATE TABLE Plays (
    artistName VARCHAR(255) NOT NULL,
    instrumentName VARCHAR(255),
    yearsExperience INT,
    PRIMARY KEY (artistName, instrumentName),
    FOREIGN KEY (artistName) REFERENCES Artist(artistName),
    FOREIGN KEY (instrumentName) REFERENCES Instrument(instrumentName),
    FOREIGN KEY (yearsExperience) REFERENCES Plays_Experience(yearsExperience)
);

CREATE TABLE Genre (
    genreName VARCHAR(255) PRIMARY KEY,
    origin VARCHAR(255)
);

CREATE TABLE Album (
    albumName VARCHAR(255),
    artist VARCHAR(255),
    dateCreated DATE,
    PRIMARY KEY (albumName, artist),
    FOREIGN KEY (artist) REFERENCES Artist(artistName)
);



CREATE TABLE Song_Genre (
    isPartOf VARCHAR(255) PRIMARY KEY,
    BPM INT CHECK (BPM >= 24)
);


CREATE TABLE Song_Viewership (
    songName VARCHAR(255),
    artistName VARCHAR(255),
    numOfListeners INT,
    PRIMARY KEY (songName, artistName)
);

CREATE TABLE Song (
    songID INT PRIMARY KEY,
    songName VARCHAR(255),
    dateCreated DATE,
    artistName VARCHAR(255),
    albumName VARCHAR(255),
    isPartOf VARCHAR(255),
    FOREIGN KEY (albumName, artistName) REFERENCES Album(albumName, artist),
    FOREIGN KEY (isPartOf) REFERENCES Genre(genreName),
    FOREIGN KEY (isPartOf) REFERENCES Song_Genre(isPartOf),
    FOREIGN KEY (songName, artistName) REFERENCES Song_Viewership(songName, artistName)
);

CREATE TABLE Thread (
    commentID INT CHECK (commentID > 0),
    threadName VARCHAR(255) NOT NULL,
    commentedBy VARCHAR(255),
    description CLOB,
    dateCommented DATE,
    PRIMARY KEY (commentID, threadName),
    FOREIGN KEY (commentedBy) REFERENCES Users(userEmail),
    FOREIGN KEY (threadName) REFERENCES Users(userEmail)
);

CREATE TABLE FriendsWith (
    friend VARCHAR(255),
    friended VARCHAR(255),
    PRIMARY KEY (friend, friended),
    FOREIGN KEY (friend) REFERENCES Users(userEmail),
    FOREIGN KEY (friended) REFERENCES Users(userEmail)
);

CREATE TABLE Follows (
    follower VARCHAR(255),
    following VARCHAR(255),
    PRIMARY KEY (follower, following),
    FOREIGN KEY (follower) REFERENCES Users(userEmail),
    FOREIGN KEY (following) REFERENCES Artist(artistName)
);

CREATE TABLE HasAttended (
    attendee VARCHAR(255),
    eventName VARCHAR(255),
    eventDate DATE,
    PRIMARY KEY (attendee, eventName, eventDate),
    FOREIGN KEY (attendee) REFERENCES Users(userEmail),
    FOREIGN KEY (eventName, eventDate) REFERENCES Event(eventName, eventDate)
);


CREATE TABLE Singer (
    artistName VARCHAR(255) PRIMARY KEY,
    vocalRange VARCHAR(255),
    FOREIGN KEY (artistName) REFERENCES Artist(artistName)
);

CREATE TABLE Producer (
    artistName VARCHAR(255) PRIMARY KEY,
    FOREIGN KEY (artistName) REFERENCES Artist(artistName)
);

CREATE TABLE Playlist (
    playlistID INT PRIMARY KEY,
    playlistName VARCHAR(255),
    dateCreated DATE,
    createdBy VARCHAR(255),
    FOREIGN KEY (createdBy) REFERENCES Users(userEmail)
);

CREATE TABLE Contains (
    playlistID INT NOT NULL,
    songID INT,
    albumName VARCHAR(255),
    artist VARCHAR(255),
    PRIMARY KEY (playlistID, songID, albumName, artist),
    FOREIGN KEY (playlistID) REFERENCES Playlist(playlistID),
    FOREIGN KEY (songID) REFERENCES Song(songID),
    FOREIGN KEY (albumName, artist) REFERENCES Album(albumName, artist)
);

CREATE TABLE HasStyleOf (
    playlistID INT NOT NULL,
    genreName VARCHAR(255),
    PRIMARY KEY (playlistID, genreName),
    FOREIGN KEY (playlistID) REFERENCES Playlist(playlistID),
    FOREIGN KEY (genreName) REFERENCES Genre(genreName)
);

CREATE TABLE HasStyle (
    artistName VARCHAR(255) NOT NULL,
    genreName VARCHAR(255),
    PRIMARY KEY (artistName, genreName),
    FOREIGN KEY (artistName) REFERENCES Artist(artistName),
    FOREIGN KEY (genreName) REFERENCES Genre(genreName)
);

CREATE TABLE Favorites (
    favoritedBy VARCHAR(255),
    songID INT,
    albumName VARCHAR(255),
    artist VARCHAR(255),
    PRIMARY KEY (favoritedBy, songID, albumName, artist),
    FOREIGN KEY (favoritedBy) REFERENCES Users(userEmail),
    FOREIGN KEY (songID) REFERENCES Song(songID),
    FOREIGN KEY (albumName, artist) REFERENCES Album(albumName, artist)
);

CREATE TABLE Creates (
    songID INT,
    albumName VARCHAR(255),
    artist VARCHAR(255),
    PRIMARY KEY (songID, albumName, artist),
    FOREIGN KEY (songID) REFERENCES Song(songID),
    FOREIGN KEY (albumName, artist) REFERENCES Album(albumName, artist),
    FOREIGN KEY (artist) REFERENCES Artist(artistName)
);

INSERT INTO User_Birthday VALUES ('1995-06-15', 28);
INSERT INTO User_Birthday VALUES ('1989-02-22', 34);
INSERT INTO User_Birthday VALUES ('2001-11-30', 22);
INSERT INTO User_Birthday VALUES ('1990-04-04', 33);
INSERT INTO User_Birthday VALUES ('1999-08-08', 24);
INSERT INTO User_Birthday VALUES ('1985-01-01', 38);
INSERT INTO User_Birthday VALUES ('1998-12-25', 25);

INSERT INTO Users VALUES ('JohnDoe', 'john.doe@gmail.com', '1995-06-15');
INSERT INTO Users VALUES ('AliceSmith', 'alice.smith@gmail.com', '1989-02-22');
INSERT INTO Users VALUES ('EveJackson', 'eve.jackson@gmail.com', '2001-11-30');
INSERT INTO Users VALUES ('BobMartinez', 'bob.martinez@gmail.com', '1990-04-04');
INSERT INTO Users VALUES ('ChrisGreen', 'chris.green@gmail.com', '1999-08-08');
INSERT INTO Users VALUES ('DavidBrown', 'david.brown@gmail.com', '1985-01-01');
INSERT INTO Users VALUES ('EmmaWhite', 'emma.white@gmail.com', '1998-12-25');

INSERT INTO Thread VALUES (1, 'john.doe@gmail.com', 'alice.smith@gmail.com', 'Loving the new Ed Sheeran Album!', '2020-01-05');
INSERT INTO Thread VALUES (2, 'alice.smith@gmail.com', 'alice.smith@gmail.com', 'Totally agree! "Shape of You" is my favorite.', '2020-01-06');
INSERT INTO Thread VALUES (4, 'bob.martinez@gmail.com', 'alice.smith@gmail.com', 'Have you heard Billie Eilishs new song?', '2020-01-06');

INSERT INTO Event_Ticket VALUES ('Madison Square Garden', 70);
INSERT INTO Event_Ticket VALUES ('O2 Arena', 80);
INSERT INTO Event_Ticket VALUES ('Staples Center', 90);
INSERT INTO Event_Ticket VALUES ('Red Rocks Amphitheatre', 100);
INSERT INTO Event_Ticket VALUES ('Rose Bowl', 85);
INSERT INTO Event_Ticket VALUES ('Tokyo Dome', 95);
INSERT INTO Event_Ticket VALUES ('Wembley Stadium', 100);

INSERT INTO Event_Attendance VALUES (20000, 70);
INSERT INTO Event_Attendance VALUES (18000, 80);
INSERT INTO Event_Attendance VALUES (25000, 90);
INSERT INTO Event_Attendance VALUES (9500, 100);
INSERT INTO Event_Attendance VALUES (88000, 85);
INSERT INTO Event_Attendance VALUES (55000, 95);
INSERT INTO Event_Attendance VALUES (90000, 100);

INSERT INTO Event_Venue VALUES ('Madison Square Garden', 20000);
INSERT INTO Event_Venue VALUES ('O2 Arena', 18000);
INSERT INTO Event_Venue VALUES ('Staples Center', 25000);
INSERT INTO Event_Venue VALUES ('Red Rocks Amphitheatre', 9500);
INSERT INTO Event_Venue VALUES ('Rose Bowl', 88000);
INSERT INTO Event_Venue VALUES ('Tokyo Dome', 55000);
INSERT INTO Event_Venue VALUES ('Wembley Stadium', 90000);

INSERT INTO Event_Type VALUES ('Madison Square Garden', 'Concert');
INSERT INTO Event_Type VALUES ('O2 Arena', 'Concert');
INSERT INTO Event_Type VALUES ('Staples Center', 'Basketball Game');
INSERT INTO Event_Type VALUES ('Red Rocks Amphitheatre', 'Outdoor Concert');
INSERT INTO Event_Type VALUES ('Rose Bowl', 'Football Game');
INSERT INTO Event_Type VALUES ('Tokyo Dome', 'Baseball Game');
INSERT INTO Event_Type VALUES ('Wembley Stadium', 'Soccer Match');

INSERT INTO events VALUES ('Ariana Grande Concert', '2021-05-10', 'Madison Square Garden');
INSERT INTO events VALUES ('Ed Sheeran Concert', '2019-07-22', 'O2 Arena');
INSERT INTO events VALUES ('NBA Finals', '2018-06-05', 'Staples Center');
INSERT INTO events VALUES ('Taylor Swift Concert', '2020-08-15', 'Red Rocks Amphitheatre');
INSERT INTO events VALUES ('Super Bowl', '2017-02-05', 'Rose Bowl');
INSERT INTO events VALUES ('MLB International Series', '2016-03-30', 'Tokyo Dome');
INSERT INTO Events VALUES ('UEFA Championship', '2021-08-11', 'Wembley Stadium');

INSERT INTO HasAttended VALUES ('john.doe@gmail.com', 'Ariana Grande Concert', '2021-05-10');
INSERT INTO HasAttended VALUES ('alice.smith@gmail.com', 'NBA Finals', '2018-06-05');
INSERT INTO HasAttended VALUES ('bob.martinez@gmail.com', 'NBA Finals', '2020-09-12');

INSERT INTO Artist_Viewership VALUES (5000000, 1000000);
INSERT INTO Artist_Viewership VALUES (3000000, 750000);
INSERT INTO Artist_Viewership VALUES (7000000, 1400000);
INSERT INTO Artist_Viewership VALUES (4000000, 850000);
INSERT INTO Artist_Viewership VALUES (2500000, 650000);
INSERT INTO Artist_Viewership VALUES (6000000, 1200000);
INSERT INTO Artist_Viewership VALUES (3500000, 700000);

INSERT INTO Artist VALUES ('Ariana Grande', 'USA', 'American singer and actress', 5000000);
INSERT INTO Artist VALUES ('Ed Sheeran', 'UK', 'British singer-songwriter', 3000000);
INSERT INTO Artist VALUES ('Taylor Swift', 'USA', 'American singer-songwriter', 7000000);
INSERT INTO Artist VALUES ('Billie Eilish', 'USA', 'American singer and songwriter', 4000000);
INSERT INTO Artist VALUES ('Post Malone', 'USA', 'American rapper and singer', 2500000);
INSERT INTO Artist VALUES ('Drake', 'Canada', 'Canadian rapper and singer', 6000000);
INSERT INTO Artist VALUES ('Dua Lipa', 'UK', 'English singer and songwriter', 3500000);
INSERT INTO Artist VALUES ('Metro Boomin', 'USA', 'Producer', 3500000);
INSERT INTO Artist VALUES ('Mike Will Made It', 'UK', 'English singer and songwriter', 3500000);



INSERT INTO Rapper_Time VALUES ('Trap', 2020);
INSERT INTO Rapper_Time VALUES ('Drill', 2018);
INSERT INTO Rapper_Time VALUES ('Emo Rap', 2017);
INSERT INTO Rapper_Time VALUES ('Boom Bap', 1990);
INSERT INTO Rapper_Time VALUES ('Hyphy', 2000);
INSERT INTO Rapper_Time VALUES ('Mumble Rap', 2016);
INSERT INTO Rapper_Time VALUES ('Conscious', 2005);

INSERT INTO Rapper_Origin VALUES ('Trap', 'Atlanta');
INSERT INTO Rapper_Origin VALUES ('Drill', 'Chicago');
INSERT INTO Rapper_Origin VALUES ('Emo Rap', 'Los Angeles');
INSERT INTO Rapper_Origin VALUES ('Boom Bap', 'New York');
INSERT INTO Rapper_Origin VALUES ('Hyphy', 'Bay Area');
INSERT INTO Rapper_Origin VALUES ('Mumble Rap', 'Atlanta');
INSERT INTO Rapper_Origin VALUES ('Conscious', 'New York');

INSERT INTO Rapper VALUES ('Post Malone', 'Trap');
INSERT INTO Rapper VALUES ('Drake', 'Emo Rap');


INSERT INTO Instrument VALUES ('Guitar', 'Spain');
INSERT INTO Instrument VALUES ('Piano', 'Italy');
INSERT INTO Instrument VALUES ('Violin', 'Italy');
INSERT INTO Instrument VALUES ('Trumpet', 'Germany');
INSERT INTO Instrument VALUES ('Drums', 'Africa');
INSERT INTO Instrument VALUES ('Saxophone', 'Belgium');
INSERT INTO Instrument VALUES ('Flute', 'China');
INSERT INTO Instrument VALUES ('Vocal', 'China');


INSERT INTO Plays_Experience VALUES (1, 'Beginner');
INSERT INTO Plays_Experience VALUES (3, 'Intermediate');
INSERT INTO Plays_Experience VALUES (5, 'Experienced');
INSERT INTO Plays_Experience VALUES (7, 'Expert');
INSERT INTO Plays_Experience VALUES (10, 'Master');
INSERT INTO Plays_Experience VALUES (12, 'Grandmaster');
INSERT INTO Plays_Experience VALUES (15, 'Legend');

INSERT INTO Plays VALUES ('Billie Eilish', 'Vocal', 5);
INSERT INTO Plays VALUES ('Post Malone', 'Guitar', 7);
INSERT INTO Plays VALUES ('Dua Lipa', 'Vocal', 7);


INSERT INTO Genre VALUES ('Pop', 'USA');
INSERT INTO Genre VALUES ('Rock', 'UK');
INSERT INTO Genre VALUES ('Rap', 'USA');
INSERT INTO Genre VALUES ('Country', 'USA');
INSERT INTO Genre VALUES ('Classical', 'Europe');
INSERT INTO Genre VALUES ('Jazz', 'USA');
INSERT INTO Genre VALUES ('Blues', 'USA');

INSERT INTO Album VALUES ('Divide', 'Ed Sheeran', '2017-03-03');
INSERT INTO Album VALUES ('Lover', 'Taylor Swift', '2019-08-23');
INSERT INTO Album VALUES ('Beerbongs & Bentleys', 'Post Malone', '2019-09-06');
INSERT INTO Album VALUES ('Thank U, Next', 'Ariana Grande', '2019-02-08');
INSERT INTO Album VALUES ('Scorpion', 'Drake', '2018-06-29');
INSERT INTO Album VALUES ('When We All Fall Asleep, Where Do We Go?', 'Billie Eilish', '2019-03-29');
INSERT INTO Album VALUES ('Future Nostalgia', 'Dua Lipa', '2020-03-27');



INSERT INTO Song_Genre VALUES ('Pop', 100);
INSERT INTO Song_Genre VALUES ('Rock', 130);
INSERT INTO Song_Genre VALUES ('Rap', 120);
INSERT INTO Song_Genre VALUES ('Country', 110);
INSERT INTO Song_Genre VALUES ('Classical', 60);
INSERT INTO Song_Genre VALUES ('Jazz', 90);
INSERT INTO Song_Genre VALUES ('Blues', 75);


INSERT INTO Song_Viewership VALUES ('Thank U, Next', 'Ariana Grande', 4200000);
INSERT INTO Song_Viewership VALUES ('Rockstar', 'Post Malone', 4800000);
INSERT INTO Song_Viewership VALUES ('Blinding Lights', 'The Weeknd', 4600000);
INSERT INTO Song_Viewership VALUES ('Dance Monkey', 'Tones and I', 4000000);
INSERT INTO Song_Viewership VALUES ('7 Rings', 'Ariana Grande', 4100000);


INSERT INTO Song VALUES (3, 'Rockstar', '2017-09-15', 'Post Malone', 'Beerbongs & Bentleys', 'Rap');
INSERT INTO Song VALUES (6, '7 Rings', '2019-01-18', 'Ariana Grande', 'Thank U, Next', 'Pop');
INSERT INTO Song VALUES (7, 'Thank U, Next', '2019-01-03', 'Ariana Grande', 'Thank U, Next', 'Pop');


INSERT INTO FriendsWith VALUES ('john.doe@gmail.com', 'alice.smith@gmail.com');
INSERT INTO FriendsWith VALUES ('john.doe@gmail.com', 'bob.martinez@gmail.com');


INSERT INTO Follows VALUES ('john.doe@gmail.com', 'Ed Sheeran');
INSERT INTO Follows VALUES ('alice.smith@gmail.com', 'Ed Sheeran');
INSERT INTO Follows VALUES ('bob.martinez@gmail.com', 'Billie Eilish');



INSERT INTO Singer VALUES ('Ed Sheeran', 'Tenor');
INSERT INTO Singer VALUES ('Ariana Grande', 'Soprano');
INSERT INTO Singer VALUES ('Billie Eilish', 'Alto');
INSERT INTO Singer VALUES ('Post Malone', 'Baritone');
INSERT INTO Singer VALUES ('Dua Lipa', 'Mezzo-Soprano');
INSERT INTO Singer VALUES ('Taylor Swift', 'Soprano');
INSERT INTO Singer VALUES ('Drake', 'Tenor');


INSERT INTO Producer VALUES ('Metro Boomin');
INSERT INTO Producer VALUES ('Mike Will Made It');

INSERT INTO Playlist VALUES (1, 'Chill Vibes', '2020-01-01', 'john.doe@gmail.com');
INSERT INTO Playlist VALUES (2, 'Workout Pump', '2020-01-05', 'jane.smith@gmail.com');
INSERT INTO Playlist VALUES (3, 'Top Hits', '2020-01-10', 'alice.jones@gmail.com');
INSERT INTO Playlist VALUES (4, 'Relax and Sleep', '2020-01-15', 'bob.james@gmail.com');
INSERT INTO Playlist VALUES (5, 'Party Mix', '2020-01-20', 'charlie.brown@gmail.com');
INSERT INTO Playlist VALUES (6, 'Throwback Jams', '2020-01-25', 'david.johnson@gmail.com');
INSERT INTO Playlist VALUES (7, 'Daily Mix', '2020-01-30', 'emily.wilson@gmail.com');

INSERT INTO Contains VALUES (1, 1, 'Divide', 'Ed Sheeran');
INSERT INTO Contains VALUES (2, 2, 'Divide', 'Ed Sheeran');
INSERT INTO Contains VALUES (3, 3, 'When We All Fall Asleep, Where Do We Go?', 'Billie Eilish');
INSERT INTO Contains VALUES (4, 4, 'Future Nostalgia', 'Dua Lipa');
INSERT INTO Contains VALUES (5, 5, 'Hollywoods Bleeding', 'Post Malone');
INSERT INTO Contains VALUES (6, 6, 'Thank U, Next', 'Ariana Grande');
INSERT INTO Contains VALUES (7, 7, 'Scorpion', 'Drake');

INSERT INTO HasStyleOf VALUES (1, 'Pop');
INSERT INTO HasStyleOf VALUES (2, 'Rock');
INSERT INTO HasStyleOf VALUES (3, 'Hip Hop');
INSERT INTO HasStyleOf VALUES (4, 'Jazz');
INSERT INTO HasStyleOf VALUES (5, 'R&B');
INSERT INTO HasStyleOf VALUES (6, 'Country');
INSERT INTO HasStyleOf VALUES (7, 'Electronic');

INSERT INTO HasStyle VALUES ('Ed Sheeran', 'Pop');
INSERT INTO HasStyle VALUES ('Ariana Grande', 'Pop');
INSERT INTO HasStyle VALUES ('Billie Eilish', 'Electronica');
INSERT INTO HasStyle VALUES ('Post Malone', 'Hip Hop');
INSERT INTO HasStyle VALUES ('Dua Lipa', 'Pop');
INSERT INTO HasStyle VALUES ('Taylor Swift', 'Country');
INSERT INTO HasStyle VALUES ('Drake', 'Hip Hop');

INSERT INTO Favorites VALUES ('john.doe@gmail.com', 1, 'Divide', 'Ed Sheeran');
INSERT INTO Favorites VALUES ('alice.smith@gmail.com', 2, 'Divide', 'Ed Sheeran');
INSERT INTO Favorites VALUES ('bob.martinez@gmail.com', 4, 'Future Nostalgia', 'Dua Lipa');


INSERT INTO Creates VALUES (1, 'Divide', 'Ed Sheeran');
INSERT INTO Creates VALUES (2, 'Divide', 'Ed Sheeran');
INSERT INTO Creates VALUES (3, 'When We All Fall Asleep, Where Do We Go?', 'Billie Eilish');
INSERT INTO Creates VALUES (4, 'Future Nostalgia', 'Dua Lipa');
INSERT INTO Creates VALUES (5, 'Hollywoods Bleeding', 'Post Malone');
INSERT INTO Creates VALUES (6, 'Thank U, Next', 'Ariana Grande');
INSERT INTO Creates VALUES (7, 'Scorpion', 'Drake');