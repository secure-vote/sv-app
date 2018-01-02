module Msgs exposing (..)

import Material
import Models.Ballot exposing (Ballot, BallotId, Vote, VoteId)
import Models.Democracy exposing (DemocracyId)
import Navigation exposing (Location)
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
    | OnLocationChange Location
    | NavigateBack
    | NavigateHome
    | NavigateTo String
    | CreateVote Vote VoteId
    | CreateBallot Ballot BallotId
    | DeleteBallot BallotId
    | AddBallotToDemocracy BallotId DemocracyId
    | MultiMsg (List Msg)
    | ChainMsgs (List Msg)


type MouseState
    = MouseUp
    | MouseDown
    | MouseOver
