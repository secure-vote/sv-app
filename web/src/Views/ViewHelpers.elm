module Views.ViewHelpers exposing (..)

import Element exposing (..)
import Msgs exposing (Msg)
import Styles.Styles exposing (..)
import Styles.Variations exposing (Variation(..))


nilView : Element s v m
nilView =
    empty


type alias SvElement =
    Element SvClass Variation Msg


type alias SvAttribute =
    Attribute Variation Msg


notFoundView : Element SvClass Variation m
notFoundView =
    el Error [] (text "Not Found")
