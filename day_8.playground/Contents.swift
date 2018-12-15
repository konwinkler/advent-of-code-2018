import Foundation
import PlaygroundSupport

func parseFile() -> [String.SubSequence]? {
    let fileUrl = playgroundSharedDataDirectory.appendingPathComponent("input_8.txt")
    var fileContents: String?
    do {
        fileContents = try String(contentsOf: fileUrl)
    } catch {
        print("Error reading contents: \(error)")
    }
    return fileContents?.split(separator: "\n")
}

class Node: CustomDebugStringConvertible {
    var maxChildNodes: Int?
    var maxMetaData: Int?
    
    var parent: Node?
    var childNodes: [Node] = []
    var metaData: [Int] = []
    
    public var debugDescription: String {
        return "Node \(self.maxChildNodes) \(self.maxMetaData) data \(self.metaData) children \(self.childNodes)"
    }
    
    func printMetaDataResult() -> Int {
        var result = 0
        for node in self.childNodes {
            result += node.printMetaDataResult()
        }
        
        return self.metaData.reduce(0, +) + result
    }
    
    func printMetaDataResult2() -> Int {
        if(self.childNodes.count == 0) {
            return self.metaData.reduce(0, +)
        }

        var result = 0
        for meta in self.metaData {
            if(meta <= self.childNodes.count) {
                result += self.childNodes[meta - 1].printMetaDataResult2()
            }
        }
        return result
    }
}

func parseNodes(_ currentNode: inout Node, _ numbers: inout [Int]) -> () {
    if(numbers.count == 0) {
        return
    }
    
    let number = numbers.remove(at: 0)
    
    if (currentNode.maxChildNodes == nil) {
        currentNode.maxChildNodes = number
        parseNodes(&currentNode, &numbers)
        return
    }
    
    if (currentNode.maxMetaData == nil) {
        currentNode.maxMetaData = number
        parseNodes(&currentNode, &numbers)
        return
    }
    
    if (currentNode.maxChildNodes == 0 || currentNode.maxChildNodes! == currentNode.childNodes.count) {
        // nodes are all done

        if(currentNode.maxMetaData == 0 || currentNode.maxMetaData! == currentNode.metaData.count) {
            // go to parent
            numbers.insert(number, at: 0)
            parseNodes(&currentNode.parent!, &numbers)
            return
            
        } else {
            // set meta data
            currentNode.metaData.append(number)
            parseNodes(&currentNode, &numbers)
            return
        }
        
        
    } else {
        // start new child node
        numbers.insert(number, at: 0)
        var child = Node()
        child.parent = currentNode
        currentNode.childNodes.append(child)
        parseNodes(&child, &numbers)
        return
    }
    
}

func main() -> () {
    // parse graph from file
    let line = parseFile()![0]
    var numbers: [Int] = line.split(separator: " ").map({Int(String($0))!})
    print(numbers)
    
    var root = Node()
    parseNodes(&root, &numbers)
    
    print(root)
    print(root.printMetaDataResult())
    print(root.printMetaDataResult2())
}

main()

