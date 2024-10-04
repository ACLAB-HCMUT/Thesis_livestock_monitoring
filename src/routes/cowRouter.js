import express from "express"
import cowController from "../controllers/cowController.js";

let router = express.Router();

router.post('/', cowController.postCow);

router.get('/username/:username', cowController.getCowByUsername);
router.get('/id/:cowId', cowController.getCowById);

router.delete('/id/:cowId', cowController.deleteCowById);
router.delete('/username/:username', cowController.deleteCowByUsername);

router.put('/id/:cowId', cowController.updateCowById);

export default router;
