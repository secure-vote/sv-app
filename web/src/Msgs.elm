module Msgs exposing (..)

import Material
import Models.Ballot exposing (Ballot)
import Navigation exposing (Location)
import Routes exposing (DialogRoute, Route)


type Msg
    = NoOp
    | Mdl (Material.Msg Msg)
    | SetDialog String (DialogRoute Msg)
    | SetElevation Int MouseState
    | SetField Int String
    | SetIntField Int Int
    | OnLocationChange Location
    | NavigateBack
    | NavigateHome
    | NavigateTo String
    | MultiMsg (List Msg)


type MouseState
    = MouseUp
    | MouseDown
    | MouseOver
