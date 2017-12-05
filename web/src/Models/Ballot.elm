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
    , results : String
    }


type alias BallotOption =
    { id : Int
    , name : String
    , desc : String
    }
