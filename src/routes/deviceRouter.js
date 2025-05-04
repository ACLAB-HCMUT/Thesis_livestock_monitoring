import express from "express"
import deviceController from "../controllers/deviceController.js"

let router = express.Router();

/* ------------- Post ------------- */

/* Create new device */
router.post('/', deviceController.postDevice);

router.delete('/delete', deviceController.deleteDeviceById);
/* -------------------------------- */
router.get("/all", deviceController.getAllDevice);

export default router;