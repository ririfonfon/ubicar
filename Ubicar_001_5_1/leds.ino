/////////////////////////////Lib esp32_digital_led_lib
#include "esp32_digital_led_lib.h"
#define min(m,n) ((m)<(n)?(m):(n))



strand_t STRANDS[] = { // Avoid using any of the strapping pins on the ESP32
  {.rmtChannel = 0, .gpioNum = 23, .ledType = LED_WS2812B_V3, .brightLimit = 32, .numPixels = NUM_LEDS_PER_STRIP,
   .pixels = nullptr, ._stateVars = nullptr},
  {.rmtChannel = 1, .gpioNum = 22, .ledType = LED_WS2812B_V3, .brightLimit = 32, .numPixels =  NUM_LEDS_PER_STRIP,
   .pixels = nullptr, ._stateVars = nullptr},
  {.rmtChannel = 2, .gpioNum = 18, .ledType = LED_WS2812B_V3, .brightLimit = 32, .numPixels =  NUM_LEDS_PER_STRIP,
   .pixels = nullptr, ._stateVars = nullptr},
  {.rmtChannel = 3, .gpioNum = 5, .ledType = LED_WS2812B_V3, .brightLimit = 32, .numPixels =  NUM_LEDS_PER_STRIP,
   .pixels = nullptr, ._stateVars = nullptr}, 
};
int STRANDCNT = sizeof(STRANDS)/sizeof(STRANDS[0]);
void dumpDebugBuffer(int, char *);
strand_t * strands [] = { &STRANDS[0], &STRANDS[1], &STRANDS[2], &STRANDS[3]};

void leds_init() {
  dumpSysInfo();
  getMaxMalloc(1*1024, 16*1024*1024);

  gpioSetup(23, OUTPUT, LOW);
  gpioSetup(22, OUTPUT, LOW);
  gpioSetup(18, OUTPUT, LOW);
  gpioSetup(5, OUTPUT, LOW);

  if (digitalLeds_initStrands(STRANDS, STRANDCNT)) {
    #ifdef DEBUG
    Serial.println("Init FAILURE: halting");
    delay(1000);
    #endif
    ESP.restart();
  }
  for (int i = 0; i < STRANDCNT; i++) {
    strand_t * pStrand = &STRANDS[i];
  #ifdef DEBUG
  Serial.println("Init complete");
  #endif
}//leds_init

void leds_show() {
digitalLeds_updatePixels(strands[0]);
digitalLeds_updatePixels(strands[1]);
digitalLeds_updatePixels(strands[2]);
digitalLeds_updatePixels(strands[3]);
ledcWrite(ledChannela, led_a);
ledcWrite(ledChannelb, led_b);
ledcWrite(ledChannelc, led_c);
}//leds_show

//////////////////////////////////////////////// initTest() //////////////////////////////////////////
void initTest() {
  #ifdef DEBUG
  Serial.println("initTest()");
  #endif
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    strands[0]->pixels[i] = pixelFromRGB(127, 0, 0);
    strands[1]->pixels[i] = pixelFromRGB(127, 0, 0);
    strands[2]->pixels[i] = pixelFromRGB(127, 0, 0); 
    strands[3]->pixels[i] = pixelFromRGB(127, 0, 0);
}//for i
  leds_show();
  delay(500);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(0, 127, 0);
     strands[1]->pixels[i] = pixelFromRGB(0, 127, 0); 
     strands[2]->pixels[i] = pixelFromRGB(0, 127, 0); 
     strands[3]->pixels[i] = pixelFromRGB(0, 127, 0);  
}//for i
  leds_show();
  delay(500);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(0, 0, 127);
     strands[1]->pixels[i] = pixelFromRGB(0, 0, 127); 
     strands[2]->pixels[i] = pixelFromRGB(0, 0, 127);
     strands[3]->pixels[i] = pixelFromRGB(0, 0, 127); 
}//for i
  leds_show();
  delay(500);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) { 
    strands[0]->pixels[i] = pixelFromRGB(0, 0, 0);
    strands[1]->pixels[i] = pixelFromRGB(0, 0, 0); 
    strands[2]->pixels[i] = pixelFromRGB(0, 0, 0); 
    strands[3]->pixels[i] = pixelFromRGB(0, 0, 0); 
}//for i
  leds_show();
}//initest


