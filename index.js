import express from "express";
import bodyParser from "body-parser";
import dotenv from 'dotenv';
import mongoose from 'mongoose';

import { mqttClient } from "./src/controllers/mqttController.js";
import userRouter from "./src/routes/userRouter.js";
import cowRouter from "./src/routes/cowRouter.js";
import cowLocationRouter from "./src/routes/cowLocationRouter.js";

dotenv.config();

const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }))

app.use("/user", userRouter);
app.use("/cow", cowRouter);
app.use("/cow_location", cowLocationRouter);

mongoose.connect(
  process.env.MONGO_DB_URI)
  .then(() => {
    console.log('Connected to mongodb');
    let port = process.env.SERVER_PORT;
    app.listen(port, () => {
      console.log(`Server running at: http://localhost:${port}`);
    });
  })
  .catch((err) => console.log(err))
