@echo on

rem elm-package install elm-lang/core
rem elm-package install evancz/elm-markdown

rmdir /q/s src
rmdir /q/s target
mkdir src
mkdir target
del /q ..\ElmByExample\src\*

cmd /c examples.bat

cd ..\ElmByExample
cmd /c compile.bat
cd ..\elm-by-example

copy /y ..\ElmByExample\src\* target
copy /y ..\ElmByExample\*.html target
copy /y ..\ElmByExample\WindowSignals2.html target\WindowSignals2.html.txt
copy /y ..\ElmByExample\WindowSignals3.html target\WindowSignals3.html.txt
copy /y ..\ElmByExample\*.js target
copy /y Lib.elm src
copy /y index.elm src
copy /y toc.elm src
copy /y Introduction.elm src
copy target\*.elm src

prepareChapterSource Chapter1HelloWorld.elm
prepareChapterSource Chapter2FibonacciBars.elm
prepareChapterSource Chapter3MouseSignals.elm
prepareChapterSource Chapter4WindowSignals.elm
prepareChapterSource Chapter5Eyes.elm
prepareChapterSource Chapter6TimeSignals.elm
prepareChapterSource Chapter7DelayedCircles.elm
prepareChapterSource Chapter8Circles.elm
prepareChapterSource Chapter9Calculator.elm
prepareChapterSource Chapter10KeyboardSignals.elm
prepareChapterSource Chapter11Paddle.elm
prepareChapterSource Chapter12TicTacToe.elm
prepareChapterSource Chapter13Snake.elm
prepareChapterSource Chapter14SnakeRevisited.elm

elm-make src/index.elm --output target/index.html
elm-make src/toc.elm --output target/toc.html
elm-make src/Introduction.elm --output target/Introduction.html
elm-make src/Chapter1HelloWorld.elm --output target/Chapter1HelloWorld.html
elm-make src/Chapter2FibonacciBars.elm --output target/Chapter2FibonacciBars.html
elm-make src/Chapter3MouseSignals.elm --output target/Chapter3MouseSignals.html
elm-make src/Chapter4WindowSignals.elm --output target/Chapter4WindowSignals.html
elm-make src/Chapter5Eyes.elm --output target/Chapter5Eyes.html
elm-make src/Chapter6TimeSignals.elm --output target/Chapter6TimeSignals.html
elm-make src/Chapter7DelayedCircles.elm --output target/Chapter7DelayedCircles.html
elm-make src/Chapter8Circles.elm --output target/Chapter8Circles.html
elm-make src/Chapter9Calculator.elm --output target/Chapter9Calculator.html
elm-make src/Chapter10KeyboardSignals.elm --output target/Chapter10KeyboardSignals.html
elm-make src/Chapter11Paddle.elm --output target/Chapter11Paddle.html
elm-make src/Chapter12TicTacToe.elm --output target/Chapter12TicTacToe.html
elm-make src/Chapter13Snake.elm --output target/Chapter13Snake.html
elm-make src/Chapter14SnakeRevisited.elm --output target/Chapter14SnakeRevisited.html

rem copy /y code\WindowSignals2.html target\WindowSignals2.txt

echo target\build\index.html
