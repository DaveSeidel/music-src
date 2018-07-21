;
; Launch Control XL using custon preset
; controllers 0-31 on channel 3
;

#define CONTROLLER_LC ##

#define KNOB_CHAN #4#
#define BUTT_CHAN #8#

; upper row of knobs
#define U1 #0#
#define U2 #1#
#define U3 #2#
#define U4 #3#
#define U5 #4#
#define U6 #5#
#define U7 #6#
#define U8 #7#
; lower row of knobs
#define L1 #8#
#define L2 #9#
#define L3 #10#
#define L4 #11#
#define L5 #12#
#define L6 #13#
#define L7 #14#
#define L8 #15#

gknob_u1 init  0
gknob_u2 init  0
gknob_u3 init  0
gknob_u4 init  0
gknob_u5 init  0
gknob_u6 init  0
gknob_u7 init  0
gknob_u8 init  0

gknob_l1 init  0
gknob_l2 init  0
gknob_l3 init  0
gknob_l4 init  0
gknob_l5 init  0
gknob_l6 init  0
gknob_l7 init  0
gknob_l8 init  0

#define KNOB_U1 #gknob_u1#
#define KNOB_U2 #gknob_u2#
#define KNOB_U3 #gknob_u3#
#define KNOB_U4 #gknob_u4#
#define KNOB_U5 #gknob_u5#
#define KNOB_U6 #gknob_u6#
#define KNOB_U7 #gknob_u7#
#define KNOB_U8 #gknob_u8#

#define KNOB_L1 #gknob_l1#
#define KNOB_L2 #gknob_l2#
#define KNOB_L3 #gknob_l3#
#define KNOB_L4 #gknob_l4#
#define KNOB_L5 #gknob_l5#
#define KNOB_L6 #gknob_l6#
#define KNOB_L7 #gknob_l7#
#define KNOB_L8 #gknob_l8#

opcode read_controls, 0, 0
  $KNOB_U1,  $KNOB_U2,  $KNOB_U3,  $KNOB_U4,  $KNOB_U5,  $KNOB_U6,  $KNOB_U7,  $KNOB_U8, \
  $KNOB_L1,  $KNOB_L2,  $KNOB_L3,  $KNOB_L4,  $KNOB_L5,  $KNOB_L6,  $KNOB_L7,  $KNOB_L8  \
    slider16 $KNOB_CHAN, $U1, 0, 1, 0, 0, \
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

    ; printks2("KNOB_U1: %f\n", $KNOB_U1)
endop

;; note numbers for buttons
#define BUTT_1 #0#
#define BUTT_2 #1#
#define BUTT_3 #2#
#define BUTT_4 #3#
#define BUTT_5 #4#
#define BUTT_6 #5#
#define BUTT_7 #6#
#define BUTT_8 #7#
