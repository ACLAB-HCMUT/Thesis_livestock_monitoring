import userService from "../services/userService.js"

const postUser = async (req, res) => {
    try{
        const newUser = await userService.createUser(req);
        return res.status(200).json(newUser);
    }catch(err){
        return res.status(500).json(err);
    }
}

const getUserByUsername = async (req, res) => {
    try{
        const username = req.header('username');
        const user = await userService.getUserByUsername(username);
        return res.status(200).json(user);
    }catch(err){
        return res.status(500).json(err);
    }
}

export default {
    postUser,
    getUserByUsername
}