module Styles.Variations exposing (..)

import Color exposing (Color)


type Variation
    = SecBtn
    | DisabledBtn
    | TabBtnActive
    | NoTabRowBorder
    | IssueCardMod IssueCardStatus
    | VarColor Color
    | BoldT
    | Disabled


type IssueCardStatus
    = VoteDone
    | VoteWaiting
    | VoteFuture
    | IssuePast
