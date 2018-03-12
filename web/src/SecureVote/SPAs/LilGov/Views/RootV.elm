module SecureVote.SPAs.LilGov.Views.RootV exposing (..)

--import AdminViews.CreateDemocracyV exposing (createDemocracyH, createDemocracyV)
--import Views.DashboardV exposing (dashboardH, dashboardV)
--import Views.DemocracyListV exposing (democracyListH, democracyListV)

import Components.Btn exposing (BtnProps(Attr, Click), btn)
import Components.Dialog exposing (dialog)
import Components.Icons exposing (IconSize(I24, I36), mkIcon)
import Components.Navigation exposing (CommonRoute(NotFoundRoute), NavMsg(..))
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (card)
import Html as H exposing (Html, div, i, node, span)
import Html.Attributes as HA
import Maybe.Extra exposing ((?))
import SecureVote.SPAs.LilGov.Models exposing (Model)
import SecureVote.SPAs.LilGov.Msgs exposing (..)
import SecureVote.SPAs.LilGov.Routes exposing (LilGovRoute(..))
import SecureVote.SPAs.LilGov.Views.LoginV exposing (loginV)
import SecureVote.SPAs.LilGov.Views.ViewHelpers exposing (notFoundView)
import SecureVote.SPAs.LilGov.Views.Vote1AccessV exposing (voteAccessView)
import Styles.GenStyles exposing (genStylesheet)
import Styles.SV exposing (scaled)
import Styles.Styles exposing (StyleOption(SvStyle, SwmStyle), SvClass(..))


rootView : Model -> Html Msg
rootView model =
    let
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

        --        debug =
        --            if List.head model.routeStack == Just DebugR then
        --                [ empty ]
        --            else
        --                [ btn [ Click <| Nav <| NTo DebugR ] (mkIcon "alert-circle-outline" I24) ]header
        body =
            case List.head model.navModel.routeStack ? CR NotFoundRoute of
                LoginR ->
                    loginV model

                Vote1AccessR ->
                    voteAccessView model

                CR NotFoundRoute ->
                    notFoundView

        headerRow =
            when (List.length model.navModel.routeStack > 1) <|
                within [ image NilS [ center, verticalCenter, width (px 27), height (px 29) ] { src = "img/svlogo-white-small.png", caption = "SV Logo" } ] <|
                    row HeaderS
                        [ padding (scaled 2), width fill ]
                        [ btn [ Click <| Nav <| NBack ] (mkIcon "arrow-left" I24)
                        ]

        --        showDialog =
        --            if model.showDialog then
        --                [ dialog model ]
        --            else
        --                []
        mainLayout =
            column Body
                [ center, width fill ]
                [ headerRow
                , el NilS [ maxWidth <| px (scaled 9) ] body
                ]

        --                |> within showDialog
    in
    H.div [] [ injectCss, layout (genStylesheet SvStyle) mainLayout ]
