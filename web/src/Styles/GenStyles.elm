module Styles.GenStyles exposing (..)

import Style exposing (StyleSheet)
import Styles.Styles exposing (StyleOption(..), SvClass)
import Styles.Swarm exposing (swmStylesheet)
import Styles.Variations exposing (Variation)


genStylesheet : StyleOption -> StyleSheet SvClass Variation
genStylesheet styOpt =
    case styOpt of
        SwmStyle ->
            swmStylesheet

        SvStyle ->
            swmStylesheet
