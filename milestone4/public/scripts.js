let artists = [];
let songs = [];
let comments = [];
let albums = [];
let commentID = 1;

function generateNewCommentID() {
    commentID = commentID + comments.length;
}

async function checkConnectionButton() {
    let element = document.getElementById("check-connection-btn");
    let response = await fetch('/check-db-connection', {method: "GET"});
    try {
        let text = await response.text();
        element.textContent = text;
    } catch {
        element.textContent = "Lol nope";
    }
    // let init = await fetch("/initiate-demotable", {method: 'POST'})
    // let responseInit = await init.json();
    // if (responseInit.success) {
    //     console.log("successfully started");
    // } else {
    //     console.error("could not initiate table");
    // }
    fetchArtists();
}

function toggleAddArtistForm() {
    console.log("Toggle form");
    const form = document.getElementById('add-artist-form');
    form.style.display = form.style.display === 'none' ? 'block' : 'none';
}

async function addArtist(e) {
    e.preventDefault();
    const name = document.getElementById('artist-name').value;
    const listeners = parseInt(document.getElementById('artist-listeners').value, 10);
    const origin = document.getElementById('artist-origin').value;
    let response = await fetch("/insert-artist", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            artistName: name,
            artistMonthlyListeners: listeners,
            artistOrigin: origin
        })
    });
    let responseJSON = await response.json();
    if (responseJSON.success) {
        alert("Successfully added");
        fetchArtists();
    } else {
        alert("Invalid input -- make sure not to re-enter artist names and make sure to place correct input types :)");
        console.log("could not log");
    }
}

function songArtistAlbum(id) {
    var select = document.getElementById(id);
    console.log("works");

    // Clear existing options (optional, if you want to refresh the list)
    select.innerHTML = '<option>From Artist</option>';

    // Add an option for each artist
    console.log(artists.length);
    artists.forEach(artist => {
        console.log("hello");
        var option = document.createElement('option');
        option.value = artist.ARTISTNAME;
        option.textContent = artist.ARTISTNAME;
        select.appendChild(option);
    });
}

async function addSong(e) {
    e.preventDefault();
    const songName = document.getElementById('song-name').value;
    const artistName = document.getElementById('artist-dropdown').value;
    const albumName = document.getElementById('song-album').value;
    const numOfListeners = parseInt(document.getElementById('song-listeners').value);
    let response = await fetch("/insert-song", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            songName: songName,
            artistName: artistName,
            albumName: albumName,
            numOfListeners: numOfListeners
        })
    });
    let responseJSON = await response.json();
    if (responseJSON.success) {
        songs = responseJSON.data;
        fetchSongs();
        fetchAlbums();
        console.log("successfully added");
    } else {
        alert("Invalid input - Make sure to input the right types :)");
    }
}

async function fetchArtists() {
    let response = await fetch('/fetch-artists', {method: "GET"});
    let responseData = await response.json();
    artists = responseData.data;
    console.log(artists);
    updateArtistsDisplay();
    fetchAlbums();
    fetchSongs();
    songArtistAlbum("artist-dropdown");
    songArtistAlbum("gae-artist-dropdown");
}

async function fetchSongs() {
    let response = await fetch('/fetch-songs', {method: "GET"});
    let responseData = await response.json();
    songs = responseData.data;
    console.log(songs);
    updateSongsDisplay();
}

async function fetchAlbums() {
    let response = await fetch('/fetch-albums', {method: "GET"});
    let responseData = await response.json();
    albums = responseData.data;
    updateAlbumsDisplay();
}

function updateArtistsDisplay() {
    const display = document.getElementById('artist-display');
    display.innerHTML = '';
    artists.forEach((artist, index) => {
        const artistDiv = document.createElement('div');
        artistDiv.className = "artist";
        artistDiv.textContent = artist.ARTISTNAME;
        const deleteButton = document.createElement('button');
        deleteButton.textContent = 'X';
        deleteButton.addEventListener('click', () => deleteArtist(artist));
        artistDiv.appendChild(deleteButton);
        display.appendChild(artistDiv);
    });
}

function updateSongsDisplay() {
    const display = document.getElementById('song-display');
    display.innerHTML = '';
    songs.forEach((song) => {
        const songDiv = document.createElement('div');
        songDiv.className = "artist";
        songDiv.textContent = song.SONGNAME;
        display.appendChild(songDiv);
    });
}

