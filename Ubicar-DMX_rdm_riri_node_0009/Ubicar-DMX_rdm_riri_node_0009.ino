/**************************************************************************/
/*!
    @file     DMX_node_riri
    @author   Claude Heintz
    @license  BSD (see LXDMXWiFi.h)
    @copyright 2017 by Claude Heintz All Rights Reserved

           https://github.com/claudeheintz/LXESP32DMX
*/
/**************************************************************************/
#define DEBUG 1
//#define DEBUGBAT 1

#define HELTEC 1
//#define OLED 1

int is;
uint8_t wifi_start;
uint8_t wifi_end;
int n;
uint8_t ligne = 0;
uint8_t menu = 0;
int mode_test = 1;

#ifdef HELTEC
#define NB_SAMPLE    100
int i = 0;
int raw_m;
long somme = 0;
int raw = 0;
int level;
int levelold = 0;
#endif

#include "EEPROM.h"
#define EEPROM_SIZE 64
int dmx_start;
int mode_start;
int wifichannel;
int hidden;
int hiddens;

#include <Wire.h>  // Only needed for Arduino 1.6.5 and earlier
#include "SSD1306.h" // alias for `#include "SSD1306Wire.h"` v 3.2.7
#include "OLEDDisplayUi.h"// Include the UI lib
#include "images.h"// Include custom images
#ifdef OLED
SSD1306  display(0x3c, 21, 22);
#endif
#ifdef HELTEC
SSD1306  display(0x3c, 4, 15);// heltec screen
#endif
OLEDDisplayUi ui     ( &display );

#include <RBD_Timer.h>  // https://github.com/alextaujenis/RBD_Timer
#include <RBD_Button.h> // https://github.com/alextaujenis/RBD_Button
// input pullup enabled by default
#ifdef HELTEC
RBD::Button button9(T7);//menu
RBD::Button button8(T6);//up
RBD::Button button7(T5);//down
RBD::Button button6(T4);//enter
#endif
#ifdef OLED
RBD::Button button9(T9);//menu
RBD::Button button8(T8);//up
RBD::Button button7(T7);//down
RBD::Button button6(T6);//enter
#endif

uint8_t init_btn9 = 0;
uint8_t init_btn8 = 0;
uint8_t init_btn7 = 0;
uint8_t init_btn6 = 0;

int frameCount = 7;
int frameCountnow = 0;
int enter = 0;

#define bat_check 1000
unsigned long last_bat_check_time = 0 ;
#define SCREEN_TIMEOUT 90000
unsigned long last_screen_check_time = 0;
uint8_t screen = 1;
unsigned long now;

int mode_start_value = 0;

#include <LXESP32DMX.h>
#include <UID.h>
#include <TOD.h>
#include <WiFi.h>
#include <WiFiUdp.h>
#include "LXDMXWiFi.h"
#include <LXWiFiArtNet.h>
#include <LXWiFiSACN.h>
#include "LXDMXWiFiConfig.h"
#include "freertos/task.h"

#define DIRECTION_PIN 5         // pin for output direction enable on MAX481 chip

#define STATUS_LED 19 // blue
#define WRITE_LED 0 // green
#ifdef OLED
#define TOUCH_LED 4  // red
#endif
#ifdef HELTEC
#define TOUCH_LED 23  // red
#endif

char ssid[32];
char password[32];

/*
    Edit the LXDMXWiFiConfig.initConfig() function in LXDMXWiFiConfig.cpp to configure the WiFi connection and protocol options
*/

// dmx protocol interfaces for parsing packets (created in setup)
LXWiFiArtNet* artNetInterface;
LXWiFiSACN*   sACNInterface;

// EthernetUDP instances to let us send and receive UDP packets
WiFiUDP aUDP;
WiFiUDP sUDP;

// direction output from network/input to network
uint8_t dmx_direction = 0;

// Output mode: received packet contained dmx
int art_packet_result = 0;
int acn_packet_result = 0;

// Input mode:  received slots when inputting dmx to network
int got_dmx = 0;

UID lower(0, 0, 0, 0, 0, 0);
UID upper(0, 0, 0, 0, 0, 0);
UID mid(0, 0, 0, 0, 0, 0);
UID found(0, 0, 0, 0, 0, 0);

