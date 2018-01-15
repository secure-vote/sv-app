module Components.Icons exposing (..)

import Element exposing (Element, html, row, text)
import Element.Attributes exposing (spacing, verticalCenter)
import Html
import Html.Attributes exposing (class)
import Styles.Styles exposing (SvClass(NilS))


type IconSize
    = I18
    | I24
    | I36
    | I48


mkIcon : String -> IconSize -> Element style variation msg
mkIcon name sz =
    let
        szClass =
            (\sz -> "mdi-" ++ sz ++ "px") <|
                case sz of
                    I18 ->
                        "18"

                    I24 ->
                        "24"

                    I36 ->
                        "36"

                    I48 ->
                        "48"
    in
    html <| Html.i [ class "mdi", class szClass, class <| "mdi-" ++ name ] []


mkIconWLabel : String -> String -> IconSize -> Element SvClass v m
mkIconWLabel l name sz =
    row NilS [ spacing 5, verticalCenter ] [ mkIcon name sz, text l ]
