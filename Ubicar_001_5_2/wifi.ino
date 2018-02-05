/////////////////////////////////////////lib/////////////////////////////////////////
#include <WiFi.h>
#include <WiFiUdp.h>
#include <ArtnetWifi.h>

/////////////////////////////////////////Wifi settings/////////////////////////////////////
const char* ssid = "RIRI-DMX-WiFi";
const char* password = "riridmxwifi";

void ConnectWifi() {
  int state = 1;
  int i = 0;

  WiFi.setAutoReconnect(true);
  WiFi.begin(ssid, password);
  #ifdef DEBUG
  Serial.println("");
  Serial.println("Connecting to WiFi"); 
  // Wait for connection
  Serial.print("Connecting");
  #endif
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    #ifdef DEBUG
    Serial.print(".");
    #endif
    if (i > 20){
      state = 0;
      break;
    }
    i++;
  }
  if (state==1){
    #ifdef DEBUG
    Serial.println("");
    Serial.print("Connected to ");
    Serial.println(ssid);
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());
    #endif
  } else {
    #ifdef DEBUG
    Serial.println("");
    Serial.println("Connection failed.");
    #endif
    ESP.restart();
  }  

  // If WIFI is the main channel, wait for connection to succeed or restart
  if (WiFi.waitForConnectResult() != WL_CONNECTED)  ESP.restart();

}//ConnectWifi

