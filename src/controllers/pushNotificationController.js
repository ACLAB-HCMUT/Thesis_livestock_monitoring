var admin = require("firebase-admin");
var fcm = require("fcm-notification");

var serviceAccount = require("../config/push-notification-key.json");
const certPath = admin.credential.cert(serviceAccount);
var FCM = new fcm(certPath);
exports.sendPushNotification = (req, res, next) => {
  try {
    let message = {
      notification:{
        title: "Test Notification",
        body: "Notification message"
      },
      data:{
        orderId: 123456,
        orderDate: "2024-11-5",
      },
      token: req.body.fcm_token,
    }
    FCM.send(message,function(err, resp){
      if(err){
        return res.status(500).send({
          message: err
        })
      }else{
        return res.status(200).send({
          message : "Notification send"
        })  
      }
    })
  } catch (error) {
    
  }
}