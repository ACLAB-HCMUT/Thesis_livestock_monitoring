from construct import Struct, Int8ub, Int32ub, Float32b

temp_format = Struct(
    "opcode" / Int8ub,
    "kinh_do" / Int32ub,
    "kinh_do_thuc" / Int32ub,
    "vi_do_nguyen" / Int32ub,
    "vi_do_thuc" / Int32ub
)

bytes_ex = bytes([0x00, 
            0x00, 0x00, 0x00, 32, 0x00, 0x00, 0x00, 65, 
            0x00, 0x00, 0x00, 112, 0x00, 0x00, 0x00, 94])


temp_struct = temp_format.parse(bytes_ex)

print(temp_struct.kinh_do_nguyen)
