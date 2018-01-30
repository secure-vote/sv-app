module Components.TextF exposing (..)

import Element exposing (el, text)
import Element.Attributes exposing (class, fill, width)
import Element.Input as Input
import Helpers exposing (getField)
import Models exposing (Model)
import Msgs exposing (Msg(NoOp, SetField))
import Styles.Styles exposing (SvClass(InputS, NilS))
import Views.ViewHelpers exposing (SvElement)


textF : String -> String -> Model -> SvElement
textF name labelText model =
    el NilS [ class "field" ] <|
        Input.text InputS
            []
            { onChange = SetField name
            , value = getField name model
            , label = Input.labelAbove (text labelText)
            , options = []
            }



-- Material
--textF : Int -> String -> List (Options.Property (Textf.Config Msg) Msg) -> Model -> Html Msg
--textF id label opts model =
--    Textf.render Mdl
--        [ id ]
--        model.mdl
--        ([ Options.onInput <| SetField id
--         , Textf.value <| Dict.get id model.fields ? ""
--         , Textf.label label
--         , Textf.floatingLabel
--         , cs "db"
--         ]
--            ++ opts
--        )
--        []
