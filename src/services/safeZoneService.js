import { SaveZone } from "../models/saveZoneModel.js";
export const createSafeZone = async (safeZoneData) => {
  const safeZone = new SaveZone(safeZoneData);
  return await safeZone.save();
}
export const getSafeZoneById = async (id) => {
  return await SaveZone.findById(id);
}
export const getAllSafeZone = async (id) => {
  return await SaveZone.find();
}
export const updateSafeZone = async (id, safeZoneData) => {
  return await SaveZone.findByIdAndUpdate(id, { safeZone: safeZoneData }, { new: true });
};
export const deleteSafeZone = async (id) => {
  return await SaveZone.findByIdAndDelete(id);
};
