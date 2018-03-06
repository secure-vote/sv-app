module MainLilGov exposing (..)

import Html exposing (Html)
import Models exposing (Flags, Model, initModel, lSKeys)
import Msgs exposing (..)
import Ports exposing (..)
import Routes exposing (Route(LoginR))
import Task exposing (perform, succeed)
import Time exposing (every, second)
import Update exposing (update)
import Views.RootLilGovV exposing (rootLilGovView)


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel LoginR flags, initCmds )


initCmds : Cmd Msg
initCmds =
    Cmd.batch <|
        [ perform Tick Time.now
        , perform (ToLs << LsRead) (succeed lSKeys.debugLog)
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
        , view = rootLilGovView
        , update = update
        , subscriptions = subscriptions
        }