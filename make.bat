@echo off

rem ghc --make extractCode.hs
rem ghc --make prepareChapterSource.hs

set RUNTIME=--set-runtime=elm-runtime.js
rem set RUNTIME=

rem rmdir /q/s target
mkdir target
mkdir target\Chess

extractCode Chapter1HelloWorld.elm
extractCode Chapter2FibonacciBars.elm
extractCode Chapter3MouseSignals.elm
extractCode Chapter4WindowSignals.elm
extractCode Chapter5Eyes.elm
extractCode Chapter6TimeSignals.elm
extractCode Chapter7DelayedCircles.elm
extractCode Chapter8RandomSignals.elm
extractCode Chapter9Circles.elm
extractCode Chapter10Calculator.elm
extractCode Chapter11KeyboardSignals.elm
extractCode Chapter12Paddle.elm
extractCode Chapter13TicTacToe.elm
extractCode Chapter14Snake.elm
extractCode Chapter15SnakeRevisited.elm

copy /y code\* target
copy /y *.elm target

prepareChapterSource Chapter1HelloWorld.elm
prepareChapterSource Chapter2FibonacciBars.elm
prepareChapterSource Chapter3MouseSignals.elm
prepareChapterSource Chapter4WindowSignals.elm
prepareChapterSource Chapter5Eyes.elm
prepareChapterSource Chapter6TimeSignals.elm
prepareChapterSource Chapter7DelayedCircles.elm
prepareChapterSource Chapter8RandomSignals.elm
prepareChapterSource Chapter9Circles.elm
prepareChapterSource Chapter10Calculator.elm
prepareChapterSource Chapter11KeyboardSignals.elm
prepareChapterSource Chapter12Paddle.elm
prepareChapterSource Chapter13TicTacToe.elm
prepareChapterSource Chapter14Snake.elm
prepareChapterSource Chapter15SnakeRevisited.elm

cd target

echo /* > elm-runtime.js
type ..\..\Elm\LICENSE >> elm-runtime.js
echo */ >> elm-runtime.js
type C:\Users\grzes\AppData\Roaming\cabal\i386-windows-ghc-7.8.3\Elm-0.13\elm-runtime.js >> elm-runtime.js

elm %RUNTIME% -m index.elm
elm %RUNTIME% -m toc.elm
elm %RUNTIME% -m Introduction.elm
elm %RUNTIME% -m Chapter1HelloWorld.elm
elm %RUNTIME% -m HelloWorld1.elm
elm %RUNTIME% -m HelloWorld2.elm
elm %RUNTIME% -m HelloWorld3.elm
elm %RUNTIME% -m HelloWorld4.elm
elm %RUNTIME% -m Chapter2FibonacciBars.elm
elm %RUNTIME% -m FibonacciBars.elm
elm %RUNTIME% -m Chapter3MouseSignals.elm
elm %RUNTIME% -m MouseSignals1.elm
elm %RUNTIME% -m MouseSignals2.elm
elm %RUNTIME% -m MouseSignals3.elm
elm %RUNTIME% -m Chapter4WindowSignals.elm
elm %RUNTIME% -m WindowSignals1.elm
elm %RUNTIME% --only-js WindowSignals1.elm
elm %RUNTIME% -m Chapter5Eyes.elm
elm %RUNTIME% -m EyesView.elm
elm %RUNTIME% -m EyesModel.elm
elm %RUNTIME% -m Eyes.elm
elm %RUNTIME% -m Chapter6TimeSignals.elm
elm %RUNTIME% -m TimeSignals.elm
elm %RUNTIME% -m Chapter7DelayedCircles.elm
elm %RUNTIME% -m DrawCircles.elm
elm %RUNTIME% -m DelayedMousePositions.elm
elm %RUNTIME% -m DelayedCircles.elm
elm %RUNTIME% -m Chapter8RandomSignals.elm
elm %RUNTIME% -m RandomSignals1.elm
elm %RUNTIME% -m RandomSignals2.elm
elm %RUNTIME% -m RandomSignals3.elm
elm %RUNTIME% -m Chapter9Circles.elm
elm %RUNTIME% -m CirclesView.elm
elm %RUNTIME% -m Circles.elm
elm %RUNTIME% -m CirclesTest.elm
elm %RUNTIME% -m Chapter10Calculator.elm
elm %RUNTIME% -m CalculatorViewTest1.elm
elm %RUNTIME% -m CalculatorView.elm
elm %RUNTIME% -m Calculator.elm
elm %RUNTIME% -m Chapter11KeyboardSignals.elm
elm %RUNTIME% -m KeyboardSignals1.elm
elm %RUNTIME% -m KeyboardSignals2.elm
elm %RUNTIME% -m KeyboardSignals3.elm
elm %RUNTIME% -m KeyboardSignals4.elm
elm %RUNTIME% -m Chapter12Paddle.elm
elm %RUNTIME% -m Paddle.elm
elm %RUNTIME% -m Chapter13TicTacToe.elm
elm %RUNTIME% -m TicTacToe.elm
elm %RUNTIME% -m Chapter14Snake.elm
elm %RUNTIME% -m Snake.elm
elm %RUNTIME% -m SnakeView.elm
elm %RUNTIME% -m Chapter15SnakeRevisited.elm
elm %RUNTIME% -m SnakeRevisited.elm

cd ..

copy /y target\elm-runtime.js target\build
copy /y code\* target\build
copy /y code\WindowSignals2.html target\build\WindowSignals2.txt

echo target\build\index.html
