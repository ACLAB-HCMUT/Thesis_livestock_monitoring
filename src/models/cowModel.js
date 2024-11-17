import mongoose from 'mongoose';
const cowSchema = new mongoose.Schema({
    cow_addr: {
        type: Number,
    },
    name: {
        type: String,
        required: true
    },
    username: {
        type: String, 
        required: true
    },
    latest_longitude: {
        type: Number
    },
    latest_latitude: {
        type: Number
    },
    medicated:{
        type: Boolean
    },
    sick: {
        type: Boolean,
    },
    pregnant: {
        type: Boolean
    },
    missing: {
        type: Boolean 
    },
    age:{
        type: Number
    },
    sex:{
        type: Boolean
    },
    weight:{
        type: Number
    },
    status:{
        type: String
    },
    safeZoneId: {
        type: String,
        default: "Undefined", 
    },
    timestamp: {
        type: Date
    },
    
});
export const CowModel = mongoose.model('Cow', cowSchema);