module CirclesTest where

import Circles (..)

show a b c d e f g h i j k = flow down
 [ asText a
 , asText b
 , asText c
 , asText d
 , asText e
 , asText f
 , asText g
 , asText h
 , asText i
 , asText j
 , asText k
 ]

main = show <~ clockSignal
             ~ clickPositionsSignal
             ~ inBoxClickPositionsSignal 400 400
             ~ radiusSignal 400 400
             ~ velocitySignal 400 400
             ~ colorSignal 400 400
             ~ creationTimeSignal 400 400
             ~ newCircleSpecSignal 400 400
             ~ newCircleSignal 400 400
             ~ allCirclesSpecSignal 400 400
             ~ circlesSignal 400 400