import { CowModel } from "../models/cowModel.js";

const createCow = async (req) => {
    const newCow = new CowModel(req.body);
    const savedCow = newCow.save();
    return savedCow;
}

const getCowById = async (cowId) => {
    const cow = await CowModel.findById(cowId);
    return cow;
}

const getCowByUsername = async (username) => {
    const cows = await CowModel.find({
        username: username
    });

    return cows;
}

const getCowByUsernameAndCowAddr = async (username, cow_addr) => {
    const cow = await CowModel.findOne({
        username: username,
        cow_addr: cow_addr
    });
    return cow;
}

const deleteCowById = async (cowId) => {
    await CowModel.deleteOne({_id: cowId});
}

const deleteCowByUsername = async (username) => {
    await CowModel.deleteMany({
        username: username
    });
}

const updateCowById = async (cowId, cow) => {
    const updatedCow = await CowModel.findByIdAndUpdate(
        cowId, {$set: cow}, {new: true}
    );
    return updatedCow;
}

const updateLatestLocationById = async (cowId, longitude, latitude) => {
    const updatedCow = await CowModel.findById(cowId);
    if(updatedCow) {        
        updatedCow.latest_longitude = longitude;
        updatedCow.latest_latitude = latitude;
        updatedCow.timestamp = Date.now();

        await updatedCow.save();
        return updatedCow;
    }else{
        return undefined;
    }
}


export default {
    createCow,
    getCowById,
    getCowByUsername,
    getCowByUsernameAndCowAddr,
    deleteCowById,
    deleteCowByUsername,
    updateCowById,
    updateLatestLocationById,
}