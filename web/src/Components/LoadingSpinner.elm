module Components.LoadingSpinner exposing (..)

import Html exposing (Html, div, li, span, text, ul)
import Html.Attributes exposing (class, id)


spinner : Html msg
spinner =
    div [ id "loading-screen" ]
        [ div [ class "cssload-container cssload-orange cssload-small" ]
            [ ul [ class "cssload-flex-container" ]
                [ li []
                    [ span [ class "cssload-loading cssload-one" ] []
                    , span [ class "cssload-loading cssload-two" ] []
                    , span [ class "cssload-loading-center" ] []
                    ]
                ]
            ]
        ]
