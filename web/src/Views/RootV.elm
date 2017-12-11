module Views.RootV exposing (..)

import AdminViews.CreateDemocracyV exposing (createDemocracyH, createDemocracyV)
import Components.Btn exposing (BtnProps(..), btn)
import Components.Dialog exposing (dialog)
import Html exposing (Html, div, hr, img, span, text)
import Html.Attributes exposing (class, src, style)
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options exposing (cs, css, onClick, styled)
import Models exposing (Model)
import Msgs exposing (Msg(Mdl, NavigateBack, NavigateHome, SetDialog))
import Routes exposing (DialogRoute(UserInfoD), Route(..))
import Views.CreateVoteV exposing (createVoteH, createVoteV)
import Views.DashboardV exposing (dashboardH, dashboardV)
import Views.DemocracyListV exposing (democracyListH, democracyListV)
import Views.DemocracyV exposing (democracyH, democracyV)
import Views.ResultsV exposing (resultsH, resultsV)
import Views.VoteV exposing (voteH, voteV)


rootView : Model -> Html Msg
rootView model =
    let
        logo =
            div [ class "main-logo" ] []

        header =
            [ Layout.row [ cs "main-header relative" ]
                [ Layout.navigation [ cs "absolute left-0" ]
                    [ Layout.link [ onClick NavigateHome ] [ Icon.view "home" [ Icon.size36 ] ]
                    ]
                , Layout.title [] [ logo ]
                , Layout.spacer
                , Layout.navigation []
                    [ Layout.link [] [ btn 457467845632 model [ Icon, Attr (class "sv-button-large"), OpenDialog, Click (SetDialog "User Info" <| UserInfoD) ] [ Icon.view "account_circle" [ Icon.size36 ] ] ]
                    ]
                ]
            , Layout.row [ cs "secondary-header relative" ]
                ([ Layout.navigation [ cs "absolute left-0" ]
                    [ Layout.link [ onClick NavigateBack ] [ Icon.view "arrow_back" [ Icon.size36 ] ]
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

        DemocracyR id ->
            democracyV id model

        VoteR id ->
            voteV id model

        ResultsR id ->
            resultsV id model

        CreateDemocracyR ->
            createDemocracyV model

        CreateVoteR id ->
            createVoteV id model

        NotFoundRoute ->
            notFoundView


pageHeader : Model -> List (Html Msg)
pageHeader model =
    case model.route of
        DashboardR ->
            dashboardH model

        DemocracyListR ->
            democracyListH model

        DemocracyR id ->
            democracyH id model

        VoteR id ->
            voteH id model

        ResultsR id ->
            resultsH id model

        CreateDemocracyR ->
            createDemocracyH

        CreateVoteR id ->
            createVoteH

        NotFoundRoute ->
            [ notFoundView ]


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
