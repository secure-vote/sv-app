module Views.RootV exposing (..)

import Components.Dialog exposing (dialog)
import Html exposing (Html, div, hr, img, span, text)
import Html.Attributes exposing (class, src, style)
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options exposing (cs, css, styled)
import Maybe.Extra exposing ((?))
import Models exposing (Democracy, Model)
import Msgs exposing (Msg(Mdl))
import Routes exposing (Route(..))
import Views.DashboardV exposing (dashboardH, dashboardV)
import Views.DemocracyListV exposing (democracyListH, democracyListV)
import Views.DemocracyV exposing (democracyH, democracyV)
import Views.VoteV exposing (voteH, voteV)


rootView : Model -> Html Msg
rootView model =
    let
        logo =
            img [ src "/web/img/securevote-logo-side.svg", style [ ( "max-width", "55%" ) ] ] []

        header =
            [ Layout.row [ cs "main-header" ]
                [ Layout.title [] [ logo ]
                , Layout.spacer
                , Layout.navigation []
                    [ Layout.link [] [ Icon.view "account_circle" [ Icon.size48 ] ]
                    ]
                ]
            , Layout.row [ cs "relative" ]
                ([ Layout.navigation [ cs "absolute left-0" ]
                    [ Layout.link [] [ Icon.view "arrow_back" [ Icon.size48 ] ]
                    ]
                 ]
                    ++ pageHeader model
                )
            ]

        main =
            [ page model
            , dialog model
            ]
    in
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        , Layout.fixedDrawer
        ]
        { header = header
        , drawer = []
        , tabs = ( [], [] )
        , main = main
        }


page : Model -> Html Msg
page model =
    case model.route of
        DashboardR ->
            dashboardV model

        DemocracyListR ->
            democracyListV model

        DemocracyR ->
            democracyV model

        VoteR ->
            voteV model


pageHeader model =
    case model.route of
        DashboardR ->
            dashboardH

        DemocracyListR ->
            democracyListH model

        DemocracyR ->
            democracyH model

        VoteR ->
            voteH
