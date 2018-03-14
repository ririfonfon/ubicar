void do_effet_4() {
  if (pix_mod >= 0 && pix_mod <= 10) {
    for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
      strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
      strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
      strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
      strands[3]->pixels[i] = pixelFromRGB(r, g, b);
    }//for i
  }//pix_mod 0

  if (pix_mod >= 11 && pix_mod <= 20) {
    for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
      if (i >= (pix_pos) && i <= pix_start + (pix_pos)) {
        strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[3]->pixels[i] = pixelFromRGB(r, g, b);
      } else  {
        strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
      }
    }//for i
  }//pix_mod 10

  if (pix_mod >= 21 && pix_mod <= 30) {
    for (int i = 0 ; i < numberOfLed ; i++) {
      if (i <= NUM_LEDS_PER_STRIP) {
        if (i >= (pix_pos) && i <= pix_start + (pix_pos)) {
          strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        } else {
          strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        }
      }
      if (i <= NUM_LEDS_PER_STRIP * 2 & i >= NUM_LEDS_PER_STRIP) {
        if (i >= (pix_pos) && i <= pix_start + (pix_pos)) {
          strands[1]->pixels[i - NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
        } else {
          strands[1]->pixels[i - NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
        }
      }
      if (i <= NUM_LEDS_PER_STRIP * 3 & i >= NUM_LEDS_PER_STRIP * 2) {
        if (i >= (pix_pos) && i <= pix_start + (pix_pos)) {
          strands[2]->pixels[i - NUM_LEDS_PER_STRIP * 2] = pixelFromRGB(sr, sg, sb);
        } else {
          strands[2]->pixels[i - NUM_LEDS_PER_STRIP * 2] = pixelFromRGB(sr, sg, sb);
        }
      }
      if (i <= NUM_LEDS_PER_STRIP * 4 & i >= NUM_LEDS_PER_STRIP * 3) {
        if (i >= (pix_pos) && i <= pix_start + (pix_pos)) {
          strands[3]->pixels[i - NUM_LEDS_PER_STRIP * 3] = pixelFromRGB(r, g, b);
        } else {
          strands[3]->pixels[i - NUM_LEDS_PER_STRIP * 3] = pixelFromRGB(sr, sg, sb);
        }
      }
    }//for i
  }//pix_mod 20

  if (pix_mod >= 31 && pix_mod <= 40) {
    for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
      if (i >= (pix_pos) && i <= pix_start + (pix_pos)) {
        if (pix_start <= 1) {
          pix_start_v = 1;
        } else {
          pix_start_v = pix_start;
        }
        pix_coefi = (((i - pix_pos) * 100) / pix_start_v) * 0.01;
        pix_coef = pix_coefi * pix_coefi;
        strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[3]->pixels[i] = pixelFromRGB(r * pix_coef, g * pix_coef, b * pix_coef);
      } else  {
        strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
      }
    }//for i
  }//pix_mod 30

  if (pix_mod >= 41 && pix_mod <= 50) {
    ref_pix_pos = (pix_start + pix_pos);
    for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
      if (i >= (pix_pos) && i <= (pix_start + pix_pos)) {
        if (pix_start <= 1) {
          pix_start_v = 1;
        } else {
          pix_start_v = pix_start;
        }
        pix_coefi = (((pix_pos - ref_pix_pos) * 100) / pix_start_v) * 0.01;
        pix_coef = pix_coefi * pix_coefi;
        strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[3]->pixels[i] = pixelFromRGB(r * pix_coef, g * pix_coef, b * pix_coef);
        ref_pix_pos--;
      } else  {
        strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
      }
    }//for i
  }//pix_mod 40

  if (pix_mod >= 51 && pix_mod <= 60) {
    ref_pix_pos = (pix_start + pix_pos);
    for (int i = 0 ; i < NUM_LEDS_PER_STRIP ; i++) {
      if (i >= (pix_pos) && i <= (pix_start + pix_pos)) {
        if (pix_start <= 1) {
          pix_start_v = 1;
        } else {
          pix_start_v = pix_start;
        }
        if (i <= pix_center) {
          pix_coefi = ((((i - pix_pos + 1)) * 200) / pix_start_v) * 0.01;
          pix_coef = pix_coefi * pix_coefi;
        }
        else if (i >= pix_center) {
          pix_coefi = ((((pix_pos - ref_pix_pos)) * 100) / pix_start_v) * 0.01;
          pix_coef = pix_coefi * pix_coefi;
          ref_pix_pos = ref_pix_pos - 2;
        }
        if (pix_coef > 1) pix_coef = 1;
        strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[3]->pixels[i] = pixelFromRGB(r * pix_coef, g * pix_coef, b * pix_coef);
      } else  {
        strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[1]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[2]->pixels[i] = pixelFromRGB(sr, sg, sb);
        strands[3]->pixels[i] = pixelFromRGB(sr, sg, sb);
      }
    }//for i
  }//pix_mod 50

  if (pix_mod >= 61 && pix_mod <= 70) {
    for (int i = 0 ; i < numberOfLed ; i++) {
      if (i >= (pix_pos) && i <= pix_start + (pix_pos)) {
        if (pix_start <= 1) {
          pix_start_v = 1;
        } else {
          pix_start_v = pix_start;
        }
        pix_coefi = (((i - pix_pos) * 100) / pix_start_v) * 0.01;
        pix_coef = pix_coefi * pix_coefi;

        if (i <= NUM_LEDS_PER_STRIP) {
          strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 2 & i >= NUM_LEDS_PER_STRIP) {
          strands[1]->pixels[i - NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 3 & i >= NUM_LEDS_PER_STRIP * 2) {
          strands[2]->pixels[i - NUM_LEDS_PER_STRIP * 2] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 4 & i >= NUM_LEDS_PER_STRIP * 3) {
          strands[3]->pixels[i - NUM_LEDS_PER_STRIP * 3] = pixelFromRGB(r * pix_coef, g * pix_coef, b * pix_coef);
        }
      } else {
        if (i <= NUM_LEDS_PER_STRIP) {
          strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 2 & i >= NUM_LEDS_PER_STRIP) {
          strands[1]->pixels[i - NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 3 & i >= NUM_LEDS_PER_STRIP * 2) {
          strands[2]->pixels[i - NUM_LEDS_PER_STRIP * 2] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 4 & i >= NUM_LEDS_PER_STRIP * 3) {
          strands[3]->pixels[i - NUM_LEDS_PER_STRIP * 3] = pixelFromRGB(sr, sg, sb);
        }
      }
    }//for i
  }//pix_mod 60

  if (pix_mod >= 71 && pix_mod <= 80) {
    ref_pix_pos = (pix_start + pix_pos);
    for (int i = 0 ; i < numberOfLed ; i++) {
      if (i >= (pix_pos) && i <= (pix_start + pix_pos)) {
        if (pix_start <= 1) {
          pix_start_v = 1;
        } else {
          pix_start_v = pix_start;
        }
        pix_coefi = (((pix_pos - ref_pix_pos) * 100) / pix_start_v) * 0.01;
        pix_coef = pix_coefi * pix_coefi;
        ref_pix_pos--;

        if (i <= NUM_LEDS_PER_STRIP) {
          strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 2 & i >= NUM_LEDS_PER_STRIP) {
          strands[1]->pixels[i - NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 3 & i >= NUM_LEDS_PER_STRIP * 2) {
          strands[2]->pixels[i - NUM_LEDS_PER_STRIP * 2] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 4 & i >= NUM_LEDS_PER_STRIP * 3) {
          strands[3]->pixels[i - NUM_LEDS_PER_STRIP * 3] = pixelFromRGB(r * pix_coef, g * pix_coef, b * pix_coef);
        }
      } else {
        if (i <= NUM_LEDS_PER_STRIP) {
          strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 2 & i >= NUM_LEDS_PER_STRIP) {
          strands[1]->pixels[i - NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 3 & i >= NUM_LEDS_PER_STRIP * 2) {
          strands[2]->pixels[i - NUM_LEDS_PER_STRIP * 2] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 4 & i >= NUM_LEDS_PER_STRIP * 3) {
          strands[3]->pixels[i - NUM_LEDS_PER_STRIP * 3] = pixelFromRGB(sr, sg, sb);
        }
      }
    }//for i
  }//pix_mod 70

  if (pix_mod >= 81 && pix_mod <= 90) {
    ref_pix_pos = (pix_start + pix_pos);
    for (int i = 0 ; i < numberOfLed ; i++) {
      if (i >= (pix_pos) && i <= (pix_start + pix_pos)) {
        if (pix_start <= 1) {
          pix_start_v = 1;
        } else {
          pix_start_v = pix_start;
        }
        if (i <= pix_center) {
          pix_coefi = ((((i - pix_pos + 1)) * 200) / pix_start_v) * 0.01;
          pix_coef = pix_coefi * pix_coefi;
        }
        else if (i >= pix_center) {
          pix_coefi = ((((pix_pos - ref_pix_pos)) * 100) / pix_start_v) * 0.01;
          pix_coef = pix_coefi * pix_coefi;
          ref_pix_pos = ref_pix_pos - 2;
        }
        if (pix_coef > 1) pix_coef = 1;

        if (i <= NUM_LEDS_PER_STRIP) {
          strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 2 & i >= NUM_LEDS_PER_STRIP) {
          strands[1]->pixels[i - NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 3 & i >= NUM_LEDS_PER_STRIP * 2) {
          strands[2]->pixels[i - NUM_LEDS_PER_STRIP * 2] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 4 & i >= NUM_LEDS_PER_STRIP * 3) {
          strands[3]->pixels[i - NUM_LEDS_PER_STRIP * 3] = pixelFromRGB(r * pix_coef, g * pix_coef, b * pix_coef);
        }
      } else {
        if (i <= NUM_LEDS_PER_STRIP) {
          strands[0]->pixels[i] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 2 & i >= NUM_LEDS_PER_STRIP) {
          strands[1]->pixels[i - NUM_LEDS_PER_STRIP] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 3 & i >= NUM_LEDS_PER_STRIP * 2) {
          strands[2]->pixels[i - NUM_LEDS_PER_STRIP * 2] = pixelFromRGB(sr, sg, sb);
        } else if (i <= NUM_LEDS_PER_STRIP * 4 & i >= NUM_LEDS_PER_STRIP * 3) {
          strands[3]->pixels[i - NUM_LEDS_PER_STRIP * 3] = pixelFromRGB(sr, sg, sb);
        }
      }
    }//for i
  }//pix_mod 80
}//do_effet_4 ruban 4
