import mongoose from "mongoose";
import WebSocket from 'ws';
import admin from "firebase-admin";
import fcm from "fcm-notification";
import serviceAccount from "../config/push-notification-key.json" assert { type: "json" };
import { CowModel } from "../models/cowModel.js";
import { SaveZone } from "../models/saveZoneModel.js";

const certPath = admin.credential.cert(serviceAccount);
const FCM = new fcm(certPath);  

async function pointInSafeZone(point) {
  const safeZones = await SaveZone.find();
  for (let safeZone of safeZones) {
    if (isPointInPolygon(point, safeZone.safeZone)) {
      return true;
    }
  }
  return false;
}

function isPointInPolygon(point, polygon) {
  const { latitude: x, longitude: y } = point;
  let windingNumber = 0;

  for (let i = 0; i < polygon.length; i++) {
    const { latitude: x1, longitude: y1 } = polygon[i];
    const { latitude: x2, longitude: y2 } = polygon[(i + 1) % polygon.length];

    if (y1 <= y) {
      if (y2 > y && isLeft(x1, y1, x2, y2, x, y) > 0) {
        windingNumber++;
      }
    } else {
      if (y2 <= y && isLeft(x1, y1, x2, y2, x, y) < 0) {
        windingNumber--;
      }
    }
  }

  return windingNumber !== 0;
}

function isLeft(x1, y1, x2, y2, x, y) {
  return (x2 - x1) * (y - y1) - (x - x1) * (y2 - y1);
}

async function sendPushNotification(change) {
  if(change.operationType === "delete" || change.operationType === "insert" ){
    return;
  } 
  const { updatedFields } = change.updateDescription;
  if (updatedFields.latest_latitude || updatedFields.latest_longitude) {
    const cow = await CowModel.findById(change.documentKey._id.toString());
    const newLocation = {
      latitude: cow.latest_latitude,
      longitude: cow.latest_longitude
    };
    const checkLocation = await pointInSafeZone(newLocation);
    if (!checkLocation && !cow.missing) {
      cow.missing = true;
      await CowModel.findByIdAndUpdate(
        change.documentKey._id.toString(), { $set: cow }, { new: true }
      );
      const message = {
        notification: {
          title: "Cattle Out of Safe Zone",
          body: `Cow with ID ${change.documentKey._id.toString()} has exited the safe zone!`
        },
        data: {
          type: change.operationType,
          cowId: change.documentKey._id.toString(),
          timestamp: new Date().toISOString()
        },
        token: "c0qLFnbHRUWkScleszQcKO:APA91bEE3kQyYQjnrfj7PtiAq4yGnsnxw-ovx2RKVnYZrlebA_ki_157MfHTBRde8fw455dh2oiWCPPRNqX0SseYg_HSqj3dJwvL-keFQFVJahnq34MUy7I"
      };

      FCM.send(message, function (err, resp) {
        if (err) {
          console.error("Error sending notification:", err);
        } else {
          console.log("Notification sent successfully:", resp);
        }
      });
    } else if (checkLocation && cow.missing) {
      cow.missing = false;
      await CowModel.findByIdAndUpdate(
        change.documentKey._id.toString(), { $set: cow }, { new: true }
      );
    }
  }
}

export function initCowChangeStream(server) {
  const wss = new WebSocket.Server({ server });
  const cowCollection = mongoose.connection.collection('cows');
  const changeStream = cowCollection.watch();

  changeStream.on("change", (change) => {
    console.log("Cow Collection changed:", change);
    sendPushNotification(change);

    wss.clients.forEach(client => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(JSON.stringify(change));
      }
    });
  });

  changeStream.on("error", (err) => {
    console.error("Error in change stream:", err);
  });
}
