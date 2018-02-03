#define min(m,n) ((m)<(n)?(m):(n))

///////////////////////////////Adresse
#define adr 1

///////////////////////////////Debug
//#define DEBUG 1
//#define DEBUG_dmx 1
//#define DEBUG_STR 1

/////////////////////////////////////////WS settings///////////////////////////////////////
#define NUM_STRIPS 4
#define NUM_LEDS_PER_STRIP 87
const int numberOfChannels = NUM_STRIPS * NUM_LEDS_PER_STRIP * 3;
const int numberOfLed = NUM_STRIPS * NUM_LEDS_PER_STRIP ;

/////////////////////////////////////////lib/////////////////////////////////////////
#include <WiFi.h>
#include <WiFiUdp.h>
#include <ArtnetWifi.h>

//int getMaxMalloc(int min_mem, int max_mem) {
//  int prev_size = min_mem;
//  int curr_size = min_mem;
//  int max_free = 0;
//
//  while (1) {
//    void * foo1 = malloc(curr_size);
//
//    if (foo1 == nullptr) {  // Back off
//      max_mem = min(curr_size, max_mem);
//
//      curr_size = (int)(curr_size - (curr_size - prev_size) / 2.0);
//
//    }
//    else {  // Advance
//      free(foo1);
//      max_free = curr_size;
//      prev_size = curr_size;
//      curr_size = min(curr_size * 2, max_mem);
//
//    }
//    if (abs(curr_size - prev_size) == 0) {
//      break;
//    }
//  }
//  #ifdef DEBUG
//  Serial.print("checkmem: max free heap = ");
//  Serial.print(esp_get_free_heap_size());
//  Serial.print(" bytes, max allocable = ");
//  Serial.print(max_free);
//  Serial.println(" bytes");
//  #endif
//  return max_free;
//}


#if defined(ARDUINO) && ARDUINO >= 100
  // No extras
#elif defined(ARDUINO) // pre-1.0
  // No extras
#elif defined(ESP_PLATFORM)
  #include "arduinoish.hpp"
#endif

// **Required** if debugging is enabled in library header
// TODO: Is there any way to put this in digitalLeds_initStrands() and avoid undefined refs?
#if DEBUG_ESP32_DIGITAL_LED_LIB
  int digitalLeds_debugBufferSz = 1024;
  char * digitalLeds_debugBuffer = static_cast<char*>(calloc(digitalLeds_debugBufferSz, sizeof(char)));
#endif

void gpioSetup(int gpioNum, int gpioMode, int gpioVal) {
  #if defined(ARDUINO) && ARDUINO >= 100
    pinMode (gpioNum, gpioMode);
    digitalWrite (gpioNum, gpioVal);
  #elif defined(ESP_PLATFORM)
    gpio_num_t gpioNumNative = static_cast<gpio_num_t>(gpioNum);
    gpio_mode_t gpioModeNative = static_cast<gpio_mode_t>(gpioMode);
    gpio_pad_select_gpio(gpioNumNative);
    gpio_set_direction(gpioNumNative, gpioModeNative);
    gpio_set_level(gpioNumNative, gpioVal);
  #endif
}// gpioSetup


// Artnet settings
ArtnetWifi artnet;
const int startUniverse = 0; // CHANGE FOR YOUR SETUP most software this is 1, some software send out artnet first universe as 0.

// Check if we got all universes
const int maxUniverses = numberOfChannels / 512 + ((numberOfChannels % 512) ? 1 : 0);
bool universesReceived[maxUniverses];
bool sendFrame = 1;
int previousDataLength = 0;

// connect to wifi – returns true if successful or false if not


///////////////////////////////////////PWM setting/////////////////////////////////////////
int freq =12000;
int resolution = 16;
int ledChannela = 4;
int ledChannelb = 5;
int ledChannelc = 6;
int ledPina = 0;
int ledPinb = 2;
int ledPinc = 15;
uint8_t ledArray[3] = {1, 2, 3}; // three led channels
const boolean invert = true; // set true if common anode, false if common cathode

///////////////////////////////////////dmx variables/////////////////////////////////////////
unsigned long now;
int effet_etat = 0;
int last_time_effet = 0;
int type_effet = 0;
int modulo=0;
unsigned int str_ws=0;
unsigned int l_str;
int type_modulo=0;
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
unsigned long t_last_l =0;
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
#define min(m,n) ((m)<(n)?(m):(n))
      
//////////////////////////////////////////////// VOID //////////////////////////////////////////

void dumpSysInfo() {
  esp_chip_info_t sysinfo;
  esp_chip_info(&sysinfo);
  #ifdef DEBUG
  Serial.print("Model: ");
  Serial.print((int)sysinfo.model);
  Serial.print("; Features: 0x");
  Serial.print((int)sysinfo.features, HEX);
  Serial.print("; Cores: ");
  Serial.print((int)sysinfo.cores);
  Serial.print("; Revision: r");
  Serial.println((int)sysinfo.revision);
  #endif
}// dumpSysInfo

