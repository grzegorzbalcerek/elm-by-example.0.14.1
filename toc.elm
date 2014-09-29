-- -*- coding: utf-8; -*-


import Lib (..)
import Window

main = lift (pageTemplate [content] "index" "index" "Introduction") Window.width

content = [markdown|

# Table of contents

#### [Introduction](Introduction.html)
#### [Chapter 1 Hello World](Chapter1HelloWorld.html)
#### [Chapter 2 Fibonacci Bars](Chapter2FibonacciBars.html)
#### [Chapter 3 Mouse Signals](Chapter3MouseSignals.html)
#### [Chapter 4 Window Signals](Chapter4WindowSignals.html)
#### [Chapter 5 Eyes](Chapter5Eyes.html)
#### [Chapter 6 Time Signals](Chapter6TimeSignals.html)
#### [Chapter 7 Random Signals](Chapter7RandomSignals.html)
#### [Chapter 8 Circles](Chapter8Circles.html)
#### [Chapter 9 Calculator](Chapter9Calculator.html)
#### [Chapter 10 Keyboard Signals](Chapter10KeyboardSignals.html)
#### [Chapter 11 Snake](Chapter11Snake.html)
#### [Chapter 12 Tic Tac Toe](Chapter12TicTacToe.html)
#### [Chapter 13 SnakeRevisited](Chapter13SnakeRevisited.html)

|]
