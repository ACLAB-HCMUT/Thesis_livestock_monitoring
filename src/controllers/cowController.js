import cowService from "../services/cowService.js"

const getCowByUsername = async (req, res) => {
    try {
        const username = req.params.username;
        const cows = await cowService.getCowByUsername(username);
        return res.status(200).json(cows);
    }catch(err){
        return res.status(500).json(err);
    }
}

const getCowById = async (req, res) => {
    try {
        const cowId = req.params.cowId;
        const cow = await cowService.getCowById(cowId);
        return res.status(200).json(cow);
    }catch(err){
        return res.status(500).json(err);
    }
}

const postCow = async (req, res) => {
    try{
        const newCow = await cowService.createCow(req);
        return res.status(200).json(newCow);
    }catch(err){
        return res.status(500).json(err);
    }
}

const deleteCowById = async (req, res) => {
    try{
        const cowId = req.params.cowId;
        await cowService.deleteCowById(cowId);
        return res.status(200).json({message: "Delete success"});
    }catch(err){
        return res.status(500).json(err);
    }
}

const deleteCowByUsername = async (req, res) => {
    try{
        const username = req.params.username;
        await cowService.deleteCowByUsername(username);
        return res.status(200).json({message: "Delete success"});
    }catch(err){
        return res.status(500).json(err);
    }
}

const updateCowById = async (req, res) => {
    try{
        const cowId = req.params.cowId;
        const updatedCow = await cowService.updateCowById(cowId, req.body);
        return res.status(200).json(updatedCow);
    }catch(err){
        return res.status(500).json(err);
    }
}

export default {
    getCowByUsername,
    getCowById,
    postCow,
    deleteCowById,
    deleteCowByUsername,
    updateCowById,
}