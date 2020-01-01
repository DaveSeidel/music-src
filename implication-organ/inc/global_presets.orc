#ifndef OSC_SEND_HOST
#define OSC_SEND_HOST   #127.0.0.1#
#endif

#ifndef OSC_SEND_PORT
#define OSC_SEND_PORT   #8080#
#endif

#define NUM_ENDPOINTS   #26#

opcode global_preset, 0, iiiiiiiiiiiiiiiiiiiiiiiiii
    i_main, i_gen, i_cutoff, i_q, i_c_sub, i_c_diff1, i_c_diff2, i_c_diff3,
    i_c_sum1, i_c_sum2, i_c_prod, i_m_sub, i_m_ari, i_m_geo, i_m_har, i_m_phi,
    i_detune, i_blend, i_wave, i_reduce, i_preset, i_tuning,
    i_r1_fb, i_r1_wet, i_r2_fb, i_r2_wet xin

    ; set locally
    $CTL_MAIN_LEVEL = i_main
    $CTL_GENERATED_LEVEL = i_gen

    $CTL_LPF_CUTOFF = $CALC_FILTER_CUTOFF(i_cutoff)
    $CTL_LPF_Q = i_q

    $CTL_COMBOS_LEVEL = i_c_sub
    $CTL_COMBOS_DIFF1 = i_c_diff1
    $CTL_COMBOS_DIFF2 = i_c_diff2
    $CTL_COMBOS_DIFF3 = i_c_diff3
    $CTL_COMBOS_SUM1  = i_c_sum1
    $CTL_COMBOS_SUM1  = i_c_sum2
    $CTL_COMBOS_PROD  = i_c_prod

    $CTL_MEANS_LEVEL = i_m_sub
    $CTL_MEANS_ARI   = i_m_ari
    $CTL_MEANS_GEO   = i_m_geo
    $CTL_MEANS_HAR   = i_m_har
    $CTL_MEANS_PHI   = i_m_phi

    $CTL_DETUNE = i_detune
    gk_blend = i_blend
    set_generated_waveform(i_wave)
    set_reduction_type(i_reduce)
    gi_scanx_preset = i_preset-1
    set_tuning(gi_tuning_map[i_tuning-1])

    $CTL_REV1_FB = i_r1_fb
    $CTL_REV1_WET = i_r1_wet
    $CTL_REV2_FB = i_r2_fb
    $CTL_REV2_WET = i_r2_wet

    ; send to GUI
    Sdest[] init $NUM_ENDPOINTS
    Stype[] init $NUM_ENDPOINTS
    kdata[][] init $NUM_ENDPOINTS, 1

    Sdest[0]    = "/io/master/main"
    Sdest[1]    = "/io/master/generated"
    Sdest[2]    = "/io/filter/cutoff"
    Sdest[3]    = "/io/filter/q"
    Sdest[4]    = "/io/combos/sub"
    Sdest[5]    = "/io/combos/diff1"
    Sdest[6]    = "/io/combos/diff2"
    Sdest[7]    = "/io/combos/diff3"
    Sdest[8]    = "/io/combos/sum1"
    Sdest[9]    = "/io/combos/sum2"
    Sdest[10]   = "/io/combos/prod"
    Sdest[11]   = "/io/means/sub"
    Sdest[12]   = "/io/means/ari"
    Sdest[13]   = "/io/means/geo"
    Sdest[14]   = "/io/means/harm"
    Sdest[15]   = "/io/means/phi"
    Sdest[16]   = "/io/detune"
    Sdest[17]   = "/io/blend"
    Sdest[18]   = "/io/generated_waveform"
    Sdest[19]   = "/io/reduction_type"
    Sdest[20]   = "/io/preset"
    Sdest[21]   = "/io/tuning"
    Sdest[22]   = "/io/reverb/1/fb"
    Sdest[23]   = "/io/reverb/1/wet"
    Sdest[24]   = "/io/reverb/2/fb"
    Sdest[25]   = "/io/reverb/2/wet"

    Stype[0]    = "f"
    Stype[1]    = "f"
    Stype[2]    = "f"
    Stype[3]    = "f"
    Stype[4]    = "f"
    Stype[5]    = "f"
    Stype[6]    = "f"
    Stype[7]    = "f"
    Stype[8]    = "f"
    Stype[9]    = "f"
    Stype[10]   = "f"
    Stype[11]   = "f"
    Stype[12]   = "f"
    Stype[13]   = "f"
    Stype[14]   = "f"
    Stype[15]   = "f"
    Stype[16]   = "f"
    Stype[17]   = "i"
    Stype[18]   = "i"
    Stype[19]   = "i"
    Stype[20]   = "i"
    Stype[21]   = "i"
    Stype[22]   = "f"
    Stype[23]   = "f"
    Stype[24]   = "f"
    Stype[25]   = "f"

    kdata fillarray i_main, i_gen,
                    i_cutoff, i_q,
                    i_c_sub, i_c_diff1, i_c_diff2, i_c_diff3, i_c_sum1, i_c_sum2, i_c_prod,
                    i_m_sub, i_m_ari, i_m_geo, i_m_har, i_m_phi,
                    i_detune,
                    i_blend,
                    i_wave,
                    i_reduce,
                    i_preset,
                    i_tuning,
                    i_r1_fb, i_r1_wet, i_r2_fb, i_r2_wet

    OSCbundle(1, "$OSC_SEND_HOST", $OSC_SEND_PORT, Sdest, Stype, kdata)
    OSCsend(1,   "$OSC_SEND_HOST", $OSC_SEND_PORT, "/io/state", "s", "save")
