import mqtt_client_helper
import constants
import time
import json
import random

import CowModel
import cow_controler

import SafeZoneModel
import safe_zone_controller

def get_header(msg: str) -> int:
    if len(msg) >= 2: return int(msg[0:2])
    else: return None
    
def handle_mqtt_msg(msg: str):
    """
    This function will handle msg from mqtt
    Params:
        msg (str):
            mqtt message
    """
    # Split message to header and data

    header = get_header(msg)
    
    if(header == constants.HEADER_BACKEND_RESPONSE_GET_COWS):
        cows_data: str = msg[2:]
        data_list = json.loads(cows_data)
        
        for cow_dict in data_list:
            cowModel: CowModel.CowModel = CowModel.CowModel(cow_id=cow_dict['_id'], cow_addr=cow_dict['cow_addr'])
            cow_controler.add_cow(cowModel=cowModel)
        
        print(f"After get all cows: {cow_controler.cows_dict}")
        
    elif(header == constants.HEADER_BACKEND_CREATE_COW):
        # <header><cow>
        # split to get cow_data
        cow_data: str = msg[2:]

        # convert cow_data from string to dict
        cow_dict = json.loads(cow_data)

        # add cow to global variable
        cowModel: CowModel.CowModel = CowModel.CowModel(cow_id=cow_dict['_id'], cow_addr=cow_dict['cow_addr'])
        cow_controler.add_cow(cowModel)

        # response ack to backend
        publish_mqtt_msg(f"0{constants.HEADER_GATEWAY_ACK}{cowModel.cow_id}")

        print(f"After create cow: {cow_controler.cows_dict}")
    
    elif(header == constants.HEADER_BACKEND_DELETE_COW):
        # <header><cow_id>
        # split to get cow id
        cow_id: str = msg[2:]

        #delete cow from global variable
        cow_controler.delete_cow(cow_id=cow_id)
        
        # response ack to backend
        publish_mqtt_msg(f"0{constants.HEADER_GATEWAY_ACK}")
        print(f"After delete cow: {cow_controler.cows_dict}")
    
    elif(header == constants.HEADER_BACKEND_RESPONSE_SAFE_ZONES):
        # <header><safezones>
        # split to get safezones
        safe_zones_data: str = msg[2:]

        # load json
        data_list = json.loads(safe_zones_data)
        # print(data_list)
        for safe_zone_dict in data_list:
            safe_zone_id: str = safe_zone_dict['_id']
            safe_zone_points: list = []

            for point in safe_zone_dict['safeZone']:
                point: SafeZoneModel.Point = SafeZoneModel.Point(point['longitude'], point['latitude'])
                safe_zone_points.append(point)
            
            safeZoneModel: SafeZoneModel.SafeZoneModel = \
                SafeZoneModel.SafeZoneModel(safe_zone_id, safe_zone_points)
            safe_zone_controller.add_safe_zone(safeZoneModel)
        
        print(safe_zone_controller.safe_zones_dict)
        
    else:
        print(f"Header is invalid, header = {header}")
    

def publish_mqtt_msg(msg: str):
    """
    This function will publish `msg` to mqtt broker's `topic` 
    Params:
        msg (str):
            message which we would like to publish
    """
    mqtt_client_helper.mqttClientHelper.publish(msg)


def get_all_cows():
    """
    This function will send a request to get all cows information
to backend
    """

    msg: str = f"0{constants.HEADER_GATEWAY_REQUEST_GET_COWS}" \
                if constants.HEADER_GATEWAY_REQUEST_GET_COWS < 10 \
                else f"{constants.HEADER_GATEWAY_REQUEST_GET_COWS}"
    publish_mqtt_msg(msg)

def send_ack(ack: int):
    """
    This function will feedback ack to backend
    Params:
        ack (int): ack which we wanna feedback to backend
    """

    msg: str = f"0{constants.HEADER_GATEWAY_ACK}{ack}"
    publish_mqtt_msg(msg)

def send_cow_infor(cow_id:str, longitude: float, latitude: float, cow_status):
    msg: str = f"0{constants.HEADER_GATEWAY_SEND_COW_INFOR}" \
                if constants.HEADER_GATEWAY_SEND_COW_INFOR < 10 \
                else f"{constants.HEADER_GATEWAY_SEND_COW_INFOR}"
    msg += f"{cow_id}:{longitude}:{latitude}:{cow_status}"
    publish_mqtt_msg(msg)

def get_safe_zones():
    """
    This function will send a request to get safe zone
    """

    msg: str =  f"0{constants.HEADER_GATEWAY_REQUEST_SAFE_ZONES}" \
                if constants.HEADER_GATEWAY_REQUEST_SAFE_ZONES < 10 \
                else f"{constants.HEADER_GATEWAY_REQUEST_SAFE_ZONES}"
    publish_mqtt_msg(msg)

