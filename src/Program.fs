module App.Program

open System

[<EntryPoint>]
let main args =
    printfn "Hello %A" Environment.OSVersion

    0
