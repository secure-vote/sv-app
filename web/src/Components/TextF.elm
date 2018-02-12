module Components.TextF exposing (..)

import Element exposing (el, node, text)
import Element.Attributes exposing (attribute, class, fill, width)
import Element.Events exposing (onInput)
import Element.Input as Input exposing (Option, errorBelow)
import Helpers exposing (getField)
import Models exposing (Model)
import Msgs exposing (Msg(NoOp, SetField))
import Styles.Styles exposing (SvClass(InputS, NilS))
import Styles.Variations exposing (Variation)
import Views.ViewHelpers exposing (SvAttribute, SvElement)


type TfProps
    = Disabled Bool
    | BtnNop -- doesn't do anything


type TfType
    = Text
    | Date
    | Number


type alias TextField =
    { id : String
    , type_ : TfType
    , label : String
    , props : List TfProps
    , validation : List ( Bool, String )
    }


textF : Model -> TextField -> SvElement
textF model tf =
    let
        value =
            getField tf.id model

        isError ( bool, msg ) =
            if bool then
                Just (errorBelow (text msg))
            else
                Nothing

        validation =
            List.filterMap isError tf.validation

        btnPropToOpts prop =
            case prop of
                Disabled bool ->
                    if bool then
                        [ Input.disabled ]
                    else
                        []

                _ ->
                    []

        f btnProp opts =
            opts ++ btnPropToOpts btnProp

        opts =
            List.foldl f [] tf.props ++ validation
    in
    --    TODO: Date and Number Fields need Labels and Error Messages
    el NilS [ class "field" ] <|
        case tf.type_ of
            Date ->
                node "input" <|
                    el NilS
                        [ attribute "type" "datetime-local"
                        , attribute "value" value
                        , onInput (SetField tf.id)
                        ]
                        (text tf.label)

            Number ->
                node "input" <|
                    el NilS
                        [ attribute "type" "number"
                        , attribute "value" value
                        , onInput (SetField tf.id)
                        ]
                        (text tf.label)

            Text ->
                Input.text InputS
                    []
                    { onChange = SetField tf.id
                    , value = value
                    , label = Input.labelAbove (text tf.label)
                    , options = opts
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
