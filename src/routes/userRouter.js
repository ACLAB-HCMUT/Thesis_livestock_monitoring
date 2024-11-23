import express from "express"
import userController from "../controllers/userController.js";

let router = express.Router();

router.post('/', userController.postUser);
router.get('/:username', userController.getUserByUsername);
router.put('/', userController.updateByUsername);
router.put('/global-address/:username', userController.getAndIncrementGlobalAddress)
export default router;
