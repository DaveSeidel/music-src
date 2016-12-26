import codecs
import locale
import sys
from pprint import pformat

from score_tools import Score
from catalog_tools import *


# Wrap sys.stdout into a StreamWriter to allow writing unicode.
# http://stackoverflow.com/questions/4545661/unicodedecodeerror-when-redirecting-to-file
sys.stdout = codecs.getwriter(locale.getpreferredencoding())(sys.stdout) 


BLOCK = u'\u2588'

def print_chords(chords, note_char=BLOCK):
  out = []

  for chord in chords:
    rep = []
    for note in chord:
      if note is None:
        rep.append(u' ')
      else:
        rep.append(note_char)
    out.append(rep)

  for i in range(6, -1, -1):
    row = ["%s%s" % (i, ' ')]
    for j in range(len(out)):
      row.append(out[j][i])
    print ''.join(row)


def build_section(start, score, chords, chord_dur, amp, preset, scale_size):
    # take the same notes that appear in adjacent chords and tie them together
    voices = [
        collect_common_tones([chord[i] for chord in chords])
        for i in range(scale_size)
    ]
    
    # print "Starting section at %s" % start

    for v in voices:
        p2 = start
        for segment in v:
            idx = segment[0]
            beats = segment[1]
            dur = beats * chord_dur
            if idx != None:
                score.i('"Note"', p2, dur, amp, preset, idx)
            p2 += dur


def build_score(text, sort=None, reverse=False, quiet=True):
    scale_size = 7
    chords = build_chord_catalogue(scale_size)

    amp = -16
    preset = 11
    total_dur = 60 * 11.0
    rest_dur = 3.0
    chord_dur = total_dur / len(chords)

    if not quiet:
      print "scale size: %s\n%s combinations\nchord duration: %fs\ntotal duration: %f" % \
            (scale_size, len(chords), chord_dur, total_dur)

    score = Score()

    score.append([
        '#include "scanu_tables.sco"\n',
        'i "Output" 0 %f' % (total_dur + rest_dur)
    ])

    if not quiet:
      print text

    if sort is None:
        if reverse:
            chords = list(reversed(chords))
    elif sort == "asc":
        chords = sorted(chords, reverse=reverse)
    elif sort == "desc_last":
        chords = sorted(chords, key=lambda x: x[-1], reverse=reverse)
    elif sort == "desc_all":
        chords = sorted(chords, key=lambda x: sorted(x, reverse=True), reverse=reverse)

    #print pformat(chords)
    print_chords(chords)

    # print output
    if len(sys.argv) >= 3:
        build_section(0, score, chords, chord_dur, amp, preset, scale_size)
        score.append("e")
        output = score.render()
        with open(sys.argv[2], 'w') as f:
            f.write(output)

