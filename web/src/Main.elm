module Main exposing (..)

import Models exposing (Model, initModel)
import Msgs exposing (Msg(SetTime))
import Navigation exposing (Location)
import Routing
import Task exposing (perform)
import Time exposing (Time)
import Update exposing (update)
import Views.RootV exposing (rootView)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
    ( initModel currentRoute, initCmds )


initCmds : Cmd Msg
initCmds =
    Cmd.batch <|
        [ perform SetTime Time.now
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    Navigation.program Msgs.OnLocationChange
        { init = init
        , view = rootView
        , update = update
        , subscriptions = subscriptions
        }
