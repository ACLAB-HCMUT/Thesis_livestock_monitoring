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
    timestamp: {
        type: Date
    }
});

export const CowModel = mongoose.model('Cow', cowSchema);
