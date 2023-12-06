open System.IO

let filePath = "./input"

let readLines (filePath:string) = seq {
    use sr = new StreamReader (filePath)
    while not sr.EndOfStream do
        yield sr.ReadLine ()
}

let lines = Seq.toList(readLines(filePath))

let timesString = lines[0]
let distancesString = lines[1]

let makeValuesSequence (input: string) =
    input.Split [|' '|]
      |> Seq.skip 1
      |> Seq.filter (fun x -> x <> "")
      |> Seq.map int

let checkIfRaceIsWon (raceTimeRecord: int) (raceDistance: int) (buttonHeldTime:int)  =
  if buttonHeldTime = 0 then
      false
  else
      let speed = buttonHeldTime
      let distance = speed * (raceTimeRecord - buttonHeldTime)
      if distance > raceDistance then
          true
      else
          false

let checkPossibleButtonHeldTimes (raceTimeRecord, raceDistance) =
   let rec checkTimes time count =
       if time > raceTimeRecord then
           count
       else
           if checkIfRaceIsWon raceTimeRecord raceDistance time then
               checkTimes (time + 1) (count + 1)
           else
               checkTimes (time + 1) count
   checkTimes 0 0


let timeSeq = makeValuesSequence(timesString)
let distanceSeq = makeValuesSequence(distancesString)

let timeDistancePairSeq = Seq.zip timeSeq distanceSeq

// let timeArr = Seq.toList timeDistancePairSeq
// printfn "%A" timeArr

let raceResult = timeDistancePairSeq |> Seq.toList |> List.map checkPossibleButtonHeldTimes |> List.reduce (*)
printfn "%i" raceResult

// let raceResult = checkPossibleButtonHeldTimes (7, 9)
// printfn "%i" raceResult
//
// let raceResult = checkPossibleButtonHeldTimes (15, 40)
// printfn "%i" raceResult
//
// let raceResult = checkPossibleButtonHeldTimes (30, 200)
// printfn "%i" raceResult
