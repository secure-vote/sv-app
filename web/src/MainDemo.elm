module MainDemo exposing (..)

import Models exposing (Flags, Model, initModelWithFlags)
import Msgs exposing (Msg(SetTime))
import Navigation exposing (Location)
import Routing
import Task exposing (perform)
import Time exposing (Time)
import Update exposing (update)
import Views.RootV exposing (rootView)


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            Routing.parseLocation location
    in
    ( initModelWithFlags flags currentRoute, initCmds )


initCmds : Cmd Msg
initCmds =
    Cmd.batch <|
        [ perform SetTime Time.now
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Flags Model Msg
main =
    Navigation.programWithFlags Msgs.OnLocationChange
        { init = init
        , view = rootView
        , update = update
        , subscriptions = subscriptions
        }
