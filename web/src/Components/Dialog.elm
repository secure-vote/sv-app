module Components.Dialog exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.Icons exposing (IconSize(I24), mkIcon)
import Element exposing (button, column, el, row, text, within)
import Element.Attributes exposing (alignRight, center, fill, height, minWidth, padding, percent, spacing, spread, verticalCenter, width)
import Element.Events exposing (onClick)
import Html as H exposing (Html, div, h1, h3)
import Html.Attributes exposing (class, style)
import Models exposing (Model)
import Msgs exposing (Msg(HideDialog))
import Routes exposing (DialogRoute(..))
import Styles.Styles exposing (SvClass(DialogBackdrop, DialogStyle, Error, Heading, NilS, SubH))
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

                MemberInviteD ->
                    memberInviteDialogV model

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



--            []
--            []
--            div
--            [ style
--                [ ( "width", "100%" )
--                , ( "height", "100%" )
--                , ( "position", "absolute" )
--                , ( "background-color", "rgba(10,10,10,0.5)" )
--                , ( "z-index", "10000" )
--                , ( "pointer-events", "all" )
--                , ( "box-shadow", "0 0 10px 10px rgba(10,10,10,0.5)" )
--                ]
--            ]
--            [ div
--                [ style
--                    [ ( "margin", "auto" )
--                    , ( "width", "50%" )
--                    , ( "height", "50%" )
--                    , ( "position", "absolute" )
--                    , ( "z-index", "11000" )
--                    , ( "top", "0" )
--                    , ( "right", "0" )
--                    , ( "bottom", "0" )
--                    , ( "left", "0" )
--                    , ( "padding", "1rem" )
--                    , ( "background", "white" )
--                    , ( "box-shadow", "0 9px 46px 8px rgba(0,0,0,.14), 0 11px 15px -7px rgba(0,0,0,.12), 0 24px 38px 3px rgba(0,0,0,.2)" )
--                    ]
--                ]
--                [ H.text "Test" ]
--            ]
--    Dialog.view
--        [ cs "w-80 w-70-l"
--        , cs "overflow-scroll"
--        , css "max-height" "80%"
--        , Options.id "dialog-container"
--        ]
--        [ Dialog.title
--            [ cs "" ]
--            [ div []
--                [ h3 [ class "mv0 dib" ] [ text model.dialogHtml.title ]
--                , btn 384394893 model [ Icon, CloseDialog, Attr (class "fr") ] [ MIcon.view "close" [ MIcon.size24 ] ]
--                ]
--            ]
--        , Dialog.content
--            [ cs "overflow-y-scroll db" ]
--            [ div
--                [ class "db " ]
--                [ innerHtml ]
--            ]
--        ]