// used to toggle indicator LED on and off
uint8_t led_state = 0;
uint8_t led_state_r = 0;

/************************************************************************

  Setup creates the WiFi connection.

  It also creates the network protocol object,
  either an instance of LXWiFiArtNet or LXWiFiSACN.

  if OUTPUT_FROM_NETWORK_MODE:
     Starts listening on the appropriate UDP port.

     And, it starts the ESP32DMX sending serial DMX via the UART1 TX pin.
     (see the LXESP32DMX library documentation for driver details)

   if INPUT_TO_NETWORK_MODE:
     Starts ESP32DMX listening for DMX ( received as serial on UART0 RX pin. )

*************************************************************************/

void setup() {
#ifdef DEBUG
  Serial.begin(115200);
  Serial.setDebugOutput(1); //use uart0 for debugging
#endif

#ifdef HELTEC
  /*
    analogReadResolution(12);             // Sets the sample bits and read resolution, default is 12-bit (0 - 4095), range is 9 - 12 bits
    analogSetWidth(12);                   // Sets the sample bits and read resolution, default is 12-bit (0 - 4095), range is 9 - 12 bits
                                          //  9-bit gives an ADC range of 0-511
                                          // 10-bit gives an ADC range of 0-1023
                                          // 11-bit gives an ADC range of 0-2047
                                          // 12-bit gives an ADC range of 0-4095
    analogSetCycles(8);                   // Set number of cycles per sample, default is 8 and provides an optimal result, range is 1 - 255
    analogSetSamples(1);                  // Set number of samples in the range, default is 1, it has an effect on sensitivity has been multiplied
    analogSetClockDiv(1);                 // Set the divider for the ADC clock, default is 1, range is 1 - 255
    analogSetAttenuation(ADC_11db);       // Sets the input attenuation for ALL ADC inputs, default is ADC_11db, range is ADC_0db, ADC_2_5db, ADC_6db, ADC_11db
    analogSetPinAttenuation(VP,ADC_11db); // Sets the input attenuation, default is ADC_11db, range is ADC_0db, ADC_2_5db, ADC_6db, ADC_11db
                                          // ADC_0db provides no attenuation so IN/OUT = 1 / 1 an input of 3 volts remains at 3 volts before ADC measurement
                                          // ADC_2_5db provides an attenuation so that IN/OUT = 1 / 1.34 an input of 3 volts is reduced to 2.238 volts before ADC measurement
                                          // ADC_6db provides an attenuation so that IN/OUT = 1 / 2 an input of 3 volts is reduced to 1.500 volts before ADC measurement
                                          // ADC_11db provides an attenuation so that IN/OUT = 1 / 3.6 an input of 3 volts is reduced to 0.833 volts before ADC measurement
    adcAttachPin(VP);                     // Attach a pin to ADC (also clears any other analog mode that could be on), returns TRUE/FALSE result
    adcStart(VP);                         // Starts an ADC conversion on attached pin's bus
    adcBusy(VP);                          // Check if conversion on the pin's ADC bus is currently running, returns TRUE/FALSE result
    adcEnd(VP);                           // Get the result of the conversion (will wait if it have not finished), returns 16-bit integer result
  */
  adcAttachPin(34);
  analogSetWidth(9);
  analogSetCycles(8);
  analogSetClockDiv(1); // 1338mS
  analogSetAttenuation(ADC_11db);
  analogSetPinAttenuation(34, ADC_11db);
  adcAttachPin(34);
  adcStart(34);
#endif

  // heltec screen
#ifdef HELTEC
  pinMode(16, OUTPUT);
  digitalWrite(16, LOW);    // set GPIO16 low to reset OLED
  delay(50);
  digitalWrite(16, HIGH); // while OLED is running, must set GPIO16 in high
#endif
  // heltec screen
  ui.init();// Initialising the UI will init the display too.
  display.flipScreenVertically();
  display.displayOn();
  display.setFont(ArialMT_Plain_24);
  display.setTextAlignment(TEXT_ALIGN_LEFT);
  display.drawString(0, 0, "Ave");
  display.drawXbm(50, 30, WiFi_Logo_width, WiFi_Logo_height, WiFi_Logo_bits);
  display.display();
  delay (2000);

  check_EEPROM ();

  pinMode(STATUS_LED, OUTPUT);
  pinMode(TOUCH_LED, OUTPUT);
  pinMode(WRITE_LED, OUTPUT);

  pinMode(DIRECTION_PIN, OUTPUT);

  uint8_t bootStatus = DMXWiFiConfig.begin(1);//aparently need to read from persistent to be able to write to it
  uint8_t dhcpStatus = 0;                     //hence, read in begin and replace below if startup pin is low


  DMXWiFiConfig.initConfig();

  dmx_direction = DMXWiFiConfig.inputToNetworkMode();

  if ( DMXWiFiConfig.APMode() ) {            // WiFi startup
#ifdef DEBUG
    Serial.print("AP_MODE ");
    Serial.print(DMXWiFiConfig.SSID());
#endif

    WiFi.mode(WIFI_AP);
    WiFi.softAP(DMXWiFiConfig.SSID(), DMXWiFiConfig.password(), wifichannel, hiddens);

#ifdef DEBUG
    Serial.print(" created access point at ");
    Serial.print(DMXWiFiConfig.apIPAddress());
    Serial.print(" accessPoint SSID ");
    Serial.println(DMXWiFiConfig.SSID());
    Serial.print(", ");
#endif

    WiFi.softAPConfig(DMXWiFiConfig.apIPAddress(), DMXWiFiConfig.apGateway(), DMXWiFiConfig.apSubnet());

  } else {
#ifdef DEBUG
    Serial.print("wifi connecting to ");
    Serial.print(DMXWiFiConfig.SSID());
    Serial.print("... ");
#endif

    WiFi.mode(WIFI_STA);
    strcpy(ssid, DMXWiFiConfig.SSID());
    strcpy(password, DMXWiFiConfig.password());
    WiFi.begin((const char*)ssid, (const char*)password);

    // static IP otherwise uses DHCP
    if ( DMXWiFiConfig.staticIPAddress() ) {
#ifdef DEBUG
      Serial.print("static IP");
#endif

      WiFi.config(DMXWiFiConfig.stationIPAddress(), DMXWiFiConfig.stationGateway(), DMXWiFiConfig.stationSubnet());

    } else {
      dhcpStatus = 1;
    }

    while (WiFi.status() != WL_CONNECTED)  {
      delay(100);
      blinkLED();

    }
#ifdef DEBUG
    Serial.print("wifi started ");
    Serial.println(WiFi.localIP());
#endif
  }
  display.clear();
  display.drawString(0, 0, "WIFI OK");
  display.display();
  delay(1000);

  //------------------- Initialize serialDMX  -------------------

  if ( dmx_direction == OUTPUT_FROM_NETWORK_MODE ) {                // DMX Driver startup based on direction flag
#ifdef DEBUG
    Serial.println("starting DMX");
#endif
  } else {
#ifdef DEBUG
    Serial.println("starting DMX input");
#endif
    ESP32DMX.setDirectionPin(DIRECTION_PIN);
    ESP32DMX.setDataReceivedCallback(&gotDMXCallback);
#ifdef HELTEC
    ESP32DMX.startInput(18);// U2_RX Gpio 18
#endif
#ifdef OLED
    ESP32DMX.startInput();// U2_RX Gpio 16 default
#endif
  }

  //------------------- Initialize network<->DMX interfaces -------------------

  sACNInterface = new LXWiFiSACN();
  sACNInterface->setUniverse(DMXWiFiConfig.sACNUniverse());

  artNetInterface = new LXWiFiArtNet(WiFi.localIP(), WiFi.subnetMask());
  artNetInterface->setUniverse(DMXWiFiConfig.artnetPortAddress());	//setUniverse for LXArtNet class sets complete Port-Address
  artNetInterface->setArtAddressReceivedCallback(&artAddressReceived);
  artNetInterface->setArtIpProgReceivedCallback(&artIpProgReceived);
  char* nn = DMXWiFiConfig.nodeName();
  if ( nn[0] != 0 ) {
    strcpy(artNetInterface->longName(), nn);
  }
  artNetInterface->setStatus2Flag(ARTNET_STATUS2_SACN_CAPABLE, 1);
  artNetInterface->setStatus2Flag(ARTNET_STATUS2_DHCP_CAPABLE, 1);
  if ( dhcpStatus ) {
    artNetInterface->setStatus2Flag(ARTNET_STATUS2_DHCP_USED, 1);
  }
  if ( bootStatus ) {
    artNetInterface->setStatus1Flag(ARTNET_STATUS1_FACTORY_BOOT, 1);
  }
#ifdef DEBUG
  Serial.print("interfaces created ");
#endif

  // if output from network, start wUDP listening for packets
  if ( dmx_direction == OUTPUT_FROM_NETWORK_MODE ) {
    if ( DMXWiFiConfig.multicastMode() ) {
      if ( DMXWiFiConfig.APMode() ) {
        sUDP.beginMulticast(DMXWiFiConfig.multicastAddress(), sACNInterface->dmxPort());  //WiFi.softAPIP(),
      } else {
        sUDP.beginMulticast(DMXWiFiConfig.multicastAddress(), sACNInterface->dmxPort());  //WiFi.localIP(),
      }
    } else {
      sUDP.begin(sACNInterface->dmxPort());
    }

    aUDP.begin(artNetInterface->dmxPort());
    artNetInterface->send_art_poll_reply(&aUDP);
#ifdef DEBUG
    Serial.print("udp started listening,");
#endif
  }
#ifdef DEBUG
  Serial.println(" setup complete.");
#endif

  blinkLED();


  // increase the priority of this task (main.cpp sets it at 1);
  vTaskPrioritySet(xTaskGetCurrentTaskHandle(), 2);
#ifdef DEBUG
  Serial.print("number of tasks is ");
  Serial.println(uxTaskGetNumberOfTasks());
#endif

#ifdef HELTEC
  getLevel();
#endif
  info();

} //setup



