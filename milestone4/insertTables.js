const importStatements = {
    events: `
        CREATE TABLE Events (
            eventName VARCHAR(255),
            eventDate DATE,
            eventLocation VARCHAR(255),
            PRIMARY KEY (eventName, eventDate)
        );
    `,
    artistX: `
        CREATE TABLE ArtistX (
            artistName VARCHAR(255) PRIMARY KEY,
            artistOrigin VARCHAR(255),
            artistDescription CLOB,
            monthlyListeners INT
        );
    `,
    rapper: `
        CREATE TABLE Rapper (
            artistName VARCHAR(255) PRIMARY KEY,
            rapStyle VARCHAR(255),
            FOREIGN KEY (artistName) REFERENCES ArtistX(artistName)
        );
    `,
    
    
    
    instrument: `
        CREATE TABLE Instrument (
            instrumentName VARCHAR(255) PRIMARY KEY,
            origin VARCHAR(255)
        );  
    `,    
    
    plays: `CREATE TABLE Plays (
        artistName VARCHAR(255) NOT NULL,
        instrumentName VARCHAR(255),
        yearsExperience INT,
        PRIMARY KEY (artistName, instrumentName),
        FOREIGN KEY (artistName) REFERENCES ArtistX(artistName),
        FOREIGN KEY (instrumentName) REFERENCES Instrument(instrumentName)
    )`,

    album: `CREATE TABLE Album (
        albumName VARCHAR(255),
        artist VARCHAR(255),
        dateCreated DATE,
        PRIMARY KEY (albumName, artist),
        FOREIGN KEY (artist) REFERENCES ArtistX(artistName)
    )`,

    song: `CREATE TABLE Song (
        songID INT PRIMARY KEY,
        songName VARCHAR(255),
        dateCreated DATE,
        artistName VARCHAR(255),
        albumName VARCHAR(255),
        isPartOf VARCHAR(255),
        numOfListeners INT,
        FOREIGN KEY (albumName, artistName) REFERENCES Album(albumName, artist)
    )`,

    thread: `CREATE TABLE Thread (
        commentID INT CHECK (commentID > 0),
        threadName VARCHAR(255) NOT NULL,
        commentedBy VARCHAR(255),
        description CLOB,
        dateCommented DATE,
        PRIMARY KEY (commentID, threadName)
    )`,

    singer: `CREATE TABLE Singer (
        artistName VARCHAR(255) PRIMARY KEY,
        vocalRange VARCHAR(255),
        FOREIGN KEY (artistName) REFERENCES ArtistX(artistName)
    )`,

    producer: `CREATE TABLE Producer (
        artistName VARCHAR(255) PRIMARY KEY,
        FOREIGN KEY (artistName) REFERENCES ArtistX(artistName)
    )`,

    creates: `CREATE TABLE Creates (
        songID INT,
        albumName VARCHAR(255),
        artist VARCHAR(255),
        PRIMARY KEY (songID, albumName, artist),
        FOREIGN KEY (songID) REFERENCES Song(songID),
        FOREIGN KEY (albumName, artist) REFERENCES Album(albumName, artist),
        FOREIGN KEY (artist) REFERENCES ArtistX(artistName)
    )`


}
