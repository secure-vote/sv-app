module Models.Democracy exposing (..)

import Models.Ballot exposing (BallotId)


type alias DemocracyId =
    Int


type alias Democracy =
    { name : String
    , desc : String
    , logo : String
    , ballots : List BallotId
    , delegate : Delegate
    }


type alias Delegate =
    { name : String
    , state : DelegateState
    }


type DelegateState
    = Inactive
    | Sending
    | Pending
    | Active