function updateAlbumsDisplay() {
    const display = document.getElementById('albums-display');
    display.innerHTML = '';
    albums.forEach((album) => {
        const albumDiv = document.createElement('div');
        albumDiv.className = "artist";
        albumDiv.textContent = album.ALBUMNAME;
        display.appendChild(albumDiv);
    });
}

async function funFactButton() {
    const display = document.getElementById("fun-fact-artists");
    let response = await fetch('/fun-fact-artists', {method: "GET"});
    let responseData = await response.json();
    let goatedArtists = responseData.data;
    goatedArtists.forEach((artist, index) => {
        const artistDiv = document.createElement('div');
        artistDiv.className = "artist";
        artistDiv.textContent = artist.ARTISTNAME;
        display.appendChild(artistDiv);
    });
    console.log(goatedArtists);
}

async function deleteArtist(artist) {
    let deleteCondition = artist.ARTISTNAME;
    let res = await fetch(`/remove-artist/${deleteCondition}`, {method: "DELETE"});
    let resJson = await res.json();
    if (resJson.success) {
        console.log("successfully deleted");
    } else {
        console.log("could not delete");
    }
    fetchArtists();
}

async function joinGae(e) { //artist discography
    e.preventDefault();
    const artist = document.getElementById("gae-artist-dropdown").value;
    console.log(artist);

    const response = await fetch("/join-gae", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            artist: artist,
        })
    });
    try {
        let songsGae = await response.json();
        console.log(songsGae.data);
        gaeDisplay(songsGae.data);
    } catch {
        console.log("could not gae");
    }
}

function gaeDisplay(allGaes) {
    const display = document.getElementById("gae-display");
    display.innerHTML = "";

    allGaes.forEach(song => {
        let gae = document.createElement("div");
        gae.textContent = `${song.SONGNAME} from ${song.ALBUMNAME}`;
        display.appendChild(gae);
    })
}

async function fetchComments() {
    let res = await fetch("/fetch-comments", {method: "GET"});
    let resData = await res.json();
    if (resData.success) {
        console.log("fetched comments");
        comments = resData.data;
        console.log(comments);
    } else {
        console.log("could not fetch comment");
    }
    updateCommentsDisplay();
}

async function getSongsInAlbum() {
    let res = await fetch("/songs-in-album", {method: "GET"});
    let resData = await res.json();
    if (resData.success) {
        updateFilteredAlbumsOne(resData.data);
        console.log(resData.data);
    } else {
        console.log("could not songs in album");
    }
}

async function filterAlbumAvgListens(e) {
    e.preventDefault();
    let input = parseInt(document.getElementById("listen-filter").value);
    let res = await fetch("/filter-album-listens", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({
            condition: input
        })
    });
    let resData = await res.json();
    if (resData.success) {
        updateFilteredAlbumsTwo(resData.data);
        console.log(resData.data);
    } else {
        console.log("could not songs in album");
    }
}

async function listensPerAlbumByArtist() { // nested agg
    let res = await fetch("/avg-listens-per-album", { method: "GET" });
    let resData = await res.json();
    if (resData.success) {
        updateFilteredAlbumsThree(resData.data);
    } else {
        console.log("could not nested aggregation");
    }
}

function updateFilteredAlbumsOne(filteredAlbums) {
    const display = document.getElementById('filter');
    display.innerHTML = '';
    filteredAlbums.forEach(album => {
        const albumDiv = document.createElement('div');
        albumDiv.className = "album";
        albumDiv.textContent = `${album.NUMBEROFSONGS} songs in ${album.ALBUMNAME}`;
        display.appendChild(albumDiv);
    });
}

function updateFilteredAlbumsTwo(filteredAlbums) {
    const display = document.getElementById('filter');
    display.innerHTML = '';
    filteredAlbums.forEach(album => {
        const albumDiv = document.createElement('div');
        albumDiv.className = "album";
        albumDiv.textContent = `${album.ALBUMNAME} has average of ${album.TOTALPLAYS} listens`;
        display.appendChild(albumDiv);
    });
}

