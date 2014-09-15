import Mouse
import Window
import Time (..)
import EyesView (..)
import EyesModel (..)

delayedMousePosition = delay (2*second) Mouse.position

ifFunction a b c = if a then b else c

combinedSignal = ifFunction <~ since (2*second) Mouse.clicks
                             ~ delayedMousePosition
                             ~ Mouse.position
  
main = lift2 eyes Window.dimensions combinedSignal

eyes (w,h) (x,y) = eyesView (w,h) (pupilsCoordinates (w,h) (x,y))
