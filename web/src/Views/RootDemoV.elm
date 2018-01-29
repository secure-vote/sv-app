module Views.RootDemoV exposing (..)

--import AdminViews.CreateDemocracyV exposing (createDemocracyH, createDemocracyV)
--import Views.CreateBallotV exposing (createBallotH, createBallotV)
--import Views.EditBallotV exposing (editBallotH, editBallotV)
--import Views.DashboardV exposing (dashboardH, dashboardV)
--import Views.DemocracyListV exposing (democracyListH, democracyListV)

import Components.Btn exposing (BtnProps(Click), btn)
import Components.Dialog exposing (dialog)
import Components.Icons exposing (IconSize(I24, I36), mkIcon)
import Element exposing (Element, column, el, empty, html, layout, row, text, within)
import Element.Attributes exposing (alignBottom, alignLeft, alignRight, center, fill, padding, paddingBottom, px, spacing, spread, width)
import Html as H exposing (Html, div, i, node, span)
import Html.Attributes as HA
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Msgs exposing (Msg(NavigateBack, NavigateHome, SetDialog))
import Routes exposing (DialogRoute(UserInfoD), Route(..))
import Styles.GenStyles exposing (genStylesheet)
import Styles.Styles exposing (StyleOption(SwmStyle), SvClass(..))
import Styles.Swarm exposing (scaled, swmStylesheet)
import Views.DemocracyV exposing (democracyV)
import Views.ResultsV exposing (resultsV)
import Views.ViewHelpers exposing (SvElement, cssSpinner, nilView, notFoundView)
import Views.VoteV exposing (voteV)


rootDemoView : Model -> Html Msg
rootDemoView model =
    let
        isLoading =
            model.isLoading

        injectCss =
            let
                tag =
                    "link"

                attrs =
                    [ HA.attribute "rel" "stylesheet"
                    , HA.attribute "property" "stylesheet"
                    , HA.attribute "href" "https://sv-app-mvp.netlify.com/css/cssload-spinner.css"
                    ]

                children =
                    []
            in
            H.node tag attrs children

        navBack =
            if List.length model.routeStack > 1 then
                [ btn [ Click NavigateBack ] (mkIcon "arrow-left" I24) ]
            else
                [ empty ]

        ( hLeft, hCenter, hRight ) =
            header

        ( admin, header, body ) =
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
                    notFoundView

                -- createDemocracyV model
                CreateVoteR democracyId ->
                    notFoundView

                -- createBallotV democracyId model
                EditVoteR ballotId ->
                    notFoundView

                -- editBallotV ballotId model
                NotFoundRoute ->
                    notFoundView

        headerRow =
            row HeaderStyle
                [ spacing (scaled 2), alignLeft, alignBottom, spread ]
                [ row NilS [ width fill, alignLeft, padding (scaled 1) ] <| navBack ++ hLeft
                , row MenuBarHeading [ width fill, padding (scaled 1), center ] hCenter
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
                [ admin
                , headerRow
                , body
                ]
                |> within showDialog
    in
    H.div [] [ injectCss, layout (genStylesheet SwmStyle) mainLayout ]
