module Styles.Swarm exposing (..)

import Color exposing (lightGray)
import Style exposing (..)
import Style.Border exposing (bottom, solid)
import Style.Color as C
import Style.Font as Font
import Style.Scale as Scale
import Styles.Styles exposing (SvClass(..))


scaled =
    Scale.modular 16 1.618


swmStylesheet : StyleSheet SvClass variation
swmStylesheet =
    styleSheet
        [ style NilS []
        , style HeaderStyle
            [ bottom 1.0
            , solid
            , C.border lightGray
            ]
        , style Heading
            [ Font.size <| scaled 4 ]
        ]
