module Views.RootLilGovV exposing (..)

--import AdminViews.CreateDemocracyV exposing (createDemocracyH, createDemocracyV)
--import Views.DashboardV exposing (dashboardH, dashboardV)
--import Views.DemocracyListV exposing (democracyListH, democracyListV)

import Components.Btn exposing (BtnProps(Click), btn)
import Components.Dialog exposing (dialog)
import Components.Icons exposing (IconSize(I24, I36), mkIcon)
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (card)
import Html as H exposing (Html, div, i, node, span)
import Html.Attributes as HA
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Msgs exposing (..)
import Routes exposing (DialogRoute(UserInfoD), Route(..))
import Styles.GenStyles exposing (genStylesheet)
import Styles.Styles exposing (StyleOption(SvStyle, SwmStyle), SvClass(..))
import Styles.Swarm exposing (scaled)
import Views.CreateBallotV exposing (createBallotV)
import Views.DebugV exposing (debugV)
import Views.DemocracyV exposing (democracyV)
import Views.EditBallotV exposing (editBallotV)
import Views.LoginV exposing (loginV)
import Views.PetitionsV exposing (petitionsV)
import Views.ResultsV exposing (resultsV)
import Views.ViewHelpers exposing (SvElement, cssSpinner, nilView, notFoundView)
import Views.VoteV exposing (voteV)


rootLilGovView : Model -> Html Msg
rootLilGovView model =
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

        debug =
            if List.head model.routeStack == Just DebugR then
                [ empty ]
            else
                [ btn [ Click <| Nav <| NTo DebugR ] (mkIcon "alert-circle-outline" I24) ]

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

                -- createDemocracyV model
                CreateBallotR democracyId ballotId ->
                    createBallotV democracyId ballotId model

                EditBallotR ballotId ->
                    editBallotV ballotId model

                PetitionsR ->
                    petitionsV model

                DebugR ->
                    debugV model

                LoginR ->
                    loginV model

                NotFoundRoute ->
                    notFoundView

        headerRow =
            if List.length model.routeStack > 1 then
                row HeaderStyle
                    [ spacing (scaled 2), spread ]
                    [ row NilS [ width fill, alignLeft, padding (scaled 1) ] <| [ btn [ Click <| Nav <| NBack ] (mkIcon "arrow-left" I24) ] ++ hLeft
                    , row MenuBarHeading [ width fill, padding (scaled 1), center ] hCenter
                    , row NilS [ width fill, alignRight ] <| hRight ++ debug
                    ]
            else
                empty

        showDialog =
            if model.showDialog then
                [ dialog model ]
            else
                []

        showAdmin =
            if model.isAdmin then
                admin
            else
                empty

        mainLayout =
            column Body
                [ spacing (scaled 4) ]
                [ showAdmin
                , headerRow
                , body
                ]
                |> within showDialog
    in
    H.div [] [ injectCss, layout (genStylesheet SvStyle) mainLayout ]
