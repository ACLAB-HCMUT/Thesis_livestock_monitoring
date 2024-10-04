import { InfluxDB } from '@influxdata/influxdb-client'
import dotenv from 'dotenv';

dotenv.config();

/** Environment variables **/
const url = process.env.INFLUX_DB_URL
const token = process.env.INFLUX_DB_TOKEN

const influxDB = new InfluxDB({ url, token });

const org = "do_an"
const bucket = "cow"

export const cowWriteApi = influxDB.getWriteApi(org, bucket);
export const cowQueryApi = influxDB.getQueryApi(org);

