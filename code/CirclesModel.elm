module CirclesModel where


type Position = { x: Int, y: Int }


type CircleSpec = {
         radius: Int,
         xv: Int,
         yv: Int,
         col: Color,
         creationTime: Time
     }


type Circle = {
         position: Position,
         circleSpec: CircleSpec
     }
