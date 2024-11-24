#ifndef FLASH_HPP
#define FLASH_HPP


/**
 * This function will init flash memory
 * @return Return 0 if success. Otherwise, return error code
 */
int init_flash_memory();

/**
 * This function will read flash memory and write data to buffer 
 * @return Return number of bytes request to read if success. Otherwise, return error code (negative)
*/
int read_flash(uint8_t key, uint8_t* buffer, uint8_t length);

/**
 * This function will write data to flash memory
 * @return Return number of bytes request to be written if success. 
 * If rewrite the same data, return 0.
 * Otherwise, return error code (negative)
*/
int write_flash(uint8_t key, uint8_t* buffer, uint8_t length);
#endif