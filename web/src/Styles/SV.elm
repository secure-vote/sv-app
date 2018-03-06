module Styles.SV exposing (..)

import Color exposing (rgb, white)
import Style exposing (Style, style)
import Style.Background exposing (gradient, step)
import Style.Border exposing (rounded)
import Style.Color as C
import Styles.Styles exposing (SvClass(BtnS))
import Styles.Variations exposing (Variation)


lightBlue =
    rgb 87 175 219


blue =
    rgb 23 119 172


svStyles : List (Style SvClass Variation)
svStyles =
    [ style BtnS
        [ gradient (pi / 2) [ step blue, step lightBlue ]
        , rounded 200
        , C.text white
        ]
    ]