import Mouse

combine : a -> b -> Element
combine a b = asText (a,b)

main = lift2 combine Mouse.x Mouse.y
