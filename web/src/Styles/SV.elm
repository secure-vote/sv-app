module Styles.SV exposing (..)

import Color exposing (rgb, rgba, white)
import Style exposing (..)
import Style.Background exposing (gradient, step)
import Style.Border exposing (rounded)
import Style.Color as C
import Style.Font as F
import Style.Scale as Scale
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation(..))


scaled =
    Scale.modular 10 1.618


vLightBlue =
    rgb 87 175 219


lightBlue =
    rgb 23 119 172


blue =
    rgb 0 96 143


darkBlue =
    rgb 0 48 72


vDarkBlue =
    rgb 0 27 40


lightGrey =
    rgb 138 138 138


darkGrey =
    rgb 79 79 79


none =
    rgba 0 0 0 0


svStyles : List (Style SvClass Variation)
svStyles =
    [ style Body
        [ F.typeface [ F.font "Roboto" ]
        , C.text white

        --        , prop "margin" "auto"
        ]
    , style HeaderS
        [ gradient 0 [ step darkBlue, step blue ]
        , prop "margin-bottom" <| toString (scaled 4) ++ "px"
        ]
    , style SubH
        [ F.size 24
        , F.weight 500
        ]
    , style SubSubH
        [ F.size 18
        , F.weight 500
        ]
    , style ParaS
        [ F.weight 300
        ]
    , style BtnS
        [ C.text white
        , C.background none
        , variation BtnPri
            [ prop "padding" <| toString (scaled 3) ++ "px"
            , prop "width" "100%"
            , gradient (pi / 2) [ step lightBlue, step vLightBlue ]
            , rounded 200
            ]
        , variation BtnSec
            [ prop "padding" <| toString (scaled 3) ++ "px"
            , prop "width" "100%"
            , gradient (pi / 2) [ step darkGrey, step lightGrey ]
            , rounded 200
            ]
        , variation BtnText
            [ C.background none
            ]
        ]
    ]
