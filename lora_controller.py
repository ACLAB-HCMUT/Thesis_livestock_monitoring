from construct import Struct, Float32l, Int8ub, Int16ub
import time

import mqtt_controller
from lora import lora
from cow_controler import cows_dict
from CowModel import CowModel
from safe_zone_controller import safe_zones_dict
from SafeZoneModel import SafeZoneModel, Point
import constants

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
            break

    if(cow_id == None):
        return
    
    cow: CowModel = cows_dict[cow_id]
    is_out_of_safe_zone = 0
    # Check gps in safezone
    if(cow.safe_zone_id != None):
        safe_zone_id: str = None
        for key in safe_zones_dict.keys():
            if(safe_zones_dict[key].sequentialId == cow.safe_zone_id):
                safe_zone_id = key
                break
        safe_zone: SafeZoneModel = safe_zones_dict[safe_zone_id]
        point: Point = Point(lora_recv_frame.longitude, lora_recv_frame.latitude)
        if(safe_zone.is_point_in_safe_zone(point) == False):
            is_out_of_safe_zone = 1
    
    if(cow_id != None):
        mqtt_controller.send_cow_infor(
            cow_id=cow_id, 
            longitude=lora_recv_frame.longitude, 
            latitude=lora_recv_frame.latitude, 
            is_out_of_safe_zone=is_out_of_safe_zone)
    
    
def read_lora_data():
    while(True):
        lora.read()
        if lora.cow_addr_is_waiting != 0:
            lora.sending_timeout -= 10
            if(lora.sending_timeout <= 0):
                # Raise timeout error
                print(f"cow {lora.cow_addr_is_waiting} timeout")
                # mqtt_controller.send_error(lora.cow_is_waiting.cow_id, constants.COW_NOT_RESPONSE)
                
                lora.cow_addr_is_waiting = 0
        time.sleep(0.01) # 10ms


def send_lora_data():
    while True:
        cow_addrs = [cow.cow_addr for cow in cows_dict.values()]
        for cow_addr in cow_addrs:
            if(cow_addr == None):
                continue
            lora.send_lora_msg(cow_addr, 1)

            # Waiting for read response or timeout
            while lora.cow_addr_is_waiting != 0:
                pass
        time.sleep(5)
