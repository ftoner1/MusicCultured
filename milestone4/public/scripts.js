let artists = [];
let songs = [];
let comments = [];
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
        console.log("successfully added");
        fetchArtists();
    } else {
        console.log("could not log");
    }
}

function songArtistAlbum() {
    var select = document.getElementById('artist-dropdown');
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
    const numOfListeners = document.getElementById('song-listeners').value;
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
        console.log("successfully added");
    } else {
        console.log("could not log");
    }
}

async function fetchArtists() {
    let response = await fetch('/fetch-artists', {method: "GET"});
    let responseData = await response.json();
    artists = responseData.data;
    console.log(artists);
    updateArtistsDisplay();
    songArtistAlbum();
}

async function fetchSongs() {
    let response = await fetch('/fetch-songs', {method: "GET"});
    let responseData = await response.json();
    songs = responseData.data;
    console.log(songs);
    updateSongsDisplay();
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

async function joinGae() {
    const artist = document.getElementById("artist-dropdown").value;
    
}

async function fetchComments() {
    let res = await fetch("/fetch-comments", {method: "GET"});
    let resData = res.json();
    if (resData.success) {
        console.log("fetched comments");
    } else {
        console.log("could not fetch comment");
    }
    comments = resData.data;
}

async function addComment(e) {
    e.preventDefault();
    const description = document.getElementById('comment-description').value;
    const author = document.getElementById('comment-author').value;
    let res = await fetch("/add-comment", {
        method: "POST",
        header: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            description: description,
            commentedBy: author
        }
        )
    })
    fetchComments();
    updateCommentsDisplay();
}

function updateCommentsDisplay() {
    const commentsDiv = document.getElementById('comments');
    commentsDiv.innerHTML = '';
    comments.forEach(comment => {
        const commentDiv = document.createElement('div');
        commentDiv.className = "comment";
        commentDiv.textContent = `${comment.description} by ${comment.commentedBy}`;
        commentsDiv.appendChild(commentDiv);
    });
}

window.onload = function() {
    document.getElementById('toggle-add-artist').addEventListener('click', toggleAddArtistForm);
    document.getElementById('add-artist-form').addEventListener('submit', addArtist);
    document.getElementById('comment-form').addEventListener('submit', addComment);
    document.getElementById("check-connection-btn").addEventListener("click", checkConnectionButton);
    document.getElementById("fun-fact-button").addEventListener("click", funFactButton);
    document.getElementById("insert-song").addEventListener("submit", addSong);
    fetchArtists();
    fetchSongs();
    updateCommentsDisplay();
};