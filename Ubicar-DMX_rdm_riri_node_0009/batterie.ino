float getLevel() {
  i += 1;
  if (i > NB_SAMPLE) {
    i = 1;
    somme = 0;
  }
  raw = analogRead(34);
  somme += raw ; //somme des valeurs du tableau
  raw_m = somme  / i ; //valeur moyenne
  level = map(raw_m, 450, 511, 0, 100);
  if ( level < 0 ) {
    level = 0;
  }
  if ( level > 100 ) {
    level = 100;
  }
#ifdef DEBUGBAT
  Serial.print("raw "); Serial.println(raw);
  Serial.print("somme "); Serial.println(somme);
  Serial.print("i "); Serial.println(i);
  Serial.print("raw_m "); Serial.println(raw_m);
  Serial.print("level "); Serial.println(level);
  Serial.print("adcEnd(34) "); Serial.println(adcEnd(34));
#endif
  return level;
}
