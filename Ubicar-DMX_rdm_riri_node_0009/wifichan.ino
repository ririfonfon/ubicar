void wifichan () {
  DisplayClear16 ();
  display.drawString(20, 0, "Wifi Channel");
  display.drawString(50, 16, String(wifichannel));
  display.display();
}//wifichan

void wifichanenter () {
  display.invertDisplay();
  DisplayClear16 ();
  display.drawString(20, 0, "Wifi Channel");
  display.drawString(50, 16, String(wifichannel));
  display.display();
}//wifichanset

void wifichanstore () {
  display.invertDisplay();
  DisplayClear16 ();
  display.drawString(20, 0, "Wifi Channel");
  display.drawString(50, 16, String(wifichannel));
  display.drawString(15, 32, "....STORE....");
  display.display();
  EEPROM.write(3, wifichannel);
  EEPROM.commit();
  delay(100);
  display.invertDisplay();
  delay(100);
  display.normalDisplay();
  delay(100);
  display.invertDisplay();
  delay(100);
  display.normalDisplay();
  enter = 0;
}//wifichanstore
