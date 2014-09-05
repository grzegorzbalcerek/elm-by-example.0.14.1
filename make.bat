
set RUNTIME=--set-runtime=C:\Local\ElmPlatform\0.12.3\share\elm-runtime.js
set RUNTIME=--set-runtime=http://elm-lang.org/elm-runtime.js
rem set RUNTIME=--set-runtime=elm-runtime.js
rem set RUNTIME=

rem rmdir /q/s target
mkdir target

copy /y code\* target
copy /y *.elm target

cd target

elm %RUNTIME% -m Lib.elm
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
elm %RUNTIME% -m Chapter5Eyes.elm
elm %RUNTIME% -m EyesView.elm
elm %RUNTIME% -m EyesModel.elm
elm %RUNTIME% -m Eyes.elm
elm %RUNTIME% -m Chapter6TimeSignals.elm
elm %RUNTIME% -m TimeSignals.elm
elm %RUNTIME% -m Chapter7RandomSignals.elm
elm %RUNTIME% -m RandomSignals1.elm
elm %RUNTIME% -m RandomSignals2.elm
elm %RUNTIME% -m RandomSignals3.elm
elm %RUNTIME% -m Chapter8Circles.elm
elm %RUNTIME% -m CirclesView.elm
elm %RUNTIME% -m Circles.elm
elm %RUNTIME% -m CirclesTest.elm
elm %RUNTIME% -m Chapter9Calculator.elm
elm %RUNTIME% -m CalculatorViewTest1.elm
elm %RUNTIME% -m CalculatorView.elm
elm %RUNTIME% -m Calculator.elm
elm %RUNTIME% -m Chapter10KeyboardSignals.elm
elm %RUNTIME% -m KeyboardSignals1.elm
elm %RUNTIME% -m KeyboardSignals2.elm
elm %RUNTIME% -m KeyboardSignals3.elm
elm %RUNTIME% -m KeyboardSignals4.elm
elm %RUNTIME% -m Chapter11Snake.elm
elm %RUNTIME% -m Snake.elm
elm %RUNTIME% -m SnakeView.elm

cd ..

copy /y code\* target\build
copy /y code\WindowSignals2.html target\build\WindowSignals2.txt
rem copy /y C:\Local\ElmPlatform\0.12.3\share\elm-runtime.js target\build
rem copy /y C:\Local\elm-runtime.js target\build

echo target\build\index.html
