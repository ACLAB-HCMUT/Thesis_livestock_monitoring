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
    }
});

export const CowModel = mongoose.model('Cow', cowSchema);
