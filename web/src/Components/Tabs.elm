module Components.Tabs exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Models exposing (Model)
import Msgs exposing (Msg)
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation(TabBtnActive))
import Views.ViewHelpers exposing (SvElement)


mkTabBtn : (Int -> Bool) -> (Int -> Msg) -> Int -> SvElement -> SvElement
mkTabBtn isActiveTab msgF tabId innerElem =
    button TabBtn [ onClick <| msgF tabId, vary TabBtnActive (isActiveTab tabId) ] innerElem


mkTabRow : Model -> (Int -> Bool) -> (Int -> Msg) -> List { b | id : Int, elem : SvElement } -> SvElement
mkTabRow model isActiveTab msgF pairs =
    row TabRow
        [ spacing (scaled 1), center, verticalCenter, paddingTop (scaled 1) ]
    <|
        List.map
            (\{ id, elem } -> mkTabBtn isActiveTab msgF id elem)
            pairs
