module MainDemo exposing (..)

import Html exposing (Html)
import Models exposing (Flags, Model, initModelWithFlags)
import Msgs exposing (Msg(SetTime))
import Task exposing (perform)
import Time exposing (Time)
import Update exposing (update)
import Views.RootV exposing (rootView)


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModelWithFlags flags, initCmds )


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
    Html.programWithFlags
        { init = init
        , view = rootView
        , update = update
        , subscriptions = subscriptions
        }
