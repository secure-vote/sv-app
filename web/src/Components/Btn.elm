module Components.Btn exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class, target)
import Material.Button as Button
import Material.Dialog as Dialog
import Material.Options as Options exposing (cs, css)
import Models exposing (Model)
import Msgs exposing (Msg(Mdl))


type BtnProps
    = PriBtn
    | SecBtn
    | Flat
    | Icon
    | Click Msg
    | Link String
    | Disabled
    | OpenDialog
    | CloseDialog
    | BtnNop -- doesn't do anything
    | Opt (Button.Property Msg)
    | Attr (Html.Attribute Msg)


btn : Int -> Model -> List BtnProps -> List (Html Msg) -> Html Msg
btn id model props inner =
    let
        btnPropToAttr prop =
            case prop of
                PriBtn ->
                    ( [], [ Button.colored, Button.raised, Button.ripple ] )

                SecBtn ->
                    ( [], [ Button.plain, Button.raised, Button.ripple ] )

                Flat ->
                    ( [], [ Button.flat, Button.ripple ] )

                Icon ->
                    ( [], [ Button.icon ] )

                Click msg ->
                    ( [], [ Options.onClick msg ] )

                Link url ->
                    ( [], [ Button.link url, Options.attribute <| target "_blank" ] )

                Disabled ->
                    ( [], [ Button.disabled ] )

                BtnNop ->
                    ( [], [] )

                OpenDialog ->
                    ( [], [ Dialog.openOn "click" ] )

                CloseDialog ->
                    ( [], [ Dialog.closeOn "click" ] )

                Opt opt ->
                    ( [], [ opt ] )

                Attr attr ->
                    ( [ attr ], [] )

        f btnProp ( attrs, opts ) =
            let
                ( newAttrs, newOpts ) =
                    btnPropToAttr btnProp
            in
            ( attrs ++ newAttrs, opts ++ newOpts )

        ( attrs, opts ) =
            List.foldl f ( [], [] ) props
    in
    div attrs
        [ Button.render Mdl [ id ] model.mdl opts inner
        ]
