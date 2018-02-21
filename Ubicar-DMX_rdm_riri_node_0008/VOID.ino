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

void artAddressReceived() {
  DMXWiFiConfig.setArtNetPortAddress( artNetInterface->universe() );
  DMXWiFiConfig.setNodeName( artNetInterface->longName() );
  DMXWiFiConfig.commitToPersistentStore();
}

/*
   artIpProg callback allows storing of config information
   cmd field bit 7 indicates that settings should be programmed
*/
void artIpProgReceived(uint8_t cmd, IPAddress addr, IPAddress subnet) {
  if ( cmd & 0x80 ) {
    if ( cmd & 0x40 ) {  //enable dhcp, other fields not written
      if ( DMXWiFiConfig.staticIPAddress() ) {
        DMXWiFiConfig.setStaticIPAddress(0);
      } else {
        return; // already set to dhcp
      }
    } else {
      if ( ! DMXWiFiConfig.staticIPAddress() ) {
        DMXWiFiConfig.setStaticIPAddress(1);  // static not dhcp
      }
      if ( cmd & 0x08 ) { //factory reset
        DMXWiFiConfig.initConfig();
      } else {
        if ( cmd & 0x04 ) { //programIP
          DMXWiFiConfig.setStationIPAddress(addr);
        }
        if ( cmd & 0x02 ) { //programSubnet
          DMXWiFiConfig.setStationSubnetMask(subnet);
        }
      }
    } // else ( ! dhcp )

    DMXWiFiConfig.commitToPersistentStore();
  }
}//artIpProgReceived(uint8_t cmd, IPAddress addr, IPAddress subnet)

/*
  DMX input callback function sets number of slots received by ESP32DMX
*/
void gotDMXCallback(int slots) {
  got_dmx = slots;
}

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
  if ( strcmp(CONFIG_PACKET_IDENT, (const char *) interface->packetBuffer()) == 0 ) {  //match header to config packet
    #ifdef DEBUG
    Serial.print("config packet received, ");
    #endif
    uint8_t reply = 0;
    if ( interface->packetBuffer()[8] == '?' ) {  //packet opcode is query
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
      DMXWiFiConfig.hidePassword();                         // don't transmit password!
      cUDP->beginPacket(cUDP->remoteIP(), interface->dmxPort());        // unicast reply
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
  }   // packet has config packet header

}//checkConfigReceived

/************************************************************************

  Checks to see if the dmx callback indicates received dmx
     If so, send it using the selected interface.

*************************************************************************/

void checkInput(LXDMXWiFi* interface, WiFiUDP* iUDP, uint8_t multicast) {
  if ( got_dmx ) {
   // interface->setNumberOfSlots(got_dmx);     // set slots & copy to interface
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
