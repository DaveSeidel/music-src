;
; Evolution UC-16 using preset 19 (except for channel number)
;

#define CHAN #2#

; upper row
#define U1 #102#
#define U2 #103#
#define U3 #104#
#define U4 #105#
#define U5 #106#
#define U6 #107#
#define U7 #108#
#define U8 #109#
; lower row
#define L1 #110#
#define L2 #111#
#define L3 #112#
#define L4 #113#
#define L5 #114#
#define L6 #115#
#define L7 #116#
#define L8 #117#

gknob1 init  0
gknob2 init  0
gknob3 init  0
gknob4 init  0
gknob5 init  0
gknob6 init  0
gknob7 init  0
gknob8 init  0
gknob9 init  0
gknob10 init 0
gknob11 init 0
gknob12 init 0
gknob13 init 0
gknob14 init 0
gknob15 init 0
gknob16 init 0

#define KNOB_U1 #gknob1#
#define KNOB_U2 #gknob2#
#define KNOB_U3 #gknob3#
#define KNOB_U4 #gknob4#
#define KNOB_U5 #gknob5#
#define KNOB_U6 #gknob6#
#define KNOB_U7 #gknob7#
#define KNOB_U8 #gknob8#

#define KNOB_L1 #gknob9#
#define KNOB_L2 #gknob10#
#define KNOB_L3 #gknob11#
#define KNOB_L4 #gknob12#
#define KNOB_L5 #gknob13#
#define KNOB_L6 #gknob14#
#define KNOB_L7 #gknob15#
#define KNOB_L8 #gknob16#

opcode read_controls, 0, 0
  $KNOB_U1,$KNOB_U2,$KNOB_U3,$KNOB_U4,$KNOB_U5,$KNOB_U6,$KNOB_U7,$KNOB_U8, \
  $KNOB_L1,$KNOB_L2,$KNOB_L3,$KNOB_L4,$KNOB_L5,$KNOB_L6,$KNOB_L7,$KNOB_L8  \
    slider16 $CHAN, $U1, 0, 1, 0, 0, \
                    $U2, 0, 1, 0, 0, \
                    $U3, 0, 1, 0, 0, \
                    $U4, 0, 1, 0, 0, \
                    $U5, 0, 1, 0, 0, \
                    $U6, 0, 1, 0, 0, \
                    $U7, 0, 1, 0, 0, \
                    $U8, 0, 1, 0, 0, \
                    $L1, 0, 1, 0, 0, \
                    $L2, 0, 1, 0, 0, \
                    $L3, 0, 1, 0, 0, \
                    $L4, 0, 1, 0, 0, \
                    $L5, 0, 1, 0, 0, \
                    $L6, 0, 1, 0, 0, \
                    $L7, 0, 1, 0, 0, \
                    $L8, 0, 1, 0, 0
endop

; control mappings
#define CTL_MAIN_LEVEL    #$KNOB_U1#
#define CTL_MAIN_DETUNE   #$KNOB_U2#
#define CTL_DER_LEVEL     #$KNOB_U3#
#define CTL_DER_RINGMOD   #$KNOB_L1#
#define CTL_DER_COMBOS    #$KNOB_L2#
#define CTL_DER_MEAN_ARI  #$KNOB_L3#
#define CTL_DER_MEAN_GEO  #$KNOB_L4#
#define CTL_DER_MEAN_HAR  #$KNOB_L5#
#define CTL_DER_MEAN_PHI  #$KNOB_L6#
