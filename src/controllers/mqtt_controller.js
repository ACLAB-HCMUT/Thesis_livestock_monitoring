import mqtt from "mqtt";
import { createCowLocation } from "../services/cowLocationService.js";
import { createCowState } from "../services/cowStateService.js";

const handle_mqtt_msg = async (topic, msg) => {
    let json_obj = JSON.parse(msg);
    let opcode = json_obj.opcode;
    let cow_addr;
    switch(opcode){
        case 0:
            /* Cow location */
            cow_addr = json_obj.address;
            let longitude = json_obj.longitude;
            let latitude = json_obj.latitude;

            await createCowLocation(cow_addr, topic, latitude, longitude);
            break;
        case 1:
            /* Cow state */
            cow_addr = json_obj.address;
            state = json_obj.state;

            await createCowState(cow_addr, topic, state);
            break;
        default:
            console.log("Opcode invalid");
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

            handle_mqtt_msg(topic, message);
            // console.log(`Received message from ${topic}: ${message}`);
            // let json_obj = JSON.parse(message);
            // console.log(json_obj);
            
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

export const mqttClient = new MQTTClient(MQTT_USERNAME, MQTT_PASSWORD, MQTT_BROKER_URL);

