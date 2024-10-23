import cowLocationService from "../services/cowLocationService.js";

const postCowLocation = async (req, res) => {
    try {
        const username = req.body.username;
        const cow_addr = req.body.cow_addr;
        const latitude = req.body.latitude;
        const longitude = req.body.longitude;
        const timestamp = req.body.timestamp;
        const newCowLocation = 
            await cowLocationService.createCowLocation(cow_addr, username, latitude, longitude, timestamp);
        return res.status(200).json(newCowLocation);
    }catch(err){
        return res.status(500).json(err);
    }
}

const getCowLocationsByUsername = async (req, res) => {
    try{
        const username = req.header('username');
        const cowLocations = await cowLocationService.getCowLocationsByUsername(username);
        return res.status(200).json(cowLocations);
    }catch(err){
        return res.status(500).json(err);
    }
}
const getCowLocationsByUsernameAndCowAddr = async (req, res) => {
    try{
        const username = req.header('username');
        const cow_addr = req.header('cow_addr');

        const cowLocations = 
            await cowLocationService.getCowLocationsByUsernameAndCowAddr(username, cow_addr);

        return res.status(200).json(cowLocations);
    }catch(err){
        return res.status(500).json(err);
    }
}

const getCowLocationsInDate = async (req, res) => {
    try {
        const username = req.header('username');
        const cow_addr = req.header('cow_addr');
        const start_date = req.header('start_date');
        const end_date = req.header('end_date');

        const cowLocationInDate = 
            await cowLocationService.getCowLocationInDate(username, cow_addr, start_date, end_date);
        return res.status(200).json(cowLocationInDate);
    }catch(err){
        return res.status(500).json(err);
    }
}


const deleteCowLocationsByUsernameAndCowAddr = async (req, res) => {
    try {
        const username = req.header('username');
        const cow_addr = req.header('cow_addr');
        await cowLocationService.deleteCowLocationsByUsernameAndCowAddr(username, cow_addr);
        return res.status(200).json({"message": "Delete success"});
    }catch(err){
        return res.status(500).json(err);
    }
}

const deleteCowLocationsByUsername = async (req, res) => {
    try {
        const username = req.header('username');
        await cowLocationService.deleteCowLocationsByUsername(username);
        return res.status(200).json({"message": "Delete success"});
    }catch(err){
        return res.status(500).json(err);
    }
}







export default {
    postCowLocation,

    getCowLocationsByUsername,
    getCowLocationsByUsernameAndCowAddr,
    getCowLocationsInDate,

    deleteCowLocationsByUsernameAndCowAddr,
    deleteCowLocationsByUsername,

}