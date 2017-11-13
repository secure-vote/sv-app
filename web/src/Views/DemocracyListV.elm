module Views.DemocracyListV exposing (..)

import Dict
import Html exposing (Html, div, img, span, text)
import Html.Attributes exposing (height, src)
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options exposing (cs, styled)
import Material.Table as Table
import Material.Textfield as Textf
import Material.Typography as Typo
import Models exposing (Model)
import Msgs exposing (Msg(Mdl))


democracyListV : Model -> Html Msg
democracyListV model =
    let
        listItem ( id, { name, logo } ) =
            Table.tr []
                [ Table.td [ cs "center tc" ] [ img [ src logo, height 50 ] [] ]
                , Table.td [ cs "tl" ] [ styled span [ Typo.title ] [ text name ] ]
                , Table.td [] [ Icon.view "add_circle_outline" [ Icon.size36 ] ]
                ]
    in
    Table.table [ cs "w-100" ]
        [ Table.tbody [] <| List.map listItem <| Dict.toList model.democracies
        ]


democracyListH : Model -> List (Html Msg)
democracyListH model =
    [ Layout.title []
        [ Textf.render Mdl
            [ 56345634563456 ]
            model.mdl
            [ Textf.label "Search..."
            ]
            []
        ]
    ]
