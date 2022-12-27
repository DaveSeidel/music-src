\version "2.22.2"

#(set-default-paper-size "letter" 'landscape)

\header {
  title = "Hysteresis"
  composer = "Dave Seidel"
%   subtitle = "For two voices with looper"
  copyright = "(c) Dave Seidel 2022 / Mysterybear Music, ASCAP / CC BY-NC 4.0"
}

\bookpart {
  \header {
    composer = ""
    subtitle = "Performance Notes"
    subsubtitle = ""
    piece = \markup \small \bold "Tuning Reference"
  }
  \score {
    \new Staff {
        \override Score.SpacingSpanner.strict-note-spacing = ##t
        \clef treble
        \cadenzaOn
        \new Voice \relative c {
          % 1, 16/15, 9/8, 6/5, 5/4, 4/3, 64/45, 3/2,  8/5, 5/3, 7/4,  15/8
          c'1   -\markup \center-column { "1/1" }
          des1  -\markup \center-column { "16/15" \line { \italic "+12¢" } }
          d1    -\markup \center-column { "9/8"   \line { \italic "+4¢" } }
          ees1  -\markup \center-column { "6/5"   \line { \italic "+16¢" } }   
          e1    -\markup \center-column { "5/4"   \line { \italic "-14¢" } }   
          f1    -\markup \center-column { "4/3"   \line { \italic "-2¢" } }
          fis1  -\markup \center-column { "64/65" \line { \italic "+10¢" } }
          g1    -\markup \center-column { "3/2"   \line { \italic "+2¢" } }
          gis1  -\markup \center-column { "18/5"  \line { \italic "+14¢" } }
          a1    -\markup \center-column { "5/3"   \line { \italic "-16¢" } }
          bes1  -\markup \center-column { "7/4"   \line { \italic "-31¢" } }
          b1    -\markup \center-column { "15/8"  \line { \italic "-12¢" } }
          c1    -\markup \center-column { "2/1" }
        }
    }
  \layout {
    indent = #0
    \context {
      \Score
        proportionalNotationDuration = #(ly:make-moment 1/20)
        \omit Score.BarLine
        \omit Score.SpanBar
        \omit Score.TimeSignature
        \omit BarNumber
      }
    }
  }
  \markup {
     \column {
       \line { "C is at concert pitch. Others notes indicate offsets in cents relative to notated pitch." }
       \line { "Note that cents offsets are rounded to the nearest whole integer, and are thus not quite exact." }
       \line { "Ratios are shown for reference, but indicate the actual tuning standard." }
       \line { \lower #3 "All notes should be played in strict time and with no vibrato. Each whole note lasts 15 seconds." }
       \line { \lower #4 "Looper must be set to sound-on-sound with a five-second loop duration." }
       \line { \lower #4 "Both voices are played through the looper. If a stereo looper is available," }
       \line { \lower #2 "put one voice in each channel." }
       \line { \lower #4 "Both voices may be played on the same instrument (e.g. keyboard or synth),"  }
       \line { \lower #2 "otherwise on two separate instruments with similar timbre (e.g. two cellos)." }
       \line { \lower #4 "Whatever instrument is used, it must be capable of sustaining each note for the notated duration." }
       \line { \lower #3 "Of course, bowed instruments will need to reverse direction at least once for each note;" }
       \line { \lower #2 "please do so on 5-second boundaries (i.e. lined up with the underlying beat)." }
       \line { \lower #4 "The opening crescendo is really a fade-in (i.e., it starts from silence)." }
       \line { \lower #4 "The opening F is the only note where both voices begin together." }
    }
  }
}

\score {
    \layout {
        indent = #0
        \context {
            \Score {
                \omit Score.BarLine
                \omit Score.SpanBar
                \omit Score.TimeSignature
                \omit BarNumber
            }
        }
    }
    \new StaffGroup <<
        \override Score.SpacingSpanner.strict-note-spacing = ##t
        \new Staff \relative {
            \tempo "whole note = 15 seconds"
            \clef treble
            \new Voice \relative {
                f'1\< ~ 1\!\f ~ 1
                fis\breve a\breve b1
                bes\breve g\breve ges\breve
                a\breve bes1
                b!\breve gis\breve g!\breve
                des\breve fis\breve b1
                bes\breve ges\breve des\breve
                d!\breve fis\breve bes1
                b!\breve g\breve e\breve
                b'\breve fis\breve des\breve ~ \breve
                ges\breve bes\breve
                fis\breve d\breve
                ees\breve g\breve b\breve
                f\breve ^\markup { \bold "allow looper to fade out" }
                \undo \omit Score.BarLine
                \undo \omit Score.SpanBar
                \bar "|."

            }
        }
        \new Staff \relative {
            \clef "bass"
            \new Voice \relative {
                f1\< ~ 1\!\f
                e\breve des\breve c\breve ~ 1
                des\breve e\breve
                d\breve c\breve ~ 1
                ees\breve e!\breve
                a\breve e\breve c\breve ~ 1
                e\breve g!\breve
                a\breve e\breve c\breve ~ 1
                ees\breve gis\breve
                c,\breve e\breve a\breve
                g!1 ~ 1 e\breve
                c\breve e\breve a\breve
                gis\breve e!\breve c\breve
                f1 ~ \breve
                \undo \omit Score.BarLine
                \undo \omit Score.SpanBar
                \bar "|."
            }
        }
    >>
}
