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

//lines = ["abcde",
//    "fghij",
//    "klmno",
//    "pqrst",
//    "fguij",
//    "axcye",
//    "wvxyz"
//]

extension String {
    func customCount(of needle: Character) -> Int {
        return reduce(0) {
            $1 == needle ? $0 + 1 : $0
        }
    }
    
    func differByOne(with other: String) -> Bool {
        var differCounter = 0
        for i in 0..<count {
            let index = self.index(self.startIndex, offsetBy: i)
            if(self[index] != other[index]) {
                differCounter += 1
            }
            
            if(differCounter > 1) {
                return false
            }
        }
        
        return true
    }
}

if let x = lines {
    var seenIDs: Set<String> = []
    for line in x {
        let id = String(line)
        for seenID in seenIDs {
            if(id.differByOne(with: seenID)) {
                print("Differ by one \(id) and \(seenID)")
                break
            }
        }
        seenIDs.insert(id)
    }
}

