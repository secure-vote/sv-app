module Views.RootDemoV exposing (..)

import AdminViews.CreateDemocracyV exposing (createDemocracyH, createDemocracyV)
import Components.Dialog exposing (dialog)
import Components.Icons exposing (IconSize(I24, I36), mkIcon)
import Element exposing (Element, button, column, el, empty, html, layout, row, text, within)
import Element.Attributes exposing (alignBottom, alignLeft, alignRight, center, fill, paddingBottom, px, spacing, spread, width)
import Element.Events exposing (onClick)
import Html exposing (Html, div, i, span)
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Msgs exposing (Msg(Mdl, NavigateBack, NavigateHome, SetDialog, Snackbar))
import Routes exposing (DialogRoute(UserInfoD), Route(..))
import Styles.GenStyles exposing (genStylesheet)
import Styles.Styles exposing (StyleOption(SwmStyle), SvClass(..))
import Styles.Swarm exposing (scaled, swmStylesheet)
import Views.CreateBallotV exposing (createBallotH, createBallotV)
import Views.DashboardV exposing (dashboardH, dashboardV)
import Views.DemocracyListV exposing (democracyListH, democracyListV)
import Views.DemocracyV exposing (democracyH, democracyV)
import Views.EditBallotV exposing (editBallotH, editBallotV)
import Views.ResultsV exposing (resultsH, resultsV)
import Views.ViewHelpers exposing (SvElement, nilView, notFoundView)
import Views.VoteV exposing (voteH, voteV)


rootDemoView : Model -> Html Msg
rootDemoView model =
    let
        isLoading =
            model.isLoading

        w =
            width <| px (scaled 3)

        navBack =
            if List.length model.routeStack > 1 then
                [ button NilS [ onClick NavigateBack, w ] (mkIcon "arrow-left" I24) ]
            else
                [ empty ]

        ( hLeft, hCenter, hRight ) =
            pageHeader model

        header =
            row HeaderStyle
                [ spacing (scaled 2), alignLeft, alignBottom, spread ]
                [ row NilS [ width fill, alignLeft ] <| navBack ++ hLeft
                , row MenuBarHeading [ width fill ] hCenter
                , row NilS [ width fill, alignRight ] hRight
                ]

        showDialog =
            if model.showDialog then
                [ dialog model ]
            else
                []

        mainLayout =
            column NilS
                [ spacing (scaled 2) ]
                [ header
                , page model
                ]
                |> within showDialog
    in
    layout (genStylesheet SwmStyle) mainLayout


fst a b =
    a


page : Model -> SvElement
page model =
    case List.head model.routeStack ? NotFoundRoute of
        DashboardR ->
            notFoundView

        DemocracyListR ->
            notFoundView

        DemocracyR democracyId ->
            democracyV democracyId model

        VoteR ballotId ->
            voteV ballotId model

        ResultsR ballotId ->
            resultsV ballotId model

        CreateDemocracyR ->
            fst notFoundView <| createDemocracyV model

        CreateVoteR democracyId ->
            fst notFoundView <| createBallotV democracyId model

        EditVoteR ballotId ->
            fst notFoundView <| editBallotV ballotId model

        NotFoundRoute ->
            fst notFoundView <| notFoundView


wrapH x =
    ( [], [ x ], [] )



-- | Headers should return a tuple3 of SvElements that correspond to left, center, right
-- | elements in the header.


pageHeader : Model -> ( List SvElement, List SvElement, List SvElement )
pageHeader model =
    case List.head model.routeStack ? NotFoundRoute of
        DashboardR ->
            wrapH <| html <| div [] <| dashboardH model

        DemocracyListR ->
            wrapH <| html <| div [] <| democracyListH model

        DemocracyR democracyId ->
            democracyH democracyId model

        VoteR ballotId ->
            voteH ballotId model

        ResultsR ballotId ->
            resultsH ballotId model

        CreateDemocracyR ->
            wrapH <| html <| div [] <| createDemocracyH

        CreateVoteR democracyId ->
            wrapH <| html <| div [] <| createBallotH democracyId model

        EditVoteR ballotId ->
            wrapH <| html <| div [] <| editBallotH ballotId model

        NotFoundRoute ->
            wrapH <| text "Not found"
