import express from "express"
import cowLocationController from "../controllers/cowLocationController.js";

let router = express.Router();

/* ---------------- Post ----------------*/
/* Create new cow's location by username and cow address */
router.post('/', cowLocationController.postCowLocation);
/* --------------------------------------*/


/* ----------------- Get --------------- */
/* Get latest cow's location by username and cow address */
router.get('/latest', cowLocationController.getLatestCowLocation);

/* Get all cow's location by username and cow address in the date */
router.get('/date', cowLocationController.getCowLocationInDate);
/* -------------------------------------- */


/* ----------------- Delete ------------- */
/* Delete all data of cow's location by username and cow address */
router.delete('/cow_addr', cowLocationController.deleteCowLocationByUsernameCowAddr);

/* Delete all data of cow's location by username */
router.delete('/username', cowLocationController.deleteCowLocationByUsername);
/* -------------------------------------- */

export default router;
