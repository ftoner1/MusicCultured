const oracledb = require('oracledb');
const loadEnvFile = require('./utils/envUtil');

const envVariables = loadEnvFile('./.env');

// Database configuration setup. Ensure your .env file has the required database credentials.
const dbConfig = {
    user: envVariables.ORACLE_USER,
    password: envVariables.ORACLE_PASS,
    connectString: `${envVariables.ORACLE_HOST}:${envVariables.ORACLE_PORT}/${envVariables.ORACLE_DBNAME}`,
};


// ----------------------------------------------------------
// Wrapper to manage OracleDB actions, simplifying connection handling.
async function withOracleDB(action) {
    let connection;
    try {
        connection = await oracledb.getConnection(dbConfig);
        return await action(connection);
    } catch (err) {
        console.error(err);
        throw err;
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error(err);
            }
        }
    }
}


// ----------------------------------------------------------
// Core functions for database operations
// Modify these functions, especially the SQL queries, based on your project's requirements and design.
async function testOracleConnection() {
    return await withOracleDB(async (connection) => {
        return true;
    }).catch(() => {
        return false;
    });
}

async function fetchArtistsFromDB() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM ARTISTX', [], {outFormat: oracledb.OUT_FORMAT_OBJECT});
        console.log(result.rows);
        return result.rows;
    }).catch(() => {
        console.log("could not fetch");
        return [];
    });
}

async function fetchSongsFromDB() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM SONG', [], {outFormat: oracledb.OUT_FORMAT_OBJECT});
        console.log(result.rows);
        return result.rows;
    }).catch(() => {
        console.log("could not fetch");
        return [];
    });
}

async function fetchAlbumsFromDB() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM ALBUM', [], {outFormat: oracledb.OUT_FORMAT_OBJECT});
        console.log(result.rows);
        return result.rows;
    }).catch(() => {
        console.log("could not fetch");
        return [];
    });
}

async function fetchNoSongsAlbumFromDB() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `
            SELECT albumName, COUNT(*) AS NumberOfSongs
            FROM Song
            GROUP BY albumName, artistName
            `
            , [], {outFormat: oracledb.OUT_FORMAT_OBJECT});
        console.log(result.rows);
        return result.rows;
    }).catch(() => {
        console.log("could not fetch");
        return [];
    });
}

async function fetchAlbumFilterListensFromDB(condition) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `
            SELECT albumName, SUM(numOfListeners) AS TotalPlays
            FROM Song
            GROUP BY albumName
            HAVING SUM(numOfListeners) > :condition
            `
            , {condition: condition}, {outFormat: oracledb.OUT_FORMAT_OBJECT});
        console.log(result.rows);
        return result.rows;
    }).catch(() => {
        console.log("could not fetch");
        return [];
    });
}

async function fetchNestedAgg() {       // NESTED AGGREGATION
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `
            SELECT a.artistName, AVG(a.total_listeners) AS avg_listeners_per_album
            FROM (
                SELECT s.albumName, s.artistName, SUM(s.numOfListeners) AS total_listeners
                FROM Song s
                GROUP BY s.albumName, s.artistName
                ) a GROUP BY a.artistName
            `
            , [], {outFormat: oracledb.OUT_FORMAT_OBJECT});
        console.log(result.rows);
        return result.rows;
    }).catch(() => {
        console.log("could not fetch");
        return [];
    });
}

async function fetchGaeFromDB(artist) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `
            SELECT S.songName, A.albumName
            FROM Song S
            JOIN Album A ON S.albumName = A.albumName AND S.artistName = A.artist
            WHERE S.artistName = :artistName
            `
            , {artistName: artist}, {outFormat: oracledb.OUT_FORMAT_OBJECT});
        return result.rows;
    }).catch(() => {
        console.log("could not fetch");
        return [];
    });
}

async function funFactArtistsDB() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `
            SELECT DISTINCT p.artistName
            FROM Plays p
            WHERE NOT EXISTS (
                SELECT i.instrumentName
                FROM Instrument i
                WHERE NOT EXISTS (
                    SELECT *
                    FROM Plays p2
                    WHERE p2.artistName = p.artistName AND p2.instrumentName = i.instrumentName
                )
            )
            `, [], {outFormat: oracledb.OUT_FORMAT_OBJECT});
        console.log(result.rows);
        return result.rows;
    }).catch(() => {
        console.log("could not fetch");
        return [];
    });
}

