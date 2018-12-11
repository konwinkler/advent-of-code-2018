import Foundation
import PlaygroundSupport

struct Point {
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func distance(_ other: Point) -> Int {
        return (abs(x - other.x) + abs(y - other.y))
    }
}

struct Coordinate {
    var closestPoint: Int
}

struct Grid {
    var coordinates: [[Coordinate]]
}

func closestDistance(_ coordinate: Point, _ points: [Point]) -> Int {
    // calculate manhattan distance to every point
    let distances: [Int] = points.map({
        return coordinate.distance($0)
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

let testFileUrl = playgroundSharedDataDirectory.appendingPathComponent("input_6.txt")

var fileContents: String?
do {
    fileContents = try String(contentsOf: testFileUrl)
} catch {
    print("Error reading contents: \(error)")
}

let lines: [String.SubSequence]?  = fileContents?.split(separator: "\n")

// parse point coordinates
let coordindates: [Point] = lines!.map({
    let numbers = String($0).components(separatedBy: ", ")
    return Point(Int(numbers[0])!, Int(numbers[1])!)
})
print(coordindates)

// construct grid (find largest coordinates)
var smallestCoordinate = coordindates.reduce(Point(Int.max, Int.max), {
    Point(min($0.x, $1.x), min($0.y, $1.y))
})
smallestCoordinate = Point(smallestCoordinate.x - 1, smallestCoordinate.y - 1)
print("smallest coordinate \(smallestCoordinate)")

var largestCoordinate = coordindates.reduce(Point(Int.min, Int.min), {
    Point(max($0.x, $1.x), max($0.y, $1.y))
})
largestCoordinate = Point(largestCoordinate.x + 2, largestCoordinate.y + 2)
print("largest coordinate \(largestCoordinate)")

var arr = Array(repeating: Array(repeating: Coordinate(closestPoint: -1), count: largestCoordinate.y), count: largestCoordinate.x)
var grid = Grid(coordinates: arr)

// calculate each coordinate distance to closest point
for x in smallestCoordinate.x..<largestCoordinate.x {
    for y in smallestCoordinate.y..<largestCoordinate.y {
        grid.coordinates[x][y] = Coordinate(closestPoint: closestDistance(Point(x, y), coordindates))
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
            if(xIndex == smallestCoordinate.x - 1 || yIndex == smallestCoordinate.y - 1 || xIndex == largestCoordinate.x - 1 || yIndex == largestCoordinate.y - 1) {
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
