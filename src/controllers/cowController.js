import cowService from "../services/cowService.js";
import mqttService from "../services/mqttService.js";
import constants from "./constants.js";
import eventService from "../services/eventService.js";

const getCowByUsername = async (req, res) => {
  try {
    const username = req.params.username;
    const cows = await cowService.getCowByUsername(username);
    return res.status(200).json(cows);
  } catch (err) {
    return res.status(500).json(err);
  }
};

const getAllCows = async (req, res) => {
  try {
    const cows = await cowService.getAllCows(); // Fetch all cows using the service
    return res.status(200).json(cows); // Return the list of cows in JSON format
  } catch (err) {
    return res.status(500).json(err); // Return any errors that occur
  }
};

const getCowById = async (req, res) => {
  try {
    const cow_id = req.params.cow_id;
    const cow = await cowService.getCowById(cow_id);
    return res.status(200).json(cow);
  } catch (err) {
    return res.status(500).json(err);
  }
};

const postCow = async (req, res) => {
  try {
    const newCow = await cowService.createCow(req);
    return res.status(200).json(newCow);
  } catch (err) {
    return res.status(500).json(err);
  }
};
const postCowx = async (req, res) => {
  try {
    const username = req.params.username;
    const newCow = await cowService.createCowx(req);
    /* Notificate to gateway through mqtt */
    const message = `0${constants.HEADER_BACKEND_CREATE_COW}${newCow}`;
    mqttService.publish(username, message);

    let responded = false; // Flag to track if response was sent
    
    /* Set timeout to wait for gateway response ack */
    const timeout = setTimeout(() => {
      /* Response gateaway not response */
      if (!responded) {
        responded = true;
        return res.status(424).json(newCow);
      }
    }, 3000);

    eventService.mqttEvent.once(`0${constants.HEADER_ACK}${newCow["_id"]}`,
      () => {
        if (!responded) {
          clearTimeout(timeout);
          /* Response success */
          responded = true;
          return res.status(200).json(newCow);
        }
      }
    );
  } catch (err) {
    return res.status(500).json(err);
  }
};

const deleteCowById = async (req, res) => {
  try {
    const username = req.params.username;
    const cow_id = req.params.cow_id;

    await cowService.deleteCowById(cow_id);

    /* Notify to gateway through mqtt */
    const message = `0${constants.HEADER_BACKEND_DELETE_COW}${cow_id}`;
    mqttService.publish(username, message);

    let responded = false; // Flag to track if response was sent

    /* Set timeout to wait for gateway response ack */
    const timeout = setTimeout(() => {
      if (!responded) {
        responded = true; // Prevent further responses
        return res.status(424).json({ result: "Gateway not response" });
      }
    }, 3000);

    /* Listen for acknowledgment event */
    eventService.mqttEvent.once(`0${constants.HEADER_ACK}${cow_id}`, () => {
      if (!responded) {
        clearTimeout(timeout);
        responded = true; // Prevent further responses
        return res.status(200).json({ result: "Delete success" });
      }
    });
  } catch (err) {
    return res.status(500).json(err);
  }
};

const deleteCowByUsername = async (req, res) => {
  try {
    const username = req.params["username"];
    await cowService.deleteCowByUsername(username);
    return res.status(200).json({ message: "Delete success" });
  } catch (err) {
    return res.status(500).json(err);
  }
};

const updateLatestLocationById = async (req, res) => {
  try {
    const username = req.params.username;
    const cow_id = req.params.cow_id;
    const latest_latitude = req.body["latest_latitude"];
    const latest_longitude = req.body["latest_longitude"];
    if (latest_longitude || latest_latitude) {
      const updatedCow = await cowService.updateLatestLocationById(
        cow_id,
        latest_longitude,
        latest_latitude
      );
      return res.status(200).json(updatedCow);
    } else {
      const updatedCow = await cowService.updateCowById(cow_id, req.body);
      return res.status(200).json(updatedCow);
    }
  } catch (err) {
    return res.status(500).json(err);
  }
};
const updateCowById = async (req, res) => {
  try {
    const username = req.params.username;
    const cow_id = req.params.cow_id;

    const cowData = req.body;
    console.log(cow_id);
    console.log(cowData);
    // Call the updateCowById function with cowId and cowData
    const updatedCow = await cowService.updateCowById(cow_id, cowData);
    if (updatedCow) {
      // Return a success response with the updated cow data
      return res.status(200).json(updatedCow);
    } else {
      // If the cow with the given ID was not found, return a 404 response
      return res.status(404).json({ message: "Cow not found" });
    }
  } catch (error) {
    // Handle any errors that occurred during the update process
    console.error("Error updating cow:", error);
    return res.status(500).json({ message: "Failed to update cow", error });
  }
};
export default {
  getCowByUsername,
  getAllCows,
  getCowById,
  postCow,
  postCowx,
  deleteCowById,
  deleteCowByUsername,
  updateLatestLocationById,
  updateCowById,
};
