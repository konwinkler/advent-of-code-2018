import Foundation
import PlaygroundSupport

func parseFile() -> [String.SubSequence]? {
    let fileUrl = playgroundSharedDataDirectory.appendingPathComponent("input_8_example.txt")
    var fileContents: String?
    do {
        fileContents = try String(contentsOf: fileUrl)
    } catch {
        print("Error reading contents: \(error)")
    }
    return fileContents?.split(separator: "\n")
}

func main() -> () {
    // parse graph from file
    let line = parseFile()![0]
    let numbers: [Int] = line.split(separator: " ").map({Int(String($0))!})
    print(numbers)
}

main()

