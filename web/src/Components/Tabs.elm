module Components.Tabs exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Models exposing (Model)
import Msgs exposing (Msg)
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation(TabBtnActive))
import Views.ViewHelpers exposing (SvAttribute, SvElement)


type alias TabRec =
    { id : Int, elem : SvElement, view : SvElement }


mkTabBtn : (Int -> Bool) -> (Int -> Msg) -> Int -> SvElement -> SvElement
mkTabBtn isActiveTab msgF tabId innerElem =
    el TabBtn
        [ onClick <| msgF tabId
        , vary TabBtnActive (isActiveTab tabId)
        ]
        innerElem


mkTabRow : (Int -> Bool) -> (Int -> Msg) -> List TabRec -> List SvAttribute -> SvElement
mkTabRow isActiveTab msgF pairs attrs =
    row TabRow
        ([ spacing (scaled 2), center, verticalCenter, paddingTop (scaled 1) ]
            ++ attrs
        )
    <|
        List.map
            (\{ id, elem } -> mkTabBtn isActiveTab msgF id elem)
            pairs
