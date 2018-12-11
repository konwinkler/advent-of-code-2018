import Foundation
import PlaygroundSupport

let fileUrl = playgroundSharedDataDirectory.appendingPathComponent("input_7_example.txt")
var fileContents: String?
do {
    fileContents = try String(contentsOf: fileUrl)
} catch {
    print("Error reading contents: \(error)")
}
let lines: [String.SubSequence]?  = fileContents?.split(separator: "\n")

struct Graph {
    var points: [Point]
    var edges: [Edge]
}

struct Point: Equatable, CustomStringConvertible {
    var description: String

    init(_ description: String) {
        self.description = description
    }
}

struct Edge: CustomStringConvertible {
    var description: String
    var source: Point
    var target: Point
    
    init(_ source: Point, _ target: Point) {
        self.source = source
        self.target = target
        self.description = "\(source)->\(target)"
    }
}

// parse graph from file
var graph = Graph(points: [], edges: [])
for line in lines! {
    let words = String(line).split(separator: " ")
    let source = Point(String(words[1]))
    let target = Point(String(words[7]))
    
    print("found rule \(source) to \(target)")
    
    // add points if they don't exist yet in the graph
    if(!graph.points.contains(source)) {
        graph.points.append(source)
    }
    if(!graph.points.contains(target)) {
        graph.points.append(target)
    }
    
    graph.edges.append(Edge(source, target))
}
print(graph)
