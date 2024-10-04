import mongoose from 'mongoose';
const userSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true
  },
  password: {
    type: String,
    required: true,
  },
});

export const UserModel = mongoose.model('User', userSchema);