import Foundation
import PlaygroundSupport

struct Coordinate {
    var closestPoint: Int
}

struct Grid {
    var coordinates: [[Coordinate]]
}

func closestDistance(_ coordinate: (Int, Int), _ points: [(Int, Int)]) -> Int {
    // calculate manhattan distance to every point
    let distances: [Int] = points.map({
        distance($0, coordinate)
    })
    
    var shortestDistance = Int.max
    var closestPoint = -1
    for (index, distance) in distances.enumerated() {
        if(distance == shortestDistance) {
            closestPoint = -1
        } else if(distance < shortestDistance) {
            shortestDistance = distance
            closestPoint = index
        }
    }
    
    return closestPoint
}

func distance(_ a: (Int, Int), _ b: (Int, Int)) -> Int {
    return (abs(a.0 - b.0) + abs(a.1 - b.1))
}

let testFileUrl = playgroundSharedDataDirectory.appendingPathComponent("input_6.txt")

var fileContents: String?
do {
    fileContents = try String(contentsOf: testFileUrl)
} catch {
    print("Error reading contents: \(error)")
}

let lines: [String.SubSequence]?  = fileContents?.split(separator: "\n")

// parse point coordinates
let coordindates: [(Int, Int)] = lines!.map({
    let numbers = String($0).components(separatedBy: ", ")
    return (Int(numbers[0])!, Int(numbers[1])!)
})
print(coordindates)

// construct grid (find largest coordinates)
var largestCoordinates = coordindates.reduce((0, 0), {
    (max($0.0, $1.0), max($1.1, $1.1))
})
largestCoordinates = (largestCoordinates.0 + 2, largestCoordinates.1 + 2)

print(largestCoordinates)
var arr = Array(repeating: Array(repeating: Coordinate(closestPoint: -1), count: largestCoordinates.1), count: largestCoordinates.0)
var grid = Grid(coordinates: arr)

// calculate each coordinate distance to closest point
for (xIndex, x) in grid.coordinates.enumerated() {
    for (yIndex, _) in x.enumerated() {
        grid.coordinates[xIndex][yIndex] = Coordinate(closestPoint: closestDistance((xIndex, yIndex), coordindates))
//        print("\(xIndex) \(yIndex) \(grid.coordinates[xIndex][yIndex].closestPoint)")
    }
}

// count number of occurences
var occurences: [Int:Int] = [:] // coordindate to occurences
for x in grid.coordinates {
    for y in x {
        if(y.closestPoint != -1) {
            let count = occurences[y.closestPoint] ?? 0
            occurences[y.closestPoint] = count + 1
        }
    }
}
print(occurences)

// loop though occurences from highest to lowest
var myArr = Array(occurences.keys)
var sortedKeys = myArr.sorted(by: {
    let obj1 = occurences[$0]! // get ob associated w/ key 1
    let obj2 = occurences[$1]! // get ob associated w/ key 2
    return obj1 > obj2
})
print(sortedKeys)

// if occurence has a point on edge of the map then it is infinite and skip to the next one
func foundOnEdge(_ key: Int, _ map: Grid) -> Bool {
    for (xIndex, x) in map.coordinates.enumerated() {
        for (yIndex, y) in x.enumerated() {
            if(xIndex == 0 || yIndex == 0 || xIndex == largestCoordinates.0 - 1 || yIndex == largestCoordinates.1 - 1) {
                if(key == y.closestPoint) { // key is on the edge
                    return true
                }
            }
        }
    }
    return false
}

for key in sortedKeys {
    let edge = foundOnEdge(key, grid)
    print("\(key) is on edge \(edge)")
    if(!edge) {
        print("not infinite \(key) \(occurences[key]!)")
        break
    }
}

// print number of occurence for point
