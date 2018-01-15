module Styles.GenStyles exposing (..)

import Style exposing (StyleSheet)
import Styles.Styles exposing (StyleOption(..), SvClass)
import Styles.Swarm exposing (swmStylesheet)


genStylesheet : StyleOption -> StyleSheet SvClass variation
genStylesheet styOpt =
    case styOpt of
        SwmStyle ->
            swmStylesheet

        SvStyle ->
            swmStylesheet
