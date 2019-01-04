module Eval.Core.Array exposing
  ( lib )


-- Project
import Eval.Core.Error as Error
import Eval.Encode as Encode
import Eval.Function exposing (Function(..))
import Eval.Try as Try
import Eval.Wrap as Wrap

-- Core
import Array
import Json.Encode exposing (Value)


lib : String -> Result String Function
lib fName =
  case fName of
    "empty" ->
      Wrap.a0 (\() -> Array.empty) Encode.array
        |> F0
        |> Ok

    "initialize" ->
      Err (Error.noFunction fName)

    "repeat" ->
      Wrap.a2 Array.repeat (Try.int, Just) Encode.array (Error.expected fName "[integer, any]")
        |> F2
        |> Ok

    "fromList" ->
      Wrap.a1 Array.fromList Try.list Encode.array (Error.expected fName "[array]")
        |> F1
        |> Ok

    "isEmpty" ->
      Wrap.a1 Array.isEmpty Try.array Encode.bool (Error.expected fName "[array]")
        |> F1
        |> Ok

    "length" ->
      Wrap.a1 Array.length Try.array Encode.int (Error.expected fName "[array]")
        |> F1
        |> Ok

    "get" ->
      ( \(a, b) ->
        case (a |> Try.int, b |> Try.array) of
          (Just index, Just array) ->
            case (array |> Array.get index) of
              Just value ->
                Ok value

              Nothing ->
                Err (
                  "Can't get the element at index "
                  ++ (index |> String.fromInt)
                  ++ " from an array of length "
                  ++ (array |> Array.length |> String.fromInt)
                  ++ "."
                )

          (_, _) ->
            Err (Error.expected fName "[int, array]")

      )
        |> F2
        |> Ok

    "set" ->
      ( \(a, b, c) ->
        case (a |> Try.int, c |> Try.array) of
          (Just index, Just array) ->
            case (array |> Array.get index) of
              Just _ ->
                array
                  |> Array.set index b
                  |> Encode.array
                  |> Ok

              Nothing ->
                Err (
                  "Can't set the element at index "
                  ++ (index |> String.fromInt)
                  ++ " on an array of length "
                  ++ (array |> Array.length |> String.fromInt)
                  ++ "."
                )

          (_, _) ->
            Err (Error.expected fName "[int, any, array]")

      )
        |> F3
        |> Ok

    "push" ->
      Wrap.a2 Array.push (Just, Try.array) Encode.array (Error.expected fName "[any, array]")
        |> F2
        |> Ok

    "append" ->
      Wrap.a2 Array.append (Try.array, Try.array) Encode.array (Error.expected fName "[array, array]")
        |> F2
        |> Ok

    "slice" ->
      Wrap.a3 Array.slice (Try.int, Try.int, Try.array) Encode.array (Error.expected fName "[integer, integer, array]")
        |> F3
        |> Ok

    "toList" ->
      Wrap.a1 Array.toList Try.array Encode.list (Error.expected fName "[array]")
        |> F1
        |> Ok

    "toIndexedList" ->
      Wrap.a1 Array.toIndexedList Try.array (Encode.listTuple2 (Encode.int, Encode.value)) (Error.expected fName "[array]")
        |> F1
        |> Ok

    "map" ->
      Err (Error.noFunction fName)

    "indexedMap" ->
      Err (Error.noFunction fName)

    "foldl" ->
      Err (Error.noFunction fName)

    "foldr" ->
      Err (Error.noFunction fName)

    "filter" ->
      Err (Error.noFunction fName)

    _ ->
      Err (Error.notFound "Array" fName)
