const express = require('express');
const router = express.Router();
const maintenanceController = require('../controllers/maintenanceController');

// Fixed paths must come before '/:id', or Express would read them as an ID.
router.get('/options', maintenanceController.getOptions);
router.get('/reports/employee-workload', maintenanceController.getWorkloadReport);

router.get('/', maintenanceController.getRequests);
router.get('/:id', maintenanceController.getRequest);
router.post('/', maintenanceController.createRequest);
router.put('/:id', maintenanceController.updateRequest);
router.patch('/:id/complete', maintenanceController.completeRequest);
router.delete('/:id', maintenanceController.deleteRequest);

module.exports = router;