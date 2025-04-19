import mongoose from 'mongoose';

// Original Cow Schema (from your first message)
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
    medicated: {
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
    age: {
        type: Number
    },
    sex: {
        type: Boolean
    },
    weight: {
        type: Number
    },
    status: {
        type: String,
        enum: ['eating', 'idle', 'walking']
    },
    groupId: {
        type: String,
        default: "Undefined",
    },
    timestamp: {
        type: Date,
        default: Date.now
    },
});

// Status History Schema - for tracking status changes
const statusHistorySchema = new mongoose.Schema({
    cowId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Cow',
        required: true
    },
    status: {
        type: String,
        enum: ['eating', 'idle', 'walking'],
        required: true
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

// Status Analytics Schema - for storing daily/hourly aggregated data
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

export const CowModel = mongoose.model('Cow', cowSchema);
export const StatusHistoryModel = mongoose.model('StatusHistory', statusHistorySchema);
export const StatusAnalyticsModel = mongoose.model('StatusAnalytics', statusAnalyticsSchema);

// Utility function to update cow status and record history
export async function updateCowStatus(cowId, newStatus) {
    try {
        const cow = await CowModel.findById(cowId);
        if (!cow) {
            throw new Error('Cow not found');
        }

        const oldStatus = cow.status;
        const now = new Date();

        // If there was a previous status, close that status period
        if (oldStatus) {
            const latestStatusRecord = await StatusHistoryModel.findOne({
                cowId: cowId,
                endTime: null
            }).sort({ startTime: -1 });

            if (latestStatusRecord) {
                const startTime = latestStatusRecord.startTime;
                const durationSeconds = Math.floor((now - startTime) / 1000);

                // Update the previous status record with end time and duration
                latestStatusRecord.endTime = now;
                latestStatusRecord.duration = durationSeconds;
                await latestStatusRecord.save();

                // Update the daily analytics
                await updateDailyAnalytics(cowId, oldStatus, durationSeconds);
            }
        }

        // Create a new status history record for the new status
        await StatusHistoryModel.create({
            cowId: cowId,
            status: newStatus,
            startTime: now
        });

        // Update the cow's current status
        cow.status = newStatus;
        cow.timestamp = now;
        await cow.save();

        return cow;
    } catch (error) {
        console.error('Error updating cow status:', error);
        return { success: false, error: error.message };
    }
}

// Function to update daily analytics
async function updateDailyAnalytics(cowId, status, durationSeconds) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // Find or create analytics document for today
    let analytics = await StatusAnalyticsModel.findOne({
        cowId: cowId,
        date: today
    });

    if (!analytics) {
        analytics = new StatusAnalyticsModel({
            cowId: cowId,
            date: today
        });
    }

    // Update the appropriate duration field
    switch (status) {
        case 'eating':
            analytics.eatingDuration += durationSeconds;
            break;
        case 'walking':
            analytics.walkingDuration += durationSeconds;
            break;
        case 'idle':
            analytics.idleDuration += durationSeconds;
            break;
    }

    await analytics.save();
}

// Function to get status history for a specific cow
export async function getCowStatusHistory(cowId, limit = 20) {
    try {
        return await StatusHistoryModel.find({ cowId })
            .sort({ startTime: -1 })
            .limit(limit);
    } catch (error) {
        console.error('Error getting cow status history:', error);
        return { success: false, error: error.message };
    }
}

// Function to get status analytics for a specific cow
export async function getCowStatusAnalytics(cowId, days = 7) {
    try {
        const startDate = new Date();
        startDate.setDate(startDate.getDate() - days);
        startDate.setHours(0, 0, 0, 0);

        return await StatusAnalyticsModel.find({
            cowId: cowId,
            date: { $gte: startDate }
        }).sort({ date: 1 });
    } catch (error) {
        console.error('Error getting cow status analytics:', error);
        return { success: false, error: error.message };
    }
}

// Function to record hourly status snapshots for all cows
export async function recordHourlyStatusSnapshot() {
    try {
        const cows = await CowModel.find();
        const now = new Date();
        
        for (const cow of cows) {
            if (!cow.status) continue;
            
            // Record the current status without closing the current period
            await StatusHistoryModel.create({
                cowId: cow._id,
                status: cow.status,
                startTime: now,
                endTime: now,
                duration: 0 // This is just a snapshot, not an actual period
            });
        }
        
        return { success: true, count: cows.length };
    } catch (error) {
        console.error('Error recording hourly status snapshot:', error);
        return { success: false, error: error.message };
    }
}

// Function to schedule hourly status recording
export function scheduleHourlyStatusRecording() {
    // Using setInterval for demonstration
    // In production, consider using a proper scheduling library like node-cron
    const ONE_HOUR = 60 * 60 * 1000; // 1 hour in milliseconds
    
    setInterval(async () => {
        console.log('Recording hourly cow status snapshot...');
        await recordHourlyStatusSnapshot();
    }, ONE_HOUR);
    
    console.log('Hourly status recording scheduled');
}