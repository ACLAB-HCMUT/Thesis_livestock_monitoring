from construct import Struct, Float32l, Int8ub, Int16ub
import mqtt_controller
import time
import json

OPCODE_LOCATION = 0
OPCODE_STATE = 1

struct_location = Struct (
    "opcode" / Int8ub,
    "address" / Int16ub,
    "longitude" / Float32l,
    "latitude" / Float32l
)

struct_state = Struct (
    "opcode" / Int8ub,
    "address" / Int16ub,
    "state" / Int8ub,
)

def handle_lora_msg(msg: bytes):
    opcode = msg[0]
    if(opcode == OPCODE_LOCATION):
        location_frame = struct_location.parse(msg)

        json_obj = dict()
        json_obj['opcode'] = location_frame.opcode
        json_obj['address'] = location_frame.address
        json_obj['longitude'] = location_frame.longitude
        json_obj['latitude'] = location_frame.latitude

        mqtt_controller.publish_mqtt_msg(json.dumps(json_obj))

    elif(opcode == OPCODE_STATE):
        state_frame = struct_state.parse(msg)

        json_obj = dict()
        json_obj['opcode'] = state_frame.opcode
        json_obj['address'] = state_frame.address
        json_obj['state'] = state_frame.state
        
        mqtt_controller.publish_mqtt_msg(json.dumps(json_obj))

    else:
        print(f"Opcode {opcode} invalid")

if __name__ == '__main__':
    opcode = bytes([0])
    address = bytes([0, 5])
    kinh_do = b'\xc3\xf5H@'
    vi_do = b'\x91\xed\xe4@'

    a = opcode + address + kinh_do + vi_do

    while(1):
        time.sleep(10)
        handle_lora_msg(a)