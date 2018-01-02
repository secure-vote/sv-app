module Components.Dialog exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Html exposing (Html, div, h1, h3, text)
import Html.Attributes exposing (class)
import Material.Dialog as Dialog
import Material.Icon as MIcon
import Material.Options as Options exposing (cs, css)
import Models exposing (Model)
import Msgs exposing (Msg)
import Routes exposing (DialogRoute(..))
import Views.DialogV exposing (..)


dialog : Model -> Html Msg
dialog model =
    let
        innerHtml =
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

                MemberInviteD ->
                    memberInviteDialogV model

                NotFoundD ->
                    h1 [ class "red" ] [ text "Not Found" ]
    in
    Dialog.view
        [ cs "w-80 w-70-l"
        , cs "overflow-scroll"
        , css "max-height" "80%"
        , Options.id "dialog-container"
        ]
        [ Dialog.title
            [ cs "" ]
            [ div []
                [ h3 [ class "mv0 dib" ] [ text model.dialogHtml.title ]
                , btn 384394893 model [ Icon, CloseDialog, Attr (class "fr") ] [ MIcon.view "close" [ MIcon.size24 ] ]
                ]
            ]
        , Dialog.content
            [ cs "overflow-y-scroll db" ]
            [ div
                [ class "db " ]
                [ innerHtml ]
            ]
        ]
