const roomOperationsModel = require('../models/roomOperationsModel');

async function getRoomOperations(req, res) {
    try {
        const rows = await roomOperationsModel.getRoomOperations();

        res.status(200).json({
            success: true,
            data: rows,
            count: rows.length
        });
    } catch (error) {
        console.error('Room Operations Error:', error);

        res.status(500).json({
            success: false,
            message: 'Failed to retrieve room operations.'
        });
    }
}

module.exports = { getRoomOperations };