const db = require('./db');

// Every request with its room, room type and assigned employee (if any).
// INNER JOIN: every request belongs to a room. LEFT JOIN: the employee is optional.
const SELECT_REQUESTS = `
    SELECT
        mr.maintenance_id,
        mr.room_id,
        rm.room_number,
        rt.type_name,
        mr.employee_id,
        CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
        mr.issue_description,
        mr.priority,
        mr.maintenance_items,
        DATE_FORMAT(mr.request_date, '%Y-%m-%d') AS request_date,
        DATE_FORMAT(mr.completed_date, '%Y-%m-%d') AS completed_date
    FROM maintenance_requests mr
    INNER JOIN rooms rm ON mr.room_id = rm.room_id
    LEFT JOIN room_types rt ON rm.room_type_id = rt.room_type_id
    LEFT JOIN employees e ON mr.employee_id = e.employee_id
`;

async function getAllRequests() {
    const [rows] = await db.query(`
        ${SELECT_REQUESTS}
        ORDER BY (mr.completed_date IS NOT NULL),
                 mr.request_date DESC,
                 mr.maintenance_id DESC
    `);
    return rows;
}

async function getRequestById(maintenance_id) {
    const [rows] = await db.query(
        `${SELECT_REQUESTS} WHERE mr.maintenance_id = ?`,
        [maintenance_id]
    );
    return rows[0] || null;
}

// Rooms and employees for the dropdowns on the page.
async function getFormOptions() {
    const [rooms] = await db.query(
        'SELECT room_id, room_number FROM rooms ORDER BY room_number'
    );

    const [employees] = await db.query(`
        SELECT employee_id, CONCAT(first_name, ' ', last_name) AS employee_name
        FROM employees
        ORDER BY first_name, last_name
    `);

    return { rooms, employees };
}

async function createRequest(
    room_id,
    employee_id,
    issue_description,
    priority,
    maintenance_items,
    request_date
) {
    const [result] = await db.query(
        `INSERT INTO maintenance_requests
        (room_id, employee_id, issue_description, priority,
         request_date, maintenance_items)
        VALUES (?, ?, ?, ?, COALESCE(?, NOW()), ?)`,
        [
            room_id,
            employee_id,
            issue_description,
            priority,
            request_date,
            maintenance_items
        ]
    );

    return result.insertId;
}

async function updateRequest(
    maintenance_id,
    room_id,
    employee_id,
    issue_description,
    priority,
    maintenance_items,
    request_date
) {
    const [result] = await db.query(
        `UPDATE maintenance_requests
        SET room_id = ?,
            employee_id = ?,
            issue_description = ?,
            priority = ?,
            maintenance_items = ?,
            request_date = COALESCE(?, request_date)
        WHERE maintenance_id = ?`,
        [
            room_id,
            employee_id,
            issue_description,
            priority,
            maintenance_items,
            request_date,
            maintenance_id
        ]
    );

    return result.affectedRows;
}

// Completing a request sets its completed date; only open requests qualify.
async function completeRequest(maintenance_id) {
    const [result] = await db.query(
        `UPDATE maintenance_requests
        SET completed_date = NOW()
        WHERE maintenance_id = ? AND completed_date IS NULL`,
        [maintenance_id]
    );

    return result.affectedRows;
}

async function deleteRequest(maintenance_id) {
    const [result] = await db.query(
        'DELETE FROM maintenance_requests WHERE maintenance_id = ?',
        [maintenance_id]
    );

    return result.affectedRows;
}

// JOIN report: FULL OUTER JOIN of employees and maintenance requests.
// MySQL has no FULL OUTER JOIN keyword, so it is a LEFT JOIN combined with a
// RIGHT JOIN using UNION. It lists:
//   - every employee, with their requests (or "No requests"), and
//   - every request, including requests nobody has been assigned to yet.
async function getEmployeeWorkloadReport() {
    const [rows] = await db.query(`
        SELECT
            w.employee_id,
            w.employee_name,
            w.maintenance_id,
            w.room_number,
            w.issue_description,
            w.priority,
            w.request_date,
            w.completed_date,
            CASE
                WHEN w.employee_id IS NULL THEN 'Unassigned request'
                WHEN w.maintenance_id IS NULL THEN 'No requests'
                WHEN w.completed_date IS NULL THEN 'Open'
                ELSE 'Completed'
            END AS assignment_status
        FROM (
            SELECT
                e.employee_id,
                CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
                mr.maintenance_id,
                rm.room_number,
                mr.issue_description,
                mr.priority,
                DATE_FORMAT(mr.request_date, '%Y-%m-%d') AS request_date,
                DATE_FORMAT(mr.completed_date, '%Y-%m-%d') AS completed_date
            FROM employees e
            LEFT JOIN maintenance_requests mr
                ON mr.employee_id = e.employee_id
            LEFT JOIN rooms rm
                ON mr.room_id = rm.room_id

            UNION

            SELECT
                e.employee_id,
                CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
                mr.maintenance_id,
                rm.room_number,
                mr.issue_description,
                mr.priority,
                DATE_FORMAT(mr.request_date, '%Y-%m-%d') AS request_date,
                DATE_FORMAT(mr.completed_date, '%Y-%m-%d') AS completed_date
            FROM employees e
            RIGHT JOIN maintenance_requests mr
                ON mr.employee_id = e.employee_id
            LEFT JOIN rooms rm
                ON mr.room_id = rm.room_id
        ) w
        ORDER BY (w.employee_id IS NOT NULL), w.employee_name, w.maintenance_id
    `);

    return rows;
}

module.exports = {
    getAllRequests,
    getRequestById,
    getFormOptions,
    createRequest,
    updateRequest,
    completeRequest,
    deleteRequest,
    getEmployeeWorkloadReport
};