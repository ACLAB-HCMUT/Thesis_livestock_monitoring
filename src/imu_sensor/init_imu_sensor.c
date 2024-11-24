#include <zephyr/device.h>
#include <zephyr/drivers/sensor.h>

static struct sensor_value odr_attr;
struct device* lsm6dsl_dev;

uint8_t init_imu_sensor()
{
    
    lsm6dsl_dev = DEVICE_DT_GET_ONE(st_lsm6dsl);
    

	if (!device_is_ready(lsm6dsl_dev)) {
		printk("sensor: device not ready.\n");
		return 1;
	}

	/* set accel/gyro sampling frequency to 104 Hz */
	odr_attr.val1 = 104;
	odr_attr.val2 = 0;

	if (sensor_attr_set(lsm6dsl_dev, SENSOR_CHAN_ACCEL_XYZ,
			    SENSOR_ATTR_SAMPLING_FREQUENCY, &odr_attr) < 0) {
		printk("Cannot set sampling frequency for accelerometer.\n");
		return 2;
	}

	if (sensor_attr_set(lsm6dsl_dev, SENSOR_CHAN_GYRO_XYZ,
			    SENSOR_ATTR_SAMPLING_FREQUENCY, &odr_attr) < 0) {
		printk("Cannot set sampling frequency for gyro.\n");
		return 3;
	}


	if (sensor_sample_fetch(lsm6dsl_dev) < 0) {
		printk("Sensor sample update error\n");
		return 4;
	}

	return 0;
}