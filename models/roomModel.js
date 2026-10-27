
const db = require('./db');

async function getAllRooms() {
    const [rows] = await db.query(`
        SELECT
            r.room_id,
            r.room_number,
            r.floor_number,
            r.room_status,
            r.notes,
            r.room_type_id
        FROM room r
        ORDER BY r.room_id
    `);

    return rows;
}

async function createRoom(room_number, floor_number, room_status, notes, room_type_id) {
    const [result] = await db.query(
        `INSERT INTO room
        (room_number, floor_number, room_status, notes, room_type_id)
        VALUES (?, ?, ?, ?, ?)`,
        [room_number, floor_number, room_status, notes, room_type_id]
    );

    return result.insertId;
}

async function updateRoom(room_id, room_number, floor_number, room_status, notes, room_type_id) {
    const [result] = await db.query(
        `UPDATE room
        SET room_number = ?, floor_number = ?, room_status = ?, notes = ?, room_type_id = ?
        WHERE room_id = ?`,
        [room_number, floor_number, room_status, notes, room_type_id, room_id]
    );

    return result.affectedRows;
}

async function deleteRoom(room_id) {
    const [result] = await db.query(
        'DELETE FROM room WHERE room_id = ?',
        [room_id]
    );

    return result.affectedRows;
}

module.exports = {
    getAllRooms,
    createRoom,
    updateRoom,
    deleteRoom
};
