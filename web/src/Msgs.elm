module Msgs exposing (..)

import Material
import Material.Snackbar as Snackbar
import Models.Ballot exposing (Ballot, BallotId, Vote, VoteConfirmStatus, VoteId)
import Models.Democracy exposing (DemocracyId)
import Routes exposing (DialogRoute, Route)
import Time exposing (Time)


type Msg
    = NoOp
    | SetTime Time
    | Mdl (Material.Msg Msg)
    | SetDialog String (DialogRoute Msg)
    | SetElevation Int MouseState
    | SetField Int String
    | SetIntField Int Int
    | SetFloatField Int Float
    | ToggleBoolField Int
    | NavigateBack
    | NavigateHome
    | NavigateTo Route
    | NavigateBackTo Route
    | CreateVote Vote VoteId
    | CreateBallot Ballot BallotId
    | DeleteBallot BallotId
    | AddBallotToDemocracy BallotId DemocracyId
    | SetVoteConfirmStatus VoteConfirmStatus
    | ShowToast String
    | Snackbar (Snackbar.Msg String)
    | MultiMsg (List Msg)
    | ChainMsgs (List Msg)


type MouseState
    = MouseUp
    | MouseDown
    | MouseOver
