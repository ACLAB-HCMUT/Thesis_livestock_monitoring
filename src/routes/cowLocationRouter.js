import express from "express"
import cowLocationController from "../controllers/cowLocationController.js";

let router = express.Router();

/* ---------------- Post ----------------*/
/* Create new cow's location by username and cow address */
router.post('/', cowLocationController.postCowLocation);
/* --------------------------------------*/


/* ----------------- Get --------------- */
/* Get all cow's location by username */
router.get('/username', cowLocationController.getCowLocationsByUsername);

/* Get all cow's location by username and cow address */
router.get('/cow_addr', cowLocationController.getCowLocationsByUsernameAndCowAddr);

/* Get all cow's location by username and cow address in the date */
router.get('/date', cowLocationController.getCowLocationsInDate);
/* -------------------------------------- */


/* ----------------- Delete ------------- */
/* Delete all data of cow's location by username and cow address */
router.delete('/cow_addr', cowLocationController.deleteCowLocationsByUsernameAndCowAddr);

/* Delete all data of cow's location by username */
router.delete('/username', cowLocationController.deleteCowLocationsByUsername);
/* -------------------------------------- */

export default router;
