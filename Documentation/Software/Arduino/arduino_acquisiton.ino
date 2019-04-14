#include <Wire.h>
// ADS7828 I2C address = 0x48(72)
#define Addr 0x48
int i = 0; // global variable
void setup()
{
  // Initialize I2C communication
  Wire.begin();
  // Initialize serial communication, set baud rate = 9600
  Serial.begin(9600);
  delay(4);
}
void loop()
{
  int signal_adc;
  byte data[2];

  int code;
  if(i==0){
    code=0b10000100;
  }
  else if(i==1){
    code=0b11000100;
  }
  else if(i==2){
    code=0b10010100;
  }
  else if(i==3){
    code=0b11010100;}
    
  // I2C Communication for channel control
  Wire.beginTransmission(Addr);
  Wire.write(code);
  // Stop I2C transmission
  Wire.endTransmission();
  // Request 2 bytes of data
  Wire.requestFrom(Addr, 2);
  if(Wire.available() == 2)
    {
    data[0] = Wire.read(); //raw_adc msb
    data[1] = Wire.read(); //raw_adc lsb
    delay(4);
    // 8-bit integer to 12 bits
    signal_adc = ((data[0] & 0x0F) * 256) + data[1];
    Serial.println(signal_adc);
    }
    i++;
    if(i==4){
      i=0;
      }
}
