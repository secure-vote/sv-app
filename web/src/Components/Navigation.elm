module Components.Navigation exposing (..)

import Maybe.Extra exposing ((?))


type alias NavModel r =
    { routeStack : List r }


initNavModel r =
    { routeStack = [ r ]
    }


type CommonRoute
    = NotFoundRoute


type NavMsg r
    = NBack
    | NHome
    | NTo r
    | NBackTo r


navUpdate : (CommonRoute -> r) -> NavMsg r -> NavModel r -> ( NavModel r, Cmd (NavMsg r) )
navUpdate w msg model =
    case msg of
        NBack ->
            { model | routeStack = List.tail model.routeStack ? [ w NotFoundRoute ] } ! []

        NHome ->
            { model | routeStack = List.drop (List.length model.routeStack - 1) model.routeStack } ! []

        NTo newRoute ->
            { model | routeStack = newRoute :: model.routeStack } ! []

        NBackTo oldRoute ->
            let
                findRoute routeStack =
                    if List.head routeStack == Just oldRoute then
                        routeStack
                    else
                        findRoute <| List.tail routeStack ? []
            in
            { model | routeStack = findRoute model.routeStack } ! []
