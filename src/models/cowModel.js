import mongoose from 'mongoose';
const cowSchema = new mongoose.Schema({
    lora_address: {
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
