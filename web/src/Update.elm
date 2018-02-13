module Update exposing (..)

--import Spinner

import Dict
import Element.Input as Input
import Helpers exposing (getDemocracy, getSelectField, getTx)
import Maybe.Extra exposing ((?))
import Models exposing (Model, initModel, lSKeys)
import Models.Democracy exposing (DelegateState(Active, Inactive))
import Msgs exposing (Msg(..))
import Ports
import Process
import Routes exposing (Route(NotFoundRoute))
import Task
import Time exposing (Time)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.NoOp ->
            ( model, Cmd.none )

        SetTime time ->
            { model | now = time } ! []

        SetDialog title route ->
            { model | dialogHtml = { title = title, route = route }, showDialog = True } ! []

        HideDialog ->
            { model | showDialog = False } ! []

        SetField fieldName value ->
            { model | fields = Dict.insert fieldName value model.fields } ! []

        SetIntField fieldId value ->
            { model | intFields = Dict.insert fieldId value model.intFields } ! []

        SetFloatField fieldId value ->
            { model | floatFields = Dict.insert fieldId value model.floatFields } ! []

        SetSelectField fieldId selectWith ->
            { model | selectFields = Dict.insert fieldId selectWith model.selectFields } ! []

        Select fieldId selectMsg ->
            let
                selectField =
                    getSelectField fieldId model

                selectWith =
                    Input.updateSelection selectMsg selectField
            in
            { model | selectFields = Dict.insert fieldId selectWith model.selectFields } ! []

        NavigateBack ->
            { model | routeStack = List.tail model.routeStack ? [ NotFoundRoute ] } ! []

        NavigateHome ->
            { model | routeStack = List.drop (List.length model.routeStack - 1) model.routeStack } ! []

        NavigateTo newRoute ->
            { model | routeStack = newRoute :: model.routeStack } ! []

        NavigateBackTo oldRoute ->
            let
                findRoute routeStack =
                    if List.head routeStack == Just oldRoute then
                        routeStack
                    else
                        findRoute <| List.tail routeStack ? []
            in
            { model | routeStack = findRoute model.routeStack } ! []

        CreateVote ( voteId, vote ) ->
            { model | votes = Dict.insert voteId vote model.votes } ! []

        CreateBallot democId ( ballotId, ballot ) ->
            let
                democracy =
                    getDemocracy democId model

                addBallot =
                    { democracy | ballots = ballotId :: democracy.ballots }
            in
            { model
                | ballots = Dict.insert ballotId ballot model.ballots
                , democracies = Dict.insert democId addBallot model.democracies
            }
                ! []

        EditBallot ( ballotId, ballot ) ->
            { model | ballots = Dict.insert ballotId ballot model.ballots } ! []

        DeleteBallot ballotId ->
            { model | ballots = Dict.remove ballotId model.ballots } ! []

        AddDelegate name ( democId, democracy ) ->
            let
                addDelegate =
                    { democracy | delegate = { name = name, state = Active } }
            in
            { model | democracies = Dict.insert democId addDelegate model.democracies } ! []

        RemoveDelegate ( democId, democracy ) ->
            let
                removeDelegate =
                    { democracy | delegate = { name = "", state = Inactive } }
            in
            { model | democracies = Dict.insert democId removeDelegate model.democracies } ! []

        SetVoteState state ( voteId, vote ) ->
            let
                setVoteState =
                    { vote | state = state }
            in
            { model | votes = Dict.insert voteId setVoteState model.votes } ! []

        SetBallotState state ( ballotId, ballot ) ->
            let
                setBallotState =
                    { ballot | state = state }
            in
            { model | ballots = Dict.insert ballotId setBallotState model.ballots } ! []

        SetDelegateState state ( democId, democracy ) ->
            let
                delegate =
                    democracy.delegate

                setDelegateState =
                    { democracy | delegate = { delegate | state = state } }
            in
            { model | democracies = Dict.insert democId setDelegateState model.democracies } ! []

        Debug str ->
            let
                currentLog =
                    Dict.get lSKeys.debugLog model.localStorage ? ""

                -- TODO: model.now does't update in real time.
                -- TODO: convert model.now from float to ISO format
                newLog =
                    "\n" ++ toString model.now ++ " : " ++ str ++ currentLog

                mdl =
                    { model | localStorage = Dict.insert lSKeys.debugLog newLog model.localStorage }
            in
            update (LocalStorageWrite { key = lSKeys.debugLog, value = newLog }) mdl

        MultiMsg msgs ->
            multiUpdate msgs model []

        ChainMsgs msgs ->
            let
                chain msg1 ( model1, cmds ) =
                    let
                        ( model2, cmds1 ) =
                            update msg1 model1
                    in
                    model2 ! [ cmds, cmds1 ]
            in
            List.foldl chain (model ! []) msgs

        --     Port Msgs
        BlockchainSend sendMsg ->
            let
                -- TODO: model.now does't update in real time.
                -- TODO: convert model.now from float to ISO format
                refId =
                    sendMsg.name ++ toString model.now

                mdl =
                    { model | txReceipts = Dict.insert refId sendMsg model.txReceipts }

                msgs =
                    [ Debug <| "Blockchain Send : sendMsg = { name = '" ++ sendMsg.name ++ "', payload = '" ++ sendMsg.payload ++ "' }" ]
            in
            multiUpdate msgs mdl [ Ports.send ( refId, sendMsg.payload ) ]

        BlockchainReceipt ( refId, txId ) ->
            let
                msgs =
                    [ (getTx refId model).onReceipt
                    , Debug <| "Blockchain Receipt : TxID = " ++ txId
                    ]
            in
            multiUpdate msgs model []

        BlockchainConfirm refId ->
            let
                msgs =
                    [ (getTx refId model).onConfirmation
                    , Debug <| "Blockchain Confirmation : RefId = " ++ refId
                    ]
            in
            multiUpdate msgs model []

        BlockchainGet txId ->
            let
                msgs =
                    [ Debug <| "Blockchain Get : TxId = " ++ txId ]
            in
            multiUpdate msgs model [ Ports.get txId ]

        BlockchainReceive data ->
            let
                msgs =
                    [ Debug <| "Blockchain Receive : data = " ++ data ]
            in
            multiUpdate msgs model []

        LocalStorageWrite payload ->
            ( model, Ports.writeLocalStorageImpl payload )

        LocalStorageRead key ->
            ( model, Ports.readLocalStorageImpl key )

        LocalStorageReceive { key, value } ->
            { model | localStorage = Dict.insert key value model.localStorage } ! []


multiUpdate : List Msg -> Model -> List (Cmd Msg) -> ( Model, Cmd Msg )
multiUpdate msgs model cmds =
    case msgs of
        msg :: msgs_ ->
            let
                ( model_, cmd ) =
                    update msg model

                cmds_ =
                    cmds ++ [ cmd ]
            in
            multiUpdate msgs_ model_ cmds_

        [] ->
            ( model, Cmd.batch cmds )


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity
