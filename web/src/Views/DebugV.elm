module Views.DebugV exposing (..)

import Dict
import Element exposing (..)
import Helpers exposing (card, getDebugLog, para)
import Models exposing (Model)
import Styles.Styles exposing (SvClass(NilS))
import Views.ViewHelpers exposing (SvElement, SvHeader, SvView)


debugV : Model -> SvView
debugV model =
    ( empty
    , header
    , body model
    )


header : SvHeader
header =
    ( []
    , [ text "Debug Log" ]
    , []
    )


body : Model -> SvElement
body model =
    card <|
        column NilS
            []
            [ para [] <| getDebugLog model
            ]
