extern "C" {
#include <zephyr/kernel.h>
}
#include <iostream>

#include "global.hpp"
#include "gps_software_serial.hpp"
#include "TinyGPSPlus.hpp"

static TinyGPSPlus gps;

static void displayInfo()
{
	std::cout << "Location:";
	if (gps.location.isValid()) {
		std::cout << gps.location.lat() << ", " << gps.location.lng();
	} else {
		std::cout << "INVALID";
	}
	std::cout << std::endl;
}

void gps_entry(void *p1, void *p2, void *p3)
{
	
	if(init_gps_serial()){
        return;
    }
	
	while (1) {
		while(gps_serial_is_available()){
			uint8_t data = gps_serial_read();
			if(gps.encode(data)){
				displayInfo();
			}
		}
		k_msleep(10);
	}
}