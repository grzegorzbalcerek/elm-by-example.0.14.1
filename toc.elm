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
#### [Chapter 7 Delayed Circles](Chapter7DelayedCircles.html)
#### [Chapter 8 Random Signals](Chapter8RandomSignals.html)
#### [Chapter 9 Circles](Chapter9Circles.html)
#### [Chapter 10 Calculator](Chapter10Calculator.html)
#### [Chapter 11 Keyboard Signals](Chapter11KeyboardSignals.html)
#### [Chapter 12 Paddle](Chapter12Paddle.html)
#### [Chapter 13 Tic Tac Toe](Chapter13TicTacToe.html)
#### [Chapter 14 Snake](Chapter14Snake.html)
#### [Chapter 15 Snake Revisited](Chapter15SnakeRevisited.html)

|]
