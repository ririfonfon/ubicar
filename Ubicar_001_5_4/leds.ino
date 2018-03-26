
int test_led_niv = 50;

void leds_show() {
  digitalLeds_updatePixels(strands[0]);
  digitalLeds_updatePixels(strands[1]);
  digitalLeds_updatePixels(strands[2]);
  digitalLeds_updatePixels(strands[3]);
  ledcWrite(ledChannela, led_a);
  ledcWrite(ledChannelb, led_b);
  ledcWrite(ledChannelc, led_c);
}//leds_show

void ledBlack() {
#ifdef DEBUG
  Serial.println("ledBlack()");
#endif
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    strands[0]->pixels[i] = pixelFromRGB(0, 0, 0);
    strands[1]->pixels[i] = pixelFromRGB(0, 0, 0);
    strands[2]->pixels[i] = pixelFromRGB(0, 0, 0);
    strands[3]->pixels[i] = pixelFromRGB(0, 0, 0);
    led_a = 0;
    led_b = 0;
    led_c = 0;
  }//for i
  leds_show();
}//ledBlack

void initTest() {
#ifdef DEBUG
  Serial.println("initTest()");
#endif
  Black();
  leds_show();
  delay(500);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    strands[0]->pixels[i] = pixelFromRGB(test_led_niv, 0, 0);
    strands[1]->pixels[i] = pixelFromRGB(test_led_niv, 0, 0);
    strands[2]->pixels[i] = pixelFromRGB(test_led_niv, 0, 0);
    strands[3]->pixels[i] = pixelFromRGB(test_led_niv, 0, 0);
  }//for i
  leds_show();
  delay(500);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    strands[0]->pixels[i] = pixelFromRGB(0, test_led_niv, 0);
    strands[1]->pixels[i] = pixelFromRGB(0, test_led_niv, 0);
    strands[2]->pixels[i] = pixelFromRGB(0, test_led_niv, 0);
    strands[3]->pixels[i] = pixelFromRGB(0, test_led_niv, 0);
  }//for i
  leds_show();
  delay(500);
  for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
    strands[0]->pixels[i] = pixelFromRGB(0, 0, test_led_niv);
    strands[1]->pixels[i] = pixelFromRGB(0, 0, test_led_niv);
    strands[2]->pixels[i] = pixelFromRGB(0, 0, test_led_niv);
    strands[3]->pixels[i] = pixelFromRGB(0, 0, test_led_niv);
  }//for i
  leds_show();
  delay(500);
  Black();
  leds_show();
}//initest

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
  for (int k = 0; k < NUM_STRIPS; k++) {
    STRANDS[k] = {  .rmtChannel = k, .gpioNum = PINS[k], .ledType = LED_WS2812B_V3, .brightLimit = 32,
                    .numPixels = NUM_LEDS_PER_STRIP, .pixels = nullptr, ._stateVars = nullptr
                 };
    gpioSetup(PINS[k], OUTPUT, LOW);
  }
  int STRANDCNT = sizeof(STRANDS) / sizeof(STRANDS[0]);
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
