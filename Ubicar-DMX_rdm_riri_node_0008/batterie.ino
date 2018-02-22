float getVoltage(){
  adc1_config_width(ADC_WIDTH_12Bit);
  adc1_config_channel_atten(ADC1_CHANNEL_0,ADC_ATTEN_11db);
  int raw = adc1_get_voltage(ADC1_CHANNEL_0);
  int volt = map(raw, 740, 3900, 100, 420);             
  //volt = volt / 100;
  Serial.print("A0 "); Serial.println(raw);
  Serial.print("Voltage "); Serial.println(volt);
  display.clear();
    display.setFont(ArialMT_Plain_16);
    display.setTextAlignment(TEXT_ALIGN_LEFT);
    display.drawString(0, 0, "A0 ");
    sprintf (bufi, "%d", raw);
    display.drawString(60, 0, bufi);
    display.drawString(0, 24,"Voltage ");
    sprintf (bufa, "%d", volt);
    display.drawString(60, 24, bufa);
  return volt;
}

float getLevel(){
  adc1_config_width(ADC_WIDTH_12Bit);
  adc1_config_channel_atten(ADC1_CHANNEL_6,ADC_ATTEN_11db);
  rawb = adc1_get_voltage(ADC1_CHANNEL_6); 
  level = map(rawb, 2420, 3900, 0, 100);            
  if ( level < 0 ) { level = 0; }
  if ( level > 100 ) { level = 100; }
  return level;
}
