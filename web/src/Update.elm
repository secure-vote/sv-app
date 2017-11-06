module Update exposing (..)

import Material
import Models exposing (Model)
import Msgs exposing (Msg(Mdl))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.NoOp ->
            ( model, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model
