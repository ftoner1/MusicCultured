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

router.get('/fetch-comments', async (req, res) => {
    const tableContent = await appService.fetchCommentsFromDB();
    res.json({data: tableContent});
});

router.post("/initiate-demotable", async (req, res) => {
    const initiateResult = await appService.initiateDemotable();
    if (initiateResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
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