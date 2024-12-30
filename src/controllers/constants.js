const HEADER_GATEWAY_ACK = 0

const HEADER_GATEWAY_REQUEST_GET_COWS = 1
const HEADER_BACKEND_RESPONSE_GET_COWS = 2

const HEADER_BACKEND_CREATE_COW = 3
const HEADER_BACKEND_DELETE_COW = 4
const HEADER_BACKEND_UPDATE_COW = 5


const HEADER_GATEWAY_SEND_COW_INFOR = 6

const HEADER_GATEWAY_REQUEST_SAFE_ZONES = 7
const HEADER_BACKEND_RESPONSE_SAFE_ZONES = 8

export default {
    HEADER_GATEWAY_ACK,
    HEADER_GATEWAY_REQUEST_GET_COWS,
    HEADER_BACKEND_RESPONSE_GET_COWS,

    HEADER_BACKEND_CREATE_COW,
    HEADER_BACKEND_DELETE_COW,
    HEADER_BACKEND_UPDATE_COW,

    HEADER_GATEWAY_SEND_COW_INFOR,

    HEADER_GATEWAY_REQUEST_SAFE_ZONES,
    HEADER_BACKEND_RESPONSE_SAFE_ZONES,
}
