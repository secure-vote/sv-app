port module Ports exposing (..)

import Json.Decode exposing (Value)


-------------------------------
-- Add data to the blockchain
-------------------------------
-- Send data is of the format (ReferenceId, Data)


port sendBcData : ( String, String ) -> Cmd msg



-- Receipt data is of the format (ReferenceId, TxId)


port receiptBcData : (( String, String ) -> msg) -> Sub msg



-- Confirmation data is of the format (ReferenceId)


port confirmBcData : (String -> msg) -> Sub msg



-------------------------------
-- Get data from the blockchain
-------------------------------
-- get data is of the format (TxId)


port getBcData : String -> Cmd msg



-- Receive data is of the format (data)


port receiveBcData : (String -> msg) -> Sub msg



-- Local Storage Ports


port writeLsImpl : { key : String, value : String } -> Cmd msg


port readLsImpl : String -> Cmd msg


port gotLsImpl : ({ key : String, value : String } -> msg) -> Sub msg
