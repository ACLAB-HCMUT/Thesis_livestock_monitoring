import { Point } from '@influxdata/influxdb-client'
import { cowQueryApi, cowWriteApi } from "../controllers/influxdbController.js";
import dotenv from 'dotenv';
import axios from 'axios';

dotenv.config();


const measurement = "cow_location";

/**
 * 
 * @param {number} cow_addr address of lora which is assigned on cow
 * @param {string} username username of user
 * @param {float} latitude location latitude
 * @param {float} longitude location longitude
 */
const createCowLocation = async (cow_addr, username, latitude, longitude) => {
    const point = new Point(measurement)
        .tag('cow_addr', cow_addr)
        .tag('username', username)
        .floatField('latitude', latitude)
        .floatField('longitude', longitude);

    cowWriteApi.writePoint(point);
    await cowWriteApi.flush();
    return {
        "cow_addr": cow_addr,
        "username": username,
        "latitude": latitude,
        "longitude": longitude
    };
}

/**
 * This function get latetest location of cow
 * @param {string} username Username of user
 * @param {number} cow_addr Address of lora node which is assigned in the cow
 * @returns {object} {latitude, longitude}
 */
const getLatestCowLocation = async (username, cow_addr) => {
    const fluxQuery = 
        `from(bucket:"${bucket}") 
            |> range(start: -24h) 
            |> filter(fn: (r) => r._measurement == "${measurement}")
            |> filter(fn: (r) => r.username == "${username}")
            |> filter(fn: (r) => r.cow_addr == "${cow_addr}")
            |> sort(columns: ["_time"], desc: true)
            |> limit(n: 1)`;

    const result = {};
    for await (const {values, tableMeta} of cowQueryApi.iterateRows(fluxQuery)) {
        const o = tableMeta.toObject(values)
        result[o._field] = o._value;
    }
    return result;
}

/**
 * 
 * @param {string} username 
 * @param {number} cow_addr 
 * @param {string} date mm-dd-yyyy
 * @returns 
 */
const getCowLocationInDate = async (username, cow_addr, date) => {
    /* Convert `date` parameter into object Date */
    const startOfDay = new Date(date);
    startOfDay.setHours(0, 0, 0, 0); /* Convert time to 0 */
    
    const endOfDay = new Date(date);
    endOfDay.setHours(23, 59, 59, 999);

    const startTimeISO = startOfDay.toISOString();
    const endTimeISO = endOfDay.toISOString();

    const fluxQuery = 
        `from(bucket:"${bucket}") 
            |> range(start: ${startTimeISO}, stop: ${endTimeISO}) 
            |> filter(fn: (r) => r._measurement == "${measurement}")
            |> filter(fn: (r) => r.username == "${username}")
            |> filter(fn: (r) => r.cow_addr == "${cow_addr}")
            `;

    const result = {};
    for await (const {values, tableMeta} of cowQueryApi.iterateRows(fluxQuery)) {
        const o = tableMeta.toObject(values)
        
        const timestamp = new Date(o._time).getTime();
        if(result[timestamp] == undefined){
            result[timestamp] = {'longitude': 0, 'latitude': 0};
        }
        result[timestamp][o._field] = o._value;
    }
    return result;

}

const deleteCowLocationByUsernameCowAddr = async (username, cow_addr) => {
    const url = 'http://localhost:8086/api/v2/delete';
    const org = "do_an"
    const bucket = "cow"

    const startTime = '1970-01-01T00:00:00Z';
    const stopTime = new Date().toISOString();
    const predicate = `_measurement="${measurement}" AND username="${username}" AND cow_addr="${cow_addr}"`;
    
    axios({
        method: 'post',
        url: url,
        params: {
            "org": org,
            "bucket": bucket,
        },
        headers: {
            'Authorization': `Token ${process.env.INFLUX_DB_TOKEN}`,
            'Content-Type': 'application/json'
        },
        data: {
            "start": startTime,
            "stop": stopTime,
            "predicate": predicate
        }
    }).then((res) => {
        return res.data;
    }).catch((error) => {
        console.error('Error deleting data:', error.response ? error.response.data : error.message);
        return error;
    })
}

const deleteCowLocationByUsername = async (username) => {
    const url = 'http://localhost:8086/api/v2/delete';
    const org = "do_an"
    const bucket = "cow"
    
    const startTime = '1970-01-01T00:00:00Z';
    const stopTime = new Date().toISOString();
    const predicate = `_measurement="${measurement}" AND username="${username}"`;
    
    axios({
        method: 'post',
        url: url,
        params: {
            "org": org,
            "bucket": bucket,
        },
        headers: {
            'Authorization': `Token ${process.env.INFLUX_DB_TOKEN}`,
            'Content-Type': 'application/json'
        },
        data: {
            "start": startTime,
            "stop": stopTime,
            "predicate": predicate
        }
    }).then((res) => {
        return res.data;
    }).catch((error) => {
        console.error('Error deleting data:', error.response ? error.response.data : error.message);
        return error;
    })
}


export default {
    createCowLocation,

    getLatestCowLocation,
    getCowLocationInDate,

    deleteCowLocationByUsernameCowAddr,
    deleteCowLocationByUsername,
}