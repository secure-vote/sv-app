module Models.Vote exposing (..)

import Models.Ballot exposing (BallotId, BallotOptionId)


type alias VoteId =
    Int


type alias Vote =
    { ballotId : BallotId
    , voteOptions : List VoteOption
    , state : VoteState
    }


type VoteState
    = VoteInitial
    | VoteSending
    | VotePending
    | VoteConfirmed
    | VoteNone


type alias VoteOption =
    { id : BallotOptionId
    , value : Float
    }
