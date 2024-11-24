extern "C" {
	#include <zephyr/bluetooth/bluetooth.h>
	#include <zephyr/bluetooth/conn.h>
	#include <zephyr/bluetooth/gatt.h>
	#include <zephyr/bluetooth/hci.h>
	#include <zephyr/bluetooth/uuid.h>
}
#include <iostream>
#include "ble.hpp"
#include "global.hpp"
#include "flash.hpp"

// Define BLE service 63bf0b19-2b9c-473c-9e0a-2cfcaf03a770
#define BT_UUID_COW_ADDR_SERVICE_VAL                                                                \
	BT_UUID_128_ENCODE(0x63bf0b19, 0x2b9c, 0x473c, 0x9e0a, 0x2cfcaf03a770)

static struct bt_uuid_128 cow_addr_service_uuid = BT_UUID_INIT_128(BT_UUID_COW_ADDR_SERVICE_VAL);
static struct bt_uuid_128 char_cow_addr_uuid =
	BT_UUID_INIT_128(BT_UUID_128_ENCODE(0x63bf0b19, 0x2b9c, 0x473c, 0x9e0a, 0x2cfcaf03a771));

ssize_t write_cow_addr_characteristic(struct bt_conn *conn, const struct bt_gatt_attr *attr, const void *buf,
                                      uint16_t len, uint16_t offset, uint8_t flags){
	printk("write cow_addr:\n");

	if(len == 2)
	{
		memcpy(&cow_addr, buf, len);
		int error_code = write_flash(COW_ADDR_ID, (uint8_t*)&cow_addr, 2);
		if(error_code == 2){
			std::cout << "write success\n";
		}else if(error_code == 0){
			std::cout << "already data\n";
		}else{
			std::cout << "write to flash error " << error_code << std::endl;
		}
		return 2;
	}
	return 0;
}

static ssize_t read_cow_addr_characteristic(struct bt_conn *conn, const struct bt_gatt_attr *attr, void *buf,
				   uint16_t len, uint16_t offset)
{
	printk("read cow_addr\n");
	const char *value = (const char*)attr->user_data;
	return bt_gatt_attr_read(conn, attr, buf, len, offset, value, sizeof(cow_addr));
}

// Primary Service Declaration
BT_GATT_SERVICE_DEFINE(
	cow_addr_service, BT_GATT_PRIMARY_SERVICE(&cow_addr_service_uuid),
	BT_GATT_CHARACTERISTIC(&char_cow_addr_uuid.uuid, BT_GATT_CHRC_READ | BT_GATT_CHRC_WRITE, BT_GATT_PERM_READ | BT_GATT_PERM_WRITE,
			       read_cow_addr_characteristic, write_cow_addr_characteristic, &cow_addr));
	

// Advertising data
static const struct bt_data ad[] = {
	BT_DATA_BYTES(BT_DATA_FLAGS, (BT_LE_AD_GENERAL | BT_LE_AD_NO_BREDR)),
	BT_DATA_BYTES(BT_DATA_UUID128_ALL, BT_UUID_COW_ADDR_SERVICE_VAL),
	BT_DATA_BYTES(BT_DATA_MANUFACTURER_DATA, 0xff, 0xff),
};


// Connection callbacks
static void connected(struct bt_conn *conn, uint8_t err)
{
	if (err) {
		printk("Connection failed (err 0x%02x)\n", err);
	} else {
		system_status = CONNECTED;
		printk("Connected\n");
	}
}
static void disconnected(struct bt_conn *conn, uint8_t reason)
{
	printk("Disconnected (reason 0x%02x)\n", reason);
	if(system_status == CONNECTED){
		system_status = CONFIG_ADDR;
	}
}
static struct bt_conn_cb conn_callbacks = {
	.connected = connected,
	.disconnected = disconnected,
};


static void bt_ready(void)
{
	int err;
	printk("Bluetooth initialized\n");
	err = bt_le_adv_start(BT_LE_ADV_CONN_NAME, ad, ARRAY_SIZE(ad), NULL, 0);
	if (err) {
		printk("Advertising failed to start (err %d)\n", err);
		return;
	}
	printk("Advertising successfully started\n");
}

int enable_ble()
{
	int err;
	// Initialize the Bluetooth subsystem
	err = bt_enable(NULL);
	if (err) {
		printk("Bluetooth init failed (err %d)\n", err);
		return err;
	}
	bt_ready();
	// Register connection callbacks
	bt_conn_cb_register(&conn_callbacks);
    return 0;
}

int disable_ble(){
    int err = bt_disable();
    if(err){
		printk("Cannot disable bluetooth (err %d)\n", err);
        return err;
    }
    return 0;
}