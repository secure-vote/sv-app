module AdminViews.CreateDemocracyV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Dict
import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class)
import Material.Layout as Layout
import Material.Options as Options exposing (cs, styled)
import Material.Textfield as Textf
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Msgs exposing (Msg(Mdl, NavigateBack, SetField))


-- Future Features
-- - Upload Logo
-- - Set who can propose votes


createDemocracyV : Model -> Html Msg
createDemocracyV model =
    let
        tf id label opts =
            Textf.render Mdl
                [ id ]
                model.mdl
                ([ Options.onInput <| SetField id
                 , Textf.value <| Dict.get id model.fields ? ""
                 , Textf.label label
                 , Textf.floatingLabel
                 , cs "db"
                 ]
                    ++ opts
                )
                []
    in
    div [ class "pa4" ]
        [ tf 23634563445 "Name" []
        , tf 56745674563 "Description" [ Textf.textarea ]
        , div [ class "mt4" ]
            [ btn 894823489 model [ SecBtn, Attr (class "ma3"), Click NavigateBack ] [ text "Cancel" ]
            , btn 894823489 model [ PriBtn, Attr (class "ma3"), Click NavigateBack ] [ text "Create" ]
            ]
        ]


createDemocracyH : List (Html msg)
createDemocracyH =
    [ Layout.title [] [ text "Create a Democracy" ] ]
