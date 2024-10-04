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



export default {
    createCow,
    getCowById,
    getCowByUsername,
    deleteCowById,
    deleteCowByUsername,
    updateCowById,
}