/************************************************************************
 ****************               display                ******************
 ************************************************************************/
char buf[2];
char bufi[2];
char bufa[2];

void info () {
  display.clear();
  display.setFont(ArialMT_Plain_10);
  display.setTextAlignment(TEXT_ALIGN_LEFT);
  display.drawString(0, 0, "AP Mode ");
  display.drawString(55, 0, DMXWiFiConfig.SSID());
  display.drawString(0, 10, "AP IP at ");
  IPAddress myIP = DMXWiFiConfig.apIPAddress();
  String ipStr = String(myIP[0]) + "." + String(myIP[1]) + "." + String(myIP[2]) + "." + String(myIP[3]);
  display.drawString(55, 10, ipStr );
  display.drawString(0, 20, "Wifi Chan ");
  display.drawString(55, 20, String(wifichannel));
  if (hidden == 1) {
    display.drawString(75, 20, "Cacher");
  }//hidden 1
  if (hidden == 2) {
    display.drawString(75, 20, "Visible");
  }//hidden 2
  display.drawString(0, 30, "DMX Input");
  display.drawString(65, 30, String(dmx_start));
  display.drawString(0, 40, "Mode Start ");
  if (mode_start == 1) {
    display.drawString(65, 40, "FULL");
  }//mode start 1
  if (mode_start == 2) {
    display.drawString(65, 40, "CLUB");
  }//mode start 2
  if (mode_start == 3) {
    display.drawString(65, 40, "MINI");
  }//mode start 3
  display.drawString(0, 50, "Bat : ");
  sprintf (buf, "%d", level);
  display.drawString(65, 50, buf);
  display.drawString(85, 50, "%");
  display.display();

}//info

void setin () {
  display.clear();
  display.setFont(ArialMT_Plain_16);
  display.setTextAlignment(TEXT_ALIGN_LEFT);
  display.drawString(20, 0, "DMX Input");
  display.drawString(50, 16, String(dmx_start));
  display.display();
}//setin

void setinenter () {
  display.invertDisplay();
  display.clear();
  display.setFont(ArialMT_Plain_16);
  display.setTextAlignment(TEXT_ALIGN_LEFT);
  display.drawString(20, 0, "DMX Input");
  display.drawString(50, 16, String(dmx_start));
  display.display();
}//setinenter

