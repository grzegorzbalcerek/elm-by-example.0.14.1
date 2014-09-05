module Circles where

import Color
import Time (..)
import Mouse
import Random (range)
import CirclesModel (..)
import CirclesView (..)

clickPositionsSignal : Signal (Int,Int)
clickPositionsSignal = sampleOn Mouse.clicks Mouse.position

inBoxClickPositionsSignal : Int -> Int -> Signal (Int,Int)
inBoxClickPositionsSignal w h =
  let positionInBox pos = fst pos <= w && snd pos <= h
  in keepIf positionInBox (0,0) clickPositionsSignal

clockSignal : Signal Time
clockSignal = lift fst (timestamp (fps 50))

radiusSignal : Int -> Int -> Signal Int
radiusSignal w h = range 10 30 (inBoxClickPositionsSignal w h)

velocitySignal : Int -> Int -> Signal Int
velocitySignal w h = range 10 50 (inBoxClickPositionsSignal w h)

colorSignal : Int -> Int -> Signal Color
colorSignal w h =
  let
    redSignal = range 0 220 (inBoxClickPositionsSignal w h)
    greenSignal = range 0 220 (inBoxClickPositionsSignal w h)
    blueSignal = range 0 220 (inBoxClickPositionsSignal w h)
  in lift3 rgb redSignal greenSignal blueSignal

creationTimeSignal : Int -> Int -> Signal Time
creationTimeSignal w h = sampleOn (inBoxClickPositionsSignal w h) clockSignal

newCircleSpecSignal : Int -> Int -> Signal CircleSpec
newCircleSpecSignal w h =
  let makeCircleSpec r xv yv c t = { radius = r, xv = xv, yv = yv, col = c, creationTime = t }
  in makeCircleSpec <~ radiusSignal w h
                     ~ velocitySignal w h
                     ~ velocitySignal w h
                     ~ colorSignal w h
                     ~ creationTimeSignal w h

newCircleSignal : Int -> Int -> Signal Circle
newCircleSignal w h =
  let makeCircle (x,y) spec = { position = { x = x, y = y }, circleSpec = spec }
  in makeCircle <~ inBoxClickPositionsSignal w h
                 ~ newCircleSpecSignal w h

allCirclesSpecSignal : Int -> Int -> Signal [Circle]
allCirclesSpecSignal w h = foldp (::) [] (newCircleSignal w h)

circlesSignal : Int -> Int -> Signal [Circle]
circlesSignal w h = positionedCircles w h <~ clockSignal
                                           ~ allCirclesSpecSignal w h

main : Signal Element
main = let main' w h = view w h <~ circlesSignal w h
        in main' 400 400


