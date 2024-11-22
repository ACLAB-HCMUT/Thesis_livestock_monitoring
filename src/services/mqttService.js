import mqttClient from '../controllers/mqttController.js';

const publish = (topic, message) => {
    mqttClient.publish(topic, message);
}

export default {
    publish,
}