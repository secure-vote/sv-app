module Views.VoteV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Dict exposing (Dict)
import Html exposing (Html, div, p, span, text)
import Html.Attributes exposing (class, style)
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options exposing (cs, styled)
import Material.Slider as Slider
import Material.Typography as Typo
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Msgs exposing (Msg(SetDialog))
import Routes exposing (DialogRoute(VoteConfirmationDialog))


voteV : Model -> Html Msg
voteV model =
    let
        optionList =
            List.map optionListItem sampleBallot.options

        optionListItem { id, name, desc } =
            div [ class "center mw-5 cf mb4 mt3 db w-100 bb bw1 b--silver" ]
                [ div [ class "h-100 w-100 w-100-m w-30-l fl mt2 mb3 tl-l v-mid" ]
                    [ span [ class "w-100 f4 tc tl-l v-mid b" ] [ text name ] ]
                , div [ class "cf w-0 fl dn dib-m" ]
                    -- &nbsp;
                    [ text " " ]
                , div [ class "cf v-mid w-100 w-70-m w-40-l fl mb2" ]
                    [ div [] [ text <| "Your vote: " ++ toString (Dict.get id sampleResults ? 0) ]
                    , div [ class "center" ]
                        [ div [ class "inline-flex flex-row content-center cf relative w-100", style [ ( "top", "-10px" ) ] ]
                            [ span
                                [ class "f3 relative"
                                , style [ ( "top", "0px" ), ( "left", "15px" ) ]
                                ]
                                [ text "👎" ]
                            , div [ class "dib w-100" ]
                                [ Slider.view
                                    [ Slider.value <| toFloat <| Dict.get id sampleResults ? 0
                                    , Slider.min -3
                                    , Slider.max 3
                                    , Slider.step 1

                                    -- , Slider.onChange <| SetBallotRange id
                                    ]
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

                        -- , Click (SetDialog (rSchedTitle ++ ": Details") (BallotDialog description))
                        , OpenDialog
                        ]
                        [ text "Details" ]
                    ]
                ]
    in
    div [ class "tc pa3" ]
        [ text sampleBallot.desc
        , styled p
            [ cs "tr pa2"
            , Typo.caption
            ]
            [ text sampleBallot.finish ]
        , div [] optionList
        , btn 894823489 model [ PriBtn, Attr (class "ma3"), Click (SetDialog "Confirmation" VoteConfirmationDialog), OpenDialog ] [ text "Continue" ]
        ]


voteH : List (Html Msg)
voteH =
    [ Layout.title [] [ text sampleBallot.name ]
    , Layout.spacer
    , Layout.navigation []
        [ Layout.link []
            [ Icon.view "info_outline" [ Icon.size36 ]
            ]
        ]
    ]


sampleBallot =
    { name = "Token Release Schedule"
    , desc = "This vote is to determine the release schedule of the SWM token."
    , options =
        [ { id = 12341234123, name = "8 releases of 42 days", desc = "" }
        , { id = 64564746345, name = "42 releases of 8 days", desc = "" }
        , { id = 87967875645, name = "16 releases of 42 days", desc = "" }
        , { id = 23457478556, name = "4 releases of 84 days", desc = "" }
        ]
    , finish = "Vote Ends in 42 minutes"
    }


sampleResults =
    Dict.empty
