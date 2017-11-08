module Main exposing (..)

import Html exposing (program)
import Models exposing (Model, initModel)
import Msgs exposing (Msg)
import Update exposing (update)
import Views.RootV exposing (rootView)


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = rootView
        , update = update
        , subscriptions = subscriptions
        }
