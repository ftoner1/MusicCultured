let artists = [
    { name: "Kanye West", monthlyListeners: 1000000, origin: "Chicago" },
    // ... other initial artists
];
let comments = [];

document.getElementById('toggle-add-artist').addEventListener('click', () => {
    const form = document.getElementById('add-artist-form');
    form.style.display = form.style.display === 'none' ? 'block' : 'none';
});

document.getElementById('add-artist-form').addEventListener('submit', (e) => {
    e.preventDefault();
    const name = document.getElementById('artist-name').value;
    const listeners = document.getElementById('artist-listeners').value;
    const origin = document.getElementById('artist-origin').value;
    artists.push({ name, monthlyListeners: listeners, origin });
    updateArtistsDisplay();
});

document.getElementById('comment-form').addEventListener('submit', (e) => {
    e.preventDefault();
    const description = document.getElementById('comment-description').value;
    const author = document.getElementById('comment-author').value;
    comments.push({ description, commentedBy: author });
    updateCommentsDisplay();
});

function updateArtistsDisplay() {
    const display = document.getElementById('artist-display');
    display.innerHTML = '';
    artists.forEach((artist, index) => {
        const artistDiv = document.createElement('div');
        artistDiv.textContent = artist.name;
        const deleteButton = document.createElement('button');
        deleteButton.textContent = 'X';
        deleteButton.addEventListener('click', () => deleteArtist(index));
        artistDiv.appendChild(deleteButton);
        display.appendChild(artistDiv);
    });
}

function deleteArtist(index) {
    artists.splice(index, 1);
    updateArtistsDisplay();
}

function updateCommentsDisplay() {
    const commentsDiv = document.getElementById('comments');
    commentsDiv.innerHTML = '';
    comments.forEach(comment => {
        const commentDiv = document.createElement('div');
        commentDiv.textContent = `${comment.description} by ${comment.commentedBy}`;
        commentsDiv.appendChild(commentDiv);
    });
}

updateArtistsDisplay();
updateCommentsDisplay();