//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////// onDmxFrame //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
void onDmxFrame(uint16_t universe, uint16_t length, uint8_t sequence, uint8_t* data) {
  boolean tail = false;

  #ifdef DEBUG_dmx
  Serial.print("master = ");
  Serial.println(master);
  Serial.print("r = ");
  Serial.println(r);
  Serial.print("g = ");
  Serial.println(g);
  Serial.print("b = ");
  Serial.println(b);
  Serial.print("mod = ");
  Serial.println(mod);
  Serial.print("pix_mod = ");
  Serial.println(pix_mod);
  Serial.print("pix_start = ");
  Serial.println(pix_start);
  Serial.print("pix_center = ");
  Serial.println(pix_center);
  Serial.print("pix_end = ");
  Serial.println(pix_end);
  Serial.print("pix_pos = ");
  Serial.println(pix_pos);
  Serial.print("modulo = ");
  Serial.println(modulo);
  Serial.print("str_ws = ");
  Serial.println(str_ws);
  Serial.print("M_g = ");
  Serial.println(M_g);
  #endif
  
    master=data[adr-1];
    rr=data[adr];
    gg=data[adr+1];
    bb=data[adr+2];
    mod=data[adr+3];
    pix_mod=data[adr+4];
    pix_start=data[adr+5]-1;
    
    pix_end=pix_start+pix_start;
    if (pix_mod>=11 && pix_mod<=20 || pix_mod>=31 && pix_mod<=60 ){
    pix_pos=(((pix_start+NUM_LEDS_PER_STRIP+pix_end)*data[adr+6])/255)-(pix_end+1);
    } else if (pix_mod>=21 && pix_mod<=30 || pix_mod>=61 && pix_mod<=90){
    pix_pos=(((pix_start+numberOfLed+pix_end)*data[adr+6])/255)-(pix_end+1);
    }
    modulo=data[adr+7];
    str_ws=(data[adr+8]*data[adr+8])/33;
    pix_center=((pix_start)/2)+pix_pos;
    M_g=(NUM_LEDS_PER_STRIP+1)/NUM_STRIPS;
    led_master=((data[adr+9]*data[adr+9])*1.007852);
    led_mode=data[adr+10];
    led_str=(data[adr+11]*data[adr+11])/33;
    
    smaster=data[adr+12];
    srr=data[adr+13];
    sgg=data[adr+14];
    sbb=data[adr+15];
//    sr = srr * smaster / 255;
//    sg = sgg * smaster / 255;
//    sb = sbb * smaster / 255;

// Ancienne position de led_mode ...

if ((mod>=0)&&(mod<=10)) {
  type_effet = 0;
}//mod fix
 else if ((mod>=11)&&(mod<=20)) {
  type_effet  = 1;
}//rudan 1
else if ((mod>=21)&&(mod<=30)) {
  type_effet  = 2;
}//rudan 2
else if ((mod>=31)&&(mod<=40)) {
  type_effet  = 3;
}//rudan 3
else if ((mod>=41)&&(mod<=50)) {
  type_effet  = 4;
}//rudan 4
else if ((mod>=51)&&(mod<=60)) {
  type_effet  = 5;
}//rudan 12
else if ((mod>=61)&&(mod<=70)) {
  type_effet  = 6;
}//rudan 13
else if ((mod>=71)&&(mod<=80)) {
  type_effet  = 7;
}//rudan 14
else if ((mod>=81)&&(mod<=90)) {
  type_effet  = 8;
}//rudan 23
else if ((mod>=91)&&(mod<=100)) {
  type_effet  = 9;
}//rudan 24
else if ((mod>=101)&&(mod<=110)) {
  type_effet  = 10;
}//rudan 34
else if ((mod>=111)&&(mod<=120)) {
  type_effet  = 11;
  M_g_ref=0;
  M_g1=M_g;
  M_g1_ref=M_g;
  M_g2=M_g*2;
  M_g2_ref=M_g*2;
  M_g3=M_g*3;
  M_g3_ref=M_g*3;
  M_g4=M_g*4;
}//rudan 1/4
else if ((mod>=121)&&(mod<=130)) {
  type_effet  = 11;
  M_g_ref=M_g*3;
  M_g1=M_g*4;
  M_g1_ref=0;
  M_g2=M_g;
  M_g2_ref=M_g;
  M_g3=M_g*2;
  M_g3_ref=M_g*2;
  M_g4=M_g*3;
}//rudan 2/4
else if ((mod>=131)&&(mod<=140)) {
  type_effet  = 11;
  M_g_ref=M_g*2;
  M_g1=M_g*3;
  M_g1_ref=M_g*3;
  M_g2=M_g*4;
  M_g2_ref=0;
  M_g3=M_g;
  M_g3_ref=M_g;
  M_g4=M_g*2;
}//rudan 3/4
else if ((mod>=141)&&(mod<=150)) {
  type_effet  = 11;
  M_g_ref=M_g;
  M_g1=M_g*2;
  M_g1_ref=M_g*2;
  M_g2=M_g*3;
  M_g2_ref=M_g*3;
  M_g3=M_g*4;
  M_g3_ref=0;
  M_g4=M_g; 
}//rudan 4/4

if((modulo>=0)&&modulo<=10) {
  type_modulo=0;
} else if ((modulo>=11)&&modulo<=20) {
  type_modulo=1;
} else if ((modulo>=21)&&modulo<=30) {
  type_modulo=2;
} else if ((modulo>=31)&&modulo<=110) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(0, 0, 0);
     strands[1]->pixels[i] = pixelFromRGB(0, 0, 0);
     strands[2]->pixels[i] = pixelFromRGB(0, 0, 0);
     strands[3]->pixels[i] = pixelFromRGB(0, 0, 0);
  }//for i
  type_modulo=3;
  S_seuil=(modulo-30)*4;
  type_effet = 255;
} else if ((modulo>=111)&&modulo<=120) {
  type_modulo=4;
} else if ((modulo>=121)&&modulo<=200) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(0, 0, 0);
     strands[1]->pixels[i] = pixelFromRGB(0, 0, 0);
     strands[2]->pixels[i] = pixelFromRGB(0, 0, 0);
     strands[3]->pixels[i] = pixelFromRGB(0, 0, 0);
  }//for i
  type_modulo=5;
  S_seuil=(modulo-120)*4;
  type_effet = 255;
} 
  
  previousDataLength = length;     
  
  if (sendFrame){
  // Reset universeReceived to 0
  memset(universesReceived, 0, maxUniverses);
  }
}//onframedmx

