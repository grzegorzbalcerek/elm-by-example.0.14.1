import Random
import Mouse
lengthSignal = lift (\x -> 1 + x `div` 100) Mouse.x
main = asText  <~ Random.floatList lengthSignal
