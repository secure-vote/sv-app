module Components.Slider exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (para)
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Models exposing (Model)
import Msgs exposing (Msg)
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation(..))
import Views.ViewHelpers exposing (SvElement)


range =
    { min = -3
    , max = 3
    , step = 1
    }


slider : Model -> (String -> Msg) -> Bool -> Float -> SvElement
slider model msg isDisabled value =
    let
        sliderOptions =
            if isDisabled then
                [ HA.attribute "disabled" "disabled" ]
            else
                []

        sliderBg x =
            el SliderBackground
                [ width fill
                , height (px 9)
                , vary SliderGreen ((toFloat x < value) && (x >= 0))
                , vary SliderRed ((toFloat x >= value) && (x < 0))
                ]
                empty

        htmlSlider =
            el Slider [ width fill, verticalCenter ] <|
                html <|
                    H.input
                        (sliderOptions
                            ++ [ HA.type_ "range"
                               , HA.min <| toString <| range.min
                               , HA.max <| toString <| range.max
                               , HA.step <| toString <| range.step
                               , HA.value <| toString <| value
                               , HE.onInput <| msg
                               , HA.style
                                    [ ( "-webkit-appearance", "none" )
                                    , ( "background", "none" )
                                    , ( "width", "100%" )
                                    ]
                               ]
                        )
                        []
    in
    column NilS
        [ width fill, spacing (scaled 1) ]
        [ row NilS
            [ spread ]
            [ para [] "Disagree"
            , para [] "Agree"
            ]
        , sliderLabel value
        , row NilS
            []
            (List.map sliderBg <|
                List.range range.min (range.max - 1)
            )
            |> within [ htmlSlider ]
        ]


sliderLabel : Float -> SvElement
sliderLabel value =
    let
        struct =
            case value of
                (-3) ->
                    { l = 0, r = 1, txt = "Strongly Disagree" }

                (-2) ->
                    { l = 2, r = 13, txt = "Mostly Disagree" }

                (-1) ->
                    { l = 5, r = 11, txt = "Somewhat Disagree" }

                0 ->
                    { l = 1, r = 1, txt = "Neutral" }

                1 ->
                    { l = 13, r = 6, txt = "Somewhat Agree" }

                2 ->
                    { l = 6, r = 1, txt = "Mostly Agree" }

                3 ->
                    { l = 1, r = 0, txt = "Strongly Agree" }

                _ ->
                    { l = 0, r = 0, txt = "" }
    in
    row NilS
        []
        [ el NilS [ width (fillPortion struct.l) ] empty
        , el SliderLabel [ paddingXY (scaled 2) 3 ] (text struct.txt)
        , el NilS [ width (fillPortion struct.r) ] empty
        ]