void effet() {
    if (type_effet == 0)
    do_effet_0();
    else if (type_effet == 1)
    do_effet_1();
    else if (type_effet == 2)
    do_effet_2();
    else if (type_effet == 3)
    do_effet_3();
    else if (type_effet == 4)
    do_effet_4();
    else if (type_effet == 5)
    do_effet_5();
    else if (type_effet == 6)
    do_effet_6();
    else if (type_effet == 7)
    do_effet_7();
    else if (type_effet == 8)
    do_effet_8();
    else if (type_effet == 9)
    do_effet_9();
    else if (type_effet == 10)
    do_effet_10();
    else if (type_effet == 11)
    do_effet_11();
    else if (type_effet == 255)
    do_effet_255();

 
  leds_show();
}//effet


void do_effet_0() {
if (pix_mod>=0 && pix_mod<=10){  
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(r, g, b);
     strands[1]->pixels[i] = pixelFromRGB(r, g, b);
     strands[2]->pixels[i] = pixelFromRGB(r, g, b);
     strands[3]->pixels[i] = pixelFromRGB(r, g, b);
    }//for i
  }//pix_mod 0

if (pix_mod>=11 && pix_mod<=20) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
     strands[0]->pixels[i] = pixelFromRGB(r, g, b);
     strands[1]->pixels[i] = pixelFromRGB(r, g, b);
     strands[2]->pixels[i] = pixelFromRGB(r, g, b);
     strands[3]->pixels[i] = pixelFromRGB(r, g, b);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 10
  
if (pix_mod>=21 && pix_mod<=30){  
  for (int i = 0 ; i < numberOfLed ; i++) {
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
     strands[0]->pixels[i] = pixelFromRGB(r, g, b); 
    } else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r, g, b);
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r, g, b);
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r, g, b);
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 20

if (pix_mod>=31 && pix_mod<=40) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 30

if (pix_mod>=41 && pix_mod<=50) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     ref_pix_pos--;
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 40

if (pix_mod>=51 && pix_mod<=60) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 50

