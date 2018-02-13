port module Ports exposing (..)

import Json.Decode exposing (Value)


-------------------------------
-- Add data to the blockchain
-------------------------------
-- Send data is of the format (ReferenceId, Data)


port send : ( String, String ) -> Cmd msg



-- Receipt data is of the format (ReferenceId, TxId)


port receipt : (( String, String ) -> msg) -> Sub msg



-- Confirmation data is of the format (ReferenceId)


port confirmation : (String -> msg) -> Sub msg



-------------------------------
-- Get data from the blockchain
-------------------------------
-- get data is of the format (TxId)


port get : String -> Cmd msg



-- Receive data is of the format (data)


port receive : (String -> msg) -> Sub msg



-- Local Storage Ports


port writeLocalStorageImpl : { key : String, value : String } -> Cmd msg


port readLocalStorageImpl : String -> Cmd msg


port gotLocalStorageImpl : ({ key : String, value : String } -> msg) -> Sub msg
