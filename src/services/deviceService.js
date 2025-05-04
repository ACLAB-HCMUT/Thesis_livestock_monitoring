import { CowModel } from "../models/cowModel.js";
import {DeviceModel} from "../models/deviceModel.js"
import userService from "../services/userService.js";
import cowService from "./cowService.js";

const createDevice = async (req) => {
    const updatedUser = await userService.incrementGlobalAddress(req.body.username);
    const deviceData = {
        username : req.body.username,
        address : updatedUser.global_address - 1,
        cow_id : req.body.cow_id || "",
        device_name : req.body.username + "_address" + (updatedUser.global_address - 1).toString()
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
const deleteDeviceById = async (deviceId) => {
    var cur_device = await DeviceModel.findById(deviceId);
    if (cur_device.cow_id != "") {
        var cow = await CowModel.findById(cur_device.cow_id);
        cow.cow_addr = -1;
        await cow.save();
    }
    const device = await DeviceModel.findById(deviceId);
    if (device) {
        await device.deleteOne();
    }
};

export default{
    createDevice,
    getAllDevice,
    findDevice,
    deleteDeviceById
}