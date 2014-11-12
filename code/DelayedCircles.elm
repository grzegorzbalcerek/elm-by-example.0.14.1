import Window
import Fibonacci (fibonacci)
import DrawCircles (drawCircles)
import DelayedMousePositions (delayedMousePositions)


main =
    drawCircles
        <~ delayedMousePositions (fibonacci 8 |> tail |> reverse)
        ~ Window.dimensions
