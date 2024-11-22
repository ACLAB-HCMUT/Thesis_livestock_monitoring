import express from "express";
import bodyParser from "body-parser";
import dotenv from 'dotenv';
import mongoose from 'mongoose';
import cors from 'cors';

import { mqttClient } from "./src/controllers/mqttController.js";
import userRouter from "./src/routes/userRouter.js";
import cowRouter from "./src/routes/cowRouter.js";
import cowLocationRouter from "./src/routes/cowLocationRouter.js";
import saveZoneRouter from "./src/routes/safeZoneRouter.js"; 
import { initCowChangeStream } from "./src/services/cowRouterx.js";
import { createServer } from 'http';

dotenv.config();

const app = express();
app.use(cors());

const server = createServer(app);

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }))

app.use("/user", userRouter);
app.use("/cow", cowRouter);
app.use("/cow_location", cowLocationRouter);
app.use("/safezones", saveZoneRouter);

mongoose.connect(process.env.MONGO_DB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => {
    console.log('Connected to MongoDB');
    const port = process.env.SERVER_PORT || 3000;
    server.listen(port, () => {
      console.log(`Server running at: http://localhost:${port}`);
    });
    
    // Khởi động change stream và WebSocket server
    initCowChangeStream(server);

  })
  .catch((err) => {
    console.error('Failed to connect to MongoDB', err);
    process.exit(1);
  });
