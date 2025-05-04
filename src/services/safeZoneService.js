import { SaveZone } from "../models/saveZoneModel.js";
const createSafeZone = async (safeZoneBody) => {
  const groupId = safeZoneBody.groupId;
  const username = safeZoneBody.username;
  const existingSafeZone = await SaveZone.findOne({
    groupId: groupId,
    username: username,
  });
  
  if (existingSafeZone) {
    throw new Error("Group ID already exists.");
  }
  const safeZoneData = {
    'username': username,
    'safeZone': safeZoneBody.safeZone,
    'groupId': groupId
  }
  // console.log(safeZoneData)
  const safeZone = new SaveZone(safeZoneData);
  return await safeZone.save();
}
const getSafeZoneById = async (id) => {
  return await SaveZone.findById(id);
}
const getAllSafeZone = async (id) => {
  return await SaveZone.find();
}
const updateSafeZone = async (username, data) => {
  const { groupId, safeZone } = data;
  if (!groupId || !safeZone) {
    throw new Error("Both 'groupId' and 'safeZone' are required.");
  }
  try {
    const existingSafeZone = await SaveZone.findOne({ username, groupId });

    if (!existingSafeZone) {
      return null; // Safe zone not found
    }

    // Update the safe zone details
    existingSafeZone.safeZone = safeZone;
    await existingSafeZone.save();

    return existingSafeZone;
  } catch (error) {
    console.error("Error in updateSafeZone service:", error);
    throw error; // Rethrow for controller to handle
  }
};
const deleteSafeZone = async (id) => {
  return await SaveZone.findByIdAndDelete(id);
};
const getSafeZoneByUsername = async (username) => {
  const safeZones = await SaveZone.find({
    username: username,
  })
  return safeZones;
}

export default {
  createSafeZone,
  getSafeZoneById,
  getAllSafeZone,
  updateSafeZone,
  deleteSafeZone,
  getSafeZoneByUsername
}