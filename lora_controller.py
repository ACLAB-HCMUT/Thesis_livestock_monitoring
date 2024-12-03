from construct import Struct, Float32l, Int8ub, Int16ub
import time

import mqtt_controller
from lora import lora
from cow_controler import cows_dict, cows_mutex

struct_lora_recv = Struct (
    "cow_addr" / Int16ub,
    "latitude" / Float32l,
    "longitude" / Float32l,
    "status" / Int8ub
)

def handle_lora_msg(msg: bytes) -> bool:
    lora_recv_frame = struct_lora_recv.parse(msg)
    
    cow_id = None
    # Find cow id by cow_addr
    for key in cows_dict.keys():
        if cows_dict[key].cow_addr == lora_recv_frame.cow_addr:
            cow_id = key

    if(cow_id != None):
        mqtt_controller.send_cow_infor(
            cow_id=cow_id, 
            longitude=lora_recv_frame.longitude, 
            latitude=lora_recv_frame.latitude, 
            cow_status=lora_recv_frame.status)
    
    
def read_lora_data():
    while(True):
        lora.read()
        if lora.cow_addr_is_waiting != 0:
            lora.sending_timeout -= 10
            if(lora.sending_timeout <= 0):
                # Raise timeout error
                print(f"cow {lora.cow_addr_is_waiting} timeout")

                lora.cow_addr_is_waiting = 0
        time.sleep(0.01) # 10ms


def send_lora_data():
    while True:
        cow_addrs = [cow.cow_addr for cow in cows_dict.values()]
        for cow_addr in cow_addrs:
            lora.send_lora_msg(cow_addr, 1)

            # Waiting for read response or timeout
            while lora.cow_addr_is_waiting != 0:
                pass
        time.sleep(5)
