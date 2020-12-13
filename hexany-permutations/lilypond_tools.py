# 1       c
# 7/6     ees
# 5/4     e
# 35/24   g
# 5/3     a
# 7/4     bes
# 2       c'

LY_NOTES = [
    ("c",   ""),
    ("ees", "-33"),
    ("e",   "-13"),
    ("g",   "-46"),
    ("a",   "-15"),
    ("bes", "-31"),
    ("c",   "")
]

NUM_WORDS = {
    1: 'Seven',
    2: 'Six',
    3: 'Five',
    4: 'Four',
    5: 'Three',
    6: 'Two',
    7: 'One'
}

FIRST_PITCH_SUFFIX = ' -\markup { \dynamic mf \italic "senza vib." }'
FIRST_PITCH_SUFFIX2 = ' ^\markup { "(%s)" }'

VOICE_START = '''
string%s = \\new Voice \\relative c%s {
  \\compressEmptyMeasures
  \\showTempo "%s"
'''

BOOKPART = '''
\\bookpart {
    \\header {
      piece = #\"Section %s\"
    }
    \\tocItem \\markup #\"Section %s\"
    \\markup {
      \\column \italic {
        \\line { "Notes other than C have different pitches than notated, as indicated by a number" }
        \\line { "in parentheses giving an offset in cents relative to the notated pitch, shown at" }
        \\line { "the first appearance of each note that requires alteration. Likewise, dynamics &" }
        \\line { " expression are given for the first note only, but apply to all subsequent notes." }
        \\line { " " }
      }
    }
    \\scoreSection \\partName
}
'''

def print_lilypad_score(text, voices, make_parts=False):
    parts = [None] * len(LY_NOTES)
    output = []

    for i, v in enumerate(voices):
        output.append(VOICE_START % (NUM_WORDS[(i+1)],
                                    "'" if i >= 3 else "",
                                    "_" if i == 0 else "\\sectionName"))

        first_pitch = True
        num_segments = len(v)
        for segment in v:
            end_rest = 0
            play = segment[0]
            measures = segment[1]
            if play is not None:
                for j in range(measures):
                    if j < measures-1:
                        suffix = " ~"
                    else:
                        suffix = ""
                    if first_pitch:
                        first_pitch = False
                        suffix = FIRST_PITCH_SUFFIX
                        if  len(LY_NOTES[i][1]):
                            suffix += FIRST_PITCH_SUFFIX2 % LY_NOTES[i][1]
                    
                    output.append("  %s1%s" % (LY_NOTES[i][0], suffix))
                    end_rest = 0
            else:
                if measures > 1:
                    if make_parts:
                        output.append("  R1*%d" % measures)
                        end_rest = 1
                    else:
                        for j in range(measures):
                            output.append("  r1")
                else:
                    output.append("  r1")
                    end_rest = 0
            output.append("")
        if make_parts and end_rest:
            output.append('  \\fermata \\bar "|."\n}\n')
        else:
            output.append('  \\fermata \\bar "|."\n}\n')

    sectionNum = text.replace("Section ", "")
    output.append(BOOKPART % (sectionNum, sectionNum))

    filename = "%s_%s.ly" % (text.replace(' ', '_'), 'parts' if make_parts else 'score')
    print "Writing Lilypond score to " + filename
    with open(filename, "w") as fh:
        fh.write('\n'.join(output))
