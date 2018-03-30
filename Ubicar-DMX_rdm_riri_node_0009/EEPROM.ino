void check_EEPROM () {
  if (!EEPROM.begin(EEPROM_SIZE)) {
#ifdef DEBUG
    Serial.println("failed to initialise EEPROM"); delay(1000000);
#endif
    DisplayClear10 ();
    display.drawString(0, 0, "failed to initialise EEPROM");
    display.display();
    delay(10000);
    display.drawString(0, 10, "Formate EEPROM");
    display.display();
    for (int i = 0 ; i < EEPROM_SIZE ; i++) {
      EEPROM.write(i, '\0');
      if (i % 50 == 0)delay(100);
    }
    display.drawString(0, 20, "EEPROM content cleared!");
    display.display();
    delay(1000);
    int dmx_start = 1;
    int mode_start = 1;
    int wifichannel = 1;
    int hiddens = true;
    EEPROM.write(1, dmx_start);
    EEPROM.write(2, mode_start);
    EEPROM.write(3, wifichannel);
    EEPROM.write(4, hiddens);
    EEPROM.write(62, 'O');
    EEPROM.write(63, 'K');
    EEPROM.commit();
  }//!EEPROM.begin(EEPROM_SIZE)

  if (EEPROM.read(62) != 'O' || EEPROM.read(63) != 'K') {
    DisplayClear10 ();
    display.drawString(0, 0, "failed to initialise EEPROM");
    display.display();
    delay(10000);
    display.drawString(0, 10, "Formate EEPROM");
    display.display();
    for (int i = 0 ; i < EEPROM_SIZE ; i++) {
      EEPROM.write(i, '\0');
      if (i % 50 == 0)delay(100);
    }
    display.drawString(0, 20, "EEPROM content cleared!");
    display.display();
    delay(1000);
    dmx_start = 1;
    mode_start = 1;
    wifichannel = 1;
    hiddens = true;
    EEPROM.write(1, dmx_start);
    EEPROM.write(2, mode_start);
    EEPROM.write(3, wifichannel);
    EEPROM.write(4, hiddens);
    EEPROM.write(62, 'O');
    EEPROM.write(63, 'K');
    EEPROM.commit();
  }//(EEPROM.read(62) != 'O' || EEPROM.read(63) != 'K')

  if (EEPROM.begin(EEPROM_SIZE)) {
    dmx_start = EEPROM.read(1);
    mode_start = EEPROM.read(2);
    wifichannel = EEPROM.read(3);
    hiddens = EEPROM.read(4);
    DisplayClear10 ();
    display.drawString(0, 0, "EEPROM READ");
    display.drawString(0, 10, "DMX Start ");
    display.drawString(55, 10, String(dmx_start));
    display.drawString(0, 20, "Mode Start ");
    if (mode_start == 1) {
      display.drawString(55, 20, "FULL");
    }//mode start 1
    if (mode_start == 2) {
      display.drawString(55, 20, "CLUB");
    }//mode start 2
    if (mode_start == 3) {
      display.drawString(55, 20, "MINI");
    }//mode start 3
    display.drawString(0, 30, "Wifi Channel ");
    display.drawString(55, 30, String(wifichannel));
    display.drawString(0, 40, "Wifi Hidden ");
    if (hiddens == true) {
      hidden = 1;
      display.drawString(55, 40, "Visible");
    }//hidden 1
    if (hiddens == false) {
      hidden = 2;
      display.drawString(55, 40, "Cacher");
    }//hidden 2
    display.display();
    delay(1000);
  }//(EEPROM.begin(EEPROM_SIZE)
}//check_EEPROM
