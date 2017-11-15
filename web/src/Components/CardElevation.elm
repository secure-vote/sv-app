module Components.CardElevation exposing (..)

import Dict
import Material.Elevation as Elevation
import Material.Options as Options
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Msgs exposing (MouseState(..), Msg(SetElevation))


opts : Int -> Model -> List (Options.Property a Msg)
opts id model =
    let
        elevation id =
            case Dict.get id model.elevations ? MouseUp of
                MouseUp ->
                    Elevation.e4

                MouseDown ->
                    Elevation.e2

                MouseOver ->
                    Elevation.e8
    in
    [ elevation id
    , Options.onMouseOver (SetElevation id MouseOver)
    , Options.onMouseDown (SetElevation id MouseDown)
    , Options.onMouseLeave (SetElevation id MouseUp)
    , Options.onMouseUp (SetElevation id MouseOver)
    , Elevation.transition 50
    ]
