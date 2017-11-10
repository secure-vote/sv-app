module Msgs exposing (..)

import Material
import Routes exposing (DialogRoute)


type Msg
    = NoOp
    | Mdl (Material.Msg Msg)
    | SetDialog String (DialogRoute Msg)
