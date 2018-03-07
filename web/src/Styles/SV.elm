module Styles.SV exposing (..)

import Color exposing (rgb, white)
import Style exposing (..)
import Style.Background exposing (gradient, step)
import Style.Border exposing (rounded)
import Style.Color as C
import Style.Font as F
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation(..))


lightBlue =
    rgb 87 175 219


blue =
    rgb 23 119 172


darkBlue =
    rgb 0 96 143


vDarkBlue =
    rgb 0 27 40


lightGrey =
    rgb 138 138 138


darkGrey =
    rgb 79 79 79


svStyles : List (Style SvClass Variation)
svStyles =
    [ style Body
        [ F.typeface [ F.font "Roboto" ]
        , C.text white
        ]
    , style BtnS
        [ C.text white
        , variation BtnPri
            [ prop "padding" <| toString (scaled 3) ++ "px"
            , prop "width" "100%"
            , gradient (pi / 2) [ step blue, step lightBlue ]
            , rounded 200
            ]
        , variation BtnSec
            [ prop "padding" <| toString (scaled 3) ++ "px"
            , prop "width" "100%"
            , gradient (pi / 2) [ step darkGrey, step lightGrey ]
            , rounded 200
            ]
        ]
    ]
