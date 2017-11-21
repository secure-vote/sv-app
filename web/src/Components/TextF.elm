module Components.TextF exposing (..)

import Dict
import Html exposing (Html)
import Material.Options as Options exposing (cs, styled)
import Material.Textfield as Textf
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Msgs exposing (Msg(Mdl, SetField))


--textF : Int -> String -> List (Options.Property (Textf.Config Msg) Msg) -> Model -> Html Msg


textF id label opts model =
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
