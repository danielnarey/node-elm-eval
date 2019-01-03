port module Main exposing (main)

-- Project
import Eval
import Eval.Call exposing (Call)

-- Core
import Platform.Sub
import Json.Encode as Encode exposing (Value)


port incoming : (Value -> msg) -> Sub msg


port outgoing : Value -> Cmd msg


type Msg
  = Receive Value


main : Program () (Maybe Call) Msg
main =
  { init = \() ->
      (Nothing, Cmd.none)

  , update = \(Receive object) _ ->
      object
        |> Eval.parse
        |> (\r -> (r, r))
        |> Tuple.mapBoth Just (Eval.call Eval.coreLib >> encodeResult >> outgoing)

  , subscriptions = \_ ->
      incoming Receive
        |> List.singleton
        |> Platform.Sub.batch

  }
    |> Platform.worker


encodeResult : Result String Value -> Value
encodeResult result =
  case result of
    Ok value ->
      [ ("resolve", True |> Encode.bool)
      , ("value", value)
      , ("error", Encode.null)
      ]
        |> Encode.object

    Err message ->
      [ ("resolve", False |> Encode.bool)
      , ("value", Encode.null)
      , ("error", message |> Encode.string)
      ]
        |> Encode.object
