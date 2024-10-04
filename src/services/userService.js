import { UserModel } from "../models/userModel.js";

const createUser = async (req) => {
    const newUser = new UserModel(req.body);
    const savedUser = await newUser.save();

    return savedUser;
}

const getUserByUsername = async (username) => {
    const user = await UserModel.findOne({
        username: username
    });

    return user;
}

export default {
    createUser: createUser,
    getUserByUsername: getUserByUsername
}