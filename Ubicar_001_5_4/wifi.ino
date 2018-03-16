/////////////////////////////////////////lib/////////////////////////////////////////
#include <WiFi.h>
#include <WiFiUdp.h>
#include <ArtnetWifi.h>

/////////////////////////////////////////Wifi settings/////////////////////////////////////
const char* ssid = "RIRI-DMX-WiFi";
const char* password = "riridmxwifi";

bool wifi_available = false;

void ConnectWifi() {
  WiFi.onEvent(wifi_event);
  WiFi.begin(ssid, password);
#ifdef DEBUG
  Serial.println("");
  Serial.println("Connecting to WiFi");
  // Wait for connection
  Serial.print("Connecting");
#endif
}//ConnectWifi

void wifi_event(WiFiEvent_t event) {
  static byte retry = 0;
  static byte maxRetry = 15;

  switch (event) {
    case SYSTEM_EVENT_STA_DISCONNECTED:
  master = 0;
  rr = 0;
  gg = 0;
  bb = 0;
  mod = 0;
  pix_mod = 0;
  pix_start = 0;
  modulo = 0;
  str_ws = 0;
  pix_center = 0;
  led_master = 0;
  led_mode = 0;
  led_str = 0;
  smaster = 0;
  srr = 0;
  sgg = 0;
  sbb = 0;
      break;
  }

#ifdef DEBUG
  switch (event) {
    case SYSTEM_EVENT_STA_CONNECTED:
      Serial.print("WiFi connected - ");
      Serial.print("IP address: ");
      Serial.println(WiFi.localIP());
      break;
    case SYSTEM_EVENT_STA_GOT_IP:
      Serial.print("Got IP - ");
      Serial.println(WiFi.localIP());
      break;
    case SYSTEM_EVENT_STA_LOST_IP:
      Serial.print("Lost IP..");
      break;
    case SYSTEM_EVENT_STA_DISCONNECTED:
      Serial.print("WiFi lost connection... ");
      break;
  }
#endif

  if (event == SYSTEM_EVENT_STA_DISCONNECTED) {
    wifi_available = false;
    retry += 1;

#ifdef DEBUG
    Serial.print(" reconnecting ");
    Serial.print(retry);
    Serial.print("/");
    Serial.println(maxRetry);
#endif
    WiFi.reconnect();
  }
  else if (event == SYSTEM_EVENT_STA_GOT_IP) {
    wifi_available = true;
    retry = 0;
  }
}// wifi_event

bool wifi_isok() {
  return wifi_available;
}//wifi_isok()

