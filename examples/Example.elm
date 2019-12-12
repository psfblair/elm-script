port module Example exposing (handleError, program)

import Json.Encode exposing (Value)
import Script exposing (Script)


handleError : (x -> String) -> x -> Script Int a
handleError toMessage error =
    Script.printLine ("[SCRIPT ERROR] " ++ toMessage error)
        |> Script.andThen (\() -> Script.fail 1)


port requestPort : Value -> Cmd msg


port responsePort : (Value -> msg) -> Sub msg


program :
    (List String
     -> Script.WorkingDirectory
     -> Script.Host
     -> Script.UserPrivileges
     -> Script Int ()
    )
    -> Script.Program
program script =
    Script.program script requestPort responsePort
