import { UserModel } from "../models/userModel.js";
import cowService from "../services/cowService.js";
import userService from "../services/userService.js";


const loginUser = async (req, res) =>{
  try{
    const username = req.body.username;
    const password = req.body.password;
    const user = await userService.getUserByUsername(username);
    if(user.password == password){
      return res.status(200).json(user)
    }else{
      return res.status(401).json({
        message : "Login failed"
      })
    }
  }catch(err){
    return res.status(500).json({
      error: "Internal Server Error",
      details: err.message,
    }); 
  }
}
const registerUser = async (req, res) =>{
  try {
    const { username } = req.body;
    const exitingUser = await userService.getUserByUsername(username);
    if(exitingUser){
      return res.status(400).json({messgae: "User already exists"})
    }
    const newUser = new UserModel(req.body)
    await newUser.save();
    res.status(201).json(newUser);

  } catch (err) {
    return res.status(500).json({
      error: "Internal Server Error",
      details: err.message
    })
  }
}



const postUser = async (req, res) => {
  try {
    const newUser = await userService.createUser(req);
    return res.status(200).json(newUser);
  } catch (err) {
    return res.status(500).json(err);
  }
};

const getUserByUsername = async (req, res) => {
  try {
    const username = req.params.username;
    const user = await userService.getUserByUsername(username);
    return res.status(200).json(user);
  } catch (err) {
    return res.status(500).json(err);
  }
};
export const getAllUser = async (req, res) => {
  try {
    const users = await userService.getAllUser();
    if (users) {
      return res.status(200).json(users);
    } else {
      return res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    console.error("Error retrieving user:", error);
    return res.status(500).json({ message: "Failed to retrieve user", error });
  }
};

const updateByUsername = async (req, res) => {
  try {
    const username = req.body.username;
    const userData = req.body;
    const updatedUser = await userService.updateByUsername(username, userData);
    if (updatedUser) {
      return res.status(200).json(updatedUser);
    } else {
      return res.status(404).json({ message: "User not found" });
    }
  } catch (err) {
    console.log(err);
    return res.status(500).json(err);
  }
};


export const getAndIncrementGlobalAddress = async (req, res) => {
  try {
    const username = req.params.username;
    const updatedUser = await userService.incrementGlobalAddress(username);
    const updatedCow = await cowService.updateCowAddressById(req.body.cowId, updatedUser.global_address - 1);
    if (updatedUser && updatedCow) {
      return res.status(200).json({
        global_address: updatedUser.global_address - 1,
      });
    } else {
      return res.status(404).json({ message: "User not found" });
    }
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      error: "Internal Server Error",
      details: err.message,
    });
  }
};
const deleteUserById = async (req, res) => {
  try {
    const userId = req.body.userId;
    await userService.deleteUserById(userId);
    return res.status(200).json({ result: "Delete success" });
  } catch (err) {
    return res.status(500).json(err);
  }
}
export default {
  registerUser,
  loginUser,
  postUser,
  getUserByUsername,
  updateByUsername,
  getAndIncrementGlobalAddress,
  getAllUser,
  deleteUserById
};
