from serial import SerialException, Serial
import lora_controller
import constants

lora_serial = Serial(port = constants.LORA_COM_PORT, baudrate = 9600)

def send_data(msg):
    lora_serial.write(msg)


lora_msg = ''
def recv_data():

    global lora_msg

    if(lora_serial == None):
        return
    try:
        bytesToRead = lora_serial.inWaiting()
        if (bytesToRead > 0):
            msg_recv = lora_serial.read(bytesToRead).decode()
            lora_msg += msg_recv
            if '!' in lora_msg and '#' in lora_msg:
                begin = lora_msg.index('!')
                end = lora_msg.index('#')
                lora_bytes = lora_msg[begin + 1, end].encode()
                lora_msg = lora_msg[end + 1:]
                lora_controller.handle_lora_msg(lora_bytes)

    except SerialException:
        print(f"Disconnect from {lora_serial}")
        lora_serial = None



class Lora:
    """
        This class will handle lora communication

        Attributes:
            lora_ser (serial.Serial): UART instance use to receive data from lora 
            lora_msg (str): A buffer store data from lora

    """

    GET_REGISTER_COMMAND = 0xC1
    SET_REGISTER_COMMAND = 0xC0

    def __init__(self, lora_port: str):
        # check lora_port is variable
        # TODO

        # init serial instance
        self.lora_ser = Serial(port = lora_port, baudrate = 9600)

        # init attributes use to handle message from Lora
        # this attribute use to store message from Lora
        self.lora_msg = ""
        self.is_begin = False

    def send_data(self, addr: int, channel: int, data: list):
        
        addr_bytes: list = [0x00] * 2
        addr_bytes[0] = addr >> 8
        addr_bytes[1] = addr & 0xff

        tx_buffer = []
        tx_buffer += addr_bytes

        tx_buffer.append(channel)
        tx_buffer += data

        self.send(tx_buffer)

    def send_command(self, command: int, addr: int, length: int, param: list):
        tx_buffer = [command, addr, length]

        if(command == self.SET_REGISTER_COMMAND):
            for i in range(length):
                tx_buffer.append(param[i])

        self.send(tx_buffer)
    
    def config_addr(self, addr: int):

        addr_bytes: list = [0x00] * 2
        addr_bytes[0] = addr >> 8
        addr_bytes[1] = addr & 0xff

        self.send_command(self.GET_REGISTER_COMMAND, 0x00, 2, addr_bytes)

    def config_channel(self, channel: int):

        self.send_command(self.GET_REGISTER_COMMAND, 0x04, 1, [channel])
    
    def config_key(self, key: int):
        
        key_bytes: list = [0x00] * 2
        key_bytes[0] = key >> 8
        key_bytes[1] = key & 0xff

        self.send_command(self.SET_REGISTER_COMMAND, 0x06, 2, key_bytes)
    
    def get_addr(self):
        self.send_command(self.GET_REGISTER_COMMAND, 0x00, 2, None)
        
    def get_channel(self):
        self.send_command(self.GET_REGISTER_COMMAND, 0x04, 2, None)
    
    def read(self):
        """
            This method use to read data from lora_ser and update data to lora_msg
        """
        if self.lora_ser == None:
            return
        
        try:
            #	Get the number of bytes in the input buffer
            bytesToRead = self.lora_ser.inWaiting()
            if (bytesToRead > 0):
                bytes = self.lora_ser.read(bytesToRead)
                print(f"From UART:")
                for byte in bytes:
                    print(byte)
                # #read all data in serial and assign to mess
                # self.lora_msg = self.lora_msg + self.lora_ser(bytesToRead).decode("utf-8")
                # #Format of data is "!<content>#" 
                # while ("#" in self.lora_msg) and ("!" in self.lora_msg):
                #     start = self.lora_msg.find("!")
                #     end = self.lora_msg.find("#")
                #     # processData(mess[start:end + 1], ser)
                #     # print(f"From UART: {message[start:end + 1]}")
                #     self.handle_lora_msg(self.lora_msg[start:end + 1])
                #     if (end == len(self.lora_msg)):
                #         self.lora_msg = ""
                #     else:
                #         self.lora_msg = self.lora_msg[end+1:]

        except SerialException:
            print(f"Disconnect from {self.lora_ser}")
            self.lora_ser = None
        
    def handle_msg(self, msg: str):
        """
            This function use to handle data which come from lora
        """
        lora_controller.handle_lora_msg(msg)
    
    def send(self, tx_buffer: list):
        print(f"Send UART: {tx_buffer}")
        self.lora_ser.write(tx_buffer)
        
lora = Lora(constants.LORA_COM_PORT)