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
  incrementGlobalAddress
};
