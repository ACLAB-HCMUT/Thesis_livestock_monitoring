import threading
import time

# Dictionary chia sẻ
shared_dict = {}
# Tạo một mutex để đồng bộ hóa
mutex = threading.Lock()

# Thread đọc dữ liệu từ dictionary
def read_dict():
    while True:
        with mutex:  # Bảo vệ dictionary bằng mutex
            for key, value in shared_dict.items():
                print(f"Read key={key}, value={value}")
                time.sleep(5)
        time.sleep(1)  # Giả lập thời gian xử lý

# Thread thêm/xóa dữ liệu trong dictionary
def modify_dict():
    for i in range(10):
        with mutex:  # Bảo vệ dictionary bằng mutex
            shared_dict[i] = f"value_{i}"
            print(f"Added key={i}, value=value_{i}")
        time.sleep(0.5)  # Giả lập thời gian thêm
        with mutex:  # Xóa key từ dictionary
            if i in shared_dict:
                del shared_dict[i]
                print(f"Deleted key={i}")
        time.sleep(0.5)

# Tạo và khởi động các thread
reader_thread = threading.Thread(target=read_dict)
modifier_thread = threading.Thread(target=modify_dict)

reader_thread.start()
modifier_thread.start()

reader_thread.join()
modifier_thread.join()
