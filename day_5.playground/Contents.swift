import Foundation
import PlaygroundSupport

extension Date: Strideable {
    public func advanced(by n: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: n, to: self) ?? self
    }
    
    public func distance(to other: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: other, to: self).minute ?? 0
    }
}

let testFileUrl = playgroundSharedDataDirectory.appendingPathComponent("input_5.txt")

var fileContents: String?
do {
    fileContents = try String(contentsOf: testFileUrl)
} catch {
    print("Error reading contents: \(error)")
}

let lines: [String.SubSequence]?  = fileContents?.split(separator: "\n")

var input = String(lines![0])
//input = "dabAcCaCBAcCcaDA"

var converted = Array(input)

var foundMatch = true

func match(_ first: Character, _ second: Character) -> Bool {
    let lastUnicaode = first.unicodeScalars.first!.value
    let currentUnicode = second.unicodeScalars.first!.value
    return ((lastUnicaode + 32 == currentUnicode) || (lastUnicaode - 32 == currentUnicode))
}

while(foundMatch) {
    foundMatch = false
    for (index, i) in converted.enumerated() {
        if(i != "@" && index > 0 && match(converted[index - 1], i)) {
            converted[index] = "@"
            converted[index - 1] = "@"
            foundMatch = true
            
            var area = 2
            var moreMatches = true
            while(moreMatches && (index - area >= 0) && (index + area - 1 < converted.count) ) {
                moreMatches = false
                if(match(converted[index - area], converted[index + area - 1])) {
                    converted[index - area] = "@"
                    converted[index + area - 1] = "@"
                    moreMatches = true
                }
                area += 1
            }
        }
    }
    
    print(foundMatch)
    
    converted = converted.filter({
        return $0 != "@"
    })
}
print(converted.count)
print(String(converted))
