import Foundation
import PlaygroundSupport

func getInput(_ index: Int) -> String {
    let inputs = [
        "9 players; last marble is worth 25 points",
        "10 players; last marble is worth 1618 points",
        "13 players; last marble is worth 7999 points",
        "17 players; last marble is worth 1104 points",
        "21 players; last marble is worth 6111 points",
        "30 players; last marble is worth 5807 points",
        "426 players; last marble is worth 72058 points"]
    return inputs[index]
}

class Marble: Equatable, CustomDebugStringConvertible {
    
    static func == (lhs: Marble, rhs: Marble) -> Bool {
        return lhs.value == rhs.value
    }
    
    let value: Int
    var next: Marble?
    var previous: Marble?
    
    init(_ value: Int) {
        self.value = value
    }
    
    var debugDescription: String {
        return "[\(value) p \(previous?.value ?? -1) n \(next?.value ?? -1)]"
    }
}

class MarbleCirle: CustomDebugStringConvertible {
    let amountPlayers: Int
    var playerScores: [Int]
    var currentPlayerIndex = -1
    var zeroMarble = Marble(0)
    
    var currentMarble: Marble = Marble(-1)
    
    init(_ amountPlayers: Int) {
        currentMarble = zeroMarble
//        print("Marble \(currentMarble)")
        self.amountPlayers = amountPlayers
        playerScores = Array(repeating: 0, count: self.amountPlayers)
        currentMarble.previous = currentMarble
        currentMarble.next = currentMarble
        print("filled \(currentMarble)")
    }
    
    var debugDescription: String {
        var description = "[\(self.currentPlayerIndex + 1)]"
        
        var marble = zeroMarble
        if(marble == currentMarble) {
            description += " (\(marble.value))"
        } else {
            description += " \(marble.value)"
        }
        while (marble.next! != zeroMarble) {
            marble = marble.next!
            if(marble == currentMarble) {
                description += " (\(marble.value))"
            } else {
                description += " \(marble.value)"
            }
        }

        return description
    }
    
    func insertMarble(_ marbleNumber: Int) -> () {
        // move twice ahead and insert marble
        let newMarble = Marble(marbleNumber)
        
        currentMarble = currentMarble.next!
        currentMarble = currentMarble.next!
        
        newMarble.previous = currentMarble.previous
        newMarble.next = currentMarble
//        print("insert \(newMarble) between \(currentMarble.previous!) and \(currentMarble.next!)")

        newMarble.previous?.next = newMarble
        newMarble.next?.previous = newMarble
        if(marbleNumber == 1) {
            currentMarble.previous = newMarble
        }
//        print("old marble \(currentMarble)")
        
        currentMarble = newMarble
        
        self.currentPlayerIndex = (self.currentPlayerIndex + 1) % self.amountPlayers
    }
    
    func collectPoint(_ marbleNumber: Int) -> () {
        
        // move 7 times forward and remove marble
        currentMarble = currentMarble.previous!
        currentMarble = currentMarble.previous!
        currentMarble = currentMarble.previous!
        currentMarble = currentMarble.previous!
        currentMarble = currentMarble.previous!
        currentMarble = currentMarble.previous!
        currentMarble = currentMarble.previous!
        
        let marbleToRemove = currentMarble
        
        var additionalScore = currentMarble.value
        currentMarble = currentMarble.next!
        currentMarble.previous = marbleToRemove.previous!
        marbleToRemove.previous!.next = currentMarble

        additionalScore += marbleNumber
        self.playerScores[self.currentPlayerIndex] = self.playerScores[self.currentPlayerIndex] + additionalScore
        
        self.currentPlayerIndex = (self.currentPlayerIndex + 1) % self.amountPlayers
    }
    
    func mostPoints() -> Int {
        return self.playerScores.max()!
    }
}

let input = getInput(6).split(separator: " ")
let numberOfPlayers: Int = Int(input[0])!
let lastMarble: Int = Int(input[6])!

let circle: MarbleCirle = MarbleCirle(numberOfPlayers)
print(circle)
for marble in 1..<(lastMarble + 1) {
    if(marble % 23 == 0) {
        circle.collectPoint(marble)
    } else {
        circle.insertMarble(marble)
    }
//    print(circle)
}

print(circle.mostPoints())


