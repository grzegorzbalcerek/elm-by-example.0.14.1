module CirclesModel where

type Position = { x: Int, y: Int }
type CircleSpec = { radius: Int, xv: Int, yv: Int, col: Color, creationTime: Time }
type Circle = { position: Position, circleSpec: CircleSpec }

computeCoordinate : Int -> Int -> Float -> Float -> Int
computeCoordinate startingPointCoordinate boxSize velocity time =
  let
    distance = startingPointCoordinate + round(velocity * time / 1000)
    distanceMod = distance % boxSize
    distanceDiv = distance // boxSize
  in if (distanceDiv % 2 == 0) then distanceMod else boxSize - distanceMod

positionedCircle : Int -> Int -> Float -> Circle -> Circle
positionedCircle w h time circle =
  let
    {position, circleSpec} = circle
    {radius, xv, yv, creationTime} = circleSpec
    relativeTime = time - creationTime
    boxSizeX = w - radius*2
    boxSizeY = h - radius*2
    x = radius + computeCoordinate (position.x-radius) boxSizeX (toFloat xv) relativeTime
    y = radius + computeCoordinate (position.y-radius) boxSizeY (toFloat yv) relativeTime
  in { position = { x=x, y=y }, circleSpec = circleSpec }

positionedCircles : Int -> Int -> Float -> [Circle] -> [Circle]
positionedCircles w h time circles = map (positionedCircle w h time) circles
