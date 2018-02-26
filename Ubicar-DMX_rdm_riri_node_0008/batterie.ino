float getVoltage(){
  int raw_m;
  long somme = 0; 
  int raw = 0;

    for (int i = 0 ; i < NB_SAMPLE ; i++)
    {  
      raw = analogRead(34);
        somme += raw ; //somme des valeurs du tableau
    }

  raw_m = somme  / NB_SAMPLE ; //valeur moyenne
  int volt = map(raw_m, 204, 295, 300, 420);     

  #ifdef DEBUG
  Serial.print("A0_m "); Serial.println(raw_m);
  Serial.print("Voltage "); Serial.println(volt);
  #endif
  
    display.clear();
    display.setFont(ArialMT_Plain_16);
    display.setTextAlignment(TEXT_ALIGN_LEFT);
    display.drawString(0, 0, "A0 ");
    sprintf (bufi, "%d", raw_m);
    display.drawString(60, 0, bufi);
    display.drawString(0, 24,"Voltage ");
    sprintf (bufa, "%d", volt);
    display.drawString(60, 24, bufa);
    display.display();
  return volt;
}

float getLevel(){
  int raw_m;
  long somme = 0; 
  int raw = 0;

    for (int i = 0 ; i < NB_SAMPLE ; i++)
    {  
      raw = analogRead(34);
      somme += raw ; //somme des valeurs du tableau
    }
  raw_m = somme  / NB_SAMPLE ; //valeur moyenne   
  level = map(raw_m, 204, 290, 0, 100);            
  if ( level < 0 ) { level = 0; }
  if ( level > 100 ) { level = 100; }
  return level;
}
