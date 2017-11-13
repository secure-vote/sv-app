module Update exposing (..)

import Dict
import Material
import Maybe.Extra exposing ((?))
import Models exposing (Model, initModel)
import Msgs exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.NoOp ->
            ( model, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model

        SetDialog title route ->
            { model | dialogHtml = { title = title, route = route } } ! []

        SetElevation id state ->
            { model | elevations = Dict.insert id state model.elevations } ! []

        SetPage route ->
            { model | route = route } ! []

        SetDemocracy id ->
            { model | currentDemocracy = Dict.get id model.democracies ? initModel.currentDemocracy } ! []

        SetBallot ballot ->
            { model | currentBallot = ballot } ! []

        MultiMsg msgs ->
            multiUpdate msgs model []


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
