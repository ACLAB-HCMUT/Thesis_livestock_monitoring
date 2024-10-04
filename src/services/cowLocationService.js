import { Point } from '@influxdata/influxdb-client'
import { cowQueryApi, cowWriteApi } from "../controllers/influxdb_controller.js";

const measurement = "cow_location";

/**
 * 
 * @param {number} cow_addr address of lora which is assigned on cow
 * @param {string} username username of user
 * @param {float} latitude location latitude
 * @param {float} longitude location longitude
 */
export const createCowLocation = async (cow_addr, username, latitude, longitude) => {
    const point = new Point(measurement)
        .tag('cow_addr', cow_addr)
        .tag('username', username)
        .floatField('latitude', latitude)
        .floatField('longitude', longitude);

    cowWriteApi.writePoint(point);
    await cowWriteApi.flush();
}

/**
 * This function get latetest location of cow
 * @param {string} username Username of user
 * @param {number} cow_addr Address of lora node which is assigned in the cow
 * @returns {object} {latitude, longitude}
 */
export const getLatestCowLocation = async (username, cow_addr) => {
    const fluxQuery = 
        `from(bucket:"${bucket}") 
            |> range(start: -1h) 
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