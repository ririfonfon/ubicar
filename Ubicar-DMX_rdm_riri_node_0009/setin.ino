void setin () {
  DisplayClear16 ();
  display.drawString(20, 0, "DMX Input");
  display.drawString(50, 16, String(dmx_start));
  display.display();
}//setin

void setinenter () {
  display.invertDisplay();
  DisplayClear16 ();
  display.drawString(20, 0, "DMX Input");
  display.drawString(50, 16, String(dmx_start));
  display.display();
}//setinenter

void setinstore () {
  display.normalDisplay();
  DisplayClear16 ();
  display.drawString(20, 0, "DMX Input");
  display.drawString(50, 16, String(dmx_start));
  display.drawString(15, 32, "....STORE....");
  display.display();
  EEPROM.write(1, dmx_start);
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
}//setinenter
