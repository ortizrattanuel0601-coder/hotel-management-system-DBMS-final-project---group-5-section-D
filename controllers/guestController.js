
const guestModel = require('../models/guestModel');

async function getGuests(req, res) {
    try {
        const guests = await guestModel.getAllGuests();
        res.status(200).json(guests);
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ message: 'Failed to retrieve guests.' });
    }
}

async function createGuest(req, res) {
    try {
        const { first_name, phone, email } = req.body;

        if (!first_name || !phone || !email) {
            return res.status(400).json({
                message: 'First name, phone, and email are required.'
            });
        }

        const guestId = await guestModel.createGuest(
            first_name,
            phone,
            email
        );

        res.status(201).json({
            message: 'Guest created successfully.',
            guest_id: guestId
        });
    } catch (error) {
        console.error(error.message);

        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({
                message: 'This email already exists.'
            });
        }

        res.status(500).json({ message: 'Failed to create guest.' });
    }
}

async function updateGuest(req, res) {
    try {
        const { first_name, phone, email } = req.body;
        const guestId = Number(req.params.id);

        if (!Number.isInteger(guestId) || guestId < 1) {
            return res.status(400).json({ message: 'Invalid guest ID.' });
        }

        if (!first_name || !phone || !email) {
            return res.status(400).json({
                message: 'First name, phone, and email are required.'
            });
        }

        const affectedRows = await guestModel.updateGuest(
            guestId,
            first_name,
            phone,
            email
        );

        if (affectedRows === 0) {
            return res.status(404).json({ message: 'Guest not found.' });
        }

        res.status(200).json({ message: 'Guest updated successfully.' });
    } catch (error) {
        console.error(error.message);

        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({
                message: 'This email already exists.'
            });
        }

        res.status(500).json({ message: 'Failed to update guest.' });
    }
}

async function deleteGuest(req, res) {
    try {
        const guestId = Number(req.params.id);

        if (!Number.isInteger(guestId) || guestId < 1) {
            return res.status(400).json({ message: 'Invalid guest ID.' });
        }

        const affectedRows = await guestModel.deleteGuest(guestId);

        if (affectedRows === 0) {
            return res.status(404).json({ message: 'Guest not found.' });
        }

        res.status(200).json({ message: 'Guest deleted successfully.' });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ message: 'Failed to delete guest.' });
    }
}

module.exports = {
    getGuests,
    createGuest,
    updateGuest,
    deleteGuest
};
