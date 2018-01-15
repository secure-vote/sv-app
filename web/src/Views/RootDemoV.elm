module Views.RootDemoV exposing (..)

import AdminViews.CreateDemocracyV exposing (createDemocracyH, createDemocracyV)
import Components.Btn exposing (BtnProps(..), btn)
import Components.Dialog exposing (dialog)
import Html exposing (Html, div, hr, img, span, text, node)
import Html.Attributes exposing (class, src, style, attribute)
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options exposing (cs, css, onClick, styled)
import Material.Snackbar as Snackbar
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Msgs exposing (Msg(Mdl, NavigateBack, NavigateHome, SetDialog, Snackbar))
import Routes exposing (DialogRoute(UserInfoD), Route(..))
import Views.CreateBallotV exposing (createBallotH, createBallotV)
import Views.DashboardV exposing (dashboardH, dashboardV)
import Views.DemocracyListV exposing (democracyListH, democracyListV)
import Views.DemocracyV exposing (democracyH, democracyV)
import Views.EditBallotV exposing (editBallotH, editBallotV)
import Views.ResultsV exposing (resultsH, resultsV)
import Views.VoteV exposing (voteH, voteV)


rootDemoView : Model -> Html Msg
rootDemoView model =
    let
        logo =
            div [ class "main-logo" ] []

        isLoading =
            model.isLoading

        navBack =
            if List.length model.routeStack > 1 then
                [ Layout.link [ onClick NavigateBack ] [ Icon.view "arrow_back" [ Icon.size36 ] ] ]
            else
                []

        header =
            [ Layout.row [ cs "secondary-header relative" ]
                ([ Layout.navigation [ cs "absolute left-0" ]
                    navBack
                 ]
                    ++ pageHeader model
                )
            ]

        cssInjection href_ =
            node "link" [ attribute "rel" "stylesheet", attribute "href" href_ ] []

        main =
            header
                ++ [ cssInjection "https://cdnjs.cloudflare.com/ajax/libs/tachyons/4.9.1/tachyons.min.css"
                   , page model
                   , dialog model
                   , Snackbar.view model.snack |> Html.map Snackbar
                   ]
    in
    div [] main


page : Model -> Html Msg
page model =
    case List.head model.routeStack ? NotFoundRoute of
        DashboardR ->
            dashboardV model

        DemocracyListR ->
            democracyListV model

        DemocracyR democracyId ->
            democracyV democracyId model

        VoteR ballotId ->
            voteV ballotId model

        ResultsR ballotId ->
            resultsV ballotId model

        CreateDemocracyR ->
            createDemocracyV model

        CreateVoteR democracyId ->
            createBallotV democracyId model

        EditVoteR ballotId ->
            editBallotV ballotId model

        NotFoundRoute ->
            notFoundView


pageHeader : Model -> List (Html Msg)
pageHeader model =
    case List.head model.routeStack ? NotFoundRoute of
        DashboardR ->
            dashboardH model

        DemocracyListR ->
            democracyListH model

        DemocracyR democracyId ->
            democracyH democracyId model

        VoteR ballotId ->
            voteH ballotId model

        ResultsR ballotId ->
            resultsH ballotId model

        CreateDemocracyR ->
            createDemocracyH

        CreateVoteR democracyId ->
            createBallotH democracyId model

        EditVoteR ballotId ->
            editBallotH ballotId model

        NotFoundRoute ->
            [ notFoundView ]


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
