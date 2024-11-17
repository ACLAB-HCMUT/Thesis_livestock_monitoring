import { SaveZone } from "../models/saveZoneModel.js";
const createSafeZone = async (safeZoneData) => {
  const safeZone = new SaveZone(safeZoneData);
  return await safeZone.save();
}
const getSafeZoneById = async (id) => {
  return await SaveZone.findById(id);
}
const getAllSafeZone = async (id) => {
  return await SaveZone.find();
}
const updateSafeZone = async (id, safeZoneData) => {
  return await SaveZone.findByIdAndUpdate(id, { safeZone: safeZoneData }, { new: true });
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