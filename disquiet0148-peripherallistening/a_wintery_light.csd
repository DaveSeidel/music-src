;
; "a wintery light [disquiet0148-peripherallistening]"
; by Dave Seidel
;
; 
;
; Generated by blue 2.5.14 (http://blue.kunstmusik.com)
;

<CsoundSynthesizer>

<CsInstruments>
sr=48000
ksmps=1
nchnls=2
0dbfs=1

gkdiff  init	1

giTblSz	init	2097152+1

; sine wave
giFn1 	ftgen	1, 0, giTblSz, 10, 1

ga_bluemix_1_0	init	0
ga_bluemix_1_1	init	0
ga_bluesub_Master_0	init	0
ga_bluesub_Master_1	init	0


gk_blue_auto0 init -6.4000000954
gk_blue_auto1 init 0




	opcode blueEffect0,aa,aa

ain1,ain2	xin
aout1, aout2  reverbsc ain1, ain2, 0.5, 8000.0

aout1 = (ain1 * 0.6) + (aout1 * (1 - 0.6))
aout2 = (ain2 * 0.6) + (aout2 * (1 - 0.6))


xout	aout1,aout2


	endop
	opcode blueEffect1,aa,aa

ain1,ain2	xin
iwet = 1
idry = 1 - iwet

; size of each convolution partion -- for best performance, this parameter needs to be tweaked
ipartitionsize = 1024

; calculate latency of pconvolve opcode
idel    = (ksmps < ipartitionsize ? ipartitionsize + ksmps : ipartitionsize)/sr

prints "Convolving with a latency of %f seconds%n", idel

awetl, awetr pconvolve    iwet*(ain1+ain2), "/home/dave/work/ir/minster1_000_ortf_48k.wav", ipartitionsize

; Delay dry signal, to align it with the convoled sig
adryl        delay  idry * ain1, idel
adryr        delay   idry * ain2, idel

aout1 = adryl+awetl
aout2 = adryr+awetr
xout	aout1,aout2


	endop


	instr 1	;binaural beater - gkdiff/expseg
idur  = p3          ; duration
iamp  = ampdb(p4)/2 ; amplitude
icent = p5          ; center frequency (Hz)
idiff = p6          ; difference (Hz)
itab  = p7          ; waveform (table)
irise = p8          ; envelope rise time
ifall = p9          ; envelope fall time

; amplitude envelope
ae	linen	iamp, irise, idur, ifall

; determine pitches
kdiff	=	idiff * gkdiff
kp1	=	icent + (kdiff/2)
kp2	=	icent - (kdiff/2)

	printks	"center=%f beat=%f => freq1=%f freq2=%f\\n", 1000, icent, idiff, kp1, kp2

; generate tones
asig1	poscil3	ae*iamp, kp1, itab
asig2	poscil3	ae*iamp, kp2, itab

; output
ga_bluemix_1_0 = ga_bluemix_1_0 + 	asig1
ga_bluemix_1_1 = ga_bluemix_1_1 +  asig2

	endin

	instr 2	;Blue Mixer Instrument
ktempdb = ampdb(gk_blue_auto0)
ga_bluemix_1_0 = ga_bluemix_1_0 * ktempdb
ga_bluemix_1_1 = ga_bluemix_1_1 * ktempdb
ga_bluesub_Master_0	sum	ga_bluesub_Master_0, ga_bluemix_1_0
ga_bluesub_Master_1	sum	ga_bluesub_Master_1, ga_bluemix_1_1
ga_bluesub_Master_0, ga_bluesub_Master_1	blueEffect0	ga_bluesub_Master_0, ga_bluesub_Master_1
ga_bluesub_Master_0, ga_bluesub_Master_1	blueEffect1	ga_bluesub_Master_0, ga_bluesub_Master_1
ktempdb = ampdb(gk_blue_auto1)
ga_bluesub_Master_0 = ga_bluesub_Master_0 * ktempdb
ga_bluesub_Master_1 = ga_bluesub_Master_1 * ktempdb
outc ga_bluesub_Master_0, ga_bluesub_Master_1
ga_bluemix_1_0 = 0
ga_bluemix_1_1 = 0
ga_bluesub_Master_0 = 0
ga_bluesub_Master_1 = 0

	endin


</CsInstruments>

<CsScore>








i1	0.0	120	-15	1920	1.75	1	2	2
i1	0.0	120	-15	1680.0	1.25	1	2	2
i1	0.0	120	-15	1851.4286	0.75	1	2	2
i1	0.0	120	-4	45	0.375	1	2	2
i2	0	120	
e

</CsScore>

</CsoundSynthesizer>