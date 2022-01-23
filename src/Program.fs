module App.Program

open System
open System.Runtime.InteropServices

[<EntryPoint>]
let main args =
    printfn "OS: %A" Environment.OSVersion
    printfn "Architecture: %A" RuntimeInformation.ProcessArchitecture

    0
