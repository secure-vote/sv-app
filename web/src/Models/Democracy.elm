module Models.Democracy exposing (..)

import Models.Ballot exposing (Ballot, BallotId)


type alias DemocracyId =
    Int


type alias Democracy =
    { name : String
    , desc : String
    , logo : String
    , ballots : List BallotId
    }
