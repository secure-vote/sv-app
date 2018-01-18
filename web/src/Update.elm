module Update exposing (..)

--import Spinner

import Dict
import Helpers exposing (getDemocracy)
import Material
import Material.Helpers as MHelp exposing (map1st, map2nd)
import Material.Snackbar as Snackbar
import Maybe.Extra exposing ((?))
import Models exposing (Model, initModel)
import Models.Ballot exposing (BallotId, VoteConfirmStatus(..))
import Models.Democracy exposing (Democracy, DemocracyId)
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

        Mdl msg_ ->
            Material.update Mdl msg_ model

        SetDialog title route ->
            { model | dialogHtml = { title = title, route = route }, showDialog = True } ! []

        HideDialog ->
            { model | showDialog = False } ! []

        SetElevation id state ->
            { model | elevations = Dict.insert id state model.elevations } ! []

        SetField fieldId value ->
            { model | fields = Dict.insert fieldId value model.fields } ! []

        SetIntField fieldId value ->
            { model | intFields = Dict.insert fieldId value model.intFields } ! []

        SetFloatField fieldId value ->
            { model | floatFields = Dict.insert fieldId value model.floatFields } ! []

        ToggleBoolField fieldId ->
            let
                result =
                    case Dict.get fieldId model.boolFields of
                        Just True ->
                            Dict.insert fieldId False model.boolFields

                        _ ->
                            Dict.insert fieldId True model.boolFields
            in
            { model | boolFields = result } ! []

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

        CreateBallot ballot ballotId ->
            { model | ballots = Dict.insert ballotId ballot model.ballots } ! []

        DeleteBallot ballotId ->
            { model | ballots = Dict.remove ballotId model.ballots } ! []

        AddBallotToDemocracy ballotId democracyId ->
            { model | democracies = Dict.insert democracyId (addBallot ballotId democracyId model) model.democracies } ! []

        SetVoteConfirmStatus status ->
            let
                cmd =
                    case status of
                        AwaitingConfirmation ->
                            []

                        Processing ->
                            [ delay (Time.second * 3) <| SetVoteConfirmStatus Validating ]

                        Validating ->
                            [ delay (Time.second * 3) <| SetVoteConfirmStatus Complete ]

                        Complete ->
                            []
            in
            { model | voteConfirmStatus = status } ! cmd

        ShowToast string ->
            addSnack string model

        Snackbar msg_ ->
            Snackbar.update msg_ model.snack
                |> map1st (\s -> { model | snack = s })
                |> map2nd (Cmd.map Snackbar)

        --
        --        SpinnerMsg msg ->
        --            let
        --                spinnerModel =
        --                    Spinner.update msg model.spinner
        --            in
        --            { model | spinner = spinnerModel } ! []
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


addSnack : String -> Model -> ( Model, Cmd Msg )
addSnack string model =
    let
        ( snackbar_, effect ) =
            Snackbar.add (Snackbar.toast "some payload" string) model.snack
                |> map2nd (Cmd.map Snackbar)

        model_ =
            { model | snack = snackbar_ }
    in
    ( model_, Cmd.batch [ effect ] )


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity
