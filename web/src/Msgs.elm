module Msgs exposing (..)

import Models.Ballot exposing (Ballot, BallotId, Vote, VoteId)
import Models.Democracy exposing (DemocracyId)
import Routes exposing (DialogRoute, Route)
import Time exposing (Time)


type Msg
    = NoOp
    | SetTime Time
    | SetDialog String (DialogRoute Msg)
    | HideDialog
    | SetField String String
    | SetIntField String Int
    | SetFloatField String Float
    | SetDelegate String
    | NavigateBack
    | NavigateHome
    | NavigateTo Route
    | NavigateBackTo Route
    | CreateVote Vote VoteId
    | CreateBallot ( BallotId, Ballot )
    | DeleteBallot BallotId
    | AddBallotToDemocracy BallotId DemocracyId
    | SetVoteConfirmState VoteConfirmState
    | SetDelegationState DelegationState
    | MultiMsg (List Msg)
    | ChainMsgs (List Msg)
      --     Port Msgs
    | Send ( String, String )
    | Receipt ( String, String )
    | Confirm String
    | Get String
    | Receive String


type MouseState
    = MouseUp
    | MouseDown
    | MouseOver


type DelegationState
    = Active
    | Inactive
    | Pending


type VoteConfirmState
    = AwaitingConfirmation
    | Processing
    | Validating
    | Complete
