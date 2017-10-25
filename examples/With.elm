port module Main exposing (..)

import Json.Encode exposing (Value)
import Script exposing (Script)
import Time


computeProduct : Script x Int
computeProduct =
    Script.with (Script.succeed 3)
        |> Script.andWith (Script.succeed "four")
        |> Script.andWith (Script.succeed [ 1, 2, 3, 4, 5 ])
        |> Script.return
            (\number string list ->
                number * String.length string * List.length list
            )


script : Script.Context -> Script Int ()
script context =
    Script.with computeProduct
        |> Script.andWith Script.getCurrentTime
        |> Script.yield
            (\product time ->
                Script.do
                    [ Script.print ("Product: " ++ toString product)
                    , Script.print
                        ("Current time: " ++ toString (Time.inSeconds time))
                    ]
            )


port requestPort : Value -> Cmd msg


port responsePort : (Value -> msg) -> Sub msg


main : Script.Program
main =
    Script.program script requestPort responsePort
