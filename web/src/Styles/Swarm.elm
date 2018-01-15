module Styles.Swarm exposing (..)

import Color exposing (darkGray, gray, lightGray, orange, red, rgba)
import Style exposing (..)
import Style.Border exposing (bottom, solid)
import Style.Color as C
import Style.Font as Font
import Style.Scale as Scale
import Styles.Styles exposing (SvClass(..))
import Styles.Variations exposing (Variation(..))


scaled =
    Scale.modular 16 1.618


swmHltColor =
    orange


textColorVars =
    [ variation (VarColor red) [ C.text red ] ]


swmStylesheet : StyleSheet SvClass Variation
swmStylesheet =
    styleSheet
        [ style NilS []
        , style HeaderStyle
            [ bottom 1.0
            , solid
            , C.border lightGray
            ]
        , style Heading <|
            [ Font.size <| scaled 4
            ]
                ++ textColorVars
        , style TabRow
            [ bottom 1.0
            , solid
            , C.border lightGray
            ]
        , style TabBtn
            [ Font.size 24
            , bottom 1.0
            , solid
            , C.border <| rgba 0 0 0 0
            , variation TabBtnActive
                [ bottom 1.0
                , solid
                , C.border swmHltColor
                ]
            ]
        ]
