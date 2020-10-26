\version "2.20.0"

%%% handle input parameters

partName = #(or (false-if-exception (format #f "S~d" (@ (guile-user) partNum))) "")

%%% macros/functions

global = {
  \numericTimeSignature
  \time 4/4
  \clef bass
}

show-tempo = #(define-music-function (partName) (string?)
  (if (not (string-null? partName))
    #{ \tempo "Even & sustained" 4 = 36 #}
    #{ #}
  )
)

instrument = #(define-scheme-function (parser location part) (string?)
  (format #f "~a"
    (cond ((equal? part "S1") "\\stringOne")
          ((equal? part "S2") "\\stringTwo")
          ((equal? part "S3") "\\stringThree")
          ((equal? part "S4") "\\stringFour")
          ((equal? part "S5") "\\stringFive")
          ((equal? part "S6") "\\stringSix")
          ((equal? part "S7") "\\stringSeven")
    )
  )
)

instrumentStaff = #(define-music-function (parser location part partName) (string? string?)
  #{
    \new Staff \with { instrumentName = #part } {
      \global #(ly:parser-include-string (instrument partName))
    }
  #}
)

scoreSection = #(define-scheme-function (parser location part) (string?)
  (if (string-null? partName)
    #{
      \score {
        \new StaffGroup <<
            \new Staff \with { instrumentName = "S1" }
            << \global \stringOne >>
            \new Staff \with { instrumentName = "S2" }
            << \global \stringTwo >>
            \new Staff \with { instrumentName = "S3" }
            << \global \stringThree >>
            \new Staff \with { instrumentName = "S4" }
            << \global \stringFour >>
            \new Staff \with { instrumentName = "S5" }
            << \global \stringFive >>
            \new Staff \with { instrumentName = "S6" }
            << \global \stringSix >>
            \new Staff \with { instrumentName = "S7" }
            << \global \stringSeven >>
        >>
        \layout { }
      }
    #}
    #{
      \score {
        \instrumentStaff #part \partName
        \layout { }
      }
    #}
  )
)

subsub = #(lambda (pname)
  (if (string-null? pname)
    "Full score"
    (string-append "Part for " pname)
  )
)

includeSections = #(define-void-function (parser location) ()
  (if (string-null? partName)
    (ly:parser-include-string "\\include \"sections_full.ly\"\n")
    (ly:parser-include-string "\\include \"sections_parts.ly\"\n")
  )
)

%%%
%%% book
%%%

\header {
  title = "Hexany Permutations"
  composer = "Dave Seidel"
  subtitle = "For seven like strings"
  subsubtitle = #(subsub partName)
  copyright = "(c) Dave Seidel 2020 / Mysterybear Music, ASCAP / CC BY-NC 4.0"
}

\paper {
  tocItemMarkup = \tocItemWithDotsMarkup
}
\markuplist \table-of-contents
\pageBreak

%%% performance notes

\bookpart {
  \tocItem \markup "Tuning"
  \header {
    composer = ""
    subtitle = "Performance Notes"
    subsubtitle = ""
    piece = \markup \small \bold "Tuning"
  }
  \score {
      \new Staff {
        \clef bass
        \cadenzaOn
        \new Voice \relative c {
          \once \override TextScript.outside-staff-horizontal-padding = #1
          c1    -\markup \center-align "1/1"   _\markup \center-align \italic "concert"
          ees1  -\markup \center-align "7/6"   _\markup \center-align \italic "-33¢"   
          e1    -\markup \center-align "5/4"   _\markup \center-align \italic "-13¢"   
          g1    -\markup \center-align "35/24" _\markup \center-align \italic "-46¢"   
          a1    -\markup \center-align "5/3"   _\markup \center-align \italic "-15¢"   
          bes1  -\markup \center-align "7/4"   _\markup \center-align \italic "-31¢"   
          c1    -\markup \center-align "2/1"   _\markup \center-align \italic "concert"
        }
      }
  \layout {
    \context {
      \Staff
      \remove "Time_signature_engraver"
    }
    \context {
      \Score
        proportionalNotationDuration = #(ly:make-moment 1/20)
      }
    }
  }
  \markup {
    \column {
      \line { "C is at concert pitch. Others notes indicate offsets in cents relative to notated pitch." }
      \line { "Ratios are shown for reference, but are the actual tuning standard." }
    }
  }
}

%%% score/parts

\includeSections
