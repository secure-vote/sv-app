module Msgs exposing (..)

import Material
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
    | MultiMsg (List Msg)


type MouseState
    = MouseUp
    | MouseDown
    | MouseOver
