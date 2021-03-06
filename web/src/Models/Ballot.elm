module Models.Ballot exposing (..)

import Time exposing (Time)


type alias BallotId =
    Int


type alias Ballot =
    { name : String
    , desc : String
    , start : Time
    , finish : Time
    , ballotOptions : List BallotOption
    , state : BallotState
    }


type BallotState
    = BallotInitial
    | BallotSending
    | BallotPendingCreation
    | BallotPendingEdits
    | BallotPendingDeletion
    | BallotConfirmed
    | BallotNone


type alias BallotOptionId =
    Int


type alias BallotOption =
    { id : BallotOptionId
    , name : String
    , desc : String
    , result : Maybe Float
    }


type alias BallotFieldIds =
    { name : String
    , desc : String
    , start : String
    , durationVal : String
    , durationType : String
    , extraBalOpts : String
    }


type alias BallotOptionFieldIds =
    { name : String
    , desc : String
    }
