import express from "express"
import cowController from "../controllers/cowController.js";

let router = express.Router();

router.post('/', cowController.postCow);

router.get('/username', cowController.getCowByUsername);
router.get('/id', cowController.getCowById);

router.delete('/id', cowController.deleteCowById);
router.delete('/username', cowController.deleteCowByUsername);

router.put('/id', cowController.updateCowById);

export default router;
