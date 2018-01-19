module Views.VoteV exposing (..)

import Components.Icons exposing (IconSize(I24), mkIcon)
import Element exposing (button, column, el, html, row, text)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Helpers exposing (checkAlreadyVoted, genNewId, getBallot, getField, getFloatField, para, relativeTime)
import Html as H exposing (Html, div, input, p, span)
import Html.Attributes as HA exposing (style)
import Html.Events as HE
import Models exposing (Model)
import Models.Ballot exposing (BallotId, Vote, VoteOption)
import Msgs exposing (Msg(SetDialog, SetField, SetFloatField))
import Routes exposing (DialogRoute(BallotInfoD, BallotOptionD, VoteConfirmationD))
import Styles.StyleHelpers exposing (disabledBtnAttr)
import Styles.Styles exposing (SvClass(BtnS, DataParam, FooterText, InputS, NilS, SubSubH, VoteList))
import Styles.Swarm exposing (scaled)
import Views.ViewHelpers exposing (SvElement)


voteV : BallotId -> Model -> SvElement
voteV ballotId model =
    let
        ballot =
            getBallot ballotId model

        optionList =
            List.map optionListItem ballot.ballotOptions

        isFutureVote =
            model.now < ballot.start

        haveVoted =
            checkAlreadyVoted ballotId model

        sliderOptions =
            (++)
                [ HA.type_ "range"
                , HA.min "-3"
                , HA.max "3"
                , HA.step "1"
                , style [ ( "width", "100%" ), ( "background", "none" ) ]
                ]
            <|
                if isFutureVote || haveVoted then
                    [ HA.attribute "disabled" "disabled" ]
                else
                    []

        continueBtnOptions =
            if isFutureVote || haveVoted then
                disabledBtnAttr ++ []
            else
                []

        voteTime =
            if isFutureVote then
                "Vote opens in " ++ relativeTime ballot.start model
            else
                "Vote closes in " ++ relativeTime ballot.finish model

        sliderInputMsg id =
            String.toFloat >> Result.withDefault 0 >> SetFloatField id

        optionListItem { id, name, desc } =
            row VoteList
                [ spread, verticalCenter, padding (scaled 2), spacing (scaled 3) ]
                [ el NilS [ width <| fillPortion 1 ] <| para [] name
                , column NilS
                    [ center, spacing (scaled 1), width <| fillPortion 2 ]
                    [ text <| "Your vote: " ++ (toString <| getFloatField id model)
                    , row NilS
                        [ verticalCenter, spacing (scaled 2), width fill ]
                        [ mkIcon "minus" I24
                        , el InputS [ width fill, verticalCenter ] <|
                            html <|
                                input
                                    ([ HA.value <| toString <| getFloatField id model
                                     , HE.onInput <| sliderInputMsg id
                                     ]
                                        ++ sliderOptions
                                    )
                                    []
                        , mkIcon "plus" I24
                        ]
                    ]
                , button BtnS
                    [ onClick
                        (SetDialog (name ++ ": Details") (BallotOptionD desc))
                    , padding (scaled 1)
                    , class "btn-secondary btn-outer--small"
                    , width <| fillPortion 1
                    ]
                    (text "Details")
                ]

        newVoteOption { id } =
            VoteOption id <| getFloatField id model

        newVote =
            Vote ballotId <| List.map newVoteOption ballot.ballotOptions

        newVoteId =
            genNewId ballotId <| Result.withDefault 0 <| String.toInt <| List.foldl (++) "" <| List.map toString <| List.map genNonce newVote.voteOptions

        genNonce { value } =
            value
    in
    column NilS
        []
        [ column NilS
            []
            [ el SubSubH [ paddingBottom (scaled 1) ] (text "Ballot Description")
            , para [] ballot.desc
            ]
        , el FooterText [ alignRight ] (text voteTime)
        , column NilS [ padding (scaled 3) ] optionList
        , button BtnS ([ onClick (SetDialog "Confirmation" (VoteConfirmationD newVote newVoteId)), padding (scaled 1), maxWidth (px 840), center, class "btn" ] ++ continueBtnOptions) (text "Continue")
        ]


voteH : BallotId -> Model -> ( List SvElement, List SvElement, List SvElement )
voteH id model =
    let
        ballot =
            getBallot id model

        clickMsg =
            SetDialog "Ballot Info" <| BallotInfoD ballot.desc
    in
    ( []
    , [ text ballot.name ]
    , [ el NilS
            [ onClick clickMsg, padding (scaled 1) ]
        <|
            mkIcon "information-outline" I24
      ]
    )
