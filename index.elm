-- -*- coding: utf-8; -*-

import Lib (..)
import Window
import EyesView (..)
import EyesModel (..)
import SnakeModel (..)
import SnakeView
import FibonacciBars
import CirclesView
import Text (..)
import Text
import Graphics.Element
import CalculatorView
import CalculatorModel

version = "Built on 2014-09-16 using Elm 0.13."

main = lift content Window.width

content w = pageTemplate [ spacer 30 30
                         , title
                         , spacer 30 30
                         , author
                         , spacer 30 30
                         , container w 460 middle (examples |> Graphics.Element.link "toc.html")
                         , container w 30 middle tocLink
                         , container w 30 middle (plainText version)
                         ] "" "" "toc" w

title = toText "Elm by Example" |>
        bold |>
        Text.height 60 |>
        centered

author = toText "Grzegorz Balcerek" |>
         bold |>
         Text.height 40 |>
         centered

tocLink : Element
tocLink = [markdown| [Continue to the Table of Contents](toc.html) |]

snakeState = { delta = { dx = 1, dy = 0 }, food = Just { x = 11, y = 1 }, gameOver = False, snake = { back = [{ x = -5, y = 1 },{ x = -6, y = 1 },{ x = -7, y = 1 },{ x = -8, y = 1 },{ x = -9, y = 1 },{ x = -10, y = 1 },{ x = -11, y = 1 },{ x = -11, y = 0 },{ x = -11, y = -1 },{ x = -11, y = -2 },{ x = -11, y = -3 },{ x = -11, y = -4 },{ x = -11, y = -5 },{ x = -11, y = -6 },{ x = -10, y = -6 },{ x = -9, y = -6 },{ x = -8, y = -6 }], front = [{ x = 13, y = -6 },{ x = 12, y = -6 },{ x = 11, y = -6 },{ x = 10, y = -6 },{ x = 9, y = -6 },{ x = 8, y = -6 },{ x = 7, y = -6 },{ x = 6, y = -6 },{ x = 5, y = -6 },{ x = 4, y = -6 },{ x = 3, y = -6 },{ x = 2, y = -6 },{ x = 1, y = -6 },{ x = 0, y = -6 },{ x = -1, y = -6 },{ x = -2, y = -6 },{ x = -3, y = -6 },{ x = -4, y = -6 },{ x = -5, y = -6 },{ x = -6, y = -6 },{ x = -7, y = -6 }] }, ticks = 2076 }

snakeExample = collage 200 180 [SnakeView.view snakeState |> toForm |> scale 0.32 ]

fibonacciExample = collage 400 100 [ FibonacciBars.main |> toForm |> scale 0.30 ]

circlesState = [{ circleSpec = { col = RGBA 32 215 112 1, creationTime = 1409435570943, radius = 11, xv = 33, yv = 11 }, position = { x = 319, y = 367 } },{ circleSpec = { col = RGBA 2 135 100 1, creationTime = 1409435570943, radius = 16, xv = 47, yv = 48 }, position = { x = 168, y = 19 } },{ circleSpec = { col = RGBA 97 128 42 1, creationTime = 1409435570943, radius = 17, xv = 29, yv = 36 }, position = { x = 253, y = 196 } },{ circleSpec = { col = RGBA 202 200 30 1, creationTime = 1409435570943, radius = 23, xv = 16, yv = 43 }, position = { x = 328, y = 98 } },{ circleSpec = { col = RGBA 79 176 161 1, creationTime = 1409435565941, radius = 27, xv = 14, yv = 45 }, position = { x = 258, y = 343 } },{ circleSpec = { col = RGBA 217 210 128 1, creationTime = 1409435565941, radius = 15, xv = 32, yv = 19 }, position = { x = 42, y = 168 } },{ circleSpec = { col = RGBA 96 155 209 1, creationTime = 1409435565941, radius = 28, xv = 21, yv = 31 }, position = { x = 317, y = 55 } },{ circleSpec = { col = RGBA 45 89 96 1, creationTime = 1409435565941, radius = 16, xv = 50, yv = 18 }, position = { x = 82, y = 326 } },{ circleSpec = { col = RGBA 185 116 59 1, creationTime = 1409435565941, radius = 17, xv = 27, yv = 48 }, position = { x = 285, y = 90 } },{ circleSpec = { col = RGBA 163 200 125 1, creationTime = 1409435565941, radius = 11, xv = 46, yv = 50 }, position = { x = 62, y = 68 } },{ circleSpec = { col = RGBA 54 128 35 1, creationTime = 1409435565941, radius = 11, xv = 19, yv = 26 }, position = { x = 159, y = 259 } },{ circleSpec = { col = RGBA 11 203 176 1, creationTime = 1409435565941, radius = 28, xv = 39, yv = 47 }, position = { x = 238, y = 218 } },{ circleSpec = { col = RGBA 220 152 99 1, creationTime = 1409435565941, radius = 13, xv = 44, yv = 38 }, position = { x = 226, y = 152 } },{ circleSpec = { col = RGBA 173 46 195 1, creationTime = 1409435565941, radius = 25, xv = 50, yv = 26 }, position = { x = 214, y = 39 } },{ circleSpec = { col = RGBA 57 120 5 1, creationTime = 1409435565941, radius = 21, xv = 50, yv = 43 }, position = { x = 78, y = 170 } },{ circleSpec = { col = RGBA 218 72 101 1, creationTime = 1409435565941, radius = 29, xv = 43, yv = 35 }, position = { x = 58, y = 91 } },{ circleSpec = { col = RGBA 170 220 212 1, creationTime = 1409435565941, radius = 25, xv = 17, yv = 47 }, position = { x = 339, y = 229 } },{ circleSpec = { col = RGBA 163 143 62 1, creationTime = 1409435565941, radius = 14, xv = 33, yv = 23 }, position = { x = 59, y = 165 } },{ circleSpec = { col = RGBA 68 154 204 1, creationTime = 1409435565941, radius = 12, xv = 33, yv = 17 }, position = { x = 36, y = 253 } },{ circleSpec = { col = RGBA 190 208 26 1, creationTime = 1409435565941, radius = 14, xv = 48, yv = 35 }, position = { x = 239, y = 22 } },{ circleSpec = { col = RGBA 162 58 95 1, creationTime = 1409435560941, radius = 26, xv = 10, yv = 14 }, position = { x = 307, y = 300 } },{ circleSpec = { col = RGBA 28 160 143 1, creationTime = 1409435560941, radius = 13, xv = 11, yv = 41 }, position = { x = 361, y = 254 } },{ circleSpec = { col = RGBA 75 76 206 1, creationTime = 1409435560941, radius = 13, xv = 40, yv = 36 }, position = { x = 202, y = 103 } },{ circleSpec = { col = RGBA 196 206 220 1, creationTime = 1409435560941, radius = 27, xv = 37, yv = 41 }, position = { x = 141, y = 336 } }]

circlesExample = collage 200 180 [ CirclesView.view 400 400 circlesState |> toForm |> scale 0.45 ]

calculatorExample = collage 200 180 [ CalculatorView.view CalculatorModel.initialState (400,400) |> toForm |> scale 0.45 ]

examples = flow down [
  fibonacciExample,
  flow right [ eyesView (200,180) (pupilsCoordinates (200,150) (20,30))
             , circlesExample
             ],
  flow right [ snakeExample
             , calculatorExample
             ] ]
