module Update exposing (..)

--import Spinner

import BlockchainPorts as Ports
import Dict
import Element.Input as Input
import Helpers exposing (genDropDown, getDemocracy, getTx)
import Maybe.Extra exposing ((?))
import Models exposing (Model, initModel)
import Models.Democracy exposing (DelegateState(Active, Inactive))
import Msgs exposing (Msg(..))
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

        SetSelectField fieldId sMsg ->
            let
                select =
                    Dict.get fieldId model.selectFields ? genDropDown fieldId Nothing
            in
            --            { model | selectFields = Dict.insert fieldId value model.selectFields } ! []
            { model | selectFields = Dict.insert fieldId (Input.updateSelection sMsg select) model.selectFields } ! []

        --        Select selectMsg ->
        --            { model | select = Input.updateSelection selectMsg model.select } ! []
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
        Send sendMsg ->
            let
                refId =
                    sendMsg.name ++ toString model.now
            in
            { model | txReceipts = Dict.insert refId sendMsg model.txReceipts } ! [ Ports.send ( refId, sendMsg.payload ) ]

        Receipt ( refId, txId ) ->
            let
                msg =
                    (getTx refId model).onReceipt
            in
            update msg model

        Confirm refId ->
            let
                msg =
                    (getTx refId model).onConfirmation
            in
            update msg model

        Get txId ->
            ( model, Ports.get txId )

        Receive data ->
            ( model, Cmd.none )


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
