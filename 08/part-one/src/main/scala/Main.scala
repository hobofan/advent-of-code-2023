import scala.io.Source
import scala.collection.mutable.HashMap
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

  var stepsTaken = 0
  var currentAddress = "AAA"
  boundary:
    while(true) {
      for (directionCharacter <- directionsLine) {
        println(s"Current Address: $currentAddress Next direction: $directionCharacter")
        if (currentAddress == "ZZZ") {
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

  println(stepsTaken)
