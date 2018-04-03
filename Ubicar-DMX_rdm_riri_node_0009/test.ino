int M0[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int M1[] = {127, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int M2[] = {127, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int M3[] = {127, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int M4[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 127, 0, 0, 0, 0, 0, 0};

void test() {
  DisplayClear16 ();
  display.drawString(20, 0, "Test");
  display.display();
}//test

void testenter() {
  DisplayClear16 ();
  display.drawString(30, 0, "Test");
  if (mode_test == 1) {
    display.drawString(45, 16, "Red");
  }//mode test 1
  else if (mode_test == 2) {
    display.drawString(45, 16, "Green");
  }//mode test 2
  else if (mode_test == 3) {
    display.drawString(45, 16, "Blue");
  }//mode test 3
  else if (mode_test == 4) {
    display.drawString(45, 16, "Leds");
  }//mode test 3
  display.display();
  test_btn();
}//testenter

void test_btn() {
  while (menu == 10) {
    if (button9.onPressed()) {
      display.normalDisplay();
      test_0(artNetInterface, &aUDP, 0);
      screen = 1;
      last_screen_check_time = millis();
      menu = 0;
      info();
    }//menu
    else if (button8.onPressed()) {
      display.normalDisplay();
      mode_test += 1;
      if (mode_test >= 5) mode_test = 1;
      testenter();
    }//up
    else if (button7.onPressed()) {
      display.normalDisplay();
      mode_test -= 1;
      if (mode_test <= 0) mode_test = 4;
      testenter();
    }//down
    else if (button6.onPressed()) {
      display.invertDisplay();
      if (mode_test == 1) {
        test_r(artNetInterface, &aUDP, 0);
      }//red
      else if (mode_test == 2) {
        test_g(artNetInterface, &aUDP, 0);
      }//green
      else if (mode_test == 3) {
        test_b(artNetInterface, &aUDP, 0);
      }//blue
      else if (mode_test == 4) {
        test_l(artNetInterface, &aUDP, 0);
      }//leds
    }//enter
  }//menu == 10
}//test_btn

void test_0(LXDMXWiFi* interface, WiFiUDP* iUDP, uint8_t multicast) {
  interface->setNumberOfSlots(512);
  for (int k = 0; k < 17 ; k++) {
    interface->setSlot(k + 1, M0[k]);
    interface->setSlot(k + 18, M0[k]);
    interface->setSlot(k + 35, M0[k]);
  }//for
  xSemaphoreGive( ESP32DMX.lxDataLock );
  if ( multicast ) {
      interface->sendDMX(iUDP, DMXWiFiConfig.inputAddress(), WiFi.localIP());
    } else {
      interface->sendDMX(iUDP, DMXWiFiConfig.inputAddress(), INADDR_NONE);
    }
    blinkLED();
}//test_0

void test_r(LXDMXWiFi* interface, WiFiUDP* iUDP, uint8_t multicast) {
  interface->setNumberOfSlots(512);
  for (int k = 0; k < 17 ; k++) {
    interface->setSlot(k + 1, M1[k]);
    interface->setSlot(k + 18, M1[k]);
    interface->setSlot(k + 35, M1[k]);
  }//for
  xSemaphoreGive( ESP32DMX.lxDataLock );
  if ( multicast ) {
      interface->sendDMX(iUDP, DMXWiFiConfig.inputAddress(), WiFi.localIP());
    } else {
      interface->sendDMX(iUDP, DMXWiFiConfig.inputAddress(), INADDR_NONE);
    }
    blinkLED();
}//test_r

void test_g(LXDMXWiFi* interface, WiFiUDP* iUDP, uint8_t multicast) {
  interface->setNumberOfSlots(512);
  for (int k = 0; k < 17 ; k++) {
    interface->setSlot(k + 1, M2[k]);
    interface->setSlot(k + 18, M2[k]);
    interface->setSlot(k + 35, M2[k]);
  }//for
  xSemaphoreGive( ESP32DMX.lxDataLock );
  if ( multicast ) {
      interface->sendDMX(iUDP, DMXWiFiConfig.inputAddress(), WiFi.localIP());
    } else {
      interface->sendDMX(iUDP, DMXWiFiConfig.inputAddress(), INADDR_NONE);
    }
    blinkLED();
}//test_g

void test_b(LXDMXWiFi* interface, WiFiUDP* iUDP, uint8_t multicast) {
  interface->setNumberOfSlots(512);
  for (int k = 0; k < 17 ; k++) {
    interface->setSlot(k + 1, M3[k]);
    interface->setSlot(k + 18, M3[k]);
    interface->setSlot(k + 35, M3[k]);
  }//for
  xSemaphoreGive( ESP32DMX.lxDataLock );
  if ( multicast ) {
      interface->sendDMX(iUDP, DMXWiFiConfig.inputAddress(), WiFi.localIP());
    } else {
      interface->sendDMX(iUDP, DMXWiFiConfig.inputAddress(), INADDR_NONE);
    }
    blinkLED();
}//test_b

void test_l(LXDMXWiFi* interface, WiFiUDP* iUDP, uint8_t multicast) {
  interface->setNumberOfSlots(512);
  for (int k = 0; k < 17 ; k++) {
    interface->setSlot(k + 1, M4[k]);
    interface->setSlot(k + 18, M4[k]);
    interface->setSlot(k + 35, M4[k]);
  }//for
  xSemaphoreGive( ESP32DMX.lxDataLock );
  if ( multicast ) {
      interface->sendDMX(iUDP, DMXWiFiConfig.inputAddress(), WiFi.localIP());
    } else {
      interface->sendDMX(iUDP, DMXWiFiConfig.inputAddress(), INADDR_NONE);
    }
    blinkLED();
}//test_l

//checkInput(artNetInterface, &aUDP, 0);
//void test_out(LXDMXWiFi* interface, WiFiUDP* iUDP, uint8_t multicast) {
//  if ( got_dmx ) {
//    // interface->setNumberOfSlots(got_dmx);     // set slots & copy to interface
//    interface->setNumberOfSlots(512);      // set slots 512 & copy to interface
//
//    xSemaphoreTake( ESP32DMX.lxDataLock, portMAX_DELAY );
//    for (int i = dmx_start; i <= got_dmx; i++) {
//      interface->setSlot((i - dmx_start + 1), ESP32DMX.getSlot(i));
//    }
//    /////////////////////////////////////////////////////////////////
//    //////                   mode set                          //////
//    /////////////////////////////////////////////////////////////////
//    if (mode_start == 1) {
//      mode_start_value = 10;
//    }//mode start 1
//    if (mode_start == 2) {
//      mode_start_value = 100;
//    }//mode start 2
//    if (mode_start == 3) {
//      mode_start_value = 200;
//    }//mode start 3
//    interface->setSlot(512, mode_start_value);
//    xSemaphoreGive( ESP32DMX.lxDataLock );
//
//    if ( multicast ) {
//      interface->sendDMX(iUDP, DMXWiFiConfig.inputAddress(), WiFi.localIP());
//    } else {
//      interface->sendDMX(iUDP, DMXWiFiConfig.inputAddress(), INADDR_NONE);
//    }
//    got_dmx = 0;
//    blinkLED();
//  }
//}//checkInput
