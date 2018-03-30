void hidd () {
  DisplayClear16 ();
  display.drawString(20, 0, "Wifi Hidden");
  if (hidden == 1) {
    display.drawString(45, 16, "Cacher");
  }//hidden 1
  if (hidden == 2) {
    display.drawString(45, 16, "Visible");
  }//hidden 2
  display.display();
}//hidd

void hiddenter () {
  DisplayClear16 ();
  display.drawString(20, 0, "Wifi Hidden");
  if (hidden == 1) {
    display.drawString(45, 16, "Cacher");
  }//hidden 1
  if (hidden == 2) {
    display.drawString(45, 16, "Visible");
  }//hidden 2
  display.display();
}//hiddenter

void hiddstore () {
  display.invertDisplay();
  DisplayClear16 ();
  display.drawString(20, 0, "Wifi Hidden");
  if (hidden == 1) {
    display.drawString(45, 16, "Cacher");
    hiddens = true;
  }//hidden 1
  if (hidden == 2) {
    display.drawString(45, 16, "Visible");
    hiddens = false;
  }//hidden 2
  display.drawString(15, 32, "....STORE....");
  display.display();
  EEPROM.write(4, hiddens);
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
}//hiddstore
