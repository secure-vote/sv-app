module Msgs exposing (..)

import Element.Input exposing (SelectMsg, SelectWith)
import Models.Ballot exposing (Ballot, BallotId, BallotState)
import Models.Democracy exposing (DelegateState, Democracy, DemocracyId)
import Models.Vote exposing (Vote, VoteId, VoteState)
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
    | NavigateBack
    | NavigateHome
    | NavigateTo Route
    | NavigateBackTo Route
    | CreateVote ( VoteId, Vote )
    | CreateBallot DemocracyId ( BallotId, Ballot )
    | EditBallot ( BallotId, Ballot )
    | DeleteBallot BallotId
    | AddDelegate String ( DemocracyId, Democracy )
    | RemoveDelegate ( DemocracyId, Democracy )
    | SetVoteState VoteState ( VoteId, Vote )
    | SetBallotState BallotState ( BallotId, Ballot )
    | SetDelegateState DelegateState ( DemocracyId, Democracy )
    | SetSelectField String (SelectWith SelectOptions Msg)
    | Select String (SelectMsg SelectOptions)
    | MultiMsg (List Msg)
    | ChainMsgs (List Msg)
      --     Port Msgs
    | Send SendMsg
    | Receipt ( String, String )
    | Confirm String
    | Get String
    | Receive String


type alias SendMsg =
    { name : String
    , payload : String
    , onReceipt : Msg
    , onConfirmation : Msg
    }


type SelectOptions
    = Day
    | Week
    | Month
