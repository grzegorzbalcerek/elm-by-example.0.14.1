import Mouse
import Window
import EyesView (..)
import EyesModel (..)


main = lift2 eyes Window.dimensions Mouse.position


eyes (w,h) (x,y) = eyesView (w,h) (pupilsCoordinates (w,h) (x,y))
