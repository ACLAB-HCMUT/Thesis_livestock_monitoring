import mqtt from "mqtt";
import cowLocationService from "../services/cowLocationService.js";
import cowService from "../services/cowService.js";
import eventService from '../services/eventService.js';
import constants from "./constants.js";
import safeZoneService from "../services/safeZoneService.js";
import mqttService from "../services/mqttService.js";

const handle_mqtt_msg = async (topic, msg) => {
    let data, split_data, cow_id;
    let username, response_msg;
    const header = parseInt(msg.slice(0,2));
    switch(header){
        case constants.HEADER_GATEWAY_REQUEST_GET_COWS:
            /* Call service get all cows by username */
            username = topic;
            let cows = await cowService.getCowByUsername(username);
            /* Send response back to gateway */
            response_msg = "0" + constants.HEADER_BACKEND_RESPONSE_GET_COWS + JSON.stringify(cows);
            mqttService.publish(topic, response_msg);
            break;
        case constants.HEADER_GATEWAY_SEND_COW_STATUS:
            /* Call service update cow status */
            console.log("HEADER_GATEWAY_SEND_COW_STATUS");
            data = msg.slice(2);
            split_data = data.split(':');
            cow_id = split_data[0];
            let cow_status = split_data[1];
            await cowService.updateCowStatusById(cow_id, cow_status);
            break;
        case constants.HEADER_GATEWAY_SEND_GPS:
            console.log("HEADER_GATEWAY_SEND_GPS");
            data = msg.slice(2);
            split_data = data.split(':');
            cow_id = split_data[0];
            let longitude = parseFloat(split_data[1]);
            let latitude = parseFloat(split_data[2]);
            
            /* Call service update latest gps */
            await cowService.updateLatestLocationById(cow_id, longitude, latitude);
            /* Call service create new gps */
            await cowLocationService.createCowLocation(cow_id, longitude, latitude);

            if(split_data.length == 4) {
                /* Cow out of safe area */
                /* Publish notification to user */

            }
            break;
        case constants.HEADER_GATEWAY_REQUEST_SAFE_ZONES:
            /* Call service to get safe zones by username */
            username = topic;
            const safeZone = await safeZoneService.getSafeZoneByUsername(username);
            /* Send response back to gateway */
            response_msg = "0" + constants.HEADER_BACKEND_RESPONSE_SAFE_ZONES + JSON.stringify(safeZone);
            mqttService.publish(topic, response_msg);
            break;
        case constants.HEADER_GATEWAY_ACK:
            /* Emit event */
            eventService.mqttEvent.emit(`${msg}`, "");
            break;

        default:
            console.log("Header invalid: ", header);
            break;
    }
}
class MQTTClient {
    constructor(username, password, brokerUrl) {
        console.log('init MQTT');
        this.client = mqtt.connect(brokerUrl, {
            username: username,
            password: password,
        });
    
        this.client.on('connect', () => {
            console.log('Connected to MQTT Broker');
            //subscribe to topic
            this.client.subscribe(`${username}/feeds/+`, (err) => {
                if (err) {
                    console.log(err);
                }
            })
        });
    
        this.client.on('message', async (topic, message) => {
            topic = topic.split("/")[2]
            if(topic == "V1" || topic == "V2"){
                return;
            }   
            
            message = message.toString();
            // console.log(`Received message from ${topic}: ${message}`);
            handle_mqtt_msg(topic, message);
        });
    
        this.client.on('close', () => {
            console.log('Connection to MQTT Broker closed');
        });
    }   
    publish(topic, message) {
        if (!this.client || !this.client.connected) {
          console.error("Client is not initialized or not connected.");
          return;
        }
        // console.log("Publishing to mqtt");
        this.client.publish(`nguyentruongthan/feeds/${topic}`, message);
    }
}
const MQTT_USERNAME = "nguyentruongthan";
const MQTT_PASSWORD = "";
const MQTT_BROKER_URL = "mqtt://mqtt.ohstem.vn";


const mqttClient = new MQTTClient(MQTT_USERNAME, MQTT_PASSWORD, MQTT_BROKER_URL);
export default mqttClient;
