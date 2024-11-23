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
    require: true
  }
  ,
  global_address: {
    type: Number,
    require: true,
    default: 0
  }
});

export const UserModel = mongoose.model('User', userSchema);