module Routing exposing (..)

import Navigation exposing (Location)
import Routes exposing (Route(..))
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map DashboardR top
        , map DemocracyR (s "d" </> int)
        , map VoteR (s "v" </> int)
        , map DemocracyListR (s "d")
        , map CreateDemocracyR (s "create-democracy")
        , map CreateVoteR (s "create-vote" </> int)
        ]


parseLocation : Location -> Route
parseLocation location =
    case parseHash matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
