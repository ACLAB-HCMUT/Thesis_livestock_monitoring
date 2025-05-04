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
  fullname: {
    type: String,
    required: true
  },
  global_address: {
    type: Number,
    required: true,
    default: 0
  },
  role: {
    type: String,
    enum: ['user', 'admin'], // only allows 'user' or 'admin'
    default: 'user',
    required: true
  }
});

export const UserModel = mongoose.model('User', userSchema);
