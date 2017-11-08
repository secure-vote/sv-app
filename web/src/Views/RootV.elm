module Views.RootV exposing (..)

import Html exposing (Html, div, hr, img, span, text)
import Html.Attributes exposing (class, src, style)
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options exposing (cs, css, styled)
import Models exposing (Model)
import Msgs exposing (Msg(Mdl))
import Views.DashboardV exposing (dashboardH, dashboardV)


rootView : Model -> Html Msg
rootView model =
    let
        logo =
            img [ src "/web/img/securevote-logo-side.svg", style [ ( "max-width", "55%" ) ] ] []

        header secHeader =
            [ Layout.row [ cs "main-header" ]
                [ Layout.title [] [ logo ]
                , Layout.spacer
                , Layout.navigation []
                    [ Layout.link [] [ Icon.view "account_circle" [ Icon.size48 ] ]
                    ]
                ]
            , Layout.row [] secHeader
            ]
    in
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        , Layout.fixedDrawer
        ]
        { header = header dashboardH
        , drawer = []
        , tabs = ( [], [] )
        , main = [ dashboardV model ]
        }
