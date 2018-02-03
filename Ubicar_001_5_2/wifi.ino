/////////////////////////////////////////lib/////////////////////////////////////////
#include <WiFi.h>
#include <WiFiUdp.h>
#include <ArtnetWifi.h>

/////////////////////////////////////////Wifi settings/////////////////////////////////////
const char* ssid = "RIRI-DMX-WiFi";
const char* password = "riridmxwifi";

void ConnectWifi() {

  WiFi.setAutoReconnect(true);
  WiFi.begin(ssid, password);
  #ifdef DEBUG
  Serial.println("");
  Serial.println("Connecting to WiFi"); 
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  #endif 
  // If WIFI is the main channel, wait for connection to succeed or restart
  if (WiFi.waitForConnectResult() != WL_CONNECTED)  ESP.restart();
}//ConnectWifi

