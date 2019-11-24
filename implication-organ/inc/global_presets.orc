#define GLOBAL_PRESET_MOON_METAL #
    gi_scanx_preset = 9
    set_generated_waveform(gi_asymp)
    set_reduction_type($REDUCE_FIXED)
    set_tuning(giCent)
    $CTL_DETUNE = 0.0
    $CTL_MAIN_LEVEL = 1
    $CTL_GENERATED_LEVEL = 1
    $CTL_COMBOS_LEVEL = 1
    $CTL_COMBOS_DIFF1 = 1
    $CTL_COMBOS_DIFF2 = 1
    $CTL_COMBOS_DIFF3 = 1
    $CTL_COMBOS_SUM1 = 1
    $CTL_COMBOS_SUM1 = 1
    $CTL_COMBOS_PROD = 0
    $CTL_MEANS_LEVEL = 1
    $CTL_MEANS_ARI = 0.3
    $CTL_MEANS_GEO = 0
    $CTL_MEANS_HAR = 0
    $CTL_MEANS_PHI = 0
    $CTL_LPF_CUTOFF = $CALC_FILTER_CUTOFF(0.98)
    $CTL_LPF_Q = 0.8
#

#define GLOBAL_PRESET_INVOLUTION #
    gi_scanx_preset = 27
    set_generated_waveform(gi_sine)
    set_reduction_type($REDUCE_FIXED)
    set_tuning(giMeta)
    $CTL_DETUNE = 0.33
    $CTL_MAIN_LEVEL = 1
    $CTL_GENERATED_LEVEL = 1
    $CTL_COMBOS_LEVEL = 1
    $CTL_COMBOS_DIFF1 = 1
    $CTL_COMBOS_DIFF2 = 1
    $CTL_COMBOS_DIFF3 = 1
    $CTL_COMBOS_SUM1 = 1
    $CTL_COMBOS_SUM1 = 1
    $CTL_COMBOS_PROD = 0
    $CTL_MEANS_LEVEL = 1
    $CTL_MEANS_ARI = 0.4
    $CTL_MEANS_GEO = 0
    $CTL_MEANS_HAR = 0
    $CTL_MEANS_PHI = 0
    $CTL_LPF_CUTOFF = $CALC_FILTER_CUTOFF(0.92)
    $CTL_LPF_Q = 0.46
#
