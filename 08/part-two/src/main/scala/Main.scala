import scala.io.Source
import scala.collection.mutable.HashMap
import scala.collection.mutable.ListBuffer
import scala.util.boundary, boundary.break

case class Directions(left: String, right: String)

@main def hello: Unit =
  val fileName = "./input"
  val fileContents = Source.fromFile(fileName).mkString

  val lineIter = fileContents.linesIterator
  val directionsLine = lineIter.next()
  // Skip the next empty line
  lineIter.next()

  val directionsMap = new HashMap[String, Directions]()
  val pattern = "(\\w+) = \\((\\w+), (\\w+)\\)".r
  lineIter.foreach { element =>
    val pattern(address, left, right) = element
    val directions = Directions(left, right)
    directionsMap += (address -> directions)
  }


  val keysEndingWithA = directionsMap.filterKeys(_.endsWith("A")).keys

  var allStepsTaken = ListBuffer[BigInt]()
  for (startAddress <- keysEndingWithA) {
//    println(s"Start address: $startAddress")
    val stepsTaken = countStepsTaken(directionsLine, directionsMap, startAddress)
    println(s"$stepsTaken Steps taken for $startAddress")
    allStepsTaken += BigInt(stepsTaken)
  }

  val overlap = findOverlap(allStepsTaken)
  println(s"The first overlap is at $overlap")


def countStepsTaken(directionsLine: String, directionsMap: HashMap[String, Directions], startAddress: String): Int = {
  var stepsTaken = 0
  var currentAddress = startAddress
  boundary:
    while(true) {
      for (directionCharacter <- directionsLine) {
//        println(s"Current Address: $currentAddress Next direction: $directionCharacter")
        if (currentAddress.endsWith("Z")) {
          break()
        } else {
          stepsTaken += 1
          val currentDirection = directionsMap(currentAddress)
          if (directionCharacter == 'L') {
            currentAddress = currentDirection.left
          } else {
            currentAddress = currentDirection.right
          }
        }
      }
    }

  stepsTaken
}

// Find overlap via LCM (Least Common Multiple)
def findOverlap(steps: ListBuffer[BigInt]): BigInt = {
 val lcm = steps.reduce((a, b) => (a * b) / a.gcd(b))
 lcm
}
