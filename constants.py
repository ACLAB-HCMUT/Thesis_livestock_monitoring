import sys

MQTT_SERVER = "mqtt.ohstem.vn"
MQTT_PORT = 1883
MQTT_USERNAME = "nguyentruongthan"
MQTT_PASSWORD = ""

USERNAME = "hoangs369"

LORA_COM_PORT = sys.argv[1]

HEADER_GATEWAY_ACK = 0

HEADER_GATEWAY_REQUEST_GET_COWS = 1
HEADER_BACKEND_RESPONSE_GET_COWS = 2

HEADER_BACKEND_CREATE_COW = 3
HEADER_BACKEND_DELETE_COW = 4
HEADER_BACKEND_UPDATE_COW = 5

HEADER_GATEWAY_SEND_COW_INFOR = 6

HEADER_GATEWAY_REQUEST_SAFE_ZONES = 7
HEADER_BACKEND_RESPONSE_SAFE_ZONES = 8

HEADER_GATEWAY_SEND_ERROR = 9


COW_NOT_RESPONSE = 0