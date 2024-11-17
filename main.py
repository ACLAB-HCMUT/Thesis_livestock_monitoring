import lora
import time


if __name__ == "__main__":
    count: int = 5000
    while True:
        lora.lora.read()
        if count >= 0:
            count -= 10
            if count <= 0:
                count = 5000
                lora.lora.get_addr()
        
        time.sleep(0.01)
        

        