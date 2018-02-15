module MainDemo exposing (..)

import Html exposing (Html)
import Models exposing (Flags, Model, initModelWithFlags, lSKeys)
import Msgs exposing (..)
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
        , perform (ToLs << LsRead) (succeed lSKeys.debugLog)
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.receiptBcData <| FromBc << BcReceipt
        , Ports.confirmBcData <| FromBc << BcConfirm
        , Ports.receiveBcData <| FromBc << BcReceive
        , Ports.gotLsImpl <| FromLs << LsReceive
        ]


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = rootDemoView
        , update = update
        , subscriptions = subscriptions
        }
