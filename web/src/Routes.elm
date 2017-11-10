module Routes exposing (..)


type Route
    = DashboardR
    | DemocracyListR
    | DemocracyR
    | VoteR


type DialogRoute msg
    = VoteConfirmationDialog
    | NotFoundDialog
