const express = require('express');
const router = express.Router();

const roomOperationsController = require('../controllers/roomOperationsController');

router.get('/', roomOperationsController.getRoomOperations);

module.exports = router;