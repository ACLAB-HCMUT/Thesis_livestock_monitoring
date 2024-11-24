extern "C" {
#include <zephyr/kernel.h>
#include <zephyr/drivers/sensor.h>

#include <stdio.h>

}

#include <iostream>

extern "C" {
extern struct device* lsm6dsl_dev;
extern uint8_t init_imu_sensor();
}

static struct sensor_value accel_x, accel_y, accel_z;
static struct sensor_value gyro_x, gyro_y, gyro_z;



extern struct device* lsm6dsl_dev;


void read_imu_sensor(const struct device *dev)
{
	sensor_sample_fetch_chan(dev, SENSOR_CHAN_ACCEL_XYZ);
	sensor_channel_get(dev, SENSOR_CHAN_ACCEL_X, &accel_x);
	sensor_channel_get(dev, SENSOR_CHAN_ACCEL_Y, &accel_y);
	sensor_channel_get(dev, SENSOR_CHAN_ACCEL_Z, &accel_z);

	/* lsm6dsl gyro */
	sensor_sample_fetch_chan(dev, SENSOR_CHAN_GYRO_XYZ);
	sensor_channel_get(dev, SENSOR_CHAN_GYRO_X, &gyro_x);
	sensor_channel_get(dev, SENSOR_CHAN_GYRO_Y, &gyro_y);
	sensor_channel_get(dev, SENSOR_CHAN_GYRO_Z, &gyro_z);
}

void read_imu_sensor_entry(void* p1, void* p2, void* p3){
	uint8_t err_code = init_imu_sensor();
	if(err_code != 0) {
		std::cout << "Cannot init imu sensor, err_code: " << err_code << std::endl;
		return;
	}

	char out_str[64];
	while (1) {
		read_imu_sensor(lsm6dsl_dev);

		printf("LSM6DSL sensor samples:\n\n");

		/* lsm6dsl accel */
		sprintf(out_str, "accel x:%f ms/2 y:%f ms/2 z:%f ms/2",
							  sensor_value_to_float(&accel_x),
							  sensor_value_to_float(&accel_y),
							  sensor_value_to_float(&accel_z));
		printk("%s\n", out_str);

		/* lsm6dsl gyro */
		sprintf(out_str, "gyro x:%f dps y:%f dps z:%f dps",
							   sensor_value_to_float(&gyro_x),
							   sensor_value_to_float(&gyro_y),
							   sensor_value_to_float(&gyro_z));
		printk("%s\n", out_str);

		k_sleep(K_SECONDS(2));
	}
}
