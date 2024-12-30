import time
import threading

import lora_controller
import mqtt_controller
from cow_controler import cows_dict
from CowModel import CowModel
if __name__ == "__main__":
    time.sleep(3)
    mqtt_controller.get_all_cows()
    time.sleep(3)
    mqtt_controller.get_safe_zones()
    time.sleep(3)

    # Test send cow information
    # for cow_id in cows_dict.keys():
    #     mqtt_controller.send_cow_infor(cow_id, 106.80563511600963, 10.881112870529336, 0)
    #     time.sleep(2)

    # for cow_id in cows_dict.keys():
    #     mqtt_controller.send_cow_infor(cow_id, 106.80413813907484, 10.880075359055084, 1)
    #     time.sleep(2)
    read_lora_data_thread = threading.Thread(target=lora_controller.read_lora_data)
    send_lora_data_thread = threading.Thread(target=lora_controller.send_lora_data)

    read_lora_data_thread.start()
    send_lora_data_thread.start()

    read_lora_data_thread.join()
    send_lora_data_thread.join()
        

        