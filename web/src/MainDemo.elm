module MainDemo exposing (..)

import Html exposing (Html)
import Models exposing (Flags, Model, initModelWithFlags, lSKeys)
import Msgs exposing (Msg(BlockchainConfirm, BlockchainReceipt, BlockchainReceive, LocalStorageRead, LocalStorageReceive, SetTime))
import Ports
import Task exposing (perform, succeed)
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
        , perform LocalStorageRead (succeed lSKeys.debugLog)
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.receipt BlockchainReceipt
        , Ports.confirmation BlockchainConfirm
        , Ports.receive BlockchainReceive
        , Ports.gotLocalStorageImpl LocalStorageReceive
        ]



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
