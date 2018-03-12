module Utils.Update exposing (..)

-- | do a sub update, provide msg wrapper, inner update function, the msg, the model, a function to update the outer model


doUpdate : (msg -> msgO) -> (msg -> model -> ( model, Cmd msg )) -> msg -> model -> (model -> modelO) -> ( modelO, Cmd msgO )
doUpdate fMsg fUpdate msg model wModel =
    let
        ( m_, cmd_ ) =
            fUpdate msg model

        -- So this is just a regular update function
    in
    wModel m_ ! [ Cmd.map fMsg cmd_ ]
