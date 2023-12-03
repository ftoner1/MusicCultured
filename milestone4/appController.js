const express = require('express');
const appService = require('./appService');

const router = express.Router();

// ----------------------------------------------------------
// API endpoints
// Modify or extend these routes based on your project's needs.
router.get('/check-db-connection', async (req, res) => {
    const isConnect = await appService.testOracleConnection();
    if (isConnect) {
        res.send('leggo');
        console.log("leggo");
    } else {
        res.send('unable to connect');
    }
});

router.get('/fetch-artists', async (req, res) => {
    const tableContent = await appService.fetchArtistsFromDB();
    res.json({data: tableContent});
});

router.get('/fetch-songs', async (req, res) => {
    const tableContent = await appService.fetchSongsFromDB();
    res.json({data: tableContent});
});

router.get('/fetch-albums', async (req, res) => {
    const tableContent = await appService.fetchAlbumsFromDB();
    res.json({data: tableContent});
});

router.get('/songs-in-album', async (req, res) => { // 7
    const tableContent = await appService.fetchNoSongsAlbumFromDB();
    res.json({data: tableContent, success: true});
});

router.get('/fun-fact-artists', async (req, res) => {
    const tableContent = await appService.funFactArtistsDB();
    res.json({data: tableContent});
});

router.get('/fetch-comments', async (req, res) => {
    const tableContent = await appService.fetchCommentsFromDB();
    console.log(tableContent)
    res.json({data: tableContent, success: true});
});

router.get('/avg-listens-per-album', async (req, res) => { // nested agg
    const tableContent = await appService.fetchNestedAgg();
    res.json({data: tableContent, success: true});
});

router.post('/filter-album-listens', async (req, res) => { // 8
    let {condition} = req.body;
    const tableContent = await appService.fetchAlbumFilterListensFromDB(condition);
    res.json({data: tableContent, success: true});
});

router.post("/join-gae", async (req, res) => {
    const {artist} = req.body;
    const tableContent = await appService.fetchGaeFromDB(artist);
    res.json({data: tableContent});
});

router.post("/insert-artist", async (req, res) => {
    const { artistName, artistMonthlyListeners, artistOrigin } = req.body;
    const insertResult = await appService.insertArtist(artistName, artistMonthlyListeners, artistOrigin);
    if (insertResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.post("/insert-song", async (req, res) => {
    const { songName, artistName, albumName, numOfListeners } = req.body;
    const insertResult = await appService.insertSong(songName, artistName, albumName, numOfListeners);
    if (insertResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.post("/update-comment/:id", async (req, res) => {
    const commentId = req.params.id;
    const { description } = req.body;
    const updateResult = await appService.updateCommentDB(commentId, description);
    if (updateResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});


router.post("/add-comment", async (req, res) => {
    const { description, commentedBy } = req.body;
    const insertResult = await appService.addCommentDB(description, commentedBy);
    if (insertResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.post("/update-name-demotable", async (req, res) => {
    const { oldName, newName } = req.body;
    const updateResult = await appService.updateNameDemotable(oldName, newName);
    if (updateResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.delete("/remove-artist/:artistName", async (req, res) => {
    const condition = req.params.artistName;
    const updateResult = await appService.deleteArtistDB(condition);
    if (updateResult) {
        res.json( { success: true});
    } else {
        res.status(500).json( {success: false});
    }
})

router.get('/count-demotable', async (req, res) => {
    const tableCount = await appService.countDemotable();
    if (tableCount >= 0) {
        res.json({ 
            success: true,  
            count: tableCount
        });
    } else {
        res.status(500).json({ 
            success: false, 
            count: tableCount
        });
    }
});


module.exports = router;