import Foundation
import PlaygroundSupport

let testFileUrl = playgroundSharedDataDirectory.appendingPathComponent("input_3.txt")

var fileContents: String?
do {
    fileContents = try String(contentsOf: testFileUrl)
} catch {
    print("Error reading contents: \(error)")
}

var lines: [String.SubSequence]?  = fileContents?.split(separator: "\n")

//lines = ["#1 @ 1,3: 4x4",
//    "#2 @ 3,1: 4x4",
//    "#3 @ 5,5: 2x2"]

//lines = ["#1 @ 1,1: 2x2", "#2 @ 2,2: 1x1"]

var fabric = [String: Int]()

for line in lines! {
    let claim = String(line)
    let parts = claim.split(separator: " ")

    let offset = parts[2].split(whereSeparator: {$0 == "," || $0 == ":"})
    let offsetX = Int(offset[0])
    let offsetY = Int(offset[1])
    
    let size = parts[3].split(separator: "x")
    let sizeX = Int(size[0])
    let sizeY = Int(size[1])
    
    for x in offsetX!..<(offsetX! + sizeX!) {
        for y in offsetY!..<(offsetY! + sizeY!) {
            let previousValue = fabric["\(x),\(y)"] ?? 0
            fabric["\(x),\(y)"] = previousValue + 1
        }
    }
    
}

var total = 0
for value in fabric.values {
    if(value > 1) {
        total += 1
    }
}
print(total)