if (pix_mod>=61 && pix_mod<=70){  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 60

if (pix_mod>=71 && pix_mod<=80){
  ref_pix_pos = (pix_start+pix_pos);  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     ref_pix_pos--;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 70

if (pix_mod>=81 && pix_mod<=90){
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 80
}// do_effet_0 modfix


void do_effet_1(){
if (pix_mod>=0 && pix_mod<=10){  
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(r, g, b);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }//for i
  }//pix_mod 0

if (pix_mod>=11 && pix_mod<=20) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
     strands[0]->pixels[i] = pixelFromRGB(r, g, b);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 10
  
if (pix_mod>=21 && pix_mod<=30){  
  for (int i = 0 ; i < numberOfLed ; i++) {
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[0]->pixels[i] = pixelFromRGB(r, g, b); 
    } else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 20 

if (pix_mod>=31 && pix_mod<=40) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 30

if (pix_mod>=41 && pix_mod<=50) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     ref_pix_pos--;
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 40

if (pix_mod>=51 && pix_mod<=60) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 50

if (pix_mod>=61 && pix_mod<=70){  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 60

if (pix_mod>=71 && pix_mod<=80){
  ref_pix_pos = (pix_start+pix_pos);  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     ref_pix_pos--;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 70

if (pix_mod>=81 && pix_mod<=90){
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 80
}//do_effet_1 ruban 1

void do_effet_2(){
if (pix_mod>=0 && pix_mod<=10){  
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r, g, b);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }//for i
  }//pix_mod 0

if (pix_mod>=11 && pix_mod<=20) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r, g, b);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 10
  
if (pix_mod>=21 && pix_mod<=30){  
  for (int i = 0 ; i < numberOfLed ; i++) {
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    } else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r, g, b);
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 20 

if (pix_mod>=31 && pix_mod<=40) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 30 

if (pix_mod>=41 && pix_mod<=50) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     ref_pix_pos--;
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 40

if (pix_mod>=51 && pix_mod<=60) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 50

if (pix_mod>=61 && pix_mod<=70){  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 60

if (pix_mod>=71 && pix_mod<=80){
  ref_pix_pos = (pix_start+pix_pos);  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     ref_pix_pos--;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 70

if (pix_mod>=81 && pix_mod<=90){
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 80
}//do_effet_2 ruban 2

void do_effet_3(){
if (pix_mod>=0 && pix_mod<=10){  
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r, g, b);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }//for i
  }//pix_mod 0

if (pix_mod>=11 && pix_mod<=20) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r, g, b);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 10
  
if (pix_mod>=21 && pix_mod<=30){  
  for (int i = 0 ; i < numberOfLed ; i++) {
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    } else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r, g, b);
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 20 

if (pix_mod>=31 && pix_mod<=40) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 30

if (pix_mod>=41 && pix_mod<=50) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     ref_pix_pos--;
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 40

if (pix_mod>=51 && pix_mod<=60) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 50

if (pix_mod>=61 && pix_mod<=70){  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 60

if (pix_mod>=71 && pix_mod<=80){
  ref_pix_pos = (pix_start+pix_pos);  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     ref_pix_pos--;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 70

if (pix_mod>=81 && pix_mod<=90){
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 80
}//do_effet_3 ruban 3

void do_effet_4(){
if (pix_mod>=0 && pix_mod<=10){  
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r, g, b);
    }//for i
  }//pix_mod 0

if (pix_mod>=11 && pix_mod<=20) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r, g, b);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 10
  
if (pix_mod>=21 && pix_mod<=30){  
  for (int i = 0 ; i < numberOfLed ; i++) {
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    } else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r, g, b);
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 20 

if (pix_mod>=31 && pix_mod<=40) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 30

if (pix_mod>=41 && pix_mod<=50) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     ref_pix_pos--;
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 40

if (pix_mod>=51 && pix_mod<=60) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 50

if (pix_mod>=61 && pix_mod<=70){  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 60

if (pix_mod>=71 && pix_mod<=80){
  ref_pix_pos = (pix_start+pix_pos);  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     ref_pix_pos--;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 70

if (pix_mod>=81 && pix_mod<=90){
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 80
}//do_effet_4 ruban 4

void do_effet_5() {
if (pix_mod>=0 && pix_mod<=10){  
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(r, g, b);
     strands[1]->pixels[i] = pixelFromRGB(r, g, b);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }//for i
  }//pix_mod 0

if (pix_mod>=11 && pix_mod<=20) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
     strands[0]->pixels[i] = pixelFromRGB(r, g, b);
     strands[1]->pixels[i] = pixelFromRGB(r, g, b);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 10
  
if (pix_mod>=21 && pix_mod<=30){  
  for (int i = 0 ; i < numberOfLed ; i++) {
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[0]->pixels[i] = pixelFromRGB(r, g, b); 
    } else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r, g, b);
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 20 

if (pix_mod>=31 && pix_mod<=40) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 30

if (pix_mod>=41 && pix_mod<=50) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     ref_pix_pos--;
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 40

if (pix_mod>=51 && pix_mod<=60) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 50

if (pix_mod>=61 && pix_mod<=70){  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 60

if (pix_mod>=71 && pix_mod<=80){
  ref_pix_pos = (pix_start+pix_pos);  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     ref_pix_pos--;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 70

if (pix_mod>=81 && pix_mod<=90){
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 80
}//do_effet_5 ruban 12

void do_effet_6() {
if (pix_mod>=0 && pix_mod<=10){  
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(r, g, b);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r, g, b);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }//for i
  }//pix_mod 0

if (pix_mod>=11 && pix_mod<=20) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
     strands[0]->pixels[i] = pixelFromRGB(r, g, b);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r, g, b);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 10
  
if (pix_mod>=21 && pix_mod<=30){  
  for (int i = 0 ; i < numberOfLed ; i++) {
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[0]->pixels[i] = pixelFromRGB(r, g, b); 
    } else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r, g, b);
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 20

if (pix_mod>=31 && pix_mod<=40) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 30

if (pix_mod>=41 && pix_mod<=50) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     ref_pix_pos--;
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 40

if (pix_mod>=51 && pix_mod<=60) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 50

if (pix_mod>=61 && pix_mod<=70){  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 60

if (pix_mod>=71 && pix_mod<=80){
  ref_pix_pos = (pix_start+pix_pos);  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     ref_pix_pos--;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 70

if (pix_mod>=81 && pix_mod<=90){
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 80
}//do_effet_6 ruban 13

void do_effet_7() {
if (pix_mod>=0 && pix_mod<=10){  
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(r, g, b);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r, g, b);
    }//for i
  }//pix_mod 0

if (pix_mod>=11 && pix_mod<=20) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
     strands[0]->pixels[i] = pixelFromRGB(r, g, b);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r, g, b);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 10
  
if (pix_mod>=21 && pix_mod<=30){  
  for (int i = 0 ; i < numberOfLed ; i++) {
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[0]->pixels[i] = pixelFromRGB(r, g, b); 
   } else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r, g, b);
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 20

if (pix_mod>=31 && pix_mod<=40) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 30

if (pix_mod>=41 && pix_mod<=50) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     ref_pix_pos--;
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 40

if (pix_mod>=51 && pix_mod<=60) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 50

if (pix_mod>=61 && pix_mod<=70){  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 60

if (pix_mod>=71 && pix_mod<=80){
  ref_pix_pos = (pix_start+pix_pos);  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     ref_pix_pos--;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 70

if (pix_mod>=81 && pix_mod<=90){
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 80
}//do_effet_7 ruban 14

void do_effet_8() {
if (pix_mod>=0 && pix_mod<=10){  
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r, g, b);
     strands[2]->pixels[i] = pixelFromRGB(r, g, b);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }//for i
  }//pix_mod 0

if (pix_mod>=11 && pix_mod<=20) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r, g, b);
     strands[2]->pixels[i] = pixelFromRGB(r, g, b);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 10
  
if (pix_mod>=21 && pix_mod<=30){  
  for (int i = 0 ; i < numberOfLed ; i++) {
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    }  else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r, g, b);
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r, g, b);
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 20 

if (pix_mod>=31 && pix_mod<=40) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 30

if (pix_mod>=41 && pix_mod<=50) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     ref_pix_pos--;
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 40

if (pix_mod>=51 && pix_mod<=60) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 50

if (pix_mod>=61 && pix_mod<=70){  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 60

if (pix_mod>=71 && pix_mod<=80){
  ref_pix_pos = (pix_start+pix_pos);  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     ref_pix_pos--;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 70

if (pix_mod>=81 && pix_mod<=90){
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 80
}//do_effet_8 ruban 23

void do_effet_9() {
if (pix_mod>=0 && pix_mod<=10){  
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r, g, b);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r, g, b);
    }//for i
  }//pix_mod 0

if (pix_mod>=11 && pix_mod<=20) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r, g, b);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r, g, b);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 10
  
if (pix_mod>=21 && pix_mod<=30){  
  for (int i = 0 ; i < numberOfLed ; i++) {
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    } else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r, g, b);
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r, g, b);
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 20

if (pix_mod>=31 && pix_mod<=40) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 30

if (pix_mod>=41 && pix_mod<=50) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     ref_pix_pos--;
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 40

if (pix_mod>=51 && pix_mod<=60) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 50

if (pix_mod>=61 && pix_mod<=70){  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 60

if (pix_mod>=71 && pix_mod<=80){
  ref_pix_pos = (pix_start+pix_pos);  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     ref_pix_pos--;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 70

if (pix_mod>=81 && pix_mod<=90){
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 80
}//do_effet_9 ruban 24

void do_effet_10() {
if (pix_mod>=0 && pix_mod<=10){  
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r, g, b);
     strands[3]->pixels[i] = pixelFromRGB(r, g, b);
   }//for i
  }//pix_mod 0

if (pix_mod>=11 && pix_mod<=20) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r, g, b);
     strands[3]->pixels[i] = pixelFromRGB(r, g, b);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 10
  
if (pix_mod>=21 && pix_mod<=30){  
  for (int i = 0 ; i < numberOfLed ; i++) {
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    } else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r, g, b);
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r, g, b);
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 20

