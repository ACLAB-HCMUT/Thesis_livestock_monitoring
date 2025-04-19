import mongoose from 'mongoose';

const deviceSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true
    },
    address: {
        type: Number,
        required: true
    },
    cow_id: {
        type: String,
    },
    device_name: {
        type: String,
    }
});
deviceSchema.index({ username: 1, address: 1 }, { unique: true });
export const DeviceModel = mongoose.model('Device', deviceSchema);