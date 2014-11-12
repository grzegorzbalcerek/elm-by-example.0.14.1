import Random
import Mouse


lengthSignal = lift (\x -> 1 + x // 100) Mouse.x


main = asText  <~ Random.floatList lengthSignal
