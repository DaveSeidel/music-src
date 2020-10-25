cd ..
python build_ly.py 0 part1.sco
cd lilypond

@set LY="C:\Program Files (x86)\LilyPond\usr\bin\lilypond.exe"
%LY%                         hexany_permutations.ly
%LY% -e "(define partNum 1)" hexany_permutations.ly
%LY% -e "(define partNum 2)" hexany_permutations.ly
%LY% -e "(define partNum 3)" hexany_permutations.ly
%LY% -e "(define partNum 4)" hexany_permutations.ly
%LY% -e "(define partNum 5)" hexany_permutations.ly
%LY% -e "(define partNum 6)" hexany_permutations.ly
%LY% -e "(define partNum 7)" hexany_permutations.ly