if (pix_mod>=31 && pix_mod<=40) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 30

if (pix_mod>=41 && pix_mod<=50) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     ref_pix_pos--;
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 40

if (pix_mod>=51 && pix_mod<=60) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
      if (pix_coef>1) pix_coef=1;
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 50

if (pix_mod>=61 && pix_mod<=70){  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 60

if (pix_mod>=71 && pix_mod<=80){
  ref_pix_pos = (pix_start+pix_pos);  
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     ref_pix_pos--;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 70

if (pix_mod>=81 && pix_mod<=90){
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < numberOfLed ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
   } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
   } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
   }
    } else {
   if (i<=NUM_LEDS_PER_STRIP) {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     } else if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
     } else if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb); 
     } else if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
     }
      }
    }//for i
  }//pix_mod 80
}//do_effet_10 ruban 34

void do_effet_11() {
if (pix_mod>=0 && pix_mod<=10){  
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=M_g_ref && i<=M_g1) {
     strands[0]->pixels[i] = pixelFromRGB(r, g, b);
    } else {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    }
    if (i>M_g1_ref && i<=M_g2) {
     strands[1]->pixels[i] = pixelFromRGB(r, g, b);
    } else {
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
    if (i>M_g2_ref && i<=M_g3) {
     strands[2]->pixels[i] = pixelFromRGB(r, g, b);
    } else {
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
    if (i>M_g3_ref && i<=M_g4) {
     strands[3]->pixels[i] = pixelFromRGB(r, g, b);
    } else {
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
    }//for i
  }//pix_mod 0

if (pix_mod>=11 && pix_mod<=20) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
     if (i>=M_g_ref && i<=M_g1) {
     strands[0]->pixels[i] = pixelFromRGB(r, g, b);
    } else {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    }
    if (i>M_g1_ref && i<=M_g2) {
     strands[1]->pixels[i] = pixelFromRGB(r, g, b);
    } else {
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
    if (i>M_g2_ref && i<=M_g3) {
     strands[2]->pixels[i] = pixelFromRGB(r, g, b);
    } else {
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
    if (i>M_g3_ref && i<=M_g4) {
     strands[3]->pixels[i] = pixelFromRGB(r, g, b);
    } else {
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 10
  
if (pix_mod>=21 && pix_mod<=30){  
  for (int i = 0 ; i < numberOfLed ; i++) {
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>=M_g_ref && i<=M_g1) {
     strands[0]->pixels[i] = pixelFromRGB(r, g, b);
    } else {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    }
    } else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>M_g1_ref+NUM_LEDS_PER_STRIP && i<=M_g2+NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r, g, b);
    } else {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
    }
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>M_g2_ref+(NUM_LEDS_PER_STRIP*2) && i<=M_g3+(NUM_LEDS_PER_STRIP*2)) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r, g, b);
    } else {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);  
    }
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>M_g3_ref+(NUM_LEDS_PER_STRIP*3) && i<=M_g4+(NUM_LEDS_PER_STRIP*3)) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r, g, b);
    } else {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);  
    }
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 20

