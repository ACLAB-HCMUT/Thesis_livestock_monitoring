import safeZoneService from "../services/safeZoneService.js";
export const createSafeZone = async (req, res) => {
  const username = req.params.username;
  try {
    const safeZone = await safeZoneService.createSafeZone(req.body);
    res.status(201).json(safeZone);
  } catch (error) {
    console.error("Error creating safe zone:", error);
    res.status(500).json({ message: "Failed to create safe zone", error });
  }
};
export const getSafeZoneById = async (req, res) => {
  try {
    const safeZone = await safeZoneService.getSafeZoneById(req.params.id);
    if (safeZone) {
      res.status(200).json(safeZone);
    } else {
      res.status(404).json({ message: "Safe zone not found" });
    }
  } catch (error) {
    console.error("Error retrieving safe zone:", error);
    res.status(500).json({ message: "Failed to retrieve safe zone", error });
  }
};
export const getSafeZoneByUsername = async (req, res) => {
  try {
    const safeZones = await safeZoneService.getSafeZoneByUsername(req.params.username);
    if (safeZones) {
      res.status(200).json(safeZones);
    } else {
      res.status(404).json({ message: "Safe zone not found" });
    }
  } catch (error) {
    console.error("Error retrieving safe zone:", error);
    res.status(500).json({ message: "Failed to retrieve safe zone", error });
  }
};
export const getAllSafeZone = async (req, res) => {
  try {
    const safeZone = await safeZoneService.getAllSafeZone();
    if (safeZone) {
      res.status(200).json(safeZone);
    } else {
      res.status(404).json({ message: "Safe zone not found" });
    }
  } catch (error) {
    console.error("Error retrieving safe zone:", error);
    res.status(500).json({ message: "Failed to retrieve safe zone", error });
  }
};


export const updateSafeZone = async (req, res) => {
  const username = req.params.username;
  try {
    const safeZone = await safeZoneService.updateSafeZone(req.params.id, req.body.safeZone);
    if (safeZone) {
      res.status(200).json(safeZone);
    } else {
      res.status(404).json({ message: "Safe zone not found" });
    }
  } catch (error) {
    console.error("Error updating safe zone:", error);
    res.status(500).json({ message: "Failed to update safe zone", error });
  }
};


export const deleteSafeZone = async (req, res) => {
  const username = req.params.username;
  try {
    const result = await safeZoneService.deleteSafeZone(req.params.id);
    if (result) {
      res.status(200).json({ message: "Safe zone deleted successfully" });
    } else {
      res.status(404).json({ message: "Safe zone not found" });
    }
  } catch (error) {
    console.error("Error deleting safe zone:", error);
    res.status(500).json({ message: "Failed to delete safe zone", error });
  }
};

