module Views.VoteV exposing (..)

import Components.Btn exposing (BtnProps(Click, Disabled, PriBtn, SecBtn, Small, VSmall, Warning), btn)
import Components.Icons exposing (IconSize(I24), mkIcon)
import Components.Navigation exposing (NavMsg(..))
import Components.Slider exposing (slider)
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (card, checkAlreadyVoted, genNewId, getBallot, getField, getFloatField, para, relativeTime)
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Models exposing (Model)
import Models.Ballot exposing (Ballot, BallotId, BallotOption)
import Models.Vote exposing (VoteState(VoteInitial))
import Msgs exposing (..)
import Routes exposing (DialogRoute(BallotDeleteConfirmD, BallotInfoD, BallotOptionD, HowToVoteD, VoteConfirmationD), Route(EditBallotR))
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation(BoldT, NBad, NGood, SliderGreen, SliderRed))
import Views.EditBallotV exposing (populateFromModel)
import Views.ViewHelpers exposing (SvElement, SvHeader, SvView)


voteV : BallotId -> Model -> SvView
voteV ballotId model =
    let
        ballot =
            getBallot ballotId model
    in
    ( admin ballotId ballot model
    , header ballot
    , body ballotId ballot model
    )



-- TODO: Only show admin box when admin flag is true


admin : BallotId -> Ballot -> Model -> SvElement
admin ballotId ballot model =
    let
        isFutureVote =
            model.now < ballot.start

        editMsg =
            MultiMsg
                [ populateFromModel ( ballotId, ballot ) model
                , Nav <| NTo <| EditBallotR ballotId
                ]
    in
    card <|
        column AdminBoxS
            [ spacing (scaled 1), padding (scaled 2) ]
            [ el SubH [] (text "Ballot Admin")
            , para [ width (percent 40) ] "As an administrator you can edit your ballot before it goes live, or cancel it completetly using the big red button."
            , row NilS
                [ spacing (scaled 2) ]
                [ btn [ PriBtn, Small, Click editMsg, Disabled (not isFutureVote) ] (text "Edit ballot")
                , btn [ PriBtn, Warning, Small, Click (SetDialog "Ballot Deletion Confirmation" (BallotDeleteConfirmD ballotId)) ] (text "Remove ballot")
                ]
            ]


header : Ballot -> SvHeader
header ballot =
    ( []
    , [ text "View Proposal" ]
    , [ btn [ Click (SetDialog "How to Vote" HowToVoteD) ] (mkIcon "help-circle-outline" I24)
      ]
    )


body : BallotId -> Ballot -> Model -> SvElement
body ballotId ballot model =
    let
        isFutureVote =
            model.now < ballot.start

        haveVoted =
            checkAlreadyVoted ballotId model

        isDisabled =
            isFutureVote || haveVoted

        voteTime =
            if isFutureVote then
                relativeTime ballot.start model
            else
                relativeTime ballot.finish model

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
                    para [ vary BoldT True ] ("This proposal is currently open and will remain open for " ++ voteTime)
                )
    in
    card <|
        column NilS
            []
        <|
            [ column VoteList
                [ spacing (scaled 2), padding (scaled 2) ]
                [ el SubH [] (text "Proposal Description")
                , para [] ballot.desc
                , statusNotify
                ]
            ]
                ++ List.indexedMap (optionListItem model isDisabled) ballot.ballotOptions
                ++ [ confirmationButton ballotId model
                   ]


voteOptionSliderId : Int -> String
voteOptionSliderId id =
    "vote-option-slider-" ++ toString id


getSliderValue : Int -> Model -> Float
getSliderValue id model =
    getFloatField (voteOptionSliderId id) model


optionListItem : Model -> Bool -> Int -> BallotOption -> SvElement
optionListItem model isDisabled index { id, name, desc } =
    let
        {- TODO: Why is this a string?? -}
        sliderInputMsg =
            String.toFloat >> Result.withDefault 0 >> SFloat (voteOptionSliderId id) >> SetField

        voteRangeReduce =
            let
                newVal =
                    max (getSliderValue id model - 1) -3
            in
            sliderInputMsg <| toString newVal

        voteRangeIncrease =
            let
                newVal =
                    min (getSliderValue id model + 1) 3
            in
            sliderInputMsg <| toString newVal

        value =
            getSliderValue id model

        sliderCol id =
            column NilS
                [ center, spacing (scaled 1), paddingXY (scaled 4) 0 ]
                [ row NilS
                    [ verticalCenter, spacing (scaled 4), width fill ]
                    [ btn [ PriBtn, VSmall, Click <| voteRangeReduce, Disabled isDisabled ] <| mkIcon "minus" I24
                    , slider model sliderInputMsg isDisabled value
                    , btn [ PriBtn, VSmall, Click <| voteRangeIncrease, Disabled isDisabled ] <| mkIcon "plus" I24
                    ]
                ]
    in
    column VoteList
        [ padding (scaled 4), spacing (scaled 2) ]
        [ el SubSubH [] <| para [] <| (toString <| index + 1) ++ ". " ++ name
        , para [] desc
        , sliderCol id
        ]


confirmationButton : BallotId -> Model -> SvElement
confirmationButton ballotId model =
    let
        ballot =
            getBallot ballotId model

        isFutureVote =
            model.now < ballot.start

        haveVoted =
            checkAlreadyVoted ballotId model

        newVoteOption { id } =
            { id = id
            , value = getSliderValue id model
            }

        newVote =
            { ballotId = ballotId
            , voteOptions = List.map newVoteOption ballot.ballotOptions
            , state = VoteInitial
            }

        newVoteId =
            genNewId ballotId <| Result.withDefault 0 <| String.toInt <| List.foldl (++) "" <| List.map toString <| List.map genNonce newVote.voteOptions

        genNonce { value } =
            value
    in
    column NilS
        [ padding (scaled 2), spacing (scaled 2) ]
        [ el SubH [] (text "Complete")
        , para [] "Once you have completed the options above, select continue to review your selections and submit your vote."
        , btn [ PriBtn, Click (SetDialog "Confirmation" (VoteConfirmationD ( newVoteId, newVote ))), Disabled (isFutureVote || haveVoted) ] (text "Continue")
        ]
