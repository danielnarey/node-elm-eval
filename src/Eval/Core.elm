module Eval.Core exposing
  ( lib )


-- Project
import Eval.Core.Array
import Eval.Core.Basics
import Eval.Core.Dict
import Eval.Core.List
import Eval.Core.Set
import Eval.Function exposing (Function(..))


{-| Given the name of a function in the Elm Core library, return an equivalent
function that takes one or more `Json` values as arguments and returns a `Json`
value
-}
lib : String -> Result String Function
lib expression =
  let
    parts =
      expression
        |> String.split "."

    (moduleName, fName) =
      case parts of
        [] ->
          ("Basics", "")
        first :: [] ->
          ("Basics", first)
        first :: rest ->
          (first, rest |> String.join ".")

  in
    case moduleName of
      "Basics" ->
        Eval.Core.Basics.lib fName

      "List" ->
        Eval.Core.List.lib fName

      "Array" ->
        Eval.Core.Array.lib fName

      "Set" ->
        Eval.Core.Set.lib fName

      "Dict" ->
        Eval.Core.Dict.lib fName

      _ ->
        Err (
          "A module named `"
          ++ moduleName
          ++ "` was not found in Elm's core libraries. "
          ++ "Note that Elm module names are always capitalized and that "
          ++ "module and function names should be separated by a single `.` "
          ++ "(example: `String.length`)."
        )
