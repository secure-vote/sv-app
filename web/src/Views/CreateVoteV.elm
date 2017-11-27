module Views.CreateVoteV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.TextF exposing (textF)
import Dict
import Helpers exposing (getDemocracy)
import Html exposing (Html, div, hr, p, span, text)
import Html.Attributes exposing (class)
import Material.Layout as Layout
import Material.Options as Options exposing (styled)
import Material.Textfield as Textf
import Material.Typography as Typo
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Models.Democracy exposing (DemocracyId)
import Msgs exposing (Msg(Mdl, NavigateBack, SetField))


createVoteV : DemocracyId -> Model -> Html Msg
createVoteV id model =
    let
        nameId =
            57458454645

        descId =
            34566456788

        startId =
            45675463426

        finishId =
            57458345645

        democracy =
            getDemocracy id model

        epoch timeId =
            Textf.error "Please enter an Epoch time"
                |> Options.when
                    (case String.toInt (Dict.get timeId model.fields ? "0") of
                        Err err ->
                            True

                        Ok val ->
                            False
                    )
    in
    div [ class "pa4" ]
        [ styled p [ Typo.subhead ] [ text <| "Democracy: " ++ democracy.name ]
        , styled p [ Typo.subhead ] [ text "Vote Details:" ]
        , textF nameId "Name" [] model
        , textF descId "Description" [ Textf.textarea ] model
        , textF startId "Start Time" [ epoch startId ] model
        , textF finishId "Finish Time" [ epoch finishId ] model
        , div [ class "mt4" ]
            [ btn 97546756756 model [ SecBtn, Attr (class "ma3 dib"), Click NavigateBack ] [ text "Cancel" ]
            , btn 85687456456 model [ PriBtn, Attr (class "ma3 dib"), Click NavigateBack ] [ text "Create" ]
            ]
        ]


createVoteH : List (Html msg)
createVoteH =
    [ Layout.title [] [ text "Create a new vote" ] ]
