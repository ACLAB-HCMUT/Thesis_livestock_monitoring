import userService from "../services/userService.js";

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

    if (updatedUser) {
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

export default {
  postUser,
  getUserByUsername,
  updateByUsername,
  getAndIncrementGlobalAddress
};