if (pix_mod>=31 && pix_mod<=40) {
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     if (i>=M_g_ref && i<=M_g1) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    }
    if (i>M_g1_ref && i<=M_g2) {
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
    if (i>M_g2_ref && i<=M_g3) {
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
    if (i>M_g3_ref && i<=M_g4) {
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 30

if (pix_mod>=41 && pix_mod<=50) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     if (i>=M_g_ref && i<=M_g1) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    }
    if (i>M_g1_ref && i<=M_g2) {
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
    if (i>M_g2_ref && i<=M_g3) {
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
    if (i>M_g3_ref && i<=M_g4) {
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
     ref_pix_pos--;
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 40

if (pix_mod>=51 && pix_mod<=60) {
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    if (i>=(pix_pos)&&i<=(pix_start+pix_pos)) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     if (i>=M_g_ref && i<=M_g1) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    }
    if (i>M_g1_ref && i<=M_g2) {
     strands[1]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
    if (i>M_g2_ref && i<=M_g3) {
     strands[2]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
    if (i>M_g3_ref && i<=M_g4) {
     strands[3]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);  
    }
     } else  {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
     strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
     }
   }//for i
  }//pix_mod 50

if (pix_mod>=61 && pix_mod<=70){  
  for (int i = 0 ; i < numberOfLed ; i++) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((i-pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>=M_g_ref && i<=M_g1) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    }
    } else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>M_g1_ref+NUM_LEDS_PER_STRIP && i<=M_g2+NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
    }
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>M_g2_ref+(NUM_LEDS_PER_STRIP*2) && i<=M_g3+(NUM_LEDS_PER_STRIP*2)) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);  
    }
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>M_g3_ref+(NUM_LEDS_PER_STRIP*3) && i<=M_g4+(NUM_LEDS_PER_STRIP*3)) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);  
    }
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 60

