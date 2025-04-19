import { CowModel, StatusHistoryModel, StatusAnalyticsModel } from "../models/cowModel.js";
import deviceService from "./deviceService.js";

const MS_PER_DAY = 86400000;

const createCow = async (req) => {
    const newCow = new CowModel(req.body);
    const savedCow = newCow.save();
    return savedCow;
};
const createCowx = async (req) => {
    const cowData = {
        cow_addr: req.body.cow_addr,
        name: req.body.name,
        username: req.body.username || "xxx",
        latest_longitude: req.body.latest_longitude || 10.879969479749972,
        latest_latitude: req.body.latest_latitude || 106.80616368776177,
        medicated: req.body.medicated || false,
        sick: req.body.sick || false,
        pregnant: req.body.pregnant || false,
        missing: req.body.missing || false,
        age: req.body.age || 2,
        sex: req.body.sex || false,
        weight: req.body.weight || 50,
        status: req.body.status || "idle",
        groupId: req.body.safeZoneId || "Undefined",
        timestamp: req.body.timestamp || Date.now(),
    };
    const newCow = new CowModel(cowData);
    const savedCow = await newCow.save();

    if (cowData.status && ['eating', 'idle', 'walking'].includes(cowData.status)) {
        await StatusHistoryModel.create({
            cowId: savedCow._id,
            status: cowData.status,
            startTime: new Date()
        });
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        let analytics = new StatusAnalyticsModel({
            cowId: savedCow._id,
            date: today
        });
        await analytics.save();
    }


    return savedCow;
};

const getAllCows = async () => {
    const cows = await CowModel.find();
    return cows;
};
const getCowById = async (cowId) => {
    const cow = await CowModel.findById(cowId);
    return cow;
};

const getCowByUsername = async (username) => {
    const cows = await CowModel.find({
        username: username,
    });

    return cows;
};

const getCowByUsernameAndCowAddr = async (username, cow_addr) => {
    const cow = await CowModel.findOne({
        username: username,
        cow_addr: cow_addr,
    });
    return cow;
};

const deleteCowById = async (cowId) => {
    var cur_cow = await getCowById(cowId);
    if (cur_cow.cow_addr != -1) {
        var device = await deviceService.findDevice(cur_cow.username, cur_cow.cow_addr);
        device.cow_id = "";
        await device.save();
    }
    const cow = await CowModel.findById(cowId);
    if (cow) {
        await cow.deleteOne();
    }
};
const deleteCowByUsername = async (username) => {
    await CowModel.deleteMany({
        username: username,
    });
};

const updateCowById = async (cowId, cow) => {
    var cur_cow = await getCowById(cowId)
    if ((cow.cow_addr !== cur_cow.cow_addr && cur_cow.cow_addr !== -1) || (cow.cow_addr === -1 && cur_cow.cow_addr !== -1)) {
        console.log(cow.cow_addr);
        console.log(cur_cow.cow_addr);
        var device = await deviceService.findDevice(cow.username, cur_cow.cow_addr);
        if (device) {
            device.cow_id = ""
            await device.save();
        }
    }
    const updatedCow = await CowModel.findByIdAndUpdate(
        cowId,
        { $set: cow },
        { new: true }
    );
    if (cow.cow_addr !== -1) {
        var device = await deviceService.findDevice(cow.username, cow.cow_addr);
        if (device) {
            device.cow_id = cur_cow._id.toString(); // Lấy ID của cur_cow
            await device.save(); // Đừng quên lưu lại thay đổi
        }
    }
    return updatedCow;
};

const updateLatestLocationById = async (cowId, longitude, latitude) => {
    const updatedCow = await CowModel.findById(cowId);
    if (updatedCow) {
        updatedCow.latest_longitude = longitude;
        updatedCow.latest_latitude = latitude;
        updatedCow.timestamp = Date.now();

        await updatedCow.save();
        return updatedCow;
    } else {
        return undefined;
    }
};

