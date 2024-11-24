extern "C" {
#include <zephyr/kernel.h>
}

#include <iostream>
#include "global.hpp"
#include "button.hpp"

void button_entry(void *p1, void *p2, void *p3)
{
	if(init_button()){
        return;
    }
	
	while (1) {
		fsm_button();
		k_msleep(10);
	}
}