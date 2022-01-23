module App.Program

open System
open System.Reflection
open System.Runtime.InteropServices

let version = lazy (Assembly.GetExecutingAssembly().GetName().Version)

[<EntryPoint>]
let main args =
    try
        printfn "Version: %A" version.Value
        printfn "OS: %A" Environment.OSVersion
        printfn "Architecture: %A" RuntimeInformation.ProcessArchitecture
        printfn "Args: %A" args

        0
    with
    | e ->
        eprintfn "%A" e
        1
