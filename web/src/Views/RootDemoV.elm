module Views.RootDemoV exposing (..)

import AdminViews.CreateDemocracyV exposing (createDemocracyH, createDemocracyV)
import Components.Btn exposing (BtnProps(..), btn)
import Components.Dialog exposing (dialog)
import Components.Icons exposing (IconSize(I36), mkIcon)
import Element exposing (Element, column, el, empty, html, layout, row, text)
import Element.Attributes exposing (alignLeft, fill, spacing, width)
import Element.Events exposing (onClick)
import Html exposing (Html, i, span)
import Html.Attributes exposing (class)
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Snackbar as Snackbar
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Msgs exposing (Msg(Mdl, NavigateBack, NavigateHome, SetDialog, Snackbar))
import Routes exposing (DialogRoute(UserInfoD), Route(..))
import Styles.GenStyles exposing (genStylesheet)
import Styles.Styles exposing (StyleOption(SwmStyle), SvClass(..))
import Styles.Swarm exposing (scaled, swmStylesheet)
import Styles.Variations exposing (Variation)
import Views.CreateBallotV exposing (createBallotH, createBallotV)
import Views.DashboardV exposing (dashboardH, dashboardV)
import Views.DemocracyListV exposing (democracyListH, democracyListV)
import Views.DemocracyV exposing (democracyH, democracyV)
import Views.EditBallotV exposing (editBallotH, editBallotV)
import Views.ResultsV exposing (resultsH, resultsV)
import Views.ViewHelpers exposing (nilView, notFoundView)
import Views.VoteV exposing (voteH, voteV)


rootDemoView : Model -> Html Msg
rootDemoView model =
    let
        isLoading =
            model.isLoading

        navBack =
            if List.length model.routeStack > 1 || True then
                el NilS [ onClick NavigateBack ] (mkIcon "arrow-left" I36)
            else
                el NilS [] empty

        header =
            row HeaderStyle
                [ spacing (scaled 1), alignLeft ]
                [ navBack
                , row NilS [ width fill ] <| List.map html <| pageHeader model
                ]

        mainLayout =
            column NilS
                []
                [ header
                , page model

                -- , dialog model
                ]
    in
    layout (genStylesheet SwmStyle) mainLayout


fst a b =
    a


page : Model -> Element SvClass Variation Msg
page model =
    case List.head model.routeStack ? NotFoundRoute of
        DashboardR ->
            notFoundView

        DemocracyListR ->
            notFoundView

        DemocracyR democracyId ->
            democracyV democracyId model

        VoteR ballotId ->
            fst notFoundView <| voteV ballotId model

        ResultsR ballotId ->
            fst notFoundView <| resultsV ballotId model

        CreateDemocracyR ->
            fst notFoundView <| createDemocracyV model

        CreateVoteR democracyId ->
            fst notFoundView <| createBallotV democracyId model

        EditVoteR ballotId ->
            fst notFoundView <| editBallotV ballotId model

        NotFoundRoute ->
            fst notFoundView <| notFoundView


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
            []
