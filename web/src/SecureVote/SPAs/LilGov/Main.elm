module SecureVote.SPAs.LilGov.Main exposing (..)

import Html exposing (Html)
import Ports exposing (..)
import SecureVote.SPAs.LilGov.Models exposing (Flags, Model, initModel)
import SecureVote.SPAs.LilGov.Msgs exposing (..)
import SecureVote.SPAs.LilGov.Routes exposing (LilGovRoute(LoginR))
import SecureVote.SPAs.LilGov.Update exposing (update)
import SecureVote.SPAs.LilGov.Views.RootV exposing (rootView)
import Task exposing (perform, succeed)
import Time exposing (every, second)


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel LoginR flags, initCmds )


initCmds : Cmd Msg
initCmds =
    Cmd.batch <|
        [ perform Tick Time.now
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ every second Tick
        ]


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = rootView
        , update = update
        , subscriptions = subscriptions
        }
