module Views.VoteV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Element exposing (column, el, html, row, text)
import Element.Attributes exposing (alignRight, center, padding, spacing, spread, verticalCenter)
import Helpers exposing (genNewId, getBallot, getFloatField, readableTime)
import Html as H exposing (Html, div, p, span)
import Html.Attributes exposing (class, style)
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options exposing (cs, styled)
import Material.Slider as Slider
import Material.Typography as Typo
import Models exposing (Model)
import Models.Ballot exposing (BallotId, Vote, VoteOption)
import Msgs exposing (Msg(SetDialog, SetFloatField))
import Routes exposing (DialogRoute(BallotInfoD, BallotOptionD, VoteConfirmationD))
import Styles.Styles exposing (SvClass(Footer, NilS, VoteList))
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
                [ Slider.disabled ]
            else
                []

        continueBtnOptions =
            if isFutureVote then
                [ Disabled ]
            else
                []

        voteTime =
            if isFutureVote then
                "Vote opens in " ++ readableTime ballot.start model
            else
                "Vote closes in " ++ readableTime ballot.finish model

        optionListItem { id, name, desc } =
            row VoteList
                [ spread, verticalCenter, padding (scaled 2) ]
                [ text name
                , column NilS
                    [ center, spacing (scaled 1) ]
                    [ text <| "Your vote: " ++ (toString <| getFloatField id model)
                    , row NilS
                        [ verticalCenter, spacing (scaled 2) ]
                        [ text "👎"
                        , html <|
                            Slider.view <|
                                [ Slider.value <| getFloatField id model
                                , Slider.min -3
                                , Slider.max 3
                                , Slider.step 1
                                , Slider.onChange <| SetFloatField id
                                ]
                                    ++ sliderOptions
                        , text "❤️"
                        ]
                    ]
                , html <|
                    btn (id * 13 + 1)
                        model
                        [ SecBtn
                        , Click (SetDialog (name ++ ": Details") (BallotOptionD desc))
                        , OpenDialog
                        ]
                        [ H.text "Details" ]
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
        , el Footer [ alignRight ] (text voteTime)
        , column NilS [ padding (scaled 3) ] optionList
        , el NilS [ center ] <| html <| btn 894823489 model ([ PriBtn, Attr (class "ma3"), Click (SetDialog "Confirmation" (VoteConfirmationD newVote newVoteId)), OpenDialog ] ++ continueBtnOptions) [ H.text "Continue" ]
        ]


voteH : BallotId -> Model -> ( List SvElement, List SvElement, List SvElement )
voteH id model =
    let
        ballot =
            getBallot id model
    in
    ( []
    , [ text ballot.name ]
    , [ html <| btn 2345785562 model [ Icon, Attr (class "sv-button-large"), OpenDialog, Click (SetDialog "Ballot Info" <| BallotInfoD ballot.desc) ] [ Icon.view "info_outline" [ Icon.size36 ] ] ]
    )
