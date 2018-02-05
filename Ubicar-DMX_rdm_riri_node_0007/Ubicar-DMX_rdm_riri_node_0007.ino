/**************************************************************************/
/*!
    @file     DMX_node_riri
    @author   Claude Heintz
    @license  BSD (see LXDMXWiFi.h)
    @copyright 2017 by Claude Heintz All Rights Reserved

           https://github.com/claudeheintz/LXESP32DMX

*/
/**************************************************************************/
//#define DEBUG 1

//#define HELTEC 1
#define OLED 1

#include "EEPROM.h"
#define EEPROM_SIZE 64
    int dmx_start;
    int mode_start;
    int wifichannel;
    int hidden;
    int hiddens;

 #include <Wire.h>  // Only needed for Arduino 1.6.5 and earlier
 #include "SSD1306.h" // alias for `#include "SSD1306Wire.h"`
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

uint8_t init_btn9=0;
uint8_t init_btn8=0;
uint8_t init_btn7=0;
uint8_t init_btn6=0;

int frameCount = 5;
int frameCountnow = 0;
int enter = 0;

#define SCREEN_TIMEOUT 30000
unsigned long last_screen_check_time = 0;
uint8_t screen =1;
unsigned long now;

int mode_start_value=0;

 


#include <LXESP32DMX.h>
#include <UID.h>
#include <TOD.h>
#include <rdm_utility.h>
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

// RDM defines
//#define DISC_STATE_SEARCH 0
//#define DISC_STATE_TBL_CK 1
/*
   If RDM_DISCOVER_ALWAYS == 0, the times RDM discovery runs is limited to 10 cycles
   of table check and search.  When rdm_discovery_enable reaches zero, continous RDM
   discovery stops.  Other ArtRDM packets continue to be relayed.
   If an Art-Net TODRequest or TODControl packet is received, the rdm_discovery_enable
   counter is reset and discovery runs again until rdm_discovery_enable reaches zero.
*/
//#define RDM_DISCOVER_ALWAYS 0

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

//// RDM globals
//uint8_t rdm_enabled = 0;                      // global RDM flag
//uint8_t rdm_discovery_enable = 10;            // limit RDM discovery which can cause flicker in some equipment
//uint8_t discovery_state = DISC_STATE_TBL_CK;  // alternates between checking the TOD and discovery search
//uint8_t discovery_tbl_ck_index = 0;           // next entry in table to check by sending DISC_MUTE
//uint8_t tableChangedFlag = 0;                 // set when TOD is changed by device added or removed
//uint8_t idle_count = 0;                       // count to determine cycles devoted to RDM discovery
//TOD tableOfDevices;                           // UUIDs of found devices
//TOD discoveryTree;                            // stack of UUID ranges for discovery search

UID lower(0, 0, 0, 0, 0, 0);
UID upper(0, 0, 0, 0, 0, 0);
UID mid(0, 0, 0, 0, 0, 0);
UID found(0, 0, 0, 0, 0, 0);

// used to toggle indicator LED on and off
uint8_t led_state = 0;
uint8_t led_state_r = 0;

/*
   utility function to toggle indicator LED on/off
*/
void blinkLED() {
  if ( led_state==1 ) {
    digitalWrite(STATUS_LED, HIGH);
    led_state = 0;
  } else {
    digitalWrite(STATUS_LED, LOW);
    led_state = 1;
  }
}

void blinkLEDR() {
  if ( led_state_r==1 ) {
    digitalWrite(TOUCH_LED, HIGH);
    led_state_r = 0;
  } else {
    digitalWrite(TOUCH_LED, LOW);
    led_state_r = 1;
  }
}

/*
   artAddress callback allows storing of config information
   artAddress may or may not have set this information
   but relevant fields are copied to config struct and stored to EEPROM
*/
void artAddressReceived() {
  DMXWiFiConfig.setArtNetPortAddress( artNetInterface->universe() );
  DMXWiFiConfig.setNodeName( artNetInterface->longName() );
  DMXWiFiConfig.commitToPersistentStore();
}

//void artTodRequestReceived(uint8_t* pdata) {
////  rdm_discovery_enable = 10;
//  artNetInterface->send_art_tod(&aUDP, tableOfDevices.rawBytes(), tableOfDevices.count());
//}

//void artRDMReceived(uint8_t* pdata) {
//  uint8_t plen = pdata[1] + 2;
//  uint8_t j;
//
//  //copy into ESP32DMX outgoing packet
//  uint8_t* pkt = ESP32DMX.rdmData();
//  for (j = 0; j < plen; j++) {
//    pkt[j + 1] = pdata[j];
//  }
//  pkt[0] = 0xCC;
//
//
//  if ( ESP32DMX.sendRDMControllerPacket() ) {
//    artNetInterface->send_art_rdm(&aUDP, ESP32DMX.receivedRDMData(), aUDP.remoteIP());
//  }
//}//artRDMReceived(uint8_t* pdata)

