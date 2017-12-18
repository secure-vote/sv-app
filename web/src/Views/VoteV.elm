module Views.VoteV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Helpers exposing (getBallot, getFloatField, readableTime)
import Html exposing (Html, div, p, span, text)
import Html.Attributes exposing (class, style)
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options exposing (cs, styled)
import Material.Slider as Slider
import Material.Typography as Typo
import Models exposing (Model)
import Models.Ballot exposing (BallotId)
import Msgs exposing (Msg(SetDialog, SetFloatField))
import Routes exposing (DialogRoute(BallotInfoD, BallotOptionD, VoteConfirmationD))


voteV : BallotId -> Model -> Html Msg
voteV id model =
    let
        ballot =
            getBallot id model

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
            div [ class "center mw-5 cf mb4 mt3 db w-100 bb bw1 b--silver" ]
                [ div [ class "h-100 w-100 w-100-m w-30-l fl mt2 mb3 tl-l v-mid" ]
                    [ span [ class "w-100 f4 tc tl-l v-mid b" ] [ text name ] ]
                , div [ class "cf w-0 fl dn dib-m" ]
                    -- &nbsp;
                    [ text " " ]
                , div [ class "cf v-mid w-100 w-70-m w-40-l fl mb2" ]
                    [ div [] [ text <| "Your vote: " ++ (toString <| getFloatField id model) ]
                    , div [ class "center" ]
                        [ div [ class "inline-flex flex-row content-center cf relative w-100", style [ ( "top", "-10px" ) ] ]
                            [ span
                                [ class "f3 relative"
                                , style [ ( "top", "0px" ), ( "left", "15px" ) ]
                                ]
                                [ text "👎" ]
                            , div [ class "dib w-100" ]
                                [ Slider.view
                                    ([ Slider.value <| getFloatField id model
                                     , Slider.min -3
                                     , Slider.max 3
                                     , Slider.step 1
                                     , Slider.onChange <| SetFloatField id
                                     ]
                                        ++ sliderOptions
                                    )
                                ]
                            , span
                                [ class "f3 relative"
                                , style [ ( "top", "0px" ), ( "right", "13px" ) ]
                                ]
                                [ text "❤️" ]
                            ]
                        ]
                    ]
                , div [ class "v-mid w-100 w-25-m w-30-l fl mb3 tr-l tr-m tc" ]
                    [ btn (id * 13 + 1)
                        model
                        [ SecBtn
                        , Click (SetDialog (name ++ ": Details") (BallotOptionD desc))
                        , OpenDialog
                        ]
                        [ text "Details" ]
                    ]
                ]
    in
    div [ class "tc pa3" ]
        [ text ballot.desc
        , styled p
            [ cs "tr pa2"
            , Typo.caption
            ]
            [ text voteTime ]
        , div [] optionList
        , btn 894823489 model ([ PriBtn, Attr (class "ma3"), Click (SetDialog "Confirmation" (VoteConfirmationD id)), OpenDialog ] ++ continueBtnOptions) [ text "Continue" ]
        ]


voteH : BallotId -> Model -> List (Html Msg)
voteH id model =
    let
        ballot =
            getBallot id model
    in
    [ Layout.title [] [ text ballot.name ]
    , Layout.spacer
    , Layout.navigation []
        [ Layout.link []
            [ btn 2345785562 model [ Icon, Attr (class "sv-button-large"), OpenDialog, Click (SetDialog "Ballot Info" <| BallotInfoD ballot.desc) ] [ Icon.view "info_outline" [ Icon.size36 ] ] ]
        ]
    ]
