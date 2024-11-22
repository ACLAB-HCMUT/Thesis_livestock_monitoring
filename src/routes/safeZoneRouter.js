import express from "express";
import * as safeZoneController from "../controllers/safeZoneController.js";

const router = express.Router();
router.post("/:username", safeZoneController.createSafeZone);
router.get("/id/:id", safeZoneController.getSafeZoneById);
router.get("/username/:username", safeZoneController.getSafeZoneByUsername);

router.get("/all", safeZoneController.getAllSafeZone);

router.put("/:username/:id", safeZoneController.updateSafeZone);
router.delete("/:username/:id", safeZoneController.deleteSafeZone);

export default router;
