/* ========================================
 *
 * Copyright YOUR COMPANY, THE YEAR
 * All Rights Reserved
 * UNPUBLISHED, LICENSED SOFTWARE.
 *
 * CONFIDENTIAL AND PROPRIETARY INFORMATION
 * WHICH IS THE PROPERTY OF your company.
 *
 * ========================================
*/
#include "project.h"
#include "stdio.h"

#define SLAVE_ADDRESS 0b1001000

void writeRegister(uint8_t slaveAddress, uint8_t registerAddress, uint8_t value)
{
    I2C_MasterSendStart(slaveAddress, I2C_WRITE_XFER_MODE);
    I2C_MasterWriteByte(registerAddress);
    I2C_MasterWriteByte(value);
    I2C_MasterSendStop();
}

uint8_t readRegister(uint8_t slaveAddress, uint8_t registerAddress)
{
    I2C_DisableInt();
    I2C_MasterSendStart(slaveAddress, I2C_WRITE_XFER_MODE);
    I2C_MasterWriteByte(registerAddress);
    I2C_MasterSendRestart(slaveAddress, I2C_READ_XFER_MODE);
    uint8_t data = I2C_MasterReadByte(I2C_NAK_DATA);
    I2C_MasterSendStop();
    I2C_EnableInt();
    return data;
}

void configADC(uint8_t slaveAddress)
{
    uint8_t commandByte = 0b11011100;
    
    I2C_MasterSendStart(slaveAddress, I2C_WRITE_XFER_MODE);
    I2C_MasterWriteByte(commandByte);
    I2C_MasterSendRestart(slaveAddress, I2C_READ_XFER_MODE);
    
}

uint16_t readADCData()
{
    uint16_t upperByte = I2C_MasterReadByte(I2C_ACK_DATA) & 0x0F;
    uint8_t lowerByte = I2C_MasterReadByte(I2C_NAK_DATA);
    I2C_MasterSendStop();
    return ((upperByte << 8) + lowerByte);
    
}

int main(void)
{
    CyGlobalIntEnable; /* Enable global interrupts. */

    /* Place your initialization/startup code here (e.g. MyInst_Start()) */
    I2C_Start();
    UART_Start();
    
    uint16_t data;
    char buffer[10];

    for(;;)
    {
        /* Place your application code here. */
        configADC(SLAVE_ADDRESS);
        data = readADCData();
        
        CyDelay(50);
        
        sprintf(buffer, "%d", data);
        UART_PutString(buffer);
        
        
    }
}

/* [] END OF FILE */
