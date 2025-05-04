import express from "express"
import userController from "../controllers/userController.js";

let router = express.Router();
router.post('/login', userController.loginUser);
router.post('/register', userController.registerUser);
router.post('/', userController.postUser);
router.get("/all", userController.getAllUser);
router.get('/:username', userController.getUserByUsername);
router.put('/', userController.updateByUsername);
router.put('/global-address/:username', userController.getAndIncrementGlobalAddress)
router.delete('/delete', userController.deleteUserById);
export default router;