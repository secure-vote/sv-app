module Main exposing (..)

import Html exposing (Html)
import Models exposing (Model, initModel)
import Msgs exposing (Msg(SetTime))
import Task exposing (perform)
import Time exposing (Time)
import Update exposing (update)
import Views.RootV exposing (rootView)


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
    Html.program
        { init = ( initModel, initCmds )
        , view = rootView
        , update = update
        , subscriptions = subscriptions
        }