if (pix_mod>=71 && pix_mod<=80){
  ref_pix_pos = (pix_start+pix_pos);  
  for (int i = 0 ; i < numberOfLed ; i++) {
      if (pix_start<=1) {
        pix_start_v = 1;
     } else {
        pix_start_v = pix_start;
     }
     pix_coefi=(((pix_pos-ref_pix_pos)*100)/pix_start_v)*0.01;
     pix_coef=pix_coefi*pix_coefi;
     ref_pix_pos--;
     
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>=M_g_ref && i<=M_g1) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    }
    } else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>M_g1_ref+NUM_LEDS_PER_STRIP && i<=M_g2+NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
    }
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>M_g2_ref+(NUM_LEDS_PER_STRIP*2) && i<=M_g3+(NUM_LEDS_PER_STRIP*2)) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);  
    }
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>M_g3_ref+(NUM_LEDS_PER_STRIP*3) && i<=M_g4+(NUM_LEDS_PER_STRIP*3)) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);  
    }
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 70

if (pix_mod>=81 && pix_mod<=90){
  ref_pix_pos = (pix_start+pix_pos);
  for (int i = 0 ; i < numberOfLed ; i++) {   
      if (pix_start<=1) {
        pix_start_v = 1;
      } else {
        pix_start_v = pix_start;
      }
      if (i<=pix_center) {
      pix_coefi=((((i-pix_pos+1))*200)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      }
      else if (i>=pix_center) {
      pix_coefi=((((pix_pos-ref_pix_pos))*100)/pix_start_v)*0.01;
      pix_coef=pix_coefi*pix_coefi;
      ref_pix_pos=ref_pix_pos-2;
      }
    if (pix_coef>1) pix_coef=1;
     
   if (i<=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>=M_g_ref && i<=M_g1) {
     strands[0]->pixels[i] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb); 
    }
    } else {
    strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
    }
   }
  if (i<=NUM_LEDS_PER_STRIP*2 & i>=NUM_LEDS_PER_STRIP) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>M_g1_ref+NUM_LEDS_PER_STRIP && i<=M_g2+NUM_LEDS_PER_STRIP) {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);  
    }
    } else {
    strands[1]->pixels[i-NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*3 & i>=NUM_LEDS_PER_STRIP*2) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>M_g2_ref+(NUM_LEDS_PER_STRIP*2) && i<=M_g3+(NUM_LEDS_PER_STRIP*2)) {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);  
    }
    } else {
    strands[2]->pixels[i-NUM_LEDS_PER_STRIP*2] = pixelFromRGB(sr, sg, sb);
    }
  }
  if (i<=NUM_LEDS_PER_STRIP*4 & i>=NUM_LEDS_PER_STRIP*3) {
    if (i>=(pix_pos)&&i<=pix_start+(pix_pos)) {
    if (i>M_g3_ref+(NUM_LEDS_PER_STRIP*3) && i<=M_g4+(NUM_LEDS_PER_STRIP*3)) {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(r*pix_coef, g*pix_coef, b*pix_coef);
    } else {
     strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);  
    }
    } else {
    strands[3]->pixels[i-NUM_LEDS_PER_STRIP*3] = pixelFromRGB(sr, sg, sb);
    }
  }
    }//for i
  }//pix_mod 80
}// do_effet_11 ruban 1/4 2/4 3/4 4/4

void do_effet_255 () {
  
}//do_effet_255

