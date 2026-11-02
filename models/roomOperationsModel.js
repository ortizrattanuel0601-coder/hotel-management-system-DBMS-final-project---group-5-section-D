const db = require('./db');

async function getRoomOperations() {
    const [rows] = await db.query(`
        SELECT
            rm.room_number,
            rt.type_name,
            rm.room_status,
            ht.task_type,
            ht.task_status,
            mr.issue_description,
            mr.priority
        FROM room rm
        INNER JOIN room_types rt
            ON rm.room_type_id = rt.room_type_id
        LEFT JOIN housekeeping_tasks ht
            ON rm.room_id = ht.room_id
        LEFT JOIN maintenance_requests mr
            ON rm.room_id = mr.room_id
        ORDER BY rm.room_number;
    `);

    return rows;
}

module.exports = { getRoomOperations };