void setinstore () {
  display.normalDisplay();
  display.clear();
  display.setFont(ArialMT_Plain_16);
  display.setTextAlignment(TEXT_ALIGN_LEFT);;
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

void modein () {
  display.clear();
  display.setFont(ArialMT_Plain_16);
  display.setTextAlignment(TEXT_ALIGN_LEFT);
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
  display.clear();
  display.setFont(ArialMT_Plain_16);
  display.setTextAlignment(TEXT_ALIGN_LEFT);
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
  display.clear();
  display.setFont(ArialMT_Plain_16);
  display.setTextAlignment(TEXT_ALIGN_LEFT);
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

void wifichan () {
  display.clear();
  display.setFont(ArialMT_Plain_16);
  display.setTextAlignment(TEXT_ALIGN_LEFT);
  display.drawString(20, 0, "Wifi Channel");
  display.drawString(50, 16, String(wifichannel));
  display.display();
}//wifichan

void wifichanenter () {
  display.invertDisplay();
  display.clear();
  display.setFont(ArialMT_Plain_16);
  display.setTextAlignment(TEXT_ALIGN_LEFT);
  display.drawString(20, 0, "Wifi Channel");
  display.drawString(50, 16, String(wifichannel));
  display.display();
}//wifichanset

void wifichanstore () {
  display.invertDisplay();
  display.clear();
  display.setFont(ArialMT_Plain_16);
  display.setTextAlignment(TEXT_ALIGN_LEFT);
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

void hidd () {
  display.clear();
  display.setFont(ArialMT_Plain_16);
  display.setTextAlignment(TEXT_ALIGN_LEFT);
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
  display.invertDisplay();
  display.clear();
  display.setFont(ArialMT_Plain_16);
  display.setTextAlignment(TEXT_ALIGN_LEFT);
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
  display.clear();
  display.setFont(ArialMT_Plain_16);
  display.setTextAlignment(TEXT_ALIGN_LEFT);
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

void shutdown_screen () {
  display.clear();
  display.setFont(ArialMT_Plain_10);
  display.setTextAlignment(TEXT_ALIGN_LEFT);
  display.drawString(0, 0, "DIPLAY OFF");
  display.drawString(0, 16, "MENU+UP=>ON");
  display.drawString(0, 32, "MENU+DOWN=>OFF");
  display.display();
  if (now - last_screen_check_time > SCREEN_TIMEOUT + 3000) {
    display.displayOff();
    screen = 0;
    last_screen_check_time = now;
  }
}//shutdown_screen

/************************************************************************
 ****************               Touch                ******************
 ************************************************************************/

void gotTouch9() {
  frameCountnow = frameCountnow + 1;
  if (frameCountnow > frameCount) {
    frameCountnow = 1;
  }
  if (frameCountnow == 1) {
    setin();
  }//setin
  if (frameCountnow == 2) {
    modein();
  }//modein
  if (frameCountnow == 3) {
    wifichan();
  }//modein
  if (frameCountnow == 4) {
    hidd();
  }//modein
  if (frameCountnow == 5) {
    info();
  }//info
  if (enter == 1) {
    display.normalDisplay();
  }
  enter = 0;
}//menu

void gotTouch8() {
  if (enter == 1) {
    if (frameCountnow == 1) {
      dmx_start = dmx_start + 1;
      if (dmx_start > 512) {
        dmx_start = 1;
      }
      setinenter();
    }//setin
    if (frameCountnow == 2) {
      mode_start = mode_start + 1;
      if (mode_start >= 4) {
        mode_start = 1;
      }// mode_start>=4
      modeinenter();
    }//modein
    if (frameCountnow == 3) {
      wifichannel = wifichannel + 1;
      if (wifichannel >= 14) {
        wifichannel = 1;
      }// wifichannel >=14
      wifichan();
    }//wifichan
    if (frameCountnow == 4) {
      hidden = hidden + 1;
      if (hidden >= 3) {
        hidden = 1;
      }//hidden >= 3
      hidd();
    }//hidden
    if (frameCountnow == 5) {

    }//info
  }//enter true
}//up

void gotTouch7() {
  if (enter == 1) {
    if (frameCountnow == 1) {
      dmx_start = dmx_start - 1;
      if (dmx_start <= 0) {
        dmx_start = 512;
      }
      setinenter();
    }//setin
    if (frameCountnow == 2) {
      mode_start = mode_start - 1;
      if (mode_start <= 0) {
        mode_start = 3;
      }// mode_start>4
      modeinenter();
    }//modein
    if (frameCountnow == 3) {
      wifichannel = wifichannel - 1;
      if (wifichannel <= 0) {
        wifichannel = 13;
      }// wifichannel <=0
      wifichan();
    }//channel
    if (frameCountnow == 4) {
      hidden = hidden - 1;
      if (hidden <= 0) {
        hidden = 2;
      }//hidden <= 0
      hidd();
    }//hidden
    if (frameCountnow == 5) {

    }//info
  }//enter true
}//down

void gotTouch6() {
  enter = enter + 1;
#ifdef DEBUG
  Serial.print("enter = "); Serial.println(enter) ;
#endif
  if (enter == 1) {
    if (frameCountnow == 1) {
      setinenter();
    }//setin
    if (frameCountnow == 2) {
      modeinenter();
    }//modein
    if (frameCountnow == 3) {
      wifichanenter();
    }//channel
    if (frameCountnow == 4) {
      hiddenter();
    }//hidden
    if (frameCountnow == 5) {

    }//info
  }// enter = 1
  if (enter == 2) {
    if (frameCountnow == 1) {
      setinstore();
    }//setin
    if (frameCountnow == 2) {
      modeinstore();
    }//modein
    if (frameCountnow == 3) {
      wifichanstore();
    }//channel
    if (frameCountnow == 4) {
      hiddstore();
    }//hidden
    if (frameCountnow == 5) {

    }//info
  }//enter = 2
  if (enter >= 3) {
    enter = 0;
  }// enter >= 3
}//enter

void check_btn() {
  if (button9.onPressed()) {
    digitalWrite(TOUCH_LED, HIGH);
  }
  if (button9.onReleased() && button8.isReleased() || button9.onReleased() && button7.isReleased()) {
    if (init_btn9 == 0) {
      init_btn9 = 1;
      return;
    }
    digitalWrite(TOUCH_LED, LOW);
#ifdef DEBUG
    Serial.println("Button9 Released MENU");
#endif
    last_screen_check_time = now;
    gotTouch9();
  }// 9 8 release 9 7 release

  if (button9.isPressed() && button8.isPressed()) {
    display.displayOn();
    enter = 0;
    frameCountnow = 3;
    screen = 1;
    last_screen_check_time = now;
    gotTouch9();
  }// display on

  if (button9.isPressed() && button7.isPressed()) {
    display.displayOff();
    enter = 0;
    screen = 0;
    last_screen_check_time = now;
  }// display off

  if (button8.onPressed()) {
    digitalWrite(TOUCH_LED, HIGH);
    last_screen_check_time = now;
  }
  if (button8.onReleased()) {
    if (init_btn8 == 0) {
      init_btn8 = 1;
      return;
    }
    digitalWrite(TOUCH_LED, LOW);
#ifdef DEBUG
    Serial.println("Button8 Released UP");
#endif
    gotTouch8();
  }//button.8

  if (button7.onPressed()) {
    last_screen_check_time = now;
    digitalWrite(TOUCH_LED, HIGH);
  }
  if (button7.onReleased()) {
    if (init_btn7 == 0) {
      init_btn7 = 1;
      return;
    }
    digitalWrite(TOUCH_LED, LOW);
#ifdef DEBUG
    Serial.println("Button7 Released DOWN");
#endif
    gotTouch7();
  }//button.7
  if (button6.onPressed()) {
    last_screen_check_time = now;
    digitalWrite(WRITE_LED, HIGH);
  }
  if (button6.onReleased()) {
    if (init_btn6 == 0) {
      init_btn6 = 1;
      return;
    }
    digitalWrite(WRITE_LED, LOW);
#ifdef DEBUG
    Serial.println("Button6 Released ENTER");
#endif
    gotTouch6();
  }//button.6
}// check_btn