void eff_modulo() {
  unsigned long t_now = millis();
  if ( type_modulo == 0 ) {
    r=((rr/255)*master);
    g=((gg/255)*master);
    b=((bb/255)*master);
    sr=((srr/255)*smaster);
    sg=((sgg/255)*smaster);
    sb=((sbb/255)*smaster);
    }
    else if( type_modulo == 1) {
  if(str == 0 && t_now - str_ws_last > str_ws){
  str_ws_last = t_now;
  str = 1;
 }else if(str == 1 && t_now - str_ws_last > STROB_ON_MS){
  str_ws_last = t_now;
  str = 0;
 }else{
  return;
 }
      r = rr * str * master / 255;
      g = gg * str * master / 255;
      b = bb * str * master / 255;
      sr = srr * str * smaster / 255;
      sg = sgg * str * smaster / 255;
      sb = sbb * str * smaster / 255;
    }//modulo 1
    
  else if(type_modulo == 2) {
    if (str_ws <= 0) str_ws = 1;
    float time_modulo = str_ws;
    float module = 2 * abs( (t_now % str_ws) - time_modulo/2) / time_modulo;
    module *= module;
    r = rr * module * master / 255;
    g = gg * module * master / 255;
    b = bb * module * master / 255;
    sr = srr * module * smaster / 255;
    sg = sgg * module * smaster / 255;
    sb = sbb * module * smaster / 255;
    
  }// modulo 2

  else if ( type_modulo == 3 ) {
  if(str == 0 && t_now - str_ws_last > str_ws){
  str_ws_last = t_now;
  str = 1;
 }else if(str == 1 && t_now - str_ws_last > STROB_ON_MS){
  str_ws_last = t_now;
  str = 0;
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(0, 0, 0);
     strands[1]->pixels[i] = pixelFromRGB(0, 0, 0);
     strands[2]->pixels[i] = pixelFromRGB(0, 0, 0);
     strands[3]->pixels[i] = pixelFromRGB(0, 0, 0);
    }//for i
 }else{
  return;
 }
      r = rr * str * master / 255;
      g = gg * str * master / 255;
      b = bb * str * master / 255;
      
      int n_led_to_show = (min(numberOfLed-8, S_seuil)); 
      int n_strip = 0;
for (int i = 0; i < n_led_to_show ; i ++){
 do {
    a = random( 0 , numberOfLed );
    n_strip = a / NUM_LEDS_PER_STRIP;
    }while (strands[n_strip]->pixels[a-(87*n_strip)].r != 0 || strands[n_strip]->pixels[a-(87*n_strip)].g != 0 || strands[n_strip]->pixels[a-(87*n_strip)].b != 0 );
    strands[n_strip]->pixels[a-(87*n_strip)] = pixelFromRGB(r, g, b); 
   }//for i
  }//modulo 3
  
else if( type_modulo == 4) {
  if(str == 0 && str_ws_last < t_now && t_now - str_ws_last > str_ws/(str_blind_ws*str_blind_ws)){
  str_ws_last = t_now;
  str = 1;
  str_blind_ws = str_blind_ws + 0.05;
  if (str_blind_ws >= 3) {
      str_blind_ws = 1;
      // Noir pendant 1 sec (dans le futur)
      str = 0;
      str_ws_last = t_now + 1000;
  }
 }else if(str == 1 && str_ws_last < t_now && t_now - str_ws_last > (STROB_ON_MS)){
  str_ws_last = t_now;
  str = 0;
 }else{
  return;
 }
      r = rr * str * master / 255;
      g = gg * str * master / 255;
      b = bb * str * master / 255;
      sr = srr * str * smaster / 255;
      sg = sgg * str * smaster / 255;
      sb = sbb * str * smaster / 255;
    }//modulo 4
  else if ( type_modulo == 5 ) {
   int S_seuil_B;
  if(str == 0 && str_ws_last < t_now && t_now - str_ws_last > str_ws/(str_blind_ws*str_blind_ws)){
  str_ws_last = t_now;
  str = 1;
  str_blind_ws = str_blind_ws + 0.05;
  if (str_blind_ws >= 3) {
      str_blind_ws = 1;
      // Noir pendant 1 sec (dans le futur)
      str = 0;
      str_ws_last = t_now + 1000;
  }
 }else if(str == 1 && str_ws_last < t_now && t_now - str_ws_last > (STROB_ON_MS)){
  str_ws_last = t_now;
  str = 0;
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
     strands[0]->pixels[i] = pixelFromRGB(0, 0, 0);
     strands[1]->pixels[i] = pixelFromRGB(0, 0, 0);
     strands[2]->pixels[i] = pixelFromRGB(0, 0, 0);
     strands[3]->pixels[i] = pixelFromRGB(0, 0, 0);
    }//for i
 }else{
  return;
 }
      r = rr * str * master / 255;
      g = gg * str * master / 255;
      b = bb * str * master / 255;

      int n_led_to_show = min(numberOfLed-8, S_seuil); 
      int n_strip = 0;
for (int i = 0; i < n_led_to_show ; i ++){
 do {
    a = random( 0 , numberOfLed );
    n_strip = a / NUM_LEDS_PER_STRIP;
    }while (strands[n_strip]->pixels[a-(87*n_strip)].r != 0 || strands[n_strip]->pixels[a-(87*n_strip)].g != 0 || strands[n_strip]->pixels[a-(87*n_strip)].b != 0 );
    strands[n_strip]->pixels[a-(87*n_strip)] = pixelFromRGB(r, g, b); 
   }//for i
    }//modulo 5
}//eff_modulo
