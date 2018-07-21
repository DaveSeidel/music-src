;;; OSC globals
; gi_osc_handle OSCinit 12000
gknob0 init 0
gknob1 init 0
gknob2 init 0
gknob3 init 0
gknob4 init 0
gknob5 init 0

;;; repatcher macros
#define KNOB_L1 #gknob0#
#define KNOB_L2 #gknob2#
#define KNOB_L3 #gknob4#
#define KNOB_R1 #gknob1#
#define KNOB_R2 #gknob3#
#define KNOB_R3 #gknob5#

; opcode osc_listener, 0,0
;   k_  OSClisten gi_osc_handle, "/repatcher/knob0", "f", $KNOB_L1
;   k_  OSClisten gi_osc_handle, "/repatcher/knob1", "f", $KNOB_R1
;   k_  OSClisten gi_osc_handle, "/repatcher/knob2", "f", $KNOB_L2
;   k_  OSClisten gi_osc_handle, "/repatcher/knob3", "f", $KNOB_R2
;   k_  OSClisten gi_osc_handle, "/repatcher/knob4", "f", $KNOB_L3
;   k_  OSClisten gi_osc_handle, "/repatcher/knob5", "f", $KNOB_R3
; endop
