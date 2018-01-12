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
    }


type alias BallotOptionId =
    Int


type alias BallotOption =
    { id : BallotOptionId
    , name : String
    , desc : String
    , result : Maybe Float
    }


type alias VoteId =
    Int


type alias Vote =
    { ballotId : BallotId
    , voteOptions : List VoteOption
    }


type alias VoteOption =
    { id : BallotOptionId
    , value : Float
    }


type alias BallotFieldIds =
    { name : Int
    , desc : Int
    , start : Int
    , finish : Int
    , numOpts : Int
    }


type alias BallotOptionFieldIds =
    { id : Int
    , name : Int
    , desc : Int
    }


type VoteConfirmStatus
    = AwaitingConfirmation
    | Processing
    | Validating
    | Complete
