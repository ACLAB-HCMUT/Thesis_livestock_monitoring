import mongoose from 'mongoose';
import { type } from 'os';
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
    groupId: {
        type: String,
        default: "Undefined", 
    },
    note: {
        type: String
    },
    timestamp: {
        type: Date
    },
    
});


const statusHistorySchema = new mongoose.Schema({
    cowId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Cow',
        required: true
    },
    status:{
        type: String
    },
    startTime: {
        type: Date,
        required: true,
        default: Date.now
    },
    endTime: {
        type: Date
    },
    duration: {
        type: Number, // Duration in seconds
    }
});

const statusAnalyticsSchema = new mongoose.Schema({
    cowId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Cow',
        required: true
    },
    date: {
        type: Date,
        required: true
    },
    eatingDuration: {
        type: Number, // Duration in seconds
        default: 0
    },
    walkingDuration: {
        type: Number, // Duration in seconds
        default: 0
    },
    idleDuration: {
        type: Number, // Duration in seconds
        default: 0
    }
});

cowSchema.pre('deleteOne', { document: true, query: false }, async function(next) {
    const cowId = this._id;
    try {
        await mongoose.model('StatusHistory').deleteMany({ cowId });
        await mongoose.model('StatusAnalytics').deleteMany({ cowId });
        next();
    } catch (err) {
        next(err);
    }
});

export const CowModel = mongoose.model('Cow', cowSchema);
export const StatusHistoryModel = mongoose.model('StatusHistory', statusHistorySchema);
export const StatusAnalyticsModel = mongoose.model('StatusAnalytics', statusAnalyticsSchema);
