/////////////////////////////////////////lib/////////////////////////////////////////
#include <WiFi.h>
#include <WiFiUdp.h>
#include <ArtnetWifi.h>

/////////////////////////////////////////Wifi settings/////////////////////////////////////
const char* ssid = "RIRI-DMX-WiFi";
const char* password = "riridmxwifi";

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

void wifi_event(WiFiEvent_t event){
    static byte retry = 0;
    static byte maxRetry = 15;
  
    #ifdef DEBUG     
       switch(event) {
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
    
    if(event == SYSTEM_EVENT_STA_DISCONNECTED){
      retry += 1;
//      if (retry > maxRetry) {
//        #ifdef DEBUG 
//          Serial.println("Can't connect to WIFI... RESTART ESP !");
//        #endif 
//        WiFi.disconnect(true);
//        delay(100);
//        ESP.restart();
//      }
      
      #ifdef DEBUG  
        Serial.print(" reconnecting ");
        Serial.print(retry);
        Serial.print("/");
        Serial.println(maxRetry);
      #endif 
      WiFi.reconnect();
    }
    else if (event == SYSTEM_EVENT_STA_GOT_IP){
      retry = 0;
    }
}// wifi_event

