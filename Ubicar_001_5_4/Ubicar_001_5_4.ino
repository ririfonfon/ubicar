/////////////////////////////////////////ID/////////////////////////////////////
// ID grande = 1  moyene = 2 petite = 3
#define NODE_NUMBER 1
#define VERSION 4

/////////////////////////////////////////Adresse/////////////////////////////////////
// adresse grande = 1  moyene = 18 petite = 35
// strip   grande = 90 moyene = 78 petite = 66
#if defined(NODE_NUMBER) && NODE_NUMBER == 1
#define adr 1
#define NUM_LEDS_PER_STRIP 90
#elif defined (NODE_NUMBER) && NODE_NUMBER == 2
#define adr 18
#define NUM_LEDS_PER_STRIP 78
#elif defined (NODE_NUMBER) && NODE_NUMBER == 3
#define adr 35
#define NUM_LEDS_PER_STRIP 66
#endif

/////////////////////////////////////////Debug///////////////////////////////////////
#define DEBUG 1
//#define DEBUG_dmx 1
//#define DEBUG_STR 1

/////////////////////////////////////////lib/////////////////////////////////////////
#include <WiFi.h>
#include <WiFiUdp.h>
#include <ArtnetWifi.h>//https://github.com/rstephan/ArtnetWifi
unsigned long lastRefresh = 0;
#define REFRESH 10

#if defined(ARDUINO) && ARDUINO >= 100
// No extras
#elif defined(ARDUINO) // pre-1.0
// No extras
#elif defined(ESP_PLATFORM)
#include "arduinoish.hpp"
#endif

#define HBSIZE 32
char nodeName[HBSIZE];
byte myID;

///////////////////////////////Lib esp32_digital_led_lib//////////////////////////////
#include "esp32_digital_led_lib.h"
#define min(m,n) ((m)<(n)?(m):(n))
#define NUM_STRIPS 4
int PINS[NUM_STRIPS] = {23, 22, 18, 5};
const int numberOfChannels = NUM_STRIPS * NUM_LEDS_PER_STRIP * 3;
const int numberOfLed = NUM_STRIPS * NUM_LEDS_PER_STRIP ;
strand_t STRANDS[NUM_STRIPS];
strand_t * strands [] = { &STRANDS[0], &STRANDS[1], &STRANDS[2], &STRANDS[3]};
bool randArray[numberOfLed];

///////////////////////////////////dmx variables////////////////////////////////////
unsigned long now;
int effet_etat = 0;
int last_time_effet = 0;
int type_effet = 0;
int modulo = 0;
unsigned int str_ws = 0;
unsigned int l_str;
int type_modulo = 0;
int str = 0;
int str_l = 0;
int pix_pos;
int pix_start;
int pix_center;
int pix_end;
int master;
float rrr;
float ggg;
float bbb;
float rr;
float gg;
float bb;
float r;
float g;
float b;
int smaster;
float srr;
float sgg;
float sbb;
float sr;
float sg;
float sb;
int mod;
int pix_mod;
unsigned long t_now_effet = 0;
uint8_t strob_count = 0;
uint8_t strob_count_l = 0;
unsigned long str_ws_last = 0;
unsigned long t_last_l = 0;
#define STROB_FRACTION 10
#define STROB_ON 1
#define STROB_ON_MS 30
#define STROB_FRACTION_L 10
#define STROB_ON_L 1
#define STROB_ON_MS_L 30
int l_s_count = 1;
int pix_start_v;
int ref_pix_pos;
float pix_coef;
float pix_coefi;
int M_g;
int M_g_ref;
int M_g1;
int M_g1_ref;
int M_g2;
int M_g2_ref;
int M_g3;
int M_g3_ref;
int M_g4;
int S_seuil;
int old_S_seuil = 0;
int S_count;
int a;
int led_a;
int led_b;
int led_c;
int led_master;
int led_mode;
int led_str;
float str_blind_ws = 1;
float str_blind_l = 1;

///////////////////////////////////////PWM setting/////////////////////////////////////////
int freq = 12000;
int resolution = 16;
int ledChannela = 4;
int ledChannelb = 5;
int ledChannelc = 6;
int ledPina = 0;
int ledPinb = 2;
int ledPinc = 15;
uint8_t ledArray[3] = {1, 2, 3}; // three led channels
const boolean invert = true; // set true if common anode, false if common cathode

///////////////////////////////////// Artnet settings /////////////////////////////////////
ArtnetWifi artnet;
const int startUniverse = 0; // CHANGE FOR YOUR SETUP most software this is 1, some software send out artnet first universe as 0.

// Check if we got all universes
const int maxUniverses = numberOfChannels / 512 + ((numberOfChannels % 512) ? 1 : 0);
bool universesReceived[maxUniverses];
bool sendFrame = 1;
int previousDataLength = 0;

///////////////////////////////////////////////// SETUP ////////////////////////////////////////
void setup() {
#ifdef DEBUG
  Serial.begin(115200);
#endif
  // NODE ID
#ifdef NODE_NUMBER
  eeprom_setID((byte)NODE_NUMBER);
#endif

  // NAME
  myID = eeprom_getID();
  String myName("Pira");
  sprintf(nodeName, "Pira %02i %i", myID, VERSION);
#ifdef DEBUG
  Serial.print("Starting ");
  Serial.println(nodeName);
#endif

  pwm_init();
  leds_init();
  ConnectWifi();
  // OTA
  ota_setup();
  artnet.begin();
  artnet.setArtDmxCallback(onDmxFrame);
  initTest();
}//setup

///////////////////////////////////////// LOOP /////////////////////////////////////////////////
void loop() {
  if (wifi_isok()) artnet.read();
  eff_modulo();
  effet();
  effet_led_mode();
  if ((millis() - lastRefresh) > REFRESH) {
    if (!wifi_isok())  ledBlack();//passe led noir
    lastRefresh = millis();
  }
  // MILLIS overflow protection
  if (millis() < lastRefresh) {
    lastRefresh = millis();
  }
  // OTA
  ota_loop();
}//loop
