module Styles.StyleHelpers exposing (..)

import Element.Attributes exposing (attribute, vary)
import Styles.Variations exposing (Variation(Disabled))


disabledBtnAttr =
    [ attribute "disabled" "disabled", vary Disabled True ]
