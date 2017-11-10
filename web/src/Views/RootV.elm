module Views.RootV exposing (..)

--import Views.DashboardV exposing (dashboardH, dashboardV)
--import Views.DemocracyListV exposing (democracyListH, democracyListV)
--import Views.DemocracyV exposing (democracyH, democracyV)

import Html exposing (Html, div, hr, img, span, text)
import Html.Attributes exposing (class, src, style)
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options exposing (cs, css, styled)
import Maybe.Extra exposing ((?))
import Models exposing (Democracy, Model)
import Msgs exposing (Msg(Mdl))
import Views.VoteV exposing (voteH, voteV)


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
        { header = header <| voteH
        , drawer = []
        , tabs = ( [], [] )
        , main = [ voteV model ]
        }
