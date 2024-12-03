import time
import threading

import lora_controller
import mqtt_controller


if __name__ == "__main__":
    time.sleep(3)
    mqtt_controller.get_all_cows()
    time.sleep(3)
    mqtt_controller.get_safe_zones()
    time.sleep(3)

    read_lora_data_thread = threading.Thread(target=lora_controller.read_lora_data)
    send_lora_data_thread = threading.Thread(target=lora_controller.send_lora_data)

    read_lora_data_thread.start()
    send_lora_data_thread.start()

    read_lora_data_thread.join()
    send_lora_data_thread.join()
        

        