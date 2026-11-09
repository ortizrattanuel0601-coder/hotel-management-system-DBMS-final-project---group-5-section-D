const maintenanceModel = require('../models/maintenanceModel');

// Allowed priorities. If your seed data uses other values, add them here.
const PRIORITIES = ['Low', 'Medium', 'High', 'Urgent'];

function parseId(value) {
    const id = Number(value);
    return Number.isInteger(id) && id >= 1 ? id : null;
}

function isBlank(value) {
    return value === undefined || value === null || String(value).trim() === '';
}

// Returns a timestamp, or null if the text is not a real YYYY-MM-DD date.
function parseDate(value) {
    if (typeof value !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(value)) {
        return null;
    }

    const time = Date.parse(value + 'T00:00:00Z');

    if (Number.isNaN(time)) {
        return null;
    }

    return new Date(time).toISOString().slice(0, 10) === value ? time : null;
}

function todayString() {
    const now = new Date();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    return `${now.getFullYear()}-${month}-${day}`;
}

// Used by both create (POST) and update (PUT).
function validateRequest(body) {
    const roomId = parseId(body.room_id);
    const employeeId = isBlank(body.employee_id) ? null : parseId(body.employee_id);
    const issue = String(body.issue_description || '').trim();
    const item = String(body.maintenance_items || '').trim();
    const priority = PRIORITIES.find(
        (p) => p.toLowerCase() === String(body.priority || '').trim().toLowerCase()
    );
    const requestDate = isBlank(body.request_date)
        ? null
        : String(body.request_date).trim();

    if (roomId === null) {
        return { error: 'Please choose a room.' };
    }

    if (!isBlank(body.employee_id) && employeeId === null) {
        return { error: 'The selected employee is not valid.' };
    }

    if (!item || item.length > 30) {
        return { error: 'The item is required (up to 30 characters).' };
    }

    if (!issue || issue.length > 255) {
        return { error: 'The issue description is required (up to 255 characters).' };
    }

    if (!priority) {
        return { error: `Priority must be one of: ${PRIORITIES.join(', ')}.` };
    }

    if (requestDate !== null) {
        if (parseDate(requestDate) === null) {
            return { error: 'Request date must be a valid date (YYYY-MM-DD).' };
        }

        if (requestDate > todayString()) {
            return { error: 'Request date cannot be in the future.' };
        }
    }

    return {
        data: { roomId, employeeId, issue, item, priority, requestDate }
    };
}

function handleError(res, error, fallbackMessage) {
    console.error(error.message);

    if (error.code === 'ER_NO_REFERENCED_ROW_2') {
        return res.status(400).json({
            success: false,
            message: 'The specified room or employee does not exist.'
        });
    }

    if (error.code === 'ER_ROW_IS_REFERENCED_2') {
        return res.status(409).json({
            success: false,
            message: 'This request is referenced by other records and cannot be deleted.'
        });
    }

    res.status(500).json({ success: false, message: fallbackMessage });
}

async function getRequests(req, res) {
    try {
        const rows = await maintenanceModel.getAllRequests();
        res.status(200).json({ success: true, data: rows });
    } catch (error) {
        handleError(res, error, 'Failed to retrieve maintenance requests.');
    }
}

async function getRequest(req, res) {
    try {
        const id = parseId(req.params.id);

        if (id === null) {
            return res.status(400).json({
                success: false,
                message: 'Invalid request ID.'
            });
        }

        const row = await maintenanceModel.getRequestById(id);

        if (!row) {
            return res.status(404).json({
                success: false,
                message: 'Maintenance request not found.'
            });
        }

        res.status(200).json({ success: true, data: row });
    } catch (error) {
        handleError(res, error, 'Failed to retrieve the maintenance request.');
    }
}

async function getOptions(req, res) {
    try {
        const options = await maintenanceModel.getFormOptions();
        res.status(200).json({ success: true, data: options });
    } catch (error) {
        handleError(res, error, 'Failed to load the form options.');
    }
}

async function createRequest(req, res) {
    try {
        const { error, data } = validateRequest(req.body || {});

        if (error) {
            return res.status(400).json({ success: false, message: error });
        }

        const id = await maintenanceModel.createRequest(
            data.roomId,
            data.employeeId,
            data.issue,
            data.priority,
            data.item,
            data.requestDate
        );

        res.status(201).json({
            success: true,
            message: 'Maintenance request created successfully.',
            data: { maintenance_id: id }
        });
    } catch (error) {
        handleError(res, error, 'Failed to create the maintenance request.');
    }
}

async function updateRequest(req, res) {
    try {
        const id = parseId(req.params.id);

        if (id === null) {
            return res.status(400).json({
                success: false,
                message: 'Invalid request ID.'
            });
        }

        const { error, data } = validateRequest(req.body || {});

        if (error) {
            return res.status(400).json({ success: false, message: error });
        }

        const existing = await maintenanceModel.getRequestById(id);

        if (!existing) {
            return res.status(404).json({
                success: false,
                message: 'Maintenance request not found.'
            });
        }

        await maintenanceModel.updateRequest(
            id,
            data.roomId,
            data.employeeId,
            data.issue,
            data.priority,
            data.item,
            data.requestDate
        );

        res.status(200).json({
            success: true,
            message: 'Maintenance request updated successfully.'
        });
    } catch (error) {
        handleError(res, error, 'Failed to update the maintenance request.');
    }
}

// PATCH /api/maintenance/:id/complete: marks an open request as completed.
async function completeRequest(req, res) {
    try {
        const id = parseId(req.params.id);

        if (id === null) {
            return res.status(400).json({
                success: false,
                message: 'Invalid request ID.'
            });
        }

        const existing = await maintenanceModel.getRequestById(id);

        if (!existing) {
            return res.status(404).json({
                success: false,
                message: 'Maintenance request not found.'
            });
        }

        if (existing.completed_date) {
            return res.status(409).json({
                success: false,
                message: 'This request is already completed.'
            });
        }

        await maintenanceModel.completeRequest(id);

        res.status(200).json({
            success: true,
            message: 'Maintenance request marked as completed.'
        });
    } catch (error) {
        handleError(res, error, 'Failed to complete the maintenance request.');
    }
}

async function deleteRequest(req, res) {
    try {
        const id = parseId(req.params.id);

        if (id === null) {
            return res.status(400).json({
                success: false,
                message: 'Invalid request ID.'
            });
        }

        const affectedRows = await maintenanceModel.deleteRequest(id);

        if (affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: 'Maintenance request not found.'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Maintenance request deleted successfully.'
        });
    } catch (error) {
        handleError(res, error, 'Failed to delete the maintenance request.');
    }
}

async function getWorkloadReport(req, res) {
    try {
        const rows = await maintenanceModel.getEmployeeWorkloadReport();
        res.status(200).json({ success: true, data: rows });
    } catch (error) {
        handleError(res, error, 'Failed to generate the maintenance workload report.');
    }
}

module.exports = {
    getRequests,
    getRequest,
    getOptions,
    createRequest,
    updateRequest,
    completeRequest,
    deleteRequest,
    getWorkloadReport
};