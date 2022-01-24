module App.Tests.Program

open NUnit.Framework
open FsUnit
open FsCheck
open FsCheck.NUnit

open App.Program

let genInt = Arb.Default.Int32().Generator

let genTwoInts = genInt |> Gen.two

[<Test>]
let ``1 + 2 = 3`` () = add 1 2 |> should equal 3

[<Property>]
let ``addition`` () =
    let input = genTwoInts |> Arb.fromGen
    Prop.forAll input (fun (x, y) -> add x y |> should equal (x + y))
