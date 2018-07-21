;
; Launch Control XL using custon preset
; controllers 0-31 on channel 3
;
; TODO: buttons
;

#define CONTROLLER_LCXL ##

#define KNOB_CHAN #3#
#define BUTT_CHAN #9#

; upper row of knobs
#define U1 #0#
#define U2 #1#
#define U3 #2#
#define U4 #3#
#define U5 #4#
#define U6 #5#
#define U7 #6#
#define U8 #7#
; middle row of knobs
#define M1 #8#
#define M2 #9#
#define M3 #10#
#define M4 #11#
#define M5 #12#
#define M6 #13#
#define M7 #14#
#define M8 #15#
; lower row of knobs
#define L1 #16#
#define L2 #17#
#define L3 #18#
#define L4 #19#
#define L5 #20#
#define L6 #21#
#define L7 #22#
#define L8 #23#
; sliders
#define S1 #24#
#define S2 #25#
#define S3 #26#
#define S4 #27#
#define S5 #28#
#define S6 #29#
#define S7 #30#
#define S8 #31#

gknob_u1 init  0
gknob_u2 init  0
gknob_u3 init  0
gknob_u4 init  0
gknob_u5 init  0
gknob_u6 init  0
gknob_u7 init  0
gknob_u8 init  0

gknob_m1 init  0
gknob_m2 init  0
gknob_m3 init  0
gknob_m4 init  0
gknob_m5 init  0
gknob_m6 init  0
gknob_m7 init  0
gknob_m8 init  0

gknob_l1 init  0
gknob_l2 init  0
gknob_l3 init  0
gknob_l4 init  0
gknob_l5 init  0
gknob_l6 init  0
gknob_l7 init  0
gknob_l8 init  0

gkslider_1 init  0
gkslider_2 init  0
gkslider_3 init  0
gkslider_4 init  0
gkslider_5 init  0
gkslider_6 init  0
gkslider_7 init  0
gkslider_8 init  0

#define KNOB_U1 #gknob_u1#
#define KNOB_U2 #gknob_u2#
#define KNOB_U3 #gknob_u3#
#define KNOB_U4 #gknob_u4#
#define KNOB_U5 #gknob_u5#
#define KNOB_U6 #gknob_u6#
#define KNOB_U7 #gknob_u7#
#define KNOB_U8 #gknob_u8#

#define KNOB_M1 #gknob_m1#
#define KNOB_M2 #gknob_m2#
#define KNOB_M3 #gknob_m3#
#define KNOB_M4 #gknob_m4#
#define KNOB_M5 #gknob_m5#
#define KNOB_M6 #gknob_m6#
#define KNOB_M7 #gknob_m7#
#define KNOB_M8 #gknob_m8#

#define KNOB_L1 #gknob_l1#
#define KNOB_L2 #gknob_l2#
#define KNOB_L3 #gknob_l3#
#define KNOB_L4 #gknob_l4#
#define KNOB_L5 #gknob_l5#
#define KNOB_L6 #gknob_l6#
#define KNOB_L7 #gknob_l7#
#define KNOB_L8 #gknob_l8#

#define SLIDER_1 #gkslider_1#
#define SLIDER_2 #gkslider_2#
#define SLIDER_3 #gkslider_3#
#define SLIDER_4 #gkslider_4#
#define SLIDER_5 #gkslider_5#
#define SLIDER_6 #gkslider_6#
#define SLIDER_7 #gkslider_7#
#define SLIDER_8 #gkslider_8#

opcode read_controls, 0, 0
  $KNOB_U1,  $KNOB_U2,  $KNOB_U3,  $KNOB_U4,  $KNOB_U5,  $KNOB_U6,  $KNOB_U7,  $KNOB_U8, \
  $KNOB_M1,  $KNOB_M2,  $KNOB_M3,  $KNOB_M4,  $KNOB_M5,  $KNOB_M6,  $KNOB_M7,  $KNOB_M8, \
  $KNOB_L1,  $KNOB_L2,  $KNOB_L3,  $KNOB_L4,  $KNOB_L5,  $KNOB_L6,  $KNOB_L7,  $KNOB_L8,  \
  $SLIDER_1, $SLIDER_2, $SLIDER_3, $SLIDER_4, $SLIDER_5, $SLIDER_6, $SLIDER_7, $SLIDER_8  \
    slider32 $KNOB_CHAN, $U1, 0, 1, 0, 0, \
                         $U2, 0, 1, 0, 0, \
                         $U3, 0, 1, 0, 0, \
                         $U4, 0, 1, 0, 0, \
                         $U5, 0, 1, 0, 0, \
                         $U6, 0, 1, 0, 0, \
                         $U7, 0, 1, 0, 0, \
                         $U8, 0, 1, 0, 0, \
                         $M1, 0, 1, 0, 0, \
                         $M2, 0, 1, 0, 0, \
                         $M3, 0, 1, 0, 0, \
                         $M4, 0, 1, 0, 0, \
                         $M5, 0, 1, 0, 0, \
                         $M6, 0, 1, 0, 0, \
                         $M7, 0, 1, 0, 0, \
                         $M8, 0, 1, 0, 0, \
                         $L1, 0, 1, 0, 0, \
                         $L2, 0, 1, 0, 0, \
                         $L3, 0, 1, 0, 0, \
                         $L4, 0, 1, 0, 0, \
                         $L5, 0, 1, 0, 0, \
                         $L6, 0, 1, 0, 0, \
                         $L7, 0, 1, 0, 0, \
                         $L8, 0, 1, 0, 0, \
                         $S1, 0, 1, 0, 0, \
                         $S2, 0, 1, 0, 0, \
                         $S3, 0, 1, 0, 0, \
                         $S4, 0, 1, 0, 0, \
                         $S5, 0, 1, 0, 0, \
                         $S6, 0, 1, 0, 0, \
                         $S7, 0, 1, 0, 0, \
                         $S8, 0, 1, 0, 0
endop

;; note numbers for buttons
#define BUTT_1U #0#
#define BUTT_2U #1#
#define BUTT_3U #2#
#define BUTT_4U #3#
#define BUTT_5U #4#
#define BUTT_6U #5#
#define BUTT_7U #6#
#define BUTT_8U #7#
#define BUTT_1L #8#
#define BUTT_2L #9#
#define BUTT_3L #10#
#define BUTT_4L #11#
#define BUTT_5L #12#
#define BUTT_6L #13#
#define BUTT_7L #14#
#define BUTT_8L #15#
