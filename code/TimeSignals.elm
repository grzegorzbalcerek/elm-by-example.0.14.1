import Time
import Mouse


showsignals a b c d e f =
    flow
        down
        <|
            map
                plainText
                [
                    "every (5*second): " ++ show a,
                    "since (2*second) Mouse.clicks: " ++ show b,
                    "timestamp Mouse.isDown: " ++ show c,
                    "delay second Mouse.position: " ++ show d,
                    "fps 200: " ++ show e,
                    "fpsWhen 200 Mouse.isDown: " ++ show f
                ]


main = showsignals
           <~ every (5*second)
           ~ since (2*second) Mouse.clicks
           ~ timestamp Mouse.isDown
           ~ delay second Mouse.position
           ~ fps 200
           ~ fpsWhen 200 Mouse.isDown
