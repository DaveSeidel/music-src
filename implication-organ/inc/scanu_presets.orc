giPresets ftgen 0, 0, 256, -2, \
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

giScanId init 2
giScanPreset init 11
gip1 init tab_i(giScanPreset*5+0, giPresets)
gip2 init tab_i(giScanPreset*5+1, giPresets)
gip3 init tab_i(giScanPreset*5+2, giPresets)
gip4 init tab_i(giScanPreset*5+3, giPresets)
gip5 init tab_i(giScanPreset*5+4, giPresets)