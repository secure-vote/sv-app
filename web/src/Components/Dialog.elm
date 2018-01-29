module Components.Dialog exposing (..)

import Components.Icons exposing (IconSize(I24), mkIcon)
import Element exposing (button, column, el, row, text, within)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Helpers exposing (para)
import Models exposing (Model)
import Msgs exposing (Msg(HideDialog), VoteConfirmState(..))
import Routes exposing (DialogRoute(..))
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Views.DialogV exposing (..)
import Views.ViewHelpers exposing (SvElement)


-- TODO: as a component this should not have views in the code.


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

                HowToVoteD ->
                    howToVoteV

                --              Not in use
                --                MemberInviteD ->
                --                    memberInviteDialogV model
                NotFoundD ->
                    el Error [] (text "Not Found")

        closeButton =
            if model.voteConfirmStatus == Processing || model.voteConfirmStatus == Validating then
                []
            else
                [ button NilS [ onClick HideDialog ] (mkIcon "close" I24) ]
    in
    el DialogBackdrop [ width fill, height fill ] <|
        el DialogStyle [ center, verticalCenter, maxWidth <| px 600 ] <|
            column NilS
                [ padding (scaled 2), spacing (scaled 2) ]
                [ row SubH
                    [ spacing (scaled 3), spread ]
                  <|
                    [ para [] model.dialogHtml.title
                    ]
                        ++ closeButton
                , innerElement
                ]
