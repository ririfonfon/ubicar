/////////////////////////////////////////lib/////////////////////////////////////////
#include <WiFi.h>
#include <WiFiUdp.h>
#include <ArtnetWifi.h>

/////////////////////////////////////////Wifi settings/////////////////////////////////////
const char* ssid = "RIRI-DMX-WiFi";
const char* password = "riridmxwifi";
#define WIFI_TIMEOUT 30000
unsigned long last_wifi_check_time = 0;

// Artnet settings
ArtnetWifi artnet;
const int startUniverse = 0; // CHANGE FOR YOUR SETUP most software this is 1, some software send out artnet first universe as 0.

// Check if we got all universes
const int maxUniverses = numberOfChannels / 512 + ((numberOfChannels % 512) ? 1 : 0);
bool universesReceived[maxUniverses];
bool sendFrame = 1;
int previousDataLength = 0;

// connect to wifi – returns true if successful or false if not

void ConnectWifi() {

  WiFi.setAutoReconnect(true);
  WiFi.begin(ssid, password);
  #ifdef DEBUG
  Serial.println("");
  Serial.println("Connecting to WiFi"); 
  // Wait for connection
  Serial.print("Connecting");
  #endif
 // If WIFI is the main channel, wait for connection to succeed or restart
  if (WiFi.waitForConnectResult() != WL_CONNECTED)  ESP.restart(); 

  }

