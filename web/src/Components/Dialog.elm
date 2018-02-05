module Components.Dialog exposing (..)

import Components.Btn exposing (BtnProps(Attr, Click), btn)
import Components.Icons exposing (IconSize(I24), mkIcon)
import Element exposing (..)
import Element.Attributes exposing (..)
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
                VoteConfirmationD ( voteId, vote ) ->
                    voteConfirmDialogV ( voteId, vote ) model

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
                [ btn [ Click HideDialog, Attr alignRight ] (mkIcon "close" I24) ]
    in
    el DialogBackdrop [ width fill, height fill ] <|
        el DialogStyle [ center, verticalCenter, maxWidth <| px 600 ] <|
            (column NilS
                [ padding (scaled 4), spacing (scaled 2) ]
                [ el SubH [] (para [] model.dialogHtml.title)
                , innerElement
                ]
                |> within closeButton
            )
