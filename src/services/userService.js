import { CowModel } from "../models/cowModel.js";
import { DeviceModel } from "../models/deviceModel.js";
import { SaveZone } from "../models/saveZoneModel.js";
import { UserModel } from "../models/userModel.js";
const createUser = async (req) => {
  const newUser = new UserModel(req.body);
  const savedUser = await newUser.save();

  return savedUser;
};

const getUserByUsername = async (username) => {
  const user = await UserModel.findOne({
    username: username,
  });
  return user;
};
const getAllUser = async () => {
  const users = await UserModel.find();
  return users;
};

const updateByUsername = async (username, updateData) => {
  try {
    const updatedUser = await UserModel.findOneAndUpdate(
      { username: username },
      updateData,
      { new: true, runValidators: true }
    );

    if (!updatedUser) {
      throw new Error(`User with username "${username}" not found.`);
    }

    return updatedUser;
  } catch (err) {
    console.error("Error updating user:", err);
    throw err;
  }
};
const deleteUserById = async (userId) => {
  const user = await UserModel.findById(userId);
  if (user) {
    const username = user.username;

    // Delete the user
    await user.deleteOne();

    // Delete related documents by username
    await Promise.all([
      DeviceModel.deleteMany({ username }),
      CowModel.deleteMany({ username }),
      SaveZone.deleteMany({ username })
    ]);
    console.log(`Deleted user ${username} and related data.`);
  }else{
    console.log("User not found");
  }
}

export const incrementGlobalAddress = async (username) => {
  try {
    const updatedUser = await UserModel.findOneAndUpdate(
      { username: username },
      { $inc: { global_address: 1 } },
      { new: true }
    );
    if (!updatedUser) {
      throw new Error(`User with username "${username}" not found.`);
    }
    return updatedUser;
  } catch (err) {
    console.error("Error updating global address:", err);
    throw err;
  }
};

export default {
  createUser: createUser,
  getUserByUsername: getUserByUsername,
  updateByUsername,
  incrementGlobalAddress,
  getAllUser,
  deleteUserById
};