/************************************************************************

  Main loop

  if OUTPUT_FROM_NETWORK_MODE:
    checks for and reads packets from WiFi UDP socket
    connection.  readDMXPacket() returns true when a DMX packet is received.

    If dmx is received on either interface, copy from both (HTP) to dmx output.

    If the packet is an CONFIG_PACKET_IDENT packet, the config struct is modified and stored in EEPROM

  if INPUT_TO_NETWORK_MODE:
    if serial dmx has been received, sends an sACN or Art-Net packet containing the dmx data.
    Note:  does not listen for incoming packets for remote configuration in this mode.

*************************************************************************/

void loop() {
  now = millis();
  if (screen == 1) {
    if (now - last_screen_check_time > SCREEN_TIMEOUT) {
#ifdef DEBUG
      Serial.print("shutdown screen... ");
#endif
      shutdown_screen();
    }
#ifdef HELTEC
    if (now - last_bat_check_time > bat_check) {
#ifdef DEBUG
      Serial.println("getLevel();");
#endif
      getLevel();
      if (frameCountnow == 1 && levelold != level) {
        levelold = level;
        info();
      }//info
      last_bat_check_time = now;
    }
#endif
  }//if (screen==1)

  if ( dmx_direction == OUTPUT_FROM_NETWORK_MODE ) {

    art_packet_result = artNetInterface->readDMXPacket(&aUDP);
    if ( art_packet_result == RESULT_NONE ) {
      checkConfigReceived(artNetInterface, &aUDP);
    }
    vTaskDelay(1);

    acn_packet_result = sACNInterface->readDMXPacket(&sUDP);
    if ( acn_packet_result == RESULT_NONE ) {
      checkConfigReceived(sACNInterface, &sUDP);
    }
    vTaskDelay(1);

    if ( (art_packet_result == RESULT_DMX_RECEIVED) || (acn_packet_result == RESULT_DMX_RECEIVED) ) {
      copyDMXToOutput();
      Serial.println ("art_packet ");
      led_state_r = 0;
      blinkLEDR();
      blinkLED();
    } else {
      Serial.println ("art_packet else ");
      led_state = 0;
      blinkLED();
      blinkLEDR();
    }

  } else {    //direction is input to network

    if ( DMXWiFiConfig.sACNMode() ) {
      checkInput(sACNInterface, &sUDP, DMXWiFiConfig.multicastMode());
    } else {
      checkInput(artNetInterface, &aUDP, 0);
    }

  }

  vTaskDelay(1);
  check_btn();

}// loop()

