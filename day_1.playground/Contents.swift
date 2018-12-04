import Foundation
import PlaygroundSupport

let testFileUrl = playgroundSharedDataDirectory.appendingPathComponent("input_1.txt")

var fileContents: String?
do {
    fileContents = try String(contentsOf: testFileUrl)
} catch {
    print("Error reading contents: \(error)")
}

var lines: [String.SubSequence]?  = fileContents?.split(separator: "\n")

var numbers: [Int?] = []
if let x = lines {
    numbers = x.map({
        Int($0)
    })
}

//numbers = [7, 7, -2, -7, -4]

var total: Int = 0
var seenFrequencies: Set<Int> = [0]
var doubleFrequencyFound: Bool = false

while(!doubleFrequencyFound) {
    for number in numbers {
        if let i = number {
            total += i

            if(seenFrequencies.contains(total)) {
                print("found frequency twice \(total)")
                doubleFrequencyFound = true
                break
            }

            seenFrequencies.insert(total)
        }
    }

    print(total)
}
