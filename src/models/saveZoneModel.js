import mongoose from "mongoose";


const counterSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true,
  },
  seq: {
    type: Number,
    default: 0,
  },
});

export const Counter = mongoose.model("Counter", counterSchema);

const saveZoneSchema = new mongoose.Schema({
  safeZone: {
    type: [
      {
        latitude: Number,
        longitude: Number,
      },
    ],
    required: true,
  },
  username: {
    type: String,
    required: true,
  },
  sequentialId: {
    type: String,
    unique: true,
  },
});


saveZoneSchema.pre("save", async function (next) {
  if (!this.isNew) return next(); 

  try {
    const counter = await Counter.findOneAndUpdate(
      { username: this.username },
      { $inc: { seq: 1 } }, 
      { new: true, upsert: true }
    );

    this.sequentialId = `${this.username}-SaveZone${counter.seq}`;
    next();
  } catch (err) {
    next(err);
  }
});
export const SaveZone = mongoose.model("SaveZone", saveZoneSchema);
