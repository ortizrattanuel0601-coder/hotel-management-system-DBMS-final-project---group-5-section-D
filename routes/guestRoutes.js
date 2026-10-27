
const express = require('express');
const router = express.Router();

const guestController = require('../controllers/guestController');

router.get('/', guestController.getGuests);
router.post('/', guestController.createGuest);
router.put('/:id', guestController.updateGuest);
router.delete('/:id', guestController.deleteGuest);

module.exports = router;
