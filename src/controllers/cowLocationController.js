import cowLocationService from "../services/cowLocationService.js";

const postCowLocation = async (req, res) => {
    try {
        const cow_id = req.body['cow_id'];
        const longitude = req.body['longitude'];
        const latitude = req.body['latitude'];
        const new_cow_location = 
            await cowLocationService.createCowLocation(cow_id, longitude, latitude);
        return res.status(200).json(new_cow_location);
    }catch(err){
        return res.status(500).json(err);
    }
}


const getCowLocationsByCowId = async (req, res) => {
    try {
        const cow_id = req.params['cow_id'];

        const cow_locations = 
            await cowLocationService.getCowLocationsByCowId(cow_id);
        return res.status(200).json(cow_locations);
    }catch(err){
        return res.status(500).json(err);
    }
}

const getCowLocationsByDate = async (req, res) => {
    try {
        const cow_id = req.params['cow_id'];
        const start_date = req.params['start_date'];
        const end_date = req.params['end_date'];
        const cow_locations = 
            await cowLocationService.getCowLocationsByDate(cow_id, start_date, end_date);
        return res.status(200).json(cow_locations);
    }catch(err){
        return res.status(500).json(err);
    }
}

const deleteCowLocationById = async (req, res) => {
    try{
        const cow_location_id = req.params['cow_location_id'];

        await cowLocationService.deleteCowLocationById(cow_location_id);
        return res.status(200).json({"message": "Delete success"});
    }catch(err){
        return res.status(500).json(err);
    }
}

const deleteCowLocationsByCowId = async (req, res) => {
    try{
        const cow_id = req.params['cow_id'];
        await cowLocationService.deleteCowLocationsByCowId(cow_id);
        return res.status(200).json({"message": "Delete success"});
    }catch(err){
        return res.status(500).json(err);
    }
}

export default {
    postCowLocation,

    getCowLocationsByCowId,
    getCowLocationsByDate,

    deleteCowLocationsByCowId,
    deleteCowLocationById,

}