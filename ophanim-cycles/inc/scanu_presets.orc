gi_scanx_presets ftgen 0, 0, 256, -2, \
    18, 0.03, 22, 40, 71,  \ ; preset no 1 for instr preset_call, index 0 in table
    10, 0.02, 20, 40, 70, \
	16, 0.01, 21, 40, 71, \
	12, 0.2, 21, 40, 72, \
	12, 0.2, 21, 40, 72, \
	14, 0.002, 22, 42, 72, \
	19, 0.12, 20, 40, 73, \
	11, 0.01, 23, 42, 71, \
	14, 0.003, 22, 43, 74, \
	19, 0.1, 25, 41, 70, \
	13, 0.05, 20, 41, 70, \ ; preset 11
	11, 0.1, 23, 42, 72, \
	12, 0.3, 25, 42, 70,\
	14, 0.001, 22, 43, 74, \
	12, 0.005, 20, 40, 74,\
	10, 0.01, 22, 41, 74, \
	12, 0.008, 21, 42, 72, \
	14, 0.002, 21, 42, 72, \
	14, 0.002, 21, 40, 72,\
	14, 0.1, 20, 40, 72,\
	17, 0.02, 21, 40,72 ,\ ; preset  21
	15, 0.012, 22,43,70,\
	18, 0.43, 20, 40, 72,\
	10, 0.02, 20, 40, 70, \
	16, 0.015, 22, 41, 71, \
	12, 0.235, 20, 40, 73, \
	13, 0.188, 21, 43, 70, \
	14, 0.0025, 21, 42, 73, \
	15, 0.128, 20, 41, 73, \
	18, 0.122, 20, 42, 73 ; 30

; gi_scanx_cur_preset init 11
; gi_scanx_p1 init tab_i(gi_scanx_cur_preset*5+0, gi_scanx_presets)
; gi_scanx_p2 init tab_i(gi_scanx_cur_preset*5+1, gi_scanx_presets)
; gi_scanx_p3 init tab_i(gi_scanx_cur_preset*5+2, gi_scanx_presets)
; gi_scanx_p4 init tab_i(gi_scanx_cur_preset*5+3, gi_scanx_presets)
; gi_scanx_p5 init tab_i(gi_scanx_cur_preset*5+4, gi_scanx_presets)

gi_scanx_cur_preset init 0
gi_scanx_p1 init 0
gi_scanx_p2 init 0
gi_scanx_p3 init 0
gi_scanx_p4 init 0
gi_scanx_p5 init 0

instr scanx_init
    ipreset = p4
    iscan_id = p5

    prints("scanx_init: preset=%d, scan_id=%d, %f\n", ipreset, iscan_id, gi_scanx_presets)

    gi_scanx_cur_preset = ipreset
    iofs = gi_scanx_cur_preset*5
    gi_scanx_p1 = tab_i(iofs+0, gi_scanx_presets)
    gi_scanx_p2 = tab_i(iofs+1, gi_scanx_presets)
    gi_scanx_p3 = tab_i(iofs+2, gi_scanx_presets)
    gi_scanx_p4 = tab_i(iofs+3, gi_scanx_presets)
    gi_scanx_p5 = tab_i(iofs+4, gi_scanx_presets)

    ; prints("p1:%f p2:%f p3:%f p4:%f p5:%f\n",
    ;        gi_scanx_p1, gi_scanx_p2, gi_scanx_p3, gi_scanx_p4, gi_scanx_p5)

    iinit = gi_scanx_p1
    irate = (gi_scanx_p2 == 0) ? 0.01 : gi_scanx_p2 ; do not allow 0!
    ifnvel = 60
    ifnmass = gi_scanx_p3
    ifnstif = 30
    ifncentr = gi_scanx_p4
    ifndamp = 50
    kmass = 1
    kstif = 0.1
    kcentr = 0.1
    kdamp = -0.001
    ileft = 0.1
    iright = 0.5
    kpos = 0
    kstrngth = 0
    idisp = 0
    itraj = gi_scanx_p5
    ain = 0

    ; set up identical instances with different IDs
    scanu(iinit, irate, ifnvel, ifnmass, ifnstif, ifncentr, ifndamp, kmass,
          kstif, kcentr, kdamp, ileft, iright, kpos, kstrngth, ain, idisp,
          iscan_id)
    scanu(iinit, irate, ifnvel, ifnmass, ifnstif, ifncentr, ifndamp, kmass,
          kstif, kcentr, kdamp, ileft, iright, kpos, kstrngth, ain, idisp,
          iscan_id+1)
;     scanu(iinit, irate, ifnvel, ifnmass, ifnstif, ifncentr, ifndamp, kmass,
;           kstif, kcentr, kdamp, ileft, iright, kpos, kstrngth, ain, idisp,
;           iscan_id+2)
;     scanu(iinit, irate, ifnvel, ifnmass, ifnstif, ifncentr, ifndamp, kmass,
;           kstif, kcentr, kdamp, ileft, iright, kpos, kstrngth, ain, idisp,
;           iscan_id+3)
;     scanu(iinit, irate, ifnvel, ifnmass, ifnstif, ifncentr, ifndamp, kmass,
;           kstif, kcentr, kdamp, ileft, iright, kpos, kstrngth, ain, idisp,
;           iscan_id+4)
;     scanu(iinit, irate, ifnvel, ifnmass, ifnstif, ifncentr, ifndamp, kmass,
;           kstif, kcentr, kdamp, ileft, iright, kpos, kstrngth, ain, idisp,
;           iscan_id+5)

    turnoff
endin

opcode scanx, a,kki
    kamp, kcps, iscan_id xin
    aout = scans(kamp, kcps, gi_scanx_p5, iscan_id)
    xout aout
endop
