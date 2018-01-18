module MainDemo exposing (..)

import Html exposing (Html)
import Models exposing (Flags, Model, initModelWithFlags)
import Msgs exposing (Msg(SetTime))
import Spinner
import Task exposing (perform)
import Time exposing (Time)
import Update exposing (update)
import Views.RootDemoV exposing (rootDemoView)


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
    Sub.batch []



--    Sub.map SpinnerMsg Spinner.subscription
-- MAIN


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = rootDemoView
        , update = update
        , subscriptions = subscriptions
        }