/*
   artIpProg callback allows storing of config information
   cmd field bit 7 indicates that settings should be programmed
*/
void artIpProgReceived(uint8_t cmd, IPAddress addr, IPAddress subnet) {
  if ( cmd & 0x80 ) {
    if ( cmd & 0x40 ) {	//enable dhcp, other fields not written
      if ( DMXWiFiConfig.staticIPAddress() ) {
        DMXWiFiConfig.setStaticIPAddress(0);
      } else {
        return;	// already set to dhcp
      }
    } else {
      if ( ! DMXWiFiConfig.staticIPAddress() ) {
        DMXWiFiConfig.setStaticIPAddress(1);	// static not dhcp
      }
      if ( cmd & 0x08 ) {	//factory reset
        DMXWiFiConfig.initConfig();
      } else {
        if ( cmd & 0x04 ) {	//programIP
          DMXWiFiConfig.setStationIPAddress(addr);
        }
        if ( cmd & 0x02 ) {	//programSubnet
          DMXWiFiConfig.setStationSubnetMask(subnet);
        }
      }
    }	// else ( ! dhcp )

    DMXWiFiConfig.commitToPersistentStore();
  }
}//artIpProgReceived(uint8_t cmd, IPAddress addr, IPAddress subnet)

/*
  DMX input callback function sets number of slots received by ESP32DMX
*/

void gotDMXCallback(int slots) {
  got_dmx = slots;
}

/************************************************************************/

//uint8_t testMute(UID u) {
//  // try three times to get response when sending a mute message
//  if ( ESP32DMX.sendRDMDiscoveryMute(u, RDM_DISC_MUTE) ) {
//    return 1;
//  }
//  if ( ESP32DMX.sendRDMDiscoveryMute(u, RDM_DISC_MUTE) ) {
//    return 1;
//  }
//  if ( ESP32DMX.sendRDMDiscoveryMute(u, RDM_DISC_MUTE) ) {
//    return 1;
//  }
//  return 0;
//}//testMute(UID u)

//void checkDeviceFound(UID found) {
//  if ( testMute(found) ) {
//    tableOfDevices.add(found);
//    tableChangedFlag = 1;
//  }
//}//checkDeviceFound(UID found)

//uint8_t checkTable(uint8_t ck_index) {
//  if ( ck_index == 0 ) {
//    ESP32DMX.sendRDMDiscoveryMute(BROADCAST_ALL_DEVICES_ID, RDM_DISC_UNMUTE);
//  }//checkTable(uint8_t ck_index)
//
//  if ( tableOfDevices.getUIDAt(ck_index, &found) )  {
//    if ( testMute(found) ) {
//      // device confirmed
//      return ck_index += 6;
//    }
//
//    // device not found
//    tableOfDevices.removeUIDAt(ck_index);
//    tableChangedFlag = 1;
//    return ck_index;
//  }
//  // index invalid
//  return 0;
//}//checkTable(uint8_t ck_index)

//called when range responded, so divide into sub ranges push them on stack to be further checked
//void pushActiveBranch(UID lower, UID upper) {
//  if ( mid.becomeMidpoint(lower, upper) ) {
//    discoveryTree.push(lower);
//    discoveryTree.push(mid);
//    discoveryTree.push(mid);
//    discoveryTree.push(upper);
//  } else {
//    // No midpoint possible:  lower and upper are equal or a 1 apart
//    checkDeviceFound(lower);
//    checkDeviceFound(upper);
//  }
//}//pushActiveBranch(UID lower, UID upper)

//void pushInitialBranch() {
//  lower.setBytes(0);
//  upper.setBytes(BROADCAST_ALL_DEVICES_ID);
//  discoveryTree.push(lower);
//  discoveryTree.push(upper);
//
//  //ETC devices seem to only respond with wildcard or exact manufacturer ID
//  lower.setBytes(0x657400000000);
//  upper.setBytes(0x6574FFFFFFFF);
//  discoveryTree.push(lower);
//  discoveryTree.push(upper);
//}//pushInitialBranch()

