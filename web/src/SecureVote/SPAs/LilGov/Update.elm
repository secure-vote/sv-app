module SecureVote.SPAs.LilGov.Update exposing (..)

import Components.Navigation exposing (navUpdate)
import Dict
import Element.Input as Input
import Maybe.Extra exposing ((?))
import Models.Democracy exposing (DelegateState(Active, Inactive))
import Ports
import Process
import SecureVote.SPAs.LilGov.Models exposing (Model, initModel)
import SecureVote.SPAs.LilGov.Msgs exposing (..)
import SecureVote.SPAs.LilGov.Routes exposing (LilGovRoute(..))
import Task
import Time exposing (Time)
import Utils.Update exposing (doUpdate)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Tick time ->
            --        Updates every second
            { model | now = time } ! []

        Nav msg ->
            doUpdate Nav (navUpdate CR) msg model.navModel (\n -> { model | navModel = n })
