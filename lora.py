from serial import SerialException, Serial
import lora_controller
import constants

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
        self.lora_msg = [0] * 50
        self.is_begin = False
        self.length = 0

        self.sending_timeout = 0
        self.cow_addr_is_waiting = 0

    def send_command(self, command: int, addr: int, length: int, param: list):
        tx_buffer = [command, addr, length]

        if(command == self.SET_REGISTER_COMMAND):
            for i in range(length):
                tx_buffer.append(param[i])

        self.send_buffer(tx_buffer)
    
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
            while(bytesToRead > 0):
                byte_recv = self.lora_ser.read(1)
                if (byte_recv == b'!' and self.length == 0):
                    self.is_begin = True
                else:
                    if(self.is_begin == True):
                        if(byte_recv == b'#' and self.length > 10):
                            lora_recv_frame = self.lora_msg[0: self.length]
                            if(self.get_cow_addr(lora_recv_frame) == self.cow_addr_is_waiting):
                                lora_controller.handle_lora_msg(bytes(self.lora_msg[0: self.length]))
                                self.cow_addr_is_waiting = 0
                            self.is_begin = False
                            self.length = 0
                        else:
                            self.lora_msg[self.length] = byte_recv[0]
                            self.length += 1
                bytesToRead -= 1

        except SerialException:
            print(f"Disconnect from {self.lora_ser}")
            self.lora_ser = None
    
    def get_cow_addr(self, msg: bytes):
        return (msg[0] << 8) | msg[1]
        
    
    def send_lora_msg(self, addr: int, opcode: int):
        tx_buffer: list = []
        
        tx_buffer.append(33) # 33 = '!'

        tx_buffer.append(addr >> 8)
        tx_buffer.append(addr & 0xff)

        tx_buffer.append(opcode & 0xff)

        tx_buffer.append(35) # 35 = '#'
        self.send_buffer(tx_buffer)
        self.sending_timeout = 5000
        self.cow_addr_is_waiting = addr

    def send_buffer(self, tx_buffer: list):
        print(f"Send lora data: {tx_buffer}")
        try:
            self.lora_ser.write(tx_buffer)
        except ValueError:
            print(f"Cannot send {tx_buffer} through uart")
        
lora = Lora(constants.LORA_COM_PORT)