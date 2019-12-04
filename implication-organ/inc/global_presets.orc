opcode global_preset, 0, iiiiiiiiiiiiiiiiiiiiii
    i_main, i_gen, i_cutoff, i_q, i_c_sub, i_c_diff1, i_c_diff2, i_c_diff3, i_c_sum1, i_c_sum2, i_c_prod, i_m_sub, i_m_ari, i_m_geo, i_m_har, i_m_phi, i_detune, i_blend, i_wave, i_reduce, i_preset, i_tuning xin

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
    set_tuning(i_tuning)

    ; send to GUI
    Sdest[] init 23
    Stype[] init 23
    kdata[][] init 23, 1

    Sdest[0]    = "/implication_organ/master/main"
    Sdest[1]    = "/implication_organ/master/generated"
    Sdest[2]    = "/implication_organ/filter/cutoff"
    Sdest[3]    = "/implication_organ/filter/q"
    Sdest[4]    = "/implication_organ/combos/sub"
    Sdest[5]    = "/implication_organ/combos/diff1"
    Sdest[6]    = "/implication_organ/combos/diff2"
    Sdest[7]    = "/implication_organ/combos/diff3"
    Sdest[8]    = "/implication_organ/combos/sum1"
    Sdest[9]    = "/implication_organ/combos/sum2"
    Sdest[10]   = "/implication_organ/combos/prod"
    Sdest[11]   = "/implication_organ/means/sub"
    Sdest[12]   = "/implication_organ/means/ari"
    Sdest[13]   = "/implication_organ/means/geo"
    Sdest[14]   = "/implication_organ/means/harm"
    Sdest[15]   = "/implication_organ/means/phi"
    Sdest[16]   = "/implication_organ/detune"
    Sdest[17]   = "/implication_organ/blend"
    Sdest[18]   = "/implication_organ/generated_waveform"
    Sdest[19]   = "/implication_organ/reduction_type"
    Sdest[20]   = "/implication_organ/preset"
    Sdest[21]   = "/implication_organ/tuning"
    Sdest[22]   = "/implication_organ/tuning_mode"

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
    Stype[22]   = "i"

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
                    0

    OSCbundle(1, "127.0.0.1", 8080, Sdest, Stype, kdata)
    OSCsend(1, "127.0.0.1", 8080, "/state", "s", "save")
endop

#define GLOBAL_PRESET_MOON_METAL #global_preset(1, 1, 0.92, 0.46, 1, 1, 1, 1, 1, 1, 0, 1, 0.3, 0, 0, 0, 0.11, 0, gi_asymp, $REDUCE_FIXED, 27, 1)#
#define GLOBAL_PRESET_INVOLUTION #global_preset(1, 1, 0.92, 0.46, 1, 1, 1, 1, 1, 1, 0, 1, 0.4, 0, 0, 0, 0.11, 0, gi_sine, $REDUCE_FIXED, 27, 5)#
