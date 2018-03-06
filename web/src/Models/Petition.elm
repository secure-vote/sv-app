module Models.Petition exposing (..)

import Time exposing (Time)


type alias PetitionId =
    Int


type alias Petition =
    { name : String
    , desc : String
    , start : Time
    , finish : Time
    , support : Int
    }