//uint8_t checkNextRange() {
//  if ( discoveryTree.pop(&upper) ) {
//    if ( discoveryTree.pop(&lower) ) {
//      if ( lower == upper ) {
//        checkDeviceFound(lower);
//      } else {        //not leaf so, check range lower->upper
//        uint8_t result = ESP32DMX.sendRDMDiscoveryPacket(lower, upper, &found);
//        if ( result ) {
//          //this range responded, so divide into sub ranges push them on stack to be further checked
//          pushActiveBranch(lower, upper);
//
//        } else if ( ESP32DMX.sendRDMDiscoveryPacket(lower, upper, &found) ) {
//          pushActiveBranch(lower, upper); //if discovery fails, try a second time
//        }
//      }         // end check range
//      return 1; // UID ranges may be remaining to test
//    }           // end valid pop
//  }             // end valid pop
//  return 0;     // none left to pop
//}//checkNextRange()

//void sendTODifChanged() {
//  if ( tableChangedFlag ) {   //if the table has changed...
//    tableChangedFlag--;
//
//    artNetInterface->send_art_tod(&aUDP, tableOfDevices.rawBytes(), tableOfDevices.count());
//#ifdef DEBUG
//    Serial.println("_______________ Table Of Devices _______________");
//#endif    
//    tableOfDevices.printTOD();
//  }
//}//sendTODifChanged()

//void updateRDMDiscovery() {
//  if ( rdm_discovery_enable ) {  // run RDM updates for a limited number of times
//    if ( discovery_state ) {
//      // check the table of devices
//      discovery_tbl_ck_index = checkTable(discovery_tbl_ck_index);
//
//      if ( discovery_tbl_ck_index == 0 ) {
//        // done with table check
//        discovery_state = DISC_STATE_SEARCH;
//        pushInitialBranch();
//
//        sendTODifChanged();
//      } //end table check ended
//    } else {    // search for devices in range popped from discoveryTree
//
//      if ( checkNextRange() == 0 ) {
//        // done with search
//        discovery_tbl_ck_index = 0;
//        discovery_state = DISC_STATE_TBL_CK;
//
//        sendTODifChanged();
//        if ( RDM_DISCOVER_ALWAYS == 0 ) {
//          rdm_discovery_enable--;
//        }
//      }
//    }           //end search
//  }             // discovery enabled
//}//updateRDMDiscovery()


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
  // heltec screen
  #ifdef HELTEC 
  pinMode(16,OUTPUT);
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
  display.drawXbm(50,30, WiFi_Logo_width, WiFi_Logo_height, WiFi_Logo_bits);
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
  //rdm_enabled   = DMXWiFiConfig.rdmMode();
  //rdm_enabled   = 0;off

  if ( DMXWiFiConfig.APMode() ) {            // WiFi startup
    #ifdef DEBUG
    Serial.print("AP_MODE ");
    Serial.print(DMXWiFiConfig.SSID());
    #endif
    
    WiFi.mode(WIFI_AP);
    
    WiFi.softAP(DMXWiFiConfig.SSID(), DMXWiFiConfig.password(),wifichannel,hiddens);

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
    ESP32DMX.startRDM(DIRECTION_PIN);
  } else {
    #ifdef DEBUG
    Serial.println("starting DMX input");
    #endif
    ESP32DMX.setDirectionPin(DIRECTION_PIN);
    ESP32DMX.setDataReceivedCallback(&gotDMXCallback);
    ESP32DMX.startInput();
  }

  //------------------- Initialize network<->DMX interfaces -------------------

  sACNInterface = new LXWiFiSACN();
  sACNInterface->setUniverse(DMXWiFiConfig.sACNUniverse());

  artNetInterface = new LXWiFiArtNet(WiFi.localIP(), WiFi.subnetMask());
  artNetInterface->setUniverse(DMXWiFiConfig.artnetPortAddress());	//setUniverse for LXArtNet class sets complete Port-Address
  artNetInterface->setArtAddressReceivedCallback(&artAddressReceived);
  artNetInterface->setArtIpProgReceivedCallback(&artIpProgReceived);
//  artNetInterface->setArtTodRequestCallback(&artTodRequestReceived);
//  artNetInterface->setArtRDMCallback(&artRDMReceived);
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
//  if ( rdm_enabled ) {
//    #ifdef DEBUG
//    Serial.println("rdm_enabled");
//    #endif
//    artNetInterface->setStatus1Flag(ARTNET_STATUS1_RDM_CAPABLE, 1);
//  }//( rdm_enabled )
  artNetInterface->setStatus1Flag(ARTNET_STATUS1_RDM_CAPABLE, 1);
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

  info();

} //setup

/************************************************************************

  Copy to output merges slots for Art-Net and sACN on HTP basis

*************************************************************************/

