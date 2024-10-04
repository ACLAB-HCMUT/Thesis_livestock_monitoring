import { Point } from '@influxdata/influxdb-client'
import { cowQueryApi, cowWriteApi } from "../controllers/influxdbController.js";


const measurement = "cow_state";

/**
 * 
 * @param {number} cow_addr address of lora which is assigned on cow
 * @param {string} username username of user
 * @param {number} state state of cow
 */
const createCowState = async (cow_addr, username, state) => {
    const point = new Point(measurement)
        .tag('cow_addr', cow_addr)
        .tag('username', username)
        .intField('state', state)

    cowWriteApi.writePoint(point)
    await cowWriteApi.flush();
}

/**
 * This function get latetest location of cow
 * @param {string} username Username of user
 * @param {number} cow_addr Address of lora node which is assigned in the cow
 * @returns {string} state of cow
 */
const getLatestCowState = async (username, cow_addr) => {
    const fluxQuery = 
        `from(bucket:"${bucket}") 
            |> range(start: -1h) 
            |> filter(fn: (r) => r._measurement == "${measurement}")
            |> filter(fn: (r) => r.username == "${username}")
            |> filter(fn: (r) => r.cow_addr == "${cow_addr}")
            |> sort(columns: ["_time"], desc: true)
            |> limit(n: 1)`;

    for await (const {values, tableMeta} of cowQueryApi.iterateRows(fluxQuery)) {
        const o = tableMeta.toObject(values)
        return o._value;
    }
    return undefined;
}

export default {
    createCowState,
    getLatestCowState
}