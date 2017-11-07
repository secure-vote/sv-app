module Main exposing (..)

import Html exposing (program)
import Material
import Models exposing (Model)
import Msgs exposing (Msg)
import Update exposing (update)
import Views.RootV exposing (rootView)


init : ( Model, Cmd Msg )
init =
    ( { mdl = Material.model }, Cmd.none )


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
