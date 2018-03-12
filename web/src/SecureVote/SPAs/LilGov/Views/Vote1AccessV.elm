module SecureVote.SPAs.LilGov.Views.Vote1AccessV exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (para)
import SecureVote.SPAs.LilGov.Models exposing (Model)
import SecureVote.SPAs.LilGov.Views.ViewHelpers exposing (SvElement)
import Styles.SV exposing (scaled)
import Styles.Styles exposing (SvClass(..))


voteAccessView : Model -> SvElement
voteAccessView model =
    column NilS
        [ spacing (scaled 2) ]
        [ el SubH [] (text "Participate in a vote")
        , para [] "Enter your access token below, or scan a QR code to access your vote or community"
        , el SubSubH [] (text "Access token")
        ]
