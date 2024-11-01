import mongoose from 'mongoose';
const cowLocationSchema = new mongoose.Schema({
    cow_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Cow",
        require: true,
    },
    longitude: {
        type: Number,
        require: true,
    },
    latitude: {
        type: Number,
        require: true,
    },
    timestamp: {
        type: Date,
        default: Date.now,
    }
});

export const CowLocationModel = mongoose.model('CowLocation', cowLocationSchema);
