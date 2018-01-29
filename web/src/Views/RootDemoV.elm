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
import Element.Events exposing (onClick)
import Html as H exposing (Html, div, i, node, span)
import Html.Attributes as HA
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Msgs exposing (Msg(NavigateBack, NavigateHome, SetDialog))
import Routes exposing (DialogRoute(UserInfoD), Route(..))
import Styles.GenStyles exposing (genStylesheet)
import Styles.Styles exposing (StyleOption(SwmStyle), SvClass(..))
import Styles.Swarm exposing (scaled, swmStylesheet)
import Views.DemocracyV exposing (democracyH, democracyV)
import Views.ResultsV exposing (resultsH, resultsV)
import Views.ViewHelpers exposing (SvElement, cssSpinner, nilView, notFoundView)
import Views.VoteV exposing (voteH, voteV)


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
            pageHeader model

        header =
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
                [ header
                , page model
                ]
                |> within showDialog
    in
    H.div [] [ injectCss, layout (genStylesheet SwmStyle) mainLayout ]


fst : a -> b -> a
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


wrapH : a -> ( List b, List a, List c )
wrapH x =
    ( [], [ x ], [] )



-- | Headers should return a tuple3 of SvElements that correspond to left, center, right
-- | elements in the header.


pageHeader : Model -> ( List SvElement, List SvElement, List SvElement )
pageHeader model =
    case List.head model.routeStack ? NotFoundRoute of
        DashboardR ->
            wrapH <| text "Not found"

        -- html <| div [] <| dashboardH model
        DemocracyListR ->
            wrapH <| text "Not found"

        -- html <| div [] <| democracyListH model
        DemocracyR democracyId ->
            democracyH democracyId model

        VoteR ballotId ->
            voteH ballotId model

        ResultsR ballotId ->
            resultsH ballotId model

        CreateDemocracyR ->
            wrapH <| text "Not found"

        -- html <| div [] <| createDemocracyH
        CreateVoteR democracyId ->
            wrapH <| text "Not found"

        -- html <| div [] <| createBallotH democracyId model
        EditVoteR ballotId ->
            wrapH <| text "Not found"

        -- html <| div [] <| editBallotH ballotId model
        NotFoundRoute ->
            wrapH <| text "Not found"
