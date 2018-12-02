import Foundation
import PlaygroundSupport

let testFileUrl = playgroundSharedDataDirectory.appendingPathComponent("input_2.txt")

var fileContents: String?
do {
    fileContents = try String(contentsOf: testFileUrl)
} catch {
    print("Error reading contents: \(error)")
}

var lines: [String.SubSequence]?  = fileContents?.split(separator: "\n")

//lines  = ["abcdef","bababc", "abbcde", "abcccd", "abcdd", "abcdee", "ababab"]

extension String {
    func customCount(of needle: Character) -> Int {
        return reduce(0) {
            $1 == needle ? $0 + 1 : $0
        }
    }
}

var lettersTwiceCounter = 0
var lettersThreeTimesCounter = 0

if let x = lines {
    for line in x {
        var lettersTwice = false
        var lettersThreeTimes = false
        for char in line {
            let occurences: Int = String(line).customCount(of: char)
            if(occurences == 2) {
                lettersTwice = true
            } else if (occurences == 3) {
                lettersThreeTimes = true
            }
        }
        
        if(lettersTwice) {
            lettersTwiceCounter += 1
        }
        if(lettersThreeTimes) {
            lettersThreeTimesCounter  += 1
        }
    }
}

print(lettersTwiceCounter * lettersThreeTimesCounter)

