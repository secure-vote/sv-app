module Update exposing (..)

import Dict
import Material
import Models exposing (Model, initModel)
import Msgs exposing (Msg(..))
import Navigation
import Routing exposing (parseLocation)


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

        SetField fieldId value ->
            { model | fields = Dict.insert fieldId value model.fields } ! []

        SetIntField fieldId value ->
            { model | intFields = Dict.insert fieldId value model.intFields } ! []

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
            ( { model | route = newRoute }, Cmd.none )

        NavigateBack ->
            ( model, Navigation.back 1 )

        NavigateHome ->
            ( model, Navigation.newUrl "#" )

        NavigateTo url ->
            ( model, Navigation.newUrl url )

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
