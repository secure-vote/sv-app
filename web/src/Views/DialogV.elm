module Views.DialogV exposing (..)

import Color
import Components.Icons exposing (IconSize(I48), mkIcon)
import Element exposing (button, column, el, html, paragraph, row, table, text)
import Element.Attributes exposing (alignRight, center, class, height, padding, px, spacing)
import Element.Events exposing (onClick)
import Helpers exposing (findDemocracy, getBallot, getFloatField, para)
import List exposing (map)
import Models exposing (Model)
import Models.Ballot exposing (BallotId, Vote, VoteConfirmStatus(..), VoteId)
import Msgs exposing (Msg(CreateVote, DeleteBallot, HideDialog, Mdl, MultiMsg, NavigateBack, NavigateBackTo, SetVoteConfirmStatus, ShowToast, ToggleBoolField))
import Routes exposing (Route(DemocracyR))
import Styles.Styles exposing (SvClass(Heading, NilS, SubH, SubSubH))
import Styles.Swarm exposing (scaled)
import Views.ViewHelpers exposing (SvElement, cssSpinner)


subhead : String -> SvElement
subhead s =
    el SubH [] (text s)


subsubhead : String -> SvElement
subsubhead s =
    el SubSubH [] (text s)


voteConfirmDialogV : Vote -> VoteId -> Model -> SvElement
voteConfirmDialogV vote voteId model =
    let
        ballot =
            getBallot vote.ballotId model

        democracyId =
            Tuple.first <| findDemocracy vote.ballotId model

        createVoteMsg =
            MultiMsg
                [ CreateVote vote voteId
                , SetVoteConfirmStatus Processing
                ]

        completeMsg =
            MultiMsg
                [ NavigateBackTo <| DemocracyR democracyId
                , SetVoteConfirmStatus AwaitingConfirmation
                , HideDialog
                ]
    in
    column NilS [ spacing (scaled 2) ] <|
        case model.voteConfirmStatus of
            AwaitingConfirmation ->
                let
                    names item =
                        para [] item.name

                    values item =
                        para [] <| toString <| getFloatField item.id model
                in
                [ para [] "Please confirm that your vote details below are correct."
                , table NilS [ spacing (scaled 2), padding (scaled 2) ] <| [ map names ballot.ballotOptions, map values ballot.ballotOptions ]
                , row NilS
                    [ spacing (scaled 2) ]
                    [ button NilS [ onClick HideDialog, padding (scaled 1), class "btn-secondary" ] (text "Close")
                    , button NilS [ onClick createVoteMsg, padding (scaled 1), class "btn" ] (text "Yes")
                    ]
                ]

            Processing ->
                [ el NilS [ center ] (para [] "Processing...")
                , el NilS [] <| cssSpinner
                ]

            Validating ->
                [ el NilS [ center ] (para [] "Validating...")
                , el NilS [] <| cssSpinner
                ]

            Complete ->
                [ el NilS [ center ] (para [] "Your vote has been cast successfully!")
                , el Heading [ center ] (mkIcon "check-circle-outline" I48)
                , el NilS [] <|
                    button NilS [ onClick completeMsg, padding (scaled 1), class "btn" ] (text "Close")
                ]


ballotDeleteConfirmDialogV : BallotId -> Model -> SvElement
ballotDeleteConfirmDialogV ballotId model =
    let
        ballot =
            getBallot ballotId model

        democracyId =
            Tuple.first <| findDemocracy ballotId model

        completeMsg =
            MultiMsg
                [ DeleteBallot ballotId
                , NavigateBackTo <| DemocracyR democracyId
                , ShowToast <| ballot.name ++ " has been deleted"
                , HideDialog
                ]
    in
    column NilS
        []
        [ para [] <| "Are you sure you want to delete " ++ ballot.name
        , row NilS
            [ alignRight ]
            [ button NilS [ onClick HideDialog, padding (scaled 1), class "btn-secondary" ] (text "Cancel")
            , button NilS [ onClick completeMsg, padding (scaled 1), class "btn" ] (text "Delete")
            ]
        ]


ballotInfoDialogV : String -> SvElement
ballotInfoDialogV desc =
    column NilS [] [ para [] desc ]


ballotOptionDialogV : String -> SvElement
ballotOptionDialogV desc =
    para [] desc


democracyInfoDialogV : String -> SvElement
democracyInfoDialogV desc =
    para [] desc


userInfoDialogV : Model -> SvElement
userInfoDialogV model =
    para [] "Lorem Ipsum"



--    Deprecated
--    el NilS [] <|
--        html <|
--            Toggles.switch Mdl
--                [ adminToggleId ]
--                model.mdl
--                [ Options.onToggle <| ToggleBoolField adminToggleId
--                , Toggles.ripple
--                , Toggles.value <| getAdminToggle model
--                ]
--                [ H.text "Admin User" ]
-- Not in use
--memberInviteDialogV : Model -> SvElement
--memberInviteDialogV model =
--    column NilS
--        []
--        [ text "Invite via email"
--        , html <| textF 788765454534 "Seperate addresses with a coma" [] model
--        , text "Or Upload a CSV"
--        , html <| btn 4356373453 model [ SecBtn, Attr (HA.class "db") ] [ H.text "Choose a file" ]
--        ]
