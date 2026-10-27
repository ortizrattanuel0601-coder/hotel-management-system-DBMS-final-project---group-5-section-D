
const db = require('./db');

async function getAllGuests() {
    const [rows] = await db.query(
        'SELECT * FROM guests ORDER BY guest_id'
    );
    return rows;
}

async function createGuest(first_name, phone, email) {
    const [result] = await db.query(
        'INSERT INTO guests (first_name, phone, email) VALUES (?, ?, ?)',
        [first_name, phone, email]
    );
    return result.insertId;
}

async function updateGuest(guest_id, first_name, phone, email) {
    const [result] = await db.query(
        'UPDATE guests SET first_name = ?, phone = ?, email = ? WHERE guest_id = ?',
        [first_name, phone, email, guest_id]
    );
    return result.affectedRows;
}

async function deleteGuest(guest_id) {
    const [result] = await db.query(
        'DELETE FROM guests WHERE guest_id = ?',
        [guest_id]
    );
    return result.affectedRows;
}

module.exports = {
    getAllGuests,
    createGuest,
    updateGuest,
    deleteGuest
};
