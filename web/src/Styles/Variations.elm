module Styles.Variations exposing (..)

import Color exposing (Color)


type Variation
    = TabBtnActive
    | NoTabRowBorder
    | IssueCardMod IssueCardStatus
    | VarColor Color
    | BoldT
    | BtnDisabled
    | BtnWarning
    | Caps
    | SmallFont
    | NGood
    | NBad


type IssueCardStatus
    = VoteDone
    | VoteWaiting
    | VoteFuture
    | IssuePast
