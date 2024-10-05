import cowLocationService from "../services/cowLocationService.js";

const postCowLocation = async (req, res) => {
    try {
        const username = req.body.username;
        const cow_addr = req.body.cow_addr;
        const latitude = req.body.latitude;
        const longitude = req.body.longitude;
        const newCowLocation = 
            await cowLocationService.createCowLocation(cow_addr, username, latitude, longitude);
        return res.status(200).json(newCowLocation);
    }catch(err){
        return res.status(500).json(err);
    }
}

const getLatestCowLocation = async (req, res) => {
    try {
        const username = req.header('username');
        const cow_addr = req.header('cow_addr');
        const latestCowLocation = 
            await cowLocationService.getLatestCowLocation(username, cow_addr);
        return res.status(200).json(latestCowLocation);
    }catch(err){
        return res.status(500).json(err);
    }
}

const getCowLocationInDate = async (req, res) => {
    try {
        const username = req.header('username');
        const cow_addr = req.header('cow_addr');
        const date = req.header('date');

        const cowLocationInDate = 
            await cowLocationService.getCowLocationInDate(username, cow_addr, date);
        return res.status(200).json(cowLocationInDate);
    }catch(err){
        return res.status(500).json(err);
    }
}

const deleteCowLocationByUsernameCowAddr = async (req, res) => {
    try {
        const username = req.header('username');
        const cow_addr = req.header('cow_addr');
        await cowLocationService.deleteCowLocationByUsernameCowAddr(username, cow_addr);
        return res.status(200).json({"message": "Delete success"});
    }catch(err){
        return res.status(500).json(err);
    }
}

const deleteCowLocationByUsername = async (req, res) => {
    try {
        const username = req.header('username');
        await cowLocationService.deleteCowLocationByUsername(username);
        return res.status(200).json({"message": "Delete success"});
    }catch(err){
        return res.status(500).json(err);
    }
}







export default {
    postCowLocation,

    getLatestCowLocation,
    getCowLocationInDate,

    deleteCowLocationByUsernameCowAddr,
    deleteCowLocationByUsername,

}