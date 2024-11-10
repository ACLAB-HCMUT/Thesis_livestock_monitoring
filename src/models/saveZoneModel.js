import mongoose from "mongoose";
const saveZoneSchema = new mongoose.Schema({
  safeZone:{
    type: [
      {
        latitude: Number,
        longitude: Number
      }
    ],
    required: true
  }
});
export const SaveZone = mongoose.model("SaveZone", saveZoneSchema);