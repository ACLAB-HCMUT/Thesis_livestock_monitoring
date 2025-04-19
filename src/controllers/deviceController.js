import deviceService from "../services/deviceService.js";


const postDevice = async (req, res) =>{
    try {
        const newDevice = await deviceService.createDevice(req);
        return res.status(200).json(newDevice); 
    }catch (err){
        return res.status(500).json(err);
    }
}

export const getAllDevice = async (req, res) => {
  try {
    const devices = await deviceService.getAllDevice();
    if (devices) {
      res.status(200).json(devices);
    } else {
      res.status(404).json({ message: "Device not found" });
    }
  } catch (error) {
    console.error("Error retrieving device:", error);
    res.status(500).json({ message: "Failed to retrieve device", error });
  }
};

export default {
    postDevice,
    getAllDevice
};