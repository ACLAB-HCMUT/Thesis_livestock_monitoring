import { CowLocationModel } from "../models/cowLocationModel.js";

const createCowLocation = async (cow_id, longitude, latitude) => {
    const new_cow_location = new CowLocationModel({"cow_id": cow_id, "longitude": longitude, "latitude": latitude});
    const saved_cow_location = new_cow_location.save();
    return saved_cow_location;
}

const getCowLocationsByCowId = async (cow_id) => {
    const cow_locations = await CowLocationModel.find({
        cow_id: cow_id
    });
    return cow_locations;
}

const getCowLocationsByDate = async (cow_id, start_date, end_date) => {
    const start_date_utc = new Date(start_date);
    const end_date_utc = new Date(end_date);
    end_date_utc.setUTCHours(23, 59, 59, 999);
    const cow_locations = await CowLocationModel.find({
        cow_id: cow_id,
        timestamp: {
            $gte: start_date_utc,
            $lte: end_date_utc
        }
    })
    return cow_locations
}

const deleteCowLocationById = async (cowLocationId) => {
    await CowLocationModel.findByIdAndDelete(cowLocationId);
}

const deleteCowLocationsByCowId = async (cow_id) => {
    await CowLocationModel.deleteMany({
        cow_id: cow_id
    })
}


export default {
    createCowLocation,

    getCowLocationsByCowId,
    getCowLocationsByDate,
    
    deleteCowLocationById,
    deleteCowLocationsByCowId,
}