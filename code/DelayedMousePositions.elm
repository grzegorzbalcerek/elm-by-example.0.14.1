module DelayedMousePositions where

import Mouse
import Window

delayedMousePositions : [Int] -> Signal [(Int,(Int,Int))]
delayedMousePositions rs =
  let adjust (w,h) (x,y) = (x-w//2,h//2-y)
      n = length rs
      position = adjust <~ Window.dimensions ~ Mouse.position
      positions = repeat n position -- [Signal (Int,Int)]
      delayedPositions =            -- [Signal (Int,(Int,Int))]
           zipWith
           (\r pos ->
              let delayedPosition = delay (toFloat r*100) pos
              in lift (\pos -> (r,pos)) delayedPosition)
           rs
           positions
  in combine delayedPositions

main = asText <~ delayedMousePositions [0,10,25]
