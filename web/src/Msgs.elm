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
    | SetSelectField String (SelectWith DurationType Msg)
    | Select String (SelectMsg DurationType)
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
    | Debug String
    | MultiMsg (List Msg)
    | ChainMsgs (List Msg)
      --     Port Msgs
    | BlockchainSend SendMsg
    | BlockchainReceipt ( String, String )
    | BlockchainConfirm String
    | BlockchainGet String
    | BlockchainReceive String
    | LocalStorageWrite { key : String, value : String }
    | LocalStorageRead String
    | LocalStorageReceive { key : String, value : String }


type alias SendMsg =
    { name : String
    , payload : String
    , onReceipt : Msg
    , onConfirmation : Msg
    }


type DurationType
    = Day
    | Week
    | Month
