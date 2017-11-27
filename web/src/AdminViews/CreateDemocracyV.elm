module AdminViews.CreateDemocracyV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.TextF exposing (textF)
import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class)
import Material.Layout as Layout
import Material.Textfield as Textf
import Models exposing (Model)
import Msgs exposing (Msg(Mdl, NavigateBack, SetField))


-- Future Features
-- - Upload Logo
-- - Set who can propose votes


createDemocracyV : Model -> Html Msg
createDemocracyV model =
    div [ class "pa4" ]
        [ textF 23634563445 "Name" [] model
        , textF 56745674563 "Description" [ Textf.textarea ] model
        , div [ class "mt4" ]
            [ btn 894823489 model [ SecBtn, Attr (class "ma3 dib"), Click NavigateBack ] [ text "Cancel" ]
            , btn 894823489 model [ PriBtn, Attr (class "ma3 dib"), Click NavigateBack ] [ text "Create" ]
            ]
        ]


createDemocracyH : List (Html msg)
createDemocracyH =
    [ Layout.title [] [ text "Create a Democracy" ] ]
