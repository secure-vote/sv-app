module Views.ViewHelpers exposing (..)

import Element exposing (..)
import Html as H
import Html.Attributes as HA
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


type alias SvHeader =
    ( List SvElement, List SvElement, List SvElement )


type alias SvView =
    ( SvElement, SvHeader, SvElement )


notFoundView : SvView
notFoundView =
    ( empty
    , ( [], [], [] )
    , el Error [] (text "Not Found")
    )


cssSpinner : SvElement
cssSpinner =
    html <|
        H.div [ HA.class "cssload-container" ]
            [ H.ul [ HA.class "cssload-flex-container cssload-orange" ]
                [ H.li []
                    [ H.span [ HA.class "cssload-loading cssload-one" ] []
                    , H.span [ HA.class "cssload-loading cssload-two" ] []
                    , H.span [ HA.class "cssload-loading-center" ] []
                    ]
                ]
            ]
