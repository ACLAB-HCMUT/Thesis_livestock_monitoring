import {DeviceModel} from "../models/deviceModel.js"

const createDevice = async (req) => {
    const deviceData = {
        username : req.body.username,
        address : req.body.address,
        cow_id : req.body.cow_id || "",
        device_name : req.body.username + "_address" + req.body.address
    }
    const newDevice = new DeviceModel(deviceData);
    const savedDevice = newDevice.save();
    return savedDevice;
};
const getAllDevice = async () => {
    const devices = await DeviceModel.find();
    return devices;
};
const findDevice = async (username, address) => {
    try {
        const device = await DeviceModel.findOne({ username, address });
        if (!device) {
            throw new Error(`Device with username "${username}" and address "${address}" not found.`);
        }
        return device;
    } catch (error) {
        console.error('Error finding device:', error.message);
        throw error;
    }
};
export default{
    createDevice,
    getAllDevice,
    findDevice
}