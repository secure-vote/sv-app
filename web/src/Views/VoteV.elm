module Views.VoteV exposing (..)

import Components.Icons exposing (IconSize(I24), mkIcon)
import Element exposing (button, column, el, html, row, text)
import Element.Attributes exposing (alignRight, attribute, center, class, fill, maxWidth, padding, percent, spacing, spread, verticalCenter, width)
import Element.Events exposing (onClick)
import Helpers exposing (genNewId, getBallot, getField, getFloatField, relativeTime)
import Html as H exposing (Html, div, input, p, span)
import Html.Attributes as HA exposing (style)
import Html.Events as HE
import Models exposing (Model)
import Models.Ballot exposing (BallotId, Vote, VoteOption)
import Msgs exposing (Msg(SetDialog, SetField, SetFloatField))
import Routes exposing (DialogRoute(BallotInfoD, BallotOptionD, VoteConfirmationD))
import Styles.Styles exposing (SvClass(FooterText, InputS, NilS, VoteList))
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

        sliderOptions =
            if isFutureVote then
                [ HA.attribute "disabled" "disabled" ]
            else
                []

        continueBtnOptions =
            if isFutureVote then
                [ attribute "disabled" "disabled" ]
            else
                []

        voteTime =
            if isFutureVote then
                "Vote opens in " ++ relativeTime ballot.start model
            else
                "Vote closes in " ++ relativeTime ballot.finish model

        optionListItem { id, name, desc } =
            row VoteList
                [ spread, verticalCenter, padding (scaled 2), spacing (scaled 3) ]
                [ text name
                , column NilS
                    [ center, spacing (scaled 1), width fill, maxWidth (percent 40) ]
                    [ text <| "Your vote: " ++ (toString <| getFloatField id model)
                    , row NilS
                        [ verticalCenter, spacing (scaled 2), width fill ]
                        [ mkIcon "minus" I24
                        , el InputS [ width fill, verticalCenter ] <|
                            html <|
                                input
                                    ([ HA.type_ "range"
                                     , HA.min "-3"
                                     , HA.max "3"
                                     , HA.step "1"
                                     , HA.value <| toString <| getFloatField id model
                                     , HE.onInput <| (String.toFloat >> Result.withDefault 0 >> SetFloatField id)
                                     , style [ ( "width", "100%" ) ]
                                     ]
                                        ++ sliderOptions
                                    )
                                    []
                        , mkIcon "plus" I24
                        ]
                    ]
                , button NilS [ onClick (SetDialog (name ++ ": Details") (BallotOptionD desc)), padding (scaled 1), class "btn-secondary btn-outer--small" ] (text "Details")
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
        [ text ballot.desc
        , el FooterText [ alignRight ] (text voteTime)
        , column NilS [ padding (scaled 3) ] optionList
        , button NilS ([ onClick (SetDialog "Confirmation" (VoteConfirmationD newVote newVoteId)), padding (scaled 1), class "btn" ] ++ continueBtnOptions) (text "Continue")
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
    , [ el NilS [ onClick clickMsg, padding (scaled 1) ] <| mkIcon "information-outline" I24 ]
    )
