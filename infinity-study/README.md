I've recently discovered (at long last) the music of Danish composer Per Nørgård. He developed a compositional techniques based on what he called the "infinity series", which is a simple formula for developing a series of numbers based on an interval such as a minor second. The series takes the initial interval and then slowly expands upon it both upwards and downwards in pitch, getting broader in scope as it progresses. This idea can be used to generate melodies, rhythms, or other aspect of a composition.

I decided to try playing around with this, but applying it to microtonal intervals, using Csound and a Python script to generate the Csound score according to the series. I ended up with this brief study, which takes the first 256 terms of the series and applies it to three of my favorite intervals simultaneously:
- 9/8 (major whole tone from the 9th harmonic)
- 11/8 (unidecimal tritone,from the 11th harmonic)
- 7/4 (septimal minor seventh, from the 7th harmonic)

The starting tone (240 Hz) plays throughout the piece as the other notes unfold above and below it. I used sine waves processed with a touch of tanh distortion to add a slight amount of harmonic content.

References:
- en.wikipedia.org/wiki/Per_N%C3%B8rg%C3%A5rd
- web.archive.org/web/2007101009125…lig/uindhold.html
