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
    input.Replace("Distance: ", "").Replace("Time: ", "").Replace(" ", "").Split [|' '|]
//       |> Seq.skip 1
      |> Seq.filter (fun x -> x <> "")
      |> Seq.map int64

let checkIfRaceIsWon (raceTimeRecord: int64) (raceDistance: int64) (buttonHeldTime:int64)  =
  if buttonHeldTime = 0 then
      false
  else
      let speed = buttonHeldTime
      let distance = speed * (raceTimeRecord - buttonHeldTime)
      if distance > raceDistance then
          true
      else
          false

let checkPossibleButtonHeldTimes (raceTimeRecord: int64, raceDistance: int64) =
   let rec checkTimes (time: int64) (count: int64) =
       if time > raceTimeRecord then
           count
       else
           if checkIfRaceIsWon raceTimeRecord raceDistance time then
               checkTimes (time + 1L) (count + 1L)
           else
               checkTimes (time + 1L) count
   checkTimes 0L 0L


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
