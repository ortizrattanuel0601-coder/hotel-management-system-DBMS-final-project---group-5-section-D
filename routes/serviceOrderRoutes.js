
const express = require('express');
const router = express.Router();

const serviceOrderController = require('../controllers/serviceOrderController');

router.get('/', serviceOrderController.getServiceOrders);
router.post('/', serviceOrderController.createServiceOrder);
router.put('/:id', serviceOrderController.updateServiceOrder);
router.delete('/:id', serviceOrderController.deleteServiceOrder);

module.exports = router;
