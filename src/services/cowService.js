import { CowModel } from "../models/cowModel.js";

const createCow = async (req) => {
    const newCow = new CowModel(req.body);
    const savedCow = newCow.save();
    return savedCow;
};
const createCowx = async (req) => {
    const cowData = {
        cow_addr: req.body.cow_addr,
        name: req.body.name,
        username: req.body.username || "xxx",
        latest_longitude: req.body.latest_longitude || 10.879969479749972,
        latest_latitude: req.body.latest_latitude || 106.80616368776177,
        medicated: req.body.medicated || false,
        sick: req.body.sick || false,
        pregnant: req.body.pregnant || false,
        missing: req.body.missing || false,
        age: req.body.age || 2,
        sex: req.body.sex || false,
        weight: req.body.weight || 50,
        status: req.body.status || "Unknown",
        safeZoneId: req.body.safeZoneId || "Undefined",
        timestamp: req.body.timestamp || Date.now(),
    };
    const newCow = new CowModel(cowData);
    const savedCow = await newCow.save();
    return savedCow;
};

const getAllCows = async () => {
    const cows = await CowModel.find();
    return cows;
};
const getCowById = async (cowId) => {
    const cow = await CowModel.findById(cowId);
    return cow;
};

const getCowByUsername = async (username) => {
    const cows = await CowModel.find({
        username: username,
    });

    return cows;
};

const getCowByUsernameAndCowAddr = async (username, cow_addr) => {
    const cow = await CowModel.findOne({
        username: username,
        cow_addr: cow_addr,
    });
    return cow;
};

const deleteCowById = async (cowId) => {
    await CowModel.deleteOne({ _id: cowId });
};

const deleteCowByUsername = async (username) => {
    await CowModel.deleteMany({
        username: username,
    });
};

const updateCowById = async (cowId, cow) => {
    const updatedCow = await CowModel.findByIdAndUpdate(
        cowId,
        { $set: cow },
        { new: true }
    );
    return updatedCow;
};

const updateLatestLocationById = async (cowId, longitude, latitude) => {
    const updatedCow = await CowModel.findById(cowId);
    if (updatedCow) {
        updatedCow.latest_longitude = longitude;
        updatedCow.latest_latitude = latitude;
        updatedCow.timestamp = Date.now();

        await updatedCow.save();
        return updatedCow;
    } else {
        return undefined;
    }
};
const updateCowStatusById = async (cowId, new_status) => {
    const updatedCow = await CowModel.findById(cowId);
    if (updatedCow) {
        updatedCow.status = new_status;
        updatedCow.timestamp = Date.now();
        await updatedCow.save();
        return updatedCow;
    } else {
        return undefined;
    }
};
const updateCowAddressById = async (cowId, address) => {
  const updatedCow = await CowModel.findById(cowId);
  if (updatedCow) {
    updatedCow.address = address;
    await updatedCow.save();
    return updatedCow;
  } else {
    return undefined;
  }
};

export default {
    getAllCows,
    createCow,
    createCowx,
    getCowById,
    getCowByUsername,
    getCowByUsernameAndCowAddr,
    deleteCowById,
    deleteCowByUsername,
    updateCowById,
    updateLatestLocationById,
    updateCowAddressById,
    updateCowStatusById,
};
