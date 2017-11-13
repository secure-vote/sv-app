module Msgs exposing (..)

import Material
import Models.Ballot exposing (Ballot)
import Routes exposing (DialogRoute, Route)


type Msg
    = NoOp
    | Mdl (Material.Msg Msg)
    | SetDialog String (DialogRoute Msg)
    | SetElevation Int MouseState
    | SetPage Route
    | SetDemocracy Int
    | SetBallot Ballot
    | MultiMsg (List Msg)


type MouseState
    = MouseUp
    | MouseDown
    | MouseOver
