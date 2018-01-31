module Components.TextF exposing (..)

import Element exposing (el, text)
import Element.Attributes exposing (class, fill, width)
import Element.Input as Input exposing (Option)
import Helpers exposing (getField)
import Models exposing (Model)
import Msgs exposing (Msg(NoOp, SetField))
import Styles.Styles exposing (SvClass(InputS, NilS))
import Styles.Variations exposing (Variation)
import Views.ViewHelpers exposing (SvElement)


textF : String -> String -> Options -> Model -> SvElement
textF name labelText opts model =
    el NilS [ class "field" ] <|
        Input.text InputS
            []
            { onChange = SetField name
            , value = getField name model
            , label = Input.labelAbove (text labelText)
            , options = opts
            }


type alias Options =
    List (Option SvClass Variation Msg)



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