const updateCowStatusById = async (cowId, new_status) => {
    // const updatedCow = await CowModel.findById(cowId);
    // if (updatedCow) {
    //     updatedCow.status = new_status;
    //     updatedCow.timestamp = Date.now();
    //     await updatedCow.save();
    //     return updatedCow;
    // } else {
    //     return undefined;
    // }
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
                // console.log("Status : ", oldStatus , "\n");

                // Update the daily analytics
                await updateDailyAnalytics(cowId, oldStatus, durationSeconds);
            }
        }
        // Create a new status history record for the new status
        await StatusHistoryModel.create({
            cowId: cowId,
            status: new_status,
            startTime: now
        });

        // Update the cow's current status
        cow.status = new_status;
        cow.timestamp = now;
        await cow.save();

        return cow;
    } catch (error) {
        console.error('Error updating cow status:', error);
        return { success: false, error: error.message };
    }
};
async function updateDailyAnalytics(cowId, status, durationSeconds) {
    // Get the start time by subtracting duration from current time
    const now = new Date();
    const startTime = new Date(now.getTime() - durationSeconds * 1000);

    // Loop through each day between startTime and now
    let currentDate = new Date(startTime);
    currentDate.setHours(0, 0, 0, 0); // Start of the day containing startTime

    const endDate = new Date(now);
    endDate.setHours(0, 0, 0, 0); // Start of the day containing now

    while (currentDate <= endDate) {
        // Calculate start and end boundaries for this day
        const dayStart = new Date(currentDate);
        const dayEnd = new Date(currentDate);
        dayEnd.setHours(23, 59, 59, 999);

        // Calculate the portion of status time that falls within this day
        let periodStart = startTime > dayStart ? startTime : dayStart;
        let periodEnd = now < dayEnd ? now : dayEnd;

        // Calculate seconds spent in this status on this specific day
        const dayDurationSeconds = Math.max(0, Math.floor((periodEnd - periodStart) / 1000));

        if (dayDurationSeconds > 0) {
            // Find or create analytics document for this day
            let analytics = await StatusAnalyticsModel.findOne({
                cowId: cowId,
                date: new Date(currentDate)
            });

            if (!analytics) {
                analytics = new StatusAnalyticsModel({
                    cowId: cowId,
                    date: new Date(currentDate)
                });
            }

            // Update the appropriate duration field for this day
            switch (status) {
                case 'eating':
                    analytics.eatingDuration += dayDurationSeconds;
                    break;
                case 'walking':
                    analytics.walkingDuration += dayDurationSeconds;
                    break;
                case 'idle':
                    analytics.idleDuration += dayDurationSeconds;
                    break;
            }

            await analytics.save();
        }

        // Move to next day
        currentDate.setDate(currentDate.getDate() + 1);
    }
}
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


export async function getCowStatusAnalytics(cowId, days = 7) {
    try {
        const startDate = new Date();
        startDate.setDate(startDate.getDate() - days);
        startDate.setHours(0, 0, 0, 0);

        return {
            success: true,
            data: await StatusAnalyticsModel.find({
                cowId: cowId,
                date: { $gte: startDate }
            }).sort({ date: 1 }),
            period: {
                days: parseInt(days),
                start: startDate,
                end: new Date()
            }
        };
    } catch (error) {
        console.error('Error getting cow status analytics:', error);
        return { success: false, error: error.message };
    }
}



const updateCowAddressById = async (cowId, address) => {
    const updatedCow = await CowModel.findById(cowId);
    if (updatedCow) {
        updatedCow.cow_addr = address;
        await updatedCow.save();
        return updatedCow;
    } else {
        return undefined;
    }
};

export default {
    getAllCows,
    createCow,
    createCowx,
    getCowById,
    getCowByUsername,
    getCowByUsernameAndCowAddr,
    deleteCowById,
    deleteCowByUsername,
    updateCowById,
    updateLatestLocationById,
    updateCowAddressById,
    updateCowStatusById,
    getCowStatusAnalytics,
    getCowStatusHistory
};
