module Eval.Try exposing
  ( field
  , string
  , char
  , int
  , float
  , bool
  , list
  , listString
  , listInt
  , listFloat
  , listBool
  , listList
  , listTuple2
  , listTuple3
  , listDict
  , array
  , setString
  , setChar
  , setInt
  , setFloat
  , dict
  , empty
  , singleton
  , tuple2
  , tuple3
  )


import Array exposing (Array)
import Set exposing (Set)
import Dict exposing (Dict)
import Json.Encode as Encode exposing (Value)
import Json.Decode as Decode


field : String -> Value -> Maybe Value
field key =
  Decode.decodeValue (Decode.field key Decode.value)
    >> Result.toMaybe


string : Value -> Maybe String
string =
  Decode.decodeValue Decode.string
    >> Result.toMaybe


char : Value -> Maybe Char
char =
  let
    singleChar s =
      case (s |> String.toList) of
        first :: [] ->
          Just first
        _ ->
          Nothing

  in
    Decode.decodeValue Decode.string
      >> Result.toMaybe
      >> Maybe.andThen singleChar


int : Value -> Maybe Int
int =
  Decode.decodeValue Decode.int
    >> Result.toMaybe


float : Value -> Maybe Float
float =
  Decode.decodeValue Decode.float
    >> Result.toMaybe


bool : Value -> Maybe Bool
bool =
  Decode.decodeValue Decode.bool
    >> Result.toMaybe

list : Value -> Maybe (List Value)
list =
  Decode.decodeValue (Decode.list Decode.value)
    >> Result.toMaybe


listString : Value -> Maybe (List String)
listString =
  Decode.decodeValue (Decode.list Decode.string)
    >> Result.toMaybe


listInt : Value -> Maybe (List Int)
listInt =
  Decode.decodeValue (Decode.list Decode.int)
    >> Result.toMaybe


listFloat : Value -> Maybe (List Float)
listFloat =
  Decode.decodeValue (Decode.list Decode.float)
    >> Result.toMaybe


listBool : Value -> Maybe (List Bool)
listBool =
  Decode.decodeValue (Decode.list Decode.bool)
    >> Result.toMaybe


listList : Value -> Maybe (List (List Value))
listList =
  Decode.decodeValue (Decode.list (Decode.list Decode.value))
    >> Result.toMaybe


listTuple2 : Value -> Maybe (List (Value, Value))
listTuple2 =
  let
    resolveMaybes ls =
      case (ls |> List.member Nothing) of
        True ->
          Nothing

        False ->
          ls
            |> List.map (Maybe.withDefault (Encode.null, Encode.null))
            |> Just

  in
    listList
      >> Maybe.map (List.map tuple2)
      >> Maybe.andThen resolveMaybes


listTuple3 : Value -> Maybe (List (Value, Value, Value))
listTuple3 =
  let
    resolveMaybes ls =
      case (ls |> List.member Nothing) of
        True ->
          Nothing

        False ->
          ls
            |> List.map (Maybe.withDefault (Encode.null, Encode.null, Encode.null))
            |> Just

  in
    listList
      >> Maybe.map (List.map tuple3)
      >> Maybe.andThen resolveMaybes


listDict : Value -> Maybe (List (Dict String Value))
listDict =
  Decode.decodeValue (Decode.list (Decode.dict Decode.value))
    >> Result.toMaybe


array : Value -> Maybe (Array Value)
array =
  Decode.decodeValue (Decode.array Decode.value)
    >> Result.toMaybe


setString : Value -> Maybe (Set String)
setString =
  Decode.decodeValue (Decode.list Decode.string)
    >> Result.toMaybe
    >> Maybe.map Set.fromList


setChar : Value -> Maybe (Set Char)
setChar =
  let
    resolveMaybes ls =
      case (ls |> List.member Nothing) of
        True ->
          Nothing

        False ->
          ls
            |> List.map (Maybe.withDefault '!')
            |> Just

  in
    Decode.decodeValue (Decode.list (Decode.value |> Decode.map char))
      >> Result.toMaybe
      >> Maybe.andThen resolveMaybes
      >> Maybe.map Set.fromList


setInt : Value -> Maybe (Set Int)
setInt =
  Decode.decodeValue (Decode.list Decode.int)
    >> Result.toMaybe
    >> Maybe.map Set.fromList


setFloat : Value -> Maybe (Set Float)
setFloat =
  Decode.decodeValue (Decode.list Decode.float)
    >> Result.toMaybe
    >> Maybe.map Set.fromList


dict : Value -> Maybe (Dict String Value)
dict =
  Decode.decodeValue (Decode.dict Decode.value)
    >> Result.toMaybe


--- List Helpers

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
