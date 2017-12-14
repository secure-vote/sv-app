module Views.CreateVoteV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.TextF exposing (textF)
import Dict
import Helpers exposing (genNewId, getDemocracy, getField)
import Html exposing (Html, div, hr, p, span, text)
import Html.Attributes exposing (class)
import List exposing (map, map2)
import Material.Layout as Layout
import Material.Options as Options exposing (cs, styled)
import Material.Textfield as Textf
import Material.Typography as Typo
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Models.Ballot exposing (Ballot, BallotId, BallotOption)
import Models.Democracy exposing (DemocracyId)
import Msgs exposing (Msg(AddBallotToDemocracy, CreateBallot, Mdl, MultiMsg, NavigateBack, NavigateTo, SetField))
import Result as Result


-- TODO: Add validation to all text fields etc.
-- TODO: Check that vote is not in the past


createVoteV : DemocracyId -> Model -> Html Msg
createVoteV democracyId model =
    let
        democracy =
            getDemocracy democracyId model

        ballotId =
            genNewId democracyId <| List.length democracy.ballots

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

        voteOptionId x =
            idG (1327 + x * 23)

        voteOptionNameId x =
            voteOptionId x + 1 * 857

        voteOptionDescId x =
            voteOptionId x + 2 * 857

        ballotOptions =
            [ 1, 2 ]

        voteOption id num =
            div [ class "ba pa3 ma3" ]
                [ styled p [ Typo.subhead ] [ text <| "Option " ++ toString num ]
                , textF (voteOptionNameId id) "Name" [] model
                , textF (voteOptionDescId id) "Description" [ Textf.textarea ] model
                ]

        -- TODO: Dynamically load number of options
        allVoteOptions =
            map2 voteOption (map voteOptionId ballotOptions) ballotOptions

        ballotOption id =
            BallotOption
                id
                (getField (voteOptionNameId id) model)
                (getField (voteOptionDescId id) model)
                Nothing

        ballot =
            Ballot
                (getField nameId model)
                (getField descId model)
                (Result.withDefault 0 <| String.toFloat <| getField startId model)
                (Result.withDefault 0 <| String.toFloat <| getField finishId model)
                (map ballotOption <| map voteOptionId ballotOptions)

        completeMsg =
            MultiMsg
                [ CreateBallot ballot ballotId
                , AddBallotToDemocracy ballotId democracyId
                , NavigateTo <| "#/d/" ++ toString democracyId
                ]

        errorTimeFormat timeId =
            Textf.error "Please enter an Epoch time"
                |> Options.when
                    (case String.toInt (Dict.get timeId model.fields ? "0") of
                        Err err ->
                            True

                        Ok val ->
                            False
                    )
    in
    div [ class "pa4" ] <|
        [ styled p [ Typo.subhead ] [ text "Vote Details:" ]
        , textF nameId "Name" [] model
        , textF descId "Description" [ Textf.textarea ] model
        , textF startId "Start Time" [ errorTimeFormat startId ] model
        , textF finishId "Finish Time" [ errorTimeFormat finishId ] model
        , styled p [ cs "mt4", Typo.subhead ] [ text "Vote Options:" ]
        ]
            ++ allVoteOptions
            ++ [ div [ class "mt4" ]
                    [ btn 97546756756 model [ SecBtn, Attr (class "ma3 dib"), Click NavigateBack ] [ text "Cancel" ]
                    , btn 85687456456 model [ PriBtn, Attr (class "ma3 dib"), Click completeMsg ] [ text "Create" ]
                    ]
               ]


createVoteH : DemocracyId -> Model -> List (Html msg)
createVoteH democracyId model =
    [ Layout.title [] [ text <| "Create a new vote for " ++ (getDemocracy democracyId model).name ] ]
