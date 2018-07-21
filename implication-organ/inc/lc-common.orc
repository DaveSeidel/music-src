/*
Hex   Decimal   Colour  Brightness
===   =======   ======  ==========
0Ch   12        Off     Off
0Dh   13        Red     Low
0Fh   15        Red     Full
1Dh   29        Amber   Low
3Fh   63        Amber   Full
3Eh   62        Yellow  Full
1Ch   28        Green   Low
3Ch   60        Green   Full
*/

#define LED_OFF         #12#
#define LED_RED_LOW     #13#
#define LED_RED_FULL    #15#
#define LED_AMBER_LOW   #29#
#define LED_AMBER_FULL  #63#
#define LED_YELLOW_FULL #62#
#define LED_GREEN_LOW   #28#
#define LED_GREEN_FULL  #60#

opcode butt_led_on, 0, ii
  ibutt, iled xin
  midiout 144, $BUTT_CHAN, ibutt, iled
endop

opcode butt_led_off, 0, i
  ibutt xin
  midiout 128, $BUTT_CHAN, ibutt, $LED_OFF
endop
