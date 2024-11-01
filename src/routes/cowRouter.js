import express from "express"
import cowController from "../controllers/cowController.js";

let router = express.Router();

/* ------------- Post ------------- */
/* Create new cow */
router.post('/', cowController.postCow);
/* -------------------------------- */


/* ------------- Get ------------- */
/* Get cows by username */
router.get('/username/:username', cowController.getCowByUsername);
/* Get cow by id */
router.get('/:cow_id', cowController.getCowById);
/* ------------------------------- */


/* ------------- Delete ------------- */
/* Delete cow by id */
router.delete('/:cow_id', cowController.deleteCowById);
/* Delete cow by username */
router.delete('/username/:username', cowController.deleteCowByUsername);
/* ---------------------------------- */


/* ------------- Update ------------- */
/* Update cow by id */
router.put('/:cow_id', cowController.updateCowById);
/* ---------------------------------- */
export default router;
