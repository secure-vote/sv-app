module Update exposing (..)

import Dict
import Helpers exposing (getDemocracy)
import Material
import Models exposing (Model, initModel)
import Models.Ballot exposing (BallotId)
import Models.Democracy exposing (Democracy, DemocracyId)
import Msgs exposing (Msg(..))
import Navigation
import Routing exposing (parseLocation)


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
            { model | dialogHtml = { title = title, route = route } } ! []

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

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
            { model | route = newRoute } ! []

        NavigateBack ->
            ( model, Navigation.back 1 )

        NavigateHome ->
            ( model, Navigation.newUrl "#" )

        NavigateTo url ->
            ( model, Navigation.newUrl url )

        CreateVote vote voteId ->
            { model | votes = Dict.insert voteId vote model.votes } ! []

        CreateBallot ballot ballotId ->
            { model | ballots = Dict.insert ballotId ballot model.ballots } ! []

        AddBallotToDemocracy ballotId democracyId ->
            { model | democracies = Dict.insert democracyId (addBallot ballotId democracyId model) model.democracies } ! []

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
