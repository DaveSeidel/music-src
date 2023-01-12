  gitabsz init 2^16

  giSin     ftgen 0, 0, gitabsz, 9, 1,1,0
  giTri     ftgen 0, 0, gitabsz, 9, 1,1,0,  3,0.333,180,  5,0.2,0,  7,0.143,180, 9,0.111,0, 11,0.091,180, 13,0.077,0, 15,0.067,180, 17,0.059,0, 19,0.053,180, 21,0.048,0, 23,0.043,180, 25,0.04,0, 27,0.037,180, 29,0.034,0, 31,0.032,180
  giSaw     ftgen 0, 0, gitabsz, 7, 0, gitabsz/2, 1, 0, -1, gitabsz/2, 0
  giSquare  ftgen 0, 0, gitabsz, 7, 1, gitabsz/2, 1, 0, -1, gitabsz/2, -1
  giPrime   ftgen 0, 0, gitabsz, 9, 1,1,0,  2,0.5,0,  3,0.3333,0,  5,0.2,0,   7,0.143,0,  11,0.0909,0,  13,0.077,0,   17,0.0588,0,  19,0.0526,0, 23,0.0435,0, 27,0.037,0, 31,0.032,180
  giFib     ftgen 0, 0, gitabsz, 9, 1,1,0,  2,0.5,0,  3,0.3333,0,  5,0.2,0,   8,0.125,0,  13,0.0769,0,  21,0.0476,0,  34,0.0294,0 ;,  55,0.0182,0,  89,0.0112,0, 144,0.0069,0

  giNumTables = 5
  giList ftgen 1000, 0, giNumTables, -2, giTri, giSaw, giSquare, giPrime, giFib, giSin
  giMorf ftgen 1001, 0, gitabsz, 10, 1

  gilforabsz init 2^13
  giLfoTri ftgen 0, 0, gilforabsz, 7, 0, gilforabsz/4, 1, gilforabsz/2, -1, gilforabsz/4, 0

  instr 1
    ; prints("p1=%f, p2=%f, p3=%f, p4=%f\n", p1, p2, p3, p4)
    kfreq chnget sprintf("FREQ%d", p4)

    kin1con init 0
    kin2con init 0
    kin3con init 0
    kin4con init 0

    koff  init 0.001
    koff1 init 0.001
    koff2 init 2 * 0.001
    koff3 init 3 * 0.001
    koff4 init 5 * 0.001
    koffa = scale2(chnget:k("P1"), 0.001, 0.1, -10, 10)
    if (chnget:k("IN1CON") == 1) then
      koffb = scale2(chnget:k("IN1C1"), 0.001, 0.1, 0, 10)
      koff = koffa + koffb
    else
      koff = koffa
    endif
    koff1 = koff
    koff2 = 2 * koff
    koff3 = 3 * koff
    koff4 = 5 * koff

    itbl = giMorf
    kndx init 0
    kndxa = scale2(chnget:k("P2"), 0, giNumTables-1.01, -10, 10)
    if (chnget:k("IN2CON") == 1) then
      kndxb = scale2(chnget:k("IN2C1"), 0, giNumTables-1.01, 0, 10)
      kndx = kndxa + kndxb
    else
      kndx = kndxa
    endif
    ftmorf kndx, giList, giMorf

    kamp init 0.8/9

    ; a1 oscil3 kamp, kfreq, itbl
    a2 oscil3 kamp, kfreq+koff1, itbl
    a3 oscil3 kamp, kfreq+koff2, itbl
    a4 oscil3 kamp, kfreq+koff3, itbl
    a5 oscil3 kamp, kfreq+koff4, itbl
    a6 oscil3 kamp, kfreq-koff1, itbl
    a7 oscil3 kamp, kfreq-koff2, itbl
    a8 oscil3 kamp, kfreq-koff3, itbl
    a9 oscil3 kamp, kfreq-koff4, itbl

    kdst init 0
    kdsta = scale2(chnget:k("P3"), 0, 10, -10, 10)
    if (chnget:k("IN3CON") == 1) then
      kdstb = scale2(chnget:k("IN3C1"), 0, 10, 0, 10)
      kdst = kdsta + kdstb
    else
      kdst = kdsta
    endif

    aL = a2+a4+a6+a8
    aR = a3+a5+a7+a9
    aoutL = aL + distort1(aL, kdst, 0.1, 0, 0)
    aoutR = aR + distort1(aR, kdst, 0.1, 0, 0)

    kpana = scale2(chnget:k("P4"), 0, 7, -10, 10)
    if (chnget:k("IN4CON") == 1) then
      kpanb = scale2(chnget:k("IN4C1"), 0, 5, 0, 10)
      kpan = kpana + kpanb
    else
      kpan = kpana
    endif
    if (kpan == 0) then
      kext = 0
    else
      kext = 0.1
    endif
    klfoL oscili 0.49, kpan-kext, giLfoTri, 90
    klfoR oscili 0.49, kpan+kext, giLfoTri, 270
    klfoL += 0.5
    klfoR += 0.5
    aoutL1, aoutR1 pan2 aoutL, klfoL
    aoutL2, aoutR2 pan2 aoutR, klfoR
    aoutL = aoutL1+aoutL2
    aoutR = aoutR1+aoutR2

    aenv madsr 0.07,0,1,0.7
    outs aoutL*aenv, aoutR*aenv
  endin
