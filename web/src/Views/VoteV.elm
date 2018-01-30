module Views.VoteV exposing (..)

import Components.Btn exposing (BtnProps(Click, Disabled, PriBtn, SecBtn, Small, Warning), btn)
import Components.Icons exposing (IconSize(I24), mkIcon)
import Element exposing (button, column, el, empty, html, row, text)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Helpers exposing (checkAlreadyVoted, genNewId, getBallot, getField, getFloatField, para, relativeTime)
import Html as H exposing (Html, div, input, p, span)
import Html.Attributes as HA exposing (style)
import Html.Events as HE
import Models exposing (Model)
import Models.Ballot exposing (Ballot, BallotId, Vote, VoteOption)
import Msgs exposing (Msg(NoOp, SetDialog, SetField, SetFloatField))
import Routes exposing (DialogRoute(BallotDeleteConfirmD, BallotInfoD, BallotOptionD, HowToVoteD, VoteConfirmationD))
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation(NBad, NGood))
import Views.ViewHelpers exposing (SvElement, SvHeader, SvView)


voteV : BallotId -> Model -> SvView
voteV ballotId model =
    let
        ballot =
            getBallot ballotId model
    in
    ( admin ballotId
    , header ballot
    , body ballotId model
    )



-- TODO: Only show admin box when admin flag is true


admin : BallotId -> SvElement
admin ballotId =
    column AdminBoxS
        [ spacing (scaled 1), padding (scaled 4) ]
        [ el SubH [] (text "Ballot Admin")
        , para [ width (percent 40) ] "As an administrator you can edit your ballot before it goes live, or cancel it completetly using the big red button."
        , row NilS
            [ spacing (scaled 2) ]
            [ btn [ PriBtn, Small ] (text "Edit ballot")
            , btn [ PriBtn, Warning, Small, Click (SetDialog "Ballot Deletion Confirmation" (BallotDeleteConfirmD ballotId)) ] (text "Remove ballot")
            ]
        ]


header : Ballot -> SvHeader
header ballot =
    ( []
    , [ text ballot.name ]
    , [ btn [ Click (SetDialog "Ballot Info" (BallotInfoD ballot.desc)) ] (mkIcon "information-outline" I24)
      , btn [ Click (SetDialog "How to Vote" HowToVoteD) ] (mkIcon "help-circle-outline" I24)
      ]
    )


body : BallotId -> Model -> SvElement
body ballotId model =
    let
        ballot =
            getBallot ballotId model

        isFutureVote =
            model.now < ballot.start

        haveVoted =
            checkAlreadyVoted ballotId model

        voteTime =
            if isFutureVote then
                "Vote opens in " ++ relativeTime ballot.start model
            else
                "Vote closes in " ++ relativeTime ballot.finish model

        {- TODO: Refactor the below to use a component instead of duplicating code -}
        statusNotifyAlreadyVoted =
            el Notify [ vary NGood True, padding 10 ] (para [] "You've already voted on this ballot.")

        statusNotifyNotLive =
            el Notify [ vary NBad True, padding 10 ] (para [] "This ballot is not yet live.")

        statusNotify =
            el SubSubH
                [ width fill, paddingBottom 10 ]
                (if haveVoted then
                    statusNotifyAlreadyVoted
                 else if isFutureVote then
                    statusNotifyNotLive
                 else
                    empty
                )
    in
    column NilS
        []
        [ column NilS
            []
            [ statusNotify
            , el SubSubH [ paddingBottom (scaled 1) ] (text "Ballot Description")
            , para [] ballot.desc
            ]
        , el FooterText [ alignRight ] (text voteTime)
        , column NilS [ padding (scaled 3) ] (optionList ballotId model)
        , confirmationButton ballotId model
        ]


voteOptionSliderId : Int -> String
voteOptionSliderId id =
    "vote-option-slider-" ++ toString id


getSliderValue : Int -> Model -> Float
getSliderValue id model =
    getFloatField (voteOptionSliderId id) model


optionList : BallotId -> Model -> List SvElement
optionList ballotId model =
    let
        ballot =
            getBallot ballotId model

        isFutureVote =
            model.now < ballot.start

        haveVoted =
            checkAlreadyVoted ballotId model

        {- TODO: Why is this a string?? -}
        sliderInputMsg id =
            String.toFloat >> Result.withDefault 0 >> SetFloatField (voteOptionSliderId id)

        sliderAlterMsg id newVal =
            if isFutureVote || haveVoted then
                NoOp
            else
                sliderInputMsg id newVal

        voteRangeReduce id =
            let
                newVal =
                    max (getSliderValue id model - 1) -3
            in
            onClick <| sliderAlterMsg id <| toString newVal

        voteRangeIncrease id =
            let
                newVal =
                    min (getSliderValue id model + 1) 3
            in
            onClick <| sliderAlterMsg id <| toString newVal

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

        htmlSlider id =
            el InputS [ width fill, verticalCenter ] <|
                html <|
                    input
                        (sliderOptions
                            ++ [ HA.value <| toString <| getSliderValue id model
                               , HE.onInput <| sliderInputMsg id
                               ]
                        )
                        []

        sliderCol id =
            column NilS
                [ center, spacing (scaled 1), width <| fillPortion 2 ]
                [ text <| "Your vote: " ++ (toString <| getSliderValue id model)
                , row NilS
                    [ verticalCenter, spacing (scaled 2), width fill ]
                    [ el NilS [ voteRangeReduce id ] <| mkIcon "minus" I24
                    , htmlSlider id
                    , el NilS [ voteRangeIncrease id ] <| mkIcon "plus" I24
                    ]
                ]

        optionListItem { id, name, desc } =
            row VoteList
                [ verticalCenter, padding (scaled 2), spacing (scaled 3) ]
                [ el NilS [ width <| fillPortion 1 ] <| para [] name
                , sliderCol id
                , btn [ SecBtn, Small, Click (SetDialog (name ++ ": Details") (BallotOptionD desc)) ] (text "Details")
                ]
    in
    List.map optionListItem ballot.ballotOptions


confirmationButton : BallotId -> Model -> SvElement
confirmationButton ballotId model =
    let
        ballot =
            getBallot ballotId model

        isFutureVote =
            model.now < ballot.start

        haveVoted =
            checkAlreadyVoted ballotId model

        continueBtnOptions =
            if isFutureVote || haveVoted then
                [ Disabled ]
            else
                []

        newVoteOption { id } =
            VoteOption id <| getSliderValue id model

        newVote =
            Vote ballotId <| List.map newVoteOption ballot.ballotOptions

        newVoteId =
            genNewId ballotId <| Result.withDefault 0 <| String.toInt <| List.foldl (++) "" <| List.map toString <| List.map genNonce newVote.voteOptions

        genNonce { value } =
            value
    in
    btn ([ PriBtn, Click (SetDialog "Confirmation" (VoteConfirmationD newVote newVoteId)) ] ++ continueBtnOptions) (text "Continue")
