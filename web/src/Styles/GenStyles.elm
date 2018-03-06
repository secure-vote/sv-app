module Styles.GenStyles exposing (..)

import Style exposing (StyleSheet, styleSheet)
import Styles.SV exposing (svStyles)
import Styles.Styles exposing (StyleOption(..), SvClass, commonStyles)
import Styles.Swarm exposing (swmStyles)
import Styles.Variations exposing (Variation)


genStylesheet : StyleOption -> StyleSheet SvClass Variation
genStylesheet styOpt =
    case styOpt of
        SwmStyle ->
            styleSheet (swmStyles ++ commonStyles)

        SvStyle ->
            styleSheet (svStyles ++ commonStyles)
