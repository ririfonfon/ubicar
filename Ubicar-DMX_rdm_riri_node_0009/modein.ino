void modein () {
  DisplayClear16 ();
  display.drawString(30, 0, "MODE IN");
  if (mode_start == 1) {
    display.drawString(45, 16, "FULL");
  }//mode start 1
  if (mode_start == 2) {
    display.drawString(45, 16, "CLUB");
  }//mode start 2
  if (mode_start == 3) {
    display.drawString(45, 16, "MINI");
  }//mode start 3
  display.display();
}//modein

void modeinenter () {
  display.invertDisplay();
  DisplayClear16 ();
  display.drawString(30, 0, "MODE IN");
  if (mode_start == 1) {
    display.drawString(45, 16, "FULL");
  }//mode start 1
  if (mode_start == 2) {
    display.drawString(45, 16, "CLUB");
  }//mode start 2
  if (mode_start == 3) {
    display.drawString(45, 16, "MINI");
  }//mode start 3
  display.display();
}//modeinenter

void modeinstore () {
  display.invertDisplay();
  DisplayClear16 ();
  display.drawString(30, 0, "MODE IN");
  if (mode_start == 1) {
    display.drawString(45, 16, "FULL");
  }//mode start 1
  if (mode_start == 2) {
    display.drawString(45, 16, "CLUB");
  }//mode start 2
  if (mode_start == 3) {
    display.drawString(45, 16, "MINI");
  }//mode start 3
  display.drawString(15, 32, "....STORE....");
  display.display();
  EEPROM.write(2, mode_start);
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

}//modeinstore
