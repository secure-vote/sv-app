module Msgs exposing (..)

import DatePicker
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
      --      Navigation
    | NavigateBack
    | NavigateHome
    | NavigateTo Route
    | NavigateBackTo Route
      --      Blockchain
    | CreateVote ( VoteId, Vote )
    | CreateBallot DemocracyId ( BallotId, Ballot )
    | EditBallot ( BallotId, Ballot )
    | DeleteBallot BallotId
    | AddDelegate String ( DemocracyId, Democracy )
    | RemoveDelegate ( DemocracyId, Democracy )
    | SetVoteState VoteState ( VoteId, Vote )
    | SetBallotState BallotState ( BallotId, Ballot )
    | SetDelegateState DelegateState ( DemocracyId, Democracy )
      --      Date/Time
    | DatePickerMsg DatePicker.Msg
    | DateSelected
      --     Port Msgs
    | Send SendMsg
    | Receipt ( String, String )
    | Confirm String
    | Get String
    | Receive String
      --      Helpers
    | MultiMsg (List Msg)
    | ChainMsgs (List Msg)


type alias SendMsg =
    { name : String
    , payload : String
    , onReceipt : Msg
    , onConfirmation : Msg
    }
