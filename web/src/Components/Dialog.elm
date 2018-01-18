module Components.Dialog exposing (..)

import Components.Icons exposing (IconSize(I24), mkIcon)
import Element exposing (button, column, el, row, text, within)
import Element.Attributes exposing (alignRight, center, class, fill, height, minWidth, padding, percent, spacing, spread, verticalCenter, width)
import Element.Events exposing (onClick)
import Models exposing (Model)
import Msgs exposing (Msg(HideDialog))
import Routes exposing (DialogRoute(..))
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Views.DialogV exposing (..)
import Views.ViewHelpers exposing (SvElement)


dialog : Model -> SvElement
dialog model =
    let
        innerElement =
            case model.dialogHtml.route of
                VoteConfirmationD vote voteId ->
                    voteConfirmDialogV vote voteId model

                BallotDeleteConfirmD ballotId ->
                    ballotDeleteConfirmDialogV ballotId model

                BallotInfoD desc ->
                    ballotInfoDialogV desc

                BallotOptionD desc ->
                    ballotOptionDialogV desc

                DemocracyInfoD desc ->
                    democracyInfoDialogV desc

                UserInfoD ->
                    userInfoDialogV model

                --              Not in use
                --                MemberInviteD ->
                --                    memberInviteDialogV model
                NotFoundD ->
                    el Error [] (text "Not Found")
    in
    el DialogBackdrop [ width fill, height fill ] <|
        el DialogStyle [ center, verticalCenter ] <|
            column NilS
                [ padding (scaled 2), spacing (scaled 2) ]
                [ row SubH
                    [ spacing (scaled 3), spread ]
                    [ text model.dialogHtml.title
                    , button NilS [ onClick HideDialog ] (mkIcon "close" I24)
                    ]
                , innerElement
                ]
