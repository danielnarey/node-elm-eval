module Eval.Try.List exposing
  ( empty
  , singleton
  , tuple2
  , tuple3
  )


-- Core
import Json.Decode as Decode
import Json.Encode exposing (Value)


empty : List Value -> Maybe ()
empty ls =
  case ls of
    [] ->
      Just ()

    _ ->
      Nothing


singleton : List Value -> Maybe Value
singleton ls =
  case ls of
    first :: [] ->
      Just first

    _ ->
      Nothing


tuple2 : List Value -> Maybe (Value, Value)
tuple2 ls =
  case (ls, ls |> List.drop 1) of
    (first :: rest, second :: []) ->
      Just (first, second)

    (_, _) ->
      Nothing


tuple3 : List Value -> Maybe (Value, Value, Value)
tuple3 ls =
  case (ls, ls |> List.drop 1, ls |> List.drop 2) of
    (first :: slice1, second :: slice2, third :: []) ->
      Just (first, second, third)

    (_, _, _) ->
      Nothing