void copyDMXToOutput(void) {
  uint8_t a, s;
  uint16_t a_slots = artNetInterface->numberOfSlots();
  uint16_t s_slots = sACNInterface->numberOfSlots();
  xSemaphoreTake( ESP32DMX.lxDataLock, portMAX_DELAY );
  for (int i = 1; i <= DMX_UNIVERSE_SIZE; i++) {
    if ( i <= a_slots ) {
      a = artNetInterface->getSlot(i);
    } else {
      a = 0;
    }
    if ( i <= s_slots ) {
      s = sACNInterface->getSlot(i);
    } else {
      s = 0;
    }
    if ( a > s ) {
      ESP32DMX.setSlot(i , a);
    } else {
      ESP32DMX.setSlot(i , s);
    }
  }
  ESP32DMX.setMaxSlots(512);
  xSemaphoreGive( ESP32DMX.lxDataLock );
}//copyDMXToOutput

/************************************************************************

  Checks to see if packet is a config packet.

     In the case it is a query, it replies with the current config from persistent storage.

     In the case of upload, it copies the payload to persistent storage
     and also replies with the config settings.

*************************************************************************/

void checkConfigReceived(LXDMXWiFi* interface, WiFiUDP* cUDP) {
  if ( strcmp(CONFIG_PACKET_IDENT, (const char *) interface->packetBuffer()) == 0 ) {	//match header to config packet
    #ifdef DEBUG
    Serial.print("config packet received, ");
    #endif
    uint8_t reply = 0;
    if ( interface->packetBuffer()[8] == '?' ) {	//packet opcode is query
      DMXWiFiConfig.readFromPersistentStore();
      reply = 1;
    } else if (( interface->packetBuffer()[8] == '!' ) && (interface->packetSize() >= 171)) { //packet opcode is set
      #ifdef DEBUG
      Serial.println("upload packet");
      #endif
      DMXWiFiConfig.copyConfig( interface->packetBuffer(), interface->packetSize());
      DMXWiFiConfig.commitToPersistentStore();
      reply = 1;
    } else if ( interface->packetBuffer()[8] == '^' ) {
      ESP.restart();
    } else {
      #ifdef DEBUG
      Serial.println("unknown config opcode.");
      #endif
    }
    if ( reply) {
      DMXWiFiConfig.hidePassword();													// don't transmit password!
      cUDP->beginPacket(cUDP->remoteIP(), interface->dmxPort());				// unicast reply
      cUDP->write((uint8_t*)DMXWiFiConfig.config(), DMXWiFiConfigSIZE);
      cUDP->endPacket();
      #ifdef DEBUG
      Serial.println(DMXWiFiConfig.SSID());
      Serial.println("reply complete.");
      #endif
      DMXWiFiConfig.restorePassword();
    }
    interface->packetBuffer()[0] = 0; //insure loop without recv doesn't re-trigger
    interface->packetBuffer()[1] = 0;
    blinkLED();
    delay(50);
    blinkLED();
    delay(50);
  }		// packet has config packet header

}//checkConfigReceived

/************************************************************************

  Checks to see if the dmx callback indicates received dmx
     If so, send it using the selected interface.

*************************************************************************/

void checkInput(LXDMXWiFi* interface, WiFiUDP* iUDP, uint8_t multicast) {
  if ( got_dmx ) {
   // interface->setNumberOfSlots(got_dmx);			// set slots & copy to interface
    interface->setNumberOfSlots(512);      // set slots 512 & copy to interface

    xSemaphoreTake( ESP32DMX.lxDataLock, portMAX_DELAY );
    for (int i = dmx_start; i <= got_dmx; i++) {
      interface->setSlot((i-dmx_start+1), ESP32DMX.getSlot(i));
    }
  /////////////////////////////////////////////////////////////////
  //////                   mode set                          //////
  /////////////////////////////////////////////////////////////////
  if (mode_start==1) {
    mode_start_value=10;
    }//mode start 1
    if (mode_start==2) {
    mode_start_value=100;
    }//mode start 2
    if (mode_start==3) {
    mode_start_value=200;
    }//mode start 3
    interface->setSlot(512, mode_start_value);
    xSemaphoreGive( ESP32DMX.lxDataLock );
    
    if ( multicast ) {
      interface->sendDMX(iUDP, DMXWiFiConfig.inputAddress(), WiFi.localIP());
    } else {
      interface->sendDMX(iUDP, DMXWiFiConfig.inputAddress(), INADDR_NONE);
    }
    got_dmx = 0;
    blinkLED();
  } 
}//checkInput

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
  if (screen==1) {
    if(now - last_screen_check_time > SCREEN_TIMEOUT) {
      #ifdef DEBUG
      Serial.print("shutdown screen... ");
      #endif
      shutdown_screen();
    }
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
      // output was not updated last 5 times through loop so use a cycle to perform the next step of RDM discovery
//      if ( rdm_enabled ) {
//        idle_count++;
//        if ( idle_count > 5 ) {
//          updateRDMDiscovery();
//          idle_count = 0;
//        }
//      }
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