function updateFilteredAlbumsThree(filteredArtist) { // TODO !PAOIEWJF!
    const display = document.getElementById('filter');
    display.innerHTML = '';
    filteredArtist.forEach(artist => {
        const artistdDiv = document.createElement('div');
        artistdDiv.className = "album";
        artistdDiv.textContent = `${artist.ARTISTNAME} averages ${artist.AVG_LISTENERS_PER_ALBUM} listens per Album! Slay queen 💅`;
        display.appendChild(artistdDiv);
    });
}

async function addComment(e) {
    e.preventDefault();
    const description = document.getElementById('comment-description').value;
    const author = document.getElementById('comment-author').value;
    let res = await fetch("/add-comment", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            description: description,
            commentedBy: author
        }
        )
    })
    let resJSON = await res.json();
    if (resJSON.success) {
        console.log("yay!");
        fetchComments();
    } else {
        console.log("nooo");
    }
}

function updateCommentsDisplay() {
    const commentsDiv = document.getElementById('comments');
    commentsDiv.innerHTML = '';
    comments.forEach(comment => {
        const commentDiv = document.createElement('div');
        commentDiv.className = "comment";
        commentDiv.textContent = `${comment.DESCRIPTION} by ${comment.COMMENTEDBY}`; 
        commentsDiv.appendChild(commentDiv);

        // Create and configure the edit button
        const editButton = document.createElement('button');
        editButton.textContent = 'Edit';
        editButton.onclick = function() {
            document.getElementById(`edit-form-${comment.ID}`).style.display = 'block';
        };

        // Create form for editing
        const editForm = document.createElement('form');
        editForm.id = `edit-form-${comment.ID}`;
        editForm.style.display = 'none'; // Initially hide the form

        // Create input for the updated description
        const descriptionInput = document.createElement('input');
        descriptionInput.type = 'text';
        descriptionInput.value = comment.DESCRIPTION;
        descriptionInput.name = 'description';
        descriptionInput.className = 'edit-description';

        // Create input for the updated author
        const authorInput = document.createElement('input');
        authorInput.type = 'text';
        authorInput.value = comment.COMMENTEDBY;
        authorInput.name = 'commentedBy';
        authorInput.className = 'edit-commentedBy';

        // Create a submit button for the form
        const submitButton = document.createElement('button');
        submitButton.type = 'submit';
        submitButton.textContent = 'Update';

        // Append inputs and button to the form
        editForm.appendChild(descriptionInput);
        editForm.appendChild(authorInput);
        editForm.appendChild(submitButton);

        // Add submit event listener to the form
        editForm.addEventListener('submit', (e) => editComment(e, comment.COMMENTID, descriptionInput.value, authorInput.value));

        // Append edit button and form to the comment div
        commentDiv.appendChild(editButton);
        commentDiv.appendChild(editForm);

        // Append comment div to the comments container
        commentsDiv.appendChild(commentDiv);
        
    });
}

async function editComment(e, commentID, description, author) {
    e.preventDefault();
    let res = await fetch("/edit-comment", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            commentId: commentID,
            description: description,
            author: author
        })
    })
    let resData = await res.json();
    if (resData.success) {
        fetchComments();
    } else {
        console.log("could not update comment");
    }
}

async function submitEdit(commentId) {
    const editedText = document.getElementById(`edit-text-${commentId}`).value;

    let response = await fetch(`/update-comment/${commentId}`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            description: editedText
        })
    });
a
    let responseData = await response.json();
    if (responseData.success) {
        console.log("Comment updated successfully");
        fetchComments();
    } else {
        console.log("Failed to update comment");
    }
}

window.onload = function() {
    document.getElementById('toggle-add-artist').addEventListener('click', toggleAddArtistForm);
    document.getElementById('add-artist-form').addEventListener('submit', addArtist);
    document.getElementById('comment-form').addEventListener('submit', addComment);
    document.getElementById("check-connection-btn").addEventListener("click", checkConnectionButton);
    document.getElementById("fun-fact-button").addEventListener("click", funFactButton);
    document.getElementById("get-num-songs").addEventListener("click", getSongsInAlbum);
    document.getElementById("insert-song").addEventListener("submit", addSong);
    document.getElementById("gae-ah-form").addEventListener("submit", joinGae);
    document.getElementById("get-album-greater").addEventListener("submit", filterAlbumAvgListens);
    document.getElementById("nested-agg").addEventListener("click", listensPerAlbumByArtist);
    fetchArtists();
    fetchComments();
};