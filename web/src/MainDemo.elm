module MainDemo exposing (..)

import Html exposing (Html)
import Models exposing (Flags, Model, initModelWithFlags, lSKeys)
import Msgs exposing (..)
import Ports exposing (..)
import Task exposing (perform, succeed)
import Time exposing (every, second)
import Update exposing (update)
import Views.RootDemoV exposing (rootDemoView)


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModelWithFlags flags, initCmds )


initCmds : Cmd Msg
initCmds =
    Cmd.batch <|
        [ perform (ToLs << LsRead) (succeed lSKeys.debugLog)
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ every second Tick
        , receiptBcData <| FromBc << BcReceipt
        , confirmBcData <| FromBc << BcConfirm
        , receiveBcData <| FromBc << BcReceive
        , gotLsImpl <| FromLs << LsReceive
        ]


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = rootDemoView
        , update = update
        , subscriptions = subscriptions
        }
