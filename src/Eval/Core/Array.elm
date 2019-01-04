module Eval.Core.Array exposing
  ( lib )


-- Project
import Eval.Function exposing (Function(..))
import Eval.Try as Try
import Eval.Wrap as Wrap
import Eval.Core.Error as Error

-- Core
import Array
import Json.Decode exposing (Value)
import Json.Encode as Encode


lib : String -> Result String Function
lib fName =
  case fName of
    "empty" ->
      Wrap.a0 (\() -> Array.empty) (Encode.array (\v -> v))
        |> F0
        |> Ok

    "initialize" ->
      Err (Error.noFunction fName)

    "repeat" ->
      Wrap.a2 Array.repeat (Try.int, Just) (Encode.array (\v -> v)) (Error.expected fName "[integer, any]")
        |> F2
        |> Ok

    "fromList" ->
      Wrap.a1 Array.fromList Try.list (Encode.array (\v -> v)) (Error.expected fName "[array]")
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
                  |> Encode.array (\v -> v)
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
      Wrap.a2 Array.push (Just, Try.array) (Encode.array (\v -> v)) (Error.expected fName "[any, array]")
        |> F2
        |> Ok

    "append" ->
      Wrap.a2 Array.append (Try.array, Try.array) (Encode.array (\v -> v)) (Error.expected fName "[array, array]")
        |> F2
        |> Ok

    "slice" ->
      Wrap.a3 Array.slice (Try.int, Try.int, Try.array) (Encode.array (\v -> v)) (Error.expected fName "[integer, integer, array]")
        |> F3
        |> Ok

    _ ->
      Err (Error.notFound "Array" fName)
