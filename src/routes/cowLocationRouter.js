import express from "express"
import cowLocationController from "../controllers/cowLocationController.js";

let router = express.Router();

/* ---------------- Post ----------------*/
/* Create new cow's location */
router.post('/', cowLocationController.postCowLocation);
/* --------------------------------------*/


/* ----------------- Get --------------- */
/* Get cow's locations by cow_id */
router.get('/cow_id/:cow_id', cowLocationController.getCowLocationsByCowId);
/* Get cow's location by date */
router.get('/cow_id/:cow_id/:start_date/:end_date', cowLocationController.getCowLocationsByDate);
/* -------------------------------------- */


/* ----------------- Delete ------------- */
/* Delete cow's location by id */
router.delete('/:cow_location_id', cowLocationController.deleteCowLocationById);

/* Delete cow's locations by cow_id */
router.delete('/cow_id/:cow_id', cowLocationController.deleteCowLocationsByCowId);
/* -------------------------------------- */

export default router;
