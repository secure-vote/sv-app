module Update exposing (..)

--import Spinner

import Dict
import Helpers exposing (getDemocracy)
import Maybe.Extra exposing ((?))
import Models exposing (Model, initModel)
import Models.Ballot exposing (BallotId)
import Models.Democracy exposing (Democracy, DemocracyId)
import Msgs exposing (DelegationState(..), Msg(..), VoteConfirmState(..))
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

        SetDelegate string ->
            { model | delegate = string } ! []

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

        CreateVote vote voteId ->
            { model | votes = Dict.insert voteId vote model.votes } ! []

        CreateBallot ( ballotId, ballot ) ->
            { model | ballots = Dict.insert ballotId ballot model.ballots } ! []

        DeleteBallot ballotId ->
            { model | ballots = Dict.remove ballotId model.ballots } ! []

        AddBallotToDemocracy ballotId democracyId ->
            { model | democracies = Dict.insert democracyId (addBallot ballotId democracyId model) model.democracies } ! []

        SetVoteConfirmState state ->
            let
                cmd =
                    case state of
                        AwaitingConfirmation ->
                            []

                        Processing ->
                            [ delay (Time.second * 3) <| SetVoteConfirmState Validating ]

                        Validating ->
                            [ delay (Time.second * 3) <| SetVoteConfirmState Complete ]

                        Complete ->
                            []
            in
            { model | voteConfirmStatus = state } ! cmd

        SetDelegationState state ->
            let
                cmd =
                    case state of
                        Inactive ->
                            []

                        Pending ->
                            [ delay (Time.second * 3) <| SetDelegationState Active ]

                        Active ->
                            []
            in
            { model | delegationState = state } ! cmd

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


addBallot : BallotId -> DemocracyId -> Model -> Democracy
addBallot ballotId democracyId model =
    let
        democracy =
            getDemocracy democracyId model
    in
    { democracy | ballots = ballotId :: democracy.ballots }


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity
