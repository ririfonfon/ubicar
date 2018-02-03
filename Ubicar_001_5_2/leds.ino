


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



void leds_init() {

 for (int k=0; k<NUM_STRIPS; k++) {
    STRANDS[k] = {  .rmtChannel = k, .gpioNum = PINS[k], .ledType = LED_WS2812B_V3, .brightLimit = 32, 
                    .numPixels = NUM_LEDS_PER_STRIP, .pixels = nullptr, ._stateVars = nullptr};
    gpioSetup(PINS[k], OUTPUT, LOW);
  }
  
int STRANDCNT = sizeof(STRANDS)/sizeof(STRANDS[0]);

  if (digitalLeds_initStrands(STRANDS, STRANDCNT)) {
    #ifdef DEBUG
    Serial.println("Init FAILURE: halting");
    delay(1000);
    #endif
    ESP.restart();
  }
  for (int i = 0; i < STRANDCNT; i++) {
    strand_t * pStrand = &STRANDS[i];
  }
  #ifdef DEBUG
  Serial.println("Init complete");
  #endif
}//leds_init