async function fetchCommentsFromDB() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM THREAD', [], {outFormat: oracledb.OUT_FORMAT_OBJECT});
        return result.rows;
    }).catch(() => {
        console.log("could not fetch");
        return [];
    });
}
async function initiateDemotable() {
    return await withOracleDB(async (connection) => {
        try {
            await connection.execute(`DROP TABLE ARTISTX`);
            console.log("Dropped table");
        } catch(err) {
            console.log('Table might not exist, proceeding to create...');
        }
        const result = await connection.execute(`
            CREATE TABLE ARTISTX (
                artistName VARCHAR2(255) PRIMARY KEY,
                artistOrigin VARCHAR2(255),
                artistDescription CLOB,
                monthlyListeners NUMBER
            )
        `);
        return true;
    }).catch(() => {
        return false;
    });
}

async function deleteArtistDB(artistName) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            'DELETE FROM ARTISTX WHERE ARTISTNAME = :name',
            {name: artistName},
            {outFormat: oracledb.OUT_FORMAT_OBJECT, autoCommit: true}
        );
        console.log(result.rowsAffected);
        return true;
    }).catch(() => {
        return false;
    })
}

async function insertArtist(name, listeners, origin) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `INSERT INTO ARTISTX (artistName, artistOrigin, monthlyListeners) VALUES (:n, :o, :l)`,
            {n: name, o: origin, l: listeners},
            { autoCommit: true }
        );

        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
        console.log("could not insert");
        return false;
    });
}


async function insertSong(songName, artistName, albumName, numOfListeners) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `INSERT INTO SONG (songName, artistName, albumName, numOfListeners) VALUES (:name, :artist, :album, :listeners)`,  
            {name: songName, artist: artistName, album: albumName, listeners: numOfListeners},
            { autoCommit: true }  
        );

        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
        console.log("could not insert");
        return false;
    });
}

async function editCommentDB(commentId, description, author) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `
            UPDATE THREAD SET commentedBy = :author, description = :des 
            WHERE commentID = :id
            `,
            {author: author, des: description, id: commentId},
            { autoCommit: true }
        );
        console.log(result.rowsAffected);
        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
        console.log("could not add");
        return false;
    });
}

async function addCommentDB(description, commentedBy) {
    return await withOracleDB(async (connection) => {
        console.log(description);
        console.log(commentedBy);
        const result = await connection.execute(
            `INSERT INTO THREAD (description, commentedBy) VALUES (:des, :author)`,
            {des: description, author: commentedBy},
            { autoCommit: true }
        );
        console.log(result.rowsAffected);
        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
        console.log("could not add");
        return false;
    });
}

async function updateNameDemotable(oldName, newName) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `UPDATE DEMOTABLE SET name=:newName where name=:oldName`,
            [newName, oldName],
            { autoCommit: true }
        );

        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
        return false;
    });
}

async function updateCommentDB(commentId, description) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `UPDATE THREAD SET descr = :description WHERE id = :commentId`,
            {description: description, commentId: commentId},
            { autoCommit: true }
        );
        return result.rowsAffected && result.rowsAffected > 0;
    }).catch((err) => {
        console.log("Error updating comment: ", err);
        return false;
    });
}

async function countDemotable() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT Count(*) FROM DEMOTABLE');
        return result.rows[0][0];
    }).catch(() => {
        return -1;
    });
}

module.exports = {
    testOracleConnection,
    fetchArtistsFromDB,
    fetchSongsFromDB,
    fetchAlbumsFromDB,
    fetchNoSongsAlbumFromDB,
    fetchAlbumFilterListensFromDB,
    editCommentDB,
    fetchNestedAgg,
    fetchGaeFromDB,
    funFactArtistsDB,
    fetchCommentsFromDB,
    initiateDemotable,
    addCommentDB,
    insertArtist,
    insertSong,
    deleteArtistDB,
    updateNameDemotable, 
    countDemotable
};