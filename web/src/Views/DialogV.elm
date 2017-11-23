module Views.DialogV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.TextF exposing (textF)
import Helpers exposing (getAdminToggle)
import Html exposing (Html, div, p, table, td, text, tr)
import Html.Attributes exposing (class)
import Material.Options as Options exposing (cs, styled)
import Material.Toggles as Toggles
import Material.Typography as Typo exposing (title)
import Models exposing (Model, adminToggleId)
import Msgs exposing (Msg(Mdl, NavigateBack, ToggleBoolField))


subhead : String -> Html Msg
subhead s =
    styled div [ title, cs "black db mv3" ] [ text s ]


subsubhead : String -> Html Msg
subsubhead s =
    styled div [ Typo.subhead, cs "black db mv3" ] [ text s ]


confirmationDialogV : Model -> Html Msg
confirmationDialogV model =
    let
        row item =
            tr []
                [ td [] [ text item.name ]
                , td [] [ text "3" ]
                ]
    in
    div []
        [ p [] [ text "Please confirm that your vote details below are correct." ]
        , table [] <| List.map row sampleBallot.options
        , div [ class "tr mt3" ]
            [ btn 976565675 model [ SecBtn, CloseDialog, Attr (class "ma2 dib") ] [ text "Close" ]
            , btn 463467465 model [ PriBtn, CloseDialog, Attr (class "ma2 dib"), Click NavigateBack ] [ text "Yes" ]
            ]
        ]


ballotInfoDialogV : String -> Html Msg
ballotInfoDialogV desc =
    text desc


ballotOptionDialogV : String -> Html Msg
ballotOptionDialogV desc =
    text desc


democracyInfoDialogV : String -> Html Msg
democracyInfoDialogV desc =
    text desc


userInfoDialogV : Model -> Html Msg
userInfoDialogV model =
    div []
        [ Toggles.switch Mdl
            [ adminToggleId ]
            model.mdl
            [ Options.onToggle <| ToggleBoolField adminToggleId
            , Toggles.ripple
            , Toggles.value <| getAdminToggle model
            ]
            [ text "Admin User" ]
        ]


memberInviteDialogV : Model -> Html Msg
memberInviteDialogV model =
    div []
        [ text "Invite via email"
        , textF 788765454534 "Seperate addresses with a coma" [] model
        , text "Or Upload a CSV"
        , btn 4356373453 model [ SecBtn, Attr (class "db") ] [ text "Choose a file" ]
        ]


sampleBallot =
    { name = "Token Release Schedule"
    , desc = "This vote is to determine the release schedule of the SWM token."
    , options =
        [ { id = 12341234123, name = "8 releases of 42 days", desc = "" }
        , { id = 64564746345, name = "42 releases of 8 days", desc = "" }
        , { id = 87967875645, name = "16 releases of 42 days", desc = "" }
        , { id = 23457478556, name = "4 releases of 84 days", desc = "" }
        ]
    , finish = "Vote Ends in 42 minutes"
    }