endop

#define GLOBAL_PRESET_MOON_METAL #
    global_preset(1, 1, 0.92, 0.46, 1, 1, 1, 1, 1, 1,   0,    1, 0.3, 0, 0, 0, 0.005, 0, gi_asymp, $REDUCE_FIXED, 27, 1, 0,   0,    0,   0)
#
#define GLOBAL_PRESET_INVOLUTION_1 #
    global_preset(1, 1, 0.92, 0.46, 1, 1, 1, 1, 1, 0.6, 0.05, 1, 0.4, 0, 0, 0, 0.005, 0, gi_sine,  $REDUCE_FIXED, 27, 5, 0.7, 0.98, 0.8, 0.98)
#
#define GLOBAL_PRESET_INVOLUTION_2 #
    global_preset(1, 1, 0.92, 0.46, 1, 1, 1, 1, 1, 0.6, 0.05, 1, 0.4, 0, 0, 0, 0.005, 0, gi_sine,  $REDUCE_FIXED, 27, 1, 0.7, 0.98, 0.8, 0.98)
#
#define GLOBAL_PRESET_INVOLUTION_3 #
    global_preset(1, 1, 0.92, 0.46, 1, 1, 1, 1, 1, 0.6, 0.05, 1, 0.4, 0, 0, 0, 0.005, 0, gi_sine,  $REDUCE_FIXED, 27, 2, 0.7, 0.98, 0.8, 0.98)
#

opcode plot_freq, 0,kkk
    kfirst, knote, kfreq xin
    if (kfirst == 0) then
        Saddr = sprintfk("/io/%s", "first")
    else
        Saddr = sprintfk("/io/%s", "second")
    endif
    if (kfreq == 0) then
        Smsg = sprintfk("%s", "--")
    else
        Smsg = sprintfk("Note %d : %f Hz", knote, kfreq)
    endif
    OSCsend(rand:k(100, 2), "$OSC_SEND_HOST", $OSC_SEND_PORT, Saddr, "s", Smsg)
endop

opcode set_derived_state, 0, k
    kstate xin
    OSCsend(rand:k(100, 2), "$OSC_SEND_HOST", $OSC_SEND_PORT, "/io/derived", "d", kstate)
endop
