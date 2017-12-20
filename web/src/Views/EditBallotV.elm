module Views.EditBallotV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.TextF exposing (textF)
import Dict
import Helpers exposing (genNewId, getBallot, getDemocracy, getField, getIntField)
import Html exposing (Html, div, hr, p, span, text)
import Html.Attributes exposing (class)
import List exposing (map)
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options exposing (cs, styled)
import Material.Textfield as Textf
import Material.Typography as Typo
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Models.Ballot exposing (Ballot, BallotId, BallotOption)
import Models.Democracy exposing (DemocracyId)
import Msgs exposing (Msg(AddBallotToDemocracy, CreateBallot, MultiMsg, NavigateBack, NavigateTo, SetField, SetIntField))
import Result as Result


-- TODO: Add validation to all text fields etc.
-- TODO: Check that vote is not in the past


editBallotV : BallotId -> Model -> Html Msg
editBallotV ballotId model =
    let
        idG x =
            genNewId ballotId x

        nameId =
            idG 1

        descId =
            idG 2

        startId =
            idG 3

        finishId =
            idG 4

        numBallotOptionsId =
            idG 5

        ballotOptionId x =
            idG <| 6 + x * 3

        ballotOptionNameId x =
            idG <| 6 + x * 3 + 1

        ballotOptionDescId x =
            idG <| 6 + x * 3 + 2

        ballotOptionView x =
            div [ class "ba pa3 ma3" ]
                [ styled p [ Typo.subhead ] [ text <| "Option " ++ (toString <| x + 1) ]
                , textF (ballotOptionNameId x) "Name" [] model
                , textF (ballotOptionDescId x) "Description" [ Textf.textarea ] model
                ]

        numBallotOptions =
            List.range 0 <| getIntField numBallotOptionsId model + 1

        allBallotOptions =
            map ballotOptionView numBallotOptions

        newBallotOption id =
            BallotOption
                id
                (getField (ballotOptionNameId id) model)
                (getField (ballotOptionDescId id) model)
                Nothing

        newBallot =
            Ballot
                (getField nameId model)
                (getField descId model)
                (Result.withDefault 0 <| String.toFloat <| getField startId model)
                (Result.withDefault 0 <| String.toFloat <| getField finishId model)
                (map newBallotOption numBallotOptions)

        --        completeMsg =
        --            MultiMsg
        --                [ CreateBallot newBallot ballotId
        --                , AddBallotToDemocracy ballotId democracyId
        --                , NavigateTo <| "#/d/" ++ toString democracyId
        --                ]
        errorTimeFormat timeId =
            Textf.error "Please enter an Epoch time"
                |> Options.when
                    (case String.toInt (Dict.get timeId model.fields ? "0") of
                        Err err ->
                            True

                        Ok val ->
                            False
                    )

        removeDisabled =
            if getIntField numBallotOptionsId model < 1 then
                [ Disabled ]
            else
                []

        addBallotOption =
            SetIntField numBallotOptionsId <| getIntField numBallotOptionsId model + 1

        removeBallotOption =
            SetIntField numBallotOptionsId <| getIntField numBallotOptionsId model - 1
    in
    div [ class "pa4" ] <|
        [ styled p [ Typo.subhead ] [ text "Ballot Details:" ]
        , textF nameId "Name" [] model
        , textF descId "Description" [ Textf.textarea ] model
        , textF startId "Start Time" [ errorTimeFormat startId ] model
        , textF finishId "Finish Time" [ errorTimeFormat finishId ] model
        , styled p [ cs "mt4", Typo.subhead ] [ text "Ballot Options:" ]
        ]
            ++ allBallotOptions
            ++ [ btn 574567456755 model [ Icon, Attr (class "sv-button-large dib"), Click addBallotOption ] [ Icon.view "add_circle_outline" [ Icon.size36 ] ]
               , btn 347584445667 model ([ Icon, Attr (class "sv-button-large dib"), Click removeBallotOption ] ++ removeDisabled) [ Icon.view "remove_circle_outline" [ Icon.size36 ] ]
               , div [ class "mt4" ]
                    [ btn 97546756756 model [ SecBtn, Attr (class "ma3 dib"), Click NavigateBack ] [ text "Cancel" ]
                    , btn 85687456456 model [ PriBtn, Attr (class "ma3 dib"), Click NavigateBack ] [ text "Create" ]
                    ]
               ]


editBallotH : BallotId -> Model -> List (Html msg)
editBallotH ballotId model =
    let
        ballot =
            getBallot ballotId model
    in
    [ Layout.title [] [ text <| "Edit " ++ ballot.name ] ]
