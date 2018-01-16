module Views.DialogV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.Icons exposing (IconSize(I48), mkIcon)
import Components.LoadingSpinner exposing (spinner)
import Components.TextF exposing (textF)
import Element exposing (button, column, el, html, row, table, text)
import Element.Attributes exposing (alignRight, center, padding, spacing)
import Element.Events exposing (onClick)
import Helpers exposing (findDemocracy, getAdminToggle, getBallot, getFloatField)
import Html as H exposing (Html, div, h2, h3, p, td, tr)
import Html.Attributes exposing (class)
import List exposing (map)
import Material.Options as Options
import Material.Toggles as Toggles
import Models exposing (Model, adminToggleId)
import Models.Ballot exposing (BallotId, Vote, VoteConfirmStatus(..), VoteId)
import Msgs exposing (Msg(CreateVote, DeleteBallot, HideDialog, Mdl, MultiMsg, NavigateBack, NavigateBackTo, SetVoteConfirmStatus, ShowToast, ToggleBoolField))
import Routes exposing (Route(DemocracyR))
import Styles.Styles exposing (SvClass(Heading, NilS, SubH, SubSubH))
import Styles.Swarm exposing (scaled)
import Views.ViewHelpers exposing (SvElement)


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
                        text item.name

                    values item =
                        text <| toString <| getFloatField item.id model
                in
                [ text "Please confirm that your vote details below are correct."
                , table NilS [ spacing (scaled 2), padding (scaled 2) ] <| [ map names ballot.ballotOptions, map values ballot.ballotOptions ]
                , row NilS
                    [ alignRight, spacing (scaled 2) ]
                    [ button NilS [ onClick HideDialog ] (text "Close")
                    , button NilS [ onClick createVoteMsg ] (text "Yes")
                    ]
                ]

            Processing ->
                [ el NilS [ center ] (text "Processing...")

                --                , html spinner
                ]

            Validating ->
                [ el NilS [ center ] (text "Validating...")

                --                , html spinner
                ]

            Complete ->
                [ el NilS [ center ] (text "Your vote has been cast successfully!")
                , el Heading [ center ] (mkIcon "check-circle-outline" I48)
                , el NilS [ alignRight ] <|
                    button NilS [ onClick completeMsg ] (text "Close")
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
                ]
    in
    column NilS
        []
        [ text <| "Are you sure you want to delete " ++ ballot.name
        , row NilS
            [ alignRight ]
            [ html <| btn 976565675 model [ SecBtn, CloseDialog, Attr (class "ma2 dib") ] [ H.text "Cancel" ]
            , html <| btn 463467465 model [ SecBtn, CloseDialog, Attr (class "ma2 dib btn-warning"), Click completeMsg ] [ H.text "Delete" ]
            ]
        ]


ballotInfoDialogV : String -> SvElement
ballotInfoDialogV desc =
    text desc


ballotOptionDialogV : String -> SvElement
ballotOptionDialogV desc =
    text desc


democracyInfoDialogV : String -> SvElement
democracyInfoDialogV desc =
    text desc


userInfoDialogV : Model -> SvElement
userInfoDialogV model =
    el NilS [] <|
        html <|
            Toggles.switch Mdl
                [ adminToggleId ]
                model.mdl
                [ Options.onToggle <| ToggleBoolField adminToggleId
                , Toggles.ripple
                , Toggles.value <| getAdminToggle model
                ]
                [ H.text "Admin User" ]


memberInviteDialogV : Model -> SvElement
memberInviteDialogV model =
    column NilS
        []
        [ text "Invite via email"
        , html <| textF 788765454534 "Seperate addresses with a coma" [] model
        , text "Or Upload a CSV"
        , html <| btn 4356373453 model [ SecBtn, Attr (class "db") ] [ H.text "Choose a file" ]
        ]
