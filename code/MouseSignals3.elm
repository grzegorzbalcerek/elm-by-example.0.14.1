import Mouse

showsignals a b c d e f g h =
 flow down <| map plainText
 [ "Mouse.position: " ++ show a
 , "Mouse.x: " ++ show b
 , "Mouse.y: " ++ show c
 , "Mouse.clicks: " ++ show d
 , "Mouse.isDown: " ++ show e
 , "count Mouse.isDown: " ++ show f
 , "sampleOn Mouse.clicks Mouse.position: " ++ show g
 , "sampleOn Mouse.isDown Mouse.position: " ++ show h
 ]

main = showsignals <~ Mouse.position
                    ~ Mouse.x
                    ~ Mouse.y
                    ~ Mouse.clicks
                    ~ Mouse.isDown
                    ~ count Mouse.isDown
                    ~ sampleOn Mouse.clicks Mouse.position
                    ~ sampleOn Mouse.isDown Mouse.position
