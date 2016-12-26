sr = 96000
ksmps = 1
nchnls = 2
0dbfs = 1.0

; base frequency
giBase = 180

#define F(RATIO)	#(giBase*($RATIO))#

; hexany scale (1 3 5 7)
giHexany[]  fillarray	$F(1), $F(7/6), $F(5/4), $F(35/24), $F(5/3), $F(7/4), $F(2)

giPan[] fillarray 0.143, 0.262, 0.381, 0.499, 0.619, 0.737, 0.857

; global audio output bus
ga_out_left init 0
ga_out_right init 0

; presets for Tarmo's scanned synthesis instrument
#include "scanu_presets.orc"

;; instruments

instr Output
	aL, aR reverbsc ga_out_left, ga_out_right, 0.85, 8000, sr, 0.1, 0
	outs((aL + (ga_out_left*0.8))*0.8, (aR + (ga_out_right*0.8))*0.8)

	ga_out_left = 0
	ga_out_right = 0
endin


instr Note
	idur = p3							; duration
	iamp = ampdb(p4)			; amplitude
	ipreset = p5					; preset
	ifreq = giHexany[p6]	; frequency index
	ipan = giPan[p6]			; panning value

	;print(ifreq)

	ip1 = tab_i(ipreset*5+0, giPresets)
	ip2 = tab_i(ipreset*5+1, giPresets)
	ip3 = tab_i(ipreset*5+2, giPresets)
	ip4 = tab_i(ipreset*5+3, giPresets)
	ip5 = tab_i(ipreset*5+4, giPresets)

	event_i("i","Sound", 0, p3, iamp, ip1, ip2, ip3, ip4, ip5, ifreq, ipan)
endin


; Tarmo's scanned synthesis instrument, slightly adapted
instr Sound
	iamp = p4
	iinit = p5
	irate = (p6 == 0) ? 0.01 : p6 ; do not allow 0!

	ifnvel = 60 
	ifnmass = p7
	ifnstif = 30
	ifncentr = p8
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
	id = 2		
	itraj = p9
	
	ifreq = p10
	ain = 0
	
	ipan = p11
	
	scanu(iinit, irate, ifnvel, ifnmass, ifnstif, ifncentr, ifndamp, kmass,
	      kstif, kcentr, kdamp, ileft, iright, kpos, kstrngth, ain, idisp, id)
	
	kenv = adsr(0.7, 0.2, 0.8, 0.5) 
	a1 = scans(iamp*kenv, ifreq, itraj, id)
	aout = dcblock2(a1)
	aleft, aright pan2 aout, ipan
	
	ga_out_left  = ga_out_left + aleft
	ga_out_right = ga_out_right + aright
endin
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>0</width>
 <height>0</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
