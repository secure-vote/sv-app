module SecureVote.SPAs.LilGov.Views.LoginV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.Icons exposing (IconSize(I24), mkIcon, mkIconWLabel)
import Components.Navigation exposing (NavMsg(..))
import Element exposing (..)
import Element.Attributes exposing (..)
import SecureVote.SPAs.LilGov.Models exposing (Model)
import SecureVote.SPAs.LilGov.Msgs exposing (..)
import SecureVote.SPAs.LilGov.Routes exposing (LilGovRoute(Vote1AccessR))
import SecureVote.SPAs.LilGov.Views.ViewHelpers exposing (SvElement)
import Styles.SV exposing (scaled)
import Styles.Styles exposing (SvClass(NilS))


loginV : Model -> SvElement
loginV model =
    column NilS
        [ center, spacingXY 0 (scaled 2), padding (scaled 2) ]
        [ image NilS [ paddingXY 0 (scaled 6), width (px 275) ] { src = "img/svlogo-white.png", caption = "SecureVote Logo" }
        , btn [ PriBtn, Click <| Nav <| NTo Vote1AccessR ] (text "Participate in a vote")
        , btn [ SecBtn ] (text "Create a vote")
        , btn [ Text, Attr (padding (scaled 3)) ] <| mkIconWLabel "Been here before? Log in >" "account" I24
        ]
