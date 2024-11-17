import express from "express";
import * as safeZoneController from "../controllers/safeZoneController.js";

const router = express.Router();
router.post("/", safeZoneController.createSafeZone);
router.get("/id/:id", safeZoneController.getSafeZoneById);
router.get("/username/:username", safeZoneController.getSafeZoneByUsername);

router.get("/all", safeZoneController.getAllSafeZone);

router.put("/:id", safeZoneController.updateSafeZone);
router.delete("/:id", safeZoneController.deleteSafeZone);

export default router;
