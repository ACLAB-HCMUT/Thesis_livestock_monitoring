extern "C" {
#include <zephyr/drivers/flash.h>
#include <zephyr/storage/flash_map.h>
#include <zephyr/fs/nvs.h>
#include <zephyr/device.h>
}
#include <iostream>

#include "flash.hpp"
#include "global.hpp"

#define NVS_PARTITION		storage_partition
#define NVS_PARTITION_DEVICE	FIXED_PARTITION_DEVICE(NVS_PARTITION)
#define NVS_PARTITION_OFFSET	FIXED_PARTITION_OFFSET(NVS_PARTITION)

static struct nvs_fs fs;
static struct flash_pages_info info;
static int rc = 0;

int init_flash_memory()
{
    fs.flash_device = NVS_PARTITION_DEVICE;
	if (!device_is_ready(fs.flash_device)) {
		std::cout << "Flash device " << fs.flash_device->name << " is not ready\n";
		return 1;
	}
	fs.offset = NVS_PARTITION_OFFSET;
	rc = flash_get_page_info_by_offs(fs.flash_device, fs.offset, &info);
	if (rc) {
		std::cout << "Unable to get page info, rc=" << rc << "\n";
		return rc;
	}
    fs.sector_size = info.size;
	fs.sector_count = 3U;

	rc = nvs_mount(&fs);
	if (rc) {
		std::cout << "Flash Init failed, rc=" << rc << "\n";
		return rc;
	}

    return 0;
}

int read_flash(uint8_t key, uint8_t* buffer, uint8_t length)
{
    int error_code = nvs_read(&fs, key, buffer, length);
    if(rc > 0) {
        std::cout << "read " << error_code << " bytes\n";
        for(uint8_t i = 0; i < error_code; i++){
            std::cout << std::hex << buffer[i];
        }
        std::cout << std::endl;
    }
    return error_code;
}

int write_flash(uint8_t key, uint8_t* buffer, uint8_t length)
{
    return nvs_write(&fs, key, buffer, length);
}