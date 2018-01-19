module Styles.Styles exposing (..)

import Style exposing (StyleSheet)


type StyleOption
    = SwmStyle
    | SvStyle


type SvClass
    = HeaderStyle
    | Heading
    | MenuBarHeading
    | SubH
    | SubSubH
    | FooterText
    | BigText
      -- MAX STYLES
    | ResultsBarGraph
    | ResultsSummary
    | ResultsColumn
    | DataParam
    | ParaS
    | SpinnerS
      -- END MAX
    | RegText
    | Error
    | TabRow
    | TabBtn
    | IssueList
    | IssueCard
    | IssueCardResults
    | CardFooter
    | VoteList
    | DialogBackdrop
    | DialogStyle
      -- TOM STYLES
    | BtnS
    | InputS
      -- END TOM
    | NilS
