module Models.Ballot exposing (..)

import Time exposing (Time)


type alias BallotId =
    Int


type alias Ballot =
    { name : String
    , desc : String
    , start : Time
    , finish : Time
    , options : List BallotOption
    }


type alias BallotOption =
    { id : Int
    , name : String
    , desc : String
    , result : Maybe Float
    }
