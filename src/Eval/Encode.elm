module Eval.Encode exposing
  ( value
  , string
  , int
  , float
  , bool
  , tuple2
  , tuple3
  , list
  , array
  , listString
  , listInt
  , listFloat
  , listBool
  , listList
  , listTuple2
  , listTuple3
  , setString
  , setChar
  , setInt
  , setFloat
  )


import Array exposing (Array)
import Set exposing (Set)
import Dict exposing (Dict)
import Json.Encode as Encode exposing (Value)


value : Value -> Value
value v =
  v


string : String -> Value
string =
  Encode.string


int : Int -> Value
int =
  Encode.int


float : Float -> Value
float =
  Encode.float


bool : Bool -> Value
bool =
  Encode.bool


tuple2 : (a -> Value, b -> Value) -> (a, b) -> Value
tuple2 (da, db) (a, b) =
  [da a, db b]
    |> Encode.list (\v -> v)


tuple3 : (a -> Value, b -> Value, c -> Value) -> (a, b, c) -> Value
tuple3 (da, db, dc) (a, b, c) =
  [da a, db b, dc c]
    |> Encode.list (\v -> v)


list : List Value -> Value
list =
  Encode.list (\v -> v)


array : Array Value -> Value
array =
  Encode.array (\v -> v)


listString : List String -> Value
listString =
  Encode.list Encode.string


listInt : List Int -> Value
listInt =
  Encode.list Encode.int


listFloat : List Float -> Value
listFloat =
  Encode.list Encode.float


listBool : List Bool -> Value
listBool =
  Encode.list Encode.bool


listList : List (List Value) -> Value
listList =
  Encode.list (Encode.list (\v -> v))


listTuple2 : (a -> Value, b -> Value) -> List (a, b) -> Value
listTuple2 (da, db) =
  Encode.list (\(a,b) -> [da a, db b] |> Encode.list (\v -> v))


listTuple3 : (a -> Value, b -> Value, c -> Value) -> List (a, b, c) -> Value
listTuple3 (da, db, dc) =
  Encode.list (\(a,b,c) -> [da a, db b, dc c] |> Encode.list (\v -> v))


setString : Set String -> Value
setString =
  Encode.set Encode.string


setChar : Set Char -> Value
setChar =
  Encode.set (String.fromChar >> Encode.string)


setInt : Set Int -> Value
setInt =
  Encode.set Encode.int


setFloat : Set Float -> Value
setFloat =
  Encode.set Encode.float