void dumpDebugBuffer(int id, char * debugBuffer){
  #ifdef DEBUG
  Serial.print("DEBUG: (");
  Serial.print(id);
  Serial.print(") ");
  Serial.println(debugBuffer);
  #endif
  debugBuffer[0] = 0;
}// dumpDebugBuffer








void effet_led_mode(){
  if ((led_mode>=0)&&(led_mode<=10)) {
  led_a=led_master;
  led_b=led_master;
  led_c=led_master;
}//ALL
else if ((led_mode>=11)&&(led_mode<=20)) {
  led_a=led_master;
  led_b=0;
  led_c=0;
}//1
else if ((led_mode>=21)&&(led_mode<=30)) {
  led_a=0;
  led_b=led_master;
  led_c=0;
}//2
else if ((led_mode>=31)&&(led_mode<=40)) {
  led_a=0;
  led_b=0;
  led_c=led_master;
}//3
else if ((led_mode>=41)&&(led_mode<=50)) {
 unsigned long t_now_l = millis();
 if(str_l == 0 && t_now_l - t_last_l > led_str){
  t_last_l = t_now_l;
  str_l = 1;
 }else if(str_l == 1 && t_now_l - t_last_l > STROB_ON_MS_L){
  t_last_l = t_now_l;
  str_l = 0;
 }else{
  return;
 }
 led_a = str_l * led_master ;
 led_b = str_l * led_master ;
 led_c = str_l * led_master ; 
}//ALL Str
else if ((led_mode>=51)&&(led_mode<=60)) {
 unsigned long t_now_l = millis();
 if(str_l == 0 && t_now_l - t_last_l > led_str){
  t_last_l = t_now_l;
  str_l = 1;
 }else if(str_l == 1 && t_now_l - t_last_l > STROB_ON_MS_L){
  t_last_l = t_now_l;
  str_l = 0;
 }else{
  return;
 }
 led_a = str_l * led_master ;
 led_b = 0 ;
 led_c = 0 ;  
}//1 Str
else if ((led_mode>=61)&&(led_mode<=70)) {
 unsigned long t_now_l = millis();
 if(str_l == 0 && t_now_l - t_last_l > led_str){
  t_last_l = t_now_l;
  str_l = 1;
 }else if(str_l == 1 && t_now_l - t_last_l > STROB_ON_MS_L){
  t_last_l = t_now_l;
  str_l = 0;
 }else{
  return;
 }
 led_a = 0 ;
 led_b = str_l * led_master ;
 led_c = 0 ;   
}//2 Str
else if ((led_mode>=71)&&(led_mode<=80)) {
 unsigned long t_now_l = millis();
 if(str_l == 0 && t_now_l - t_last_l > led_str){
  t_last_l = t_now_l;
  // ALLUMER LED
  str_l = 1;
 }else if(str_l == 1 && t_now_l - t_last_l > STROB_ON_MS_L){
  t_last_l = t_now_l;
  str_l = 0;
 }else{
  return;
 }
 led_a = 0 ;
 led_b = 0 ;
 led_c = str_l * led_master ;   
}//3 Str
else if ((led_mode>=81)&&(led_mode<=90)) {
 unsigned long t_now_l = millis();
if(str_l == 0 && t_now_l - t_last_l > led_str){
  t_last_l = t_now_l;
  str_l = 1;
 }else if(str_l == 1 && t_now_l - t_last_l > STROB_ON_MS_L){
  t_last_l = t_now_l;
  str_l = 0;
 }else{
  return;
 }
 if (l_s_count==1) {
 led_a = str_l * led_master ;
 led_b = 0 ;
 led_c = 0 ;  
 } else if (l_s_count==2) {
 led_a = 0 ;
 led_b = str_l * led_master ;
 led_c = 0 ;   
 } else if (l_s_count==3) {
 led_a = 0 ;
 led_b = 0 ;
 led_c = str_l * led_master ;
 }
 l_s_count=l_s_count + 1;
 if (l_s_count>3) l_s_count = 1;   
}//123 Str
else if ((led_mode>=91)&&(led_mode<=100)) {
 unsigned long t_now_l = millis();
if(str_l == 0 && t_last_l < t_now_l && t_now_l - t_last_l > led_str/(str_blind_l*str_blind_l)){
  t_last_l = t_now_l;
  str_l = 1;
  str_blind_l = str_blind_l + 0.05;
  if (str_blind_l >= 3) {
      str_blind_l = 1;
      // Noir pendant 1 sec (dans le futur)
      str_l = 0;
      t_last_l = t_now_l + 1000;
  }
 }else if(str_l == 1 && t_last_l < t_now_l && t_now_l - t_last_l > (STROB_ON_MS_L)){
  t_last_l = t_now_l;
  str_l = 0;
 }else{
  return;
 }
 led_a = str_l * led_master ;
 led_b = str_l * led_master ;
 led_c = str_l * led_master ; 
}//ALL Blink Str
else if ((led_mode>=101)&&(led_mode<=110)) {
 unsigned long t_now_l = millis();
if(str_l == 0 && t_last_l < t_now_l && t_now_l - t_last_l > led_str/(str_blind_l*str_blind_l)){
  t_last_l = t_now_l;
  str_l = 1;
  str_blind_l = str_blind_l + 0.05;
  if (str_blind_l >= 3) {
      str_blind_l = 1;
      // Noir pendant 1 sec (dans le futur)
      str_l = 0;
      t_last_l = t_now_l + 1000;
  }
 }else if(str_l == 1 && t_last_l < t_now_l && t_now_l - t_last_l > (STROB_ON_MS_L)){
  t_last_l = t_now_l;
  str_l = 0;
 }else{
  return;
 }
 led_a = str_l * led_master ;
 led_b = 0 ;
 led_c = 0 ; 
}//1 Blink Str
else if ((led_mode>=111)&&(led_mode<=120)) {
 unsigned long t_now_l = millis();
if(str_l == 0 && t_last_l < t_now_l && t_now_l - t_last_l > led_str/(str_blind_l*str_blind_l)){
  t_last_l = t_now_l;
  str_l = 1;
  str_blind_l = str_blind_l + 0.05;
  if (str_blind_l >= 3) {
      str_blind_l = 1;
      // Noir pendant 1 sec (dans le futur)
      str_l = 0;
      t_last_l = t_now_l + 1000;
  }
 }else if(str_l == 1 && t_last_l < t_now_l && t_now_l - t_last_l > (STROB_ON_MS_L)){
  t_last_l = t_now_l;
  str_l = 0;
 }else{
  return;
 }
 led_a = 0 ;
 led_b = str_l * led_master ;
 led_c = 0 ; 
}//2 Blink Str
else if ((led_mode>=121)&&(led_mode<=130)) {
 unsigned long t_now_l = millis();
if(str_l == 0 && t_last_l < t_now_l && t_now_l - t_last_l > led_str/(str_blind_l*str_blind_l)){
  t_last_l = t_now_l;
  str_l = 1;
  str_blind_l = str_blind_l + 0.05;
  if (str_blind_l >= 3) {
      str_blind_l = 1;
      // Noir pendant 1 sec (dans le futur)
      str_l = 0;
      t_last_l = t_now_l + 1000;
  }
 }else if(str_l == 1 && t_last_l < t_now_l && t_now_l - t_last_l > (STROB_ON_MS_L)){
  t_last_l = t_now_l;
  str_l = 0;
 }else{
  return;
 }
 led_a = 0 ;
 led_b = 0 ;
 led_c = str_l * led_master ; 
}//3 Blink Str
else if ((led_mode>=131)&&(led_mode<=140)) {
 unsigned long t_now_l = millis();
if(str_l == 0 && t_last_l < t_now_l && t_now_l - t_last_l > led_str/(str_blind_l*str_blind_l)){
  t_last_l = t_now_l;
  str_l = 1;
  str_blind_l = str_blind_l + 0.05;
  if (str_blind_l >= 3) {
      str_blind_l = 1;
      // Noir pendant 1 sec (dans le futur)
      str_l = 0;
      t_last_l = t_now_l + 1000;
  }
 }else if(str_l == 1 && t_last_l < t_now_l && t_now_l - t_last_l > (STROB_ON_MS_L)){
  t_last_l = t_now_l;
  str_l = 0;
 }else{
  return;
 }
 if (l_s_count==1) {
 led_a = str_l * led_master ;
 led_b = 0 ;
 led_c = 0 ;  
 } else if (l_s_count==2) {
 led_a = 0 ;
 led_b = str_l * led_master ;
 led_c = 0 ;   
 } else if (l_s_count==3) {
 led_a = 0 ;
 led_b = 0 ;
 led_c = str_l * led_master ;
 }
 l_s_count=l_s_count + 1;
 if (l_s_count>3) l_s_count = 1; 
}//123 Blink Str
}//effet_led_mode






///////////////////////////////////////////////// SETUP ////////////////////////////////////////
void setup() {
  #ifdef DEBUG
  Serial.begin(115200);
  #endif
   
/////////////////////////////////////////////////PWM setup 
  ledcAttachPin(ledPina, ledChannela);
  ledcAttachPin(ledPinb, ledChannelb);
  ledcAttachPin(ledPinc, ledChannelc);
  ledcSetup(ledChannela, freq, resolution);
  ledcSetup(ledChannelb, freq, resolution);
  ledcSetup(ledChannelc, freq, resolution);
    
//  ConnectWifi();
  artnet.begin();
  leds_init();
//  initTest();

  // this will be called for each packet received
  artnet.setArtDmxCallback(onDmxFrame);
  
}//setup

///////////////////////////////////////// LOOP /////////////////////////////////////////////////
void loop() {
  
  unsigned long now = millis();
  unsigned long last_refresh = millis();

  // we call the read function inside the loop
  artnet.read();
  eff_modulo();
  effet();   
  effet_led_mode();
  
}//loop
