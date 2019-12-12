module CreateTempDirectory exposing (main)

import Duration
import Example
import Script exposing (Script)
import Script.Directory as Directory
import Script.File as File


script :
    List String
    -> Script.WorkingDirectory
    -> Script.Host
    -> Script.UserPrivileges
    -> Script Int ()
script arguments workingDirectory host userPrivileges =
    Directory.createTemporary
        |> Script.andThen
            (\tempDirectory ->
                let
                    tempFile =
                        tempDirectory |> Directory.file "temp.txt"
                in
                File.writeTo tempFile "dummy contents"
            )
        |> Script.andThen (\() -> Script.sleep (Duration.seconds 10))
        |> Script.onError (Example.handleError .message)


main : Script.Program
main =
    Example.program script
