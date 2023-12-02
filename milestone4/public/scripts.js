let artists = [
    { name: "Kanye West", monthlyListeners: 1000000, origin: "Chicago" },
    // ... other initial artists
];
let comments = [];

async function checkConnectionButton() {
    let element = document.getElementById("check-connection-btn");
    let response = await fetch('/check-db-connection', {method: "GET"});
    try {
        let text = await response.text();
        element.textContent = text;
    } catch {
        element.textContent = "Lol nope";
    }
    let init = await fetch("/initiate-demotable", {method: 'POST'})
    let responseInit = await init.json();
    if (responseInit.success) {
        console.log("successfully added");
    } else {
        console.error("could not initiate table");
    }
}

function toggleAddArtistForm() {
    console.log("Toggle form");
    const form = document.getElementById('add-artist-form');
    form.style.display = form.style.display === 'none' ? 'block' : 'none';
}

async function addArtist(e) {
    e.preventDefault();
    const name = document.getElementById('artist-name').value;
    const listeners = document.getElementById('artist-listeners').value;
    const origin = document.getElementById('artist-origin').value;
    let response = await fetch("/insert-artist", {
        method: "POST",
        header: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            artistName: name,
            artistMonthlyListeners: listeners,
            artistOrigin: origin
        })
    });
    if (response.json().success) {
        console.log("successfully added");
    } else {
        console.log("could not log");
    }
    fetchArtists();
    updateArtistsDisplay();
}

async function fetchArtists() {
    let response = await fetch('/get-artists', {method: "GET"});
    let responsedData = await response.json();
    artists = responseData.data;
}

function updateArtistsDisplay() {
    const display = document.getElementById('artist-display');
    display.innerHTML = '';
    artists.forEach((artist, index) => {
        const artistDiv = document.createElement('div');
        artistDiv.className = "artist";
        artistDiv.textContent = artist.name;
        const deleteButton = document.createElement('button');
        deleteButton.textContent = 'X';
        deleteButton.addEventListener('click', () => deleteArtist(artist));
        artistDiv.appendChild(deleteButton);
        display.appendChild(artistDiv);
    });
}

async function deleteArtist(artist) {
    let deleteCondition = artist.name;
    let res = await fetch(`/remove-artist/${deleteCondition}`, {method: "DELETE"});
    if (res.json().success) {
        console.log("successfully deleted");
    } else {
        console.log("could not delete");
    }
    fetchArtists();
    updateArtistsDisplay();
}

async function fetchComments() {
    let res = await fetch("/fetch-comments", {method: "GET"});
    let resData = res.json();
    if (resData.success) {
        console.log("fetched comments");
    } else {
        console.log("could not fetch comment");
    }
    comments = resData;
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
            commentDescription: description,
            commentAuthor: author
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
    updateArtistsDisplay();
    updateCommentsDisplay();
};