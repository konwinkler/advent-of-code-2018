import Foundation
import PlaygroundSupport

func parseFile() -> [String.SubSequence]? {
    let fileUrl = playgroundSharedDataDirectory.appendingPathComponent("input_7.txt")
    var fileContents: String?
    do {
        fileContents = try String(contentsOf: fileUrl)
    } catch {
        print("Error reading contents: \(error)")
    }
    return fileContents?.split(separator: "\n")
}

struct Graph {
    var nodes: [Node]
    
    func availableNodes() -> [Node] {
        return nodes.filter({ $0.precessors == []})
    }
    
    func printNodes() -> () {
        for node in nodes {
            print("\(node) \(node.precessors) \(node.successors)")
        }
    }
    
    mutating func visit(_ node: Node) -> () {
        node.visit()
        self.nodes.removeAll(where: {$0 == node})
    }
}

class Node: Equatable, Comparable, CustomStringConvertible {
    static func < (lhs: Node, rhs: Node) -> Bool {
        return lhs.description < rhs.description
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.description == rhs.description
    }
    
    var description: String
    var successors: [Node] = []
    var precessors: [Node] = []

    init(_ description: String) {
        self.description = description
    }
    
    func visit() -> () {
        for successor in successors {
            successor.precessors.removeAll(where: {$0 == self})
        }
    }
    
}

func main() -> () {
    // parse graph from file
    var graph = Graph(nodes: [])
    let lines = parseFile()
    for line in lines! {
        let words = String(line).split(separator: " ")
        var source = Node(String(words[1]))
        var target = Node(String(words[7]))
        
        print("found rule \(source) to \(target)")
        
        // add points if they don't exist yet in the graph
        if(!graph.nodes.contains(source)) {
            graph.nodes.append(source)
        } else {
            let firstIndex = graph.nodes.firstIndex(of: source)
            source = graph.nodes[firstIndex!]
        }
        if(!graph.nodes.contains(target)) {
            graph.nodes.append(target)
        } else {
            let firstIndex = graph.nodes.firstIndex(of: target)
            target = graph.nodes[firstIndex!]
        }
        
        source.successors.append(target)
        target.precessors.append(source)
    }

    var orderOfNodes: String = ""
    while(!graph.nodes.isEmpty) {
        let availableNodes = graph.availableNodes().sorted()
        let currentNode = availableNodes.first!
        orderOfNodes = orderOfNodes + currentNode.description
        graph.visit(currentNode)
    }
    print(orderOfNodes)
}

main()

