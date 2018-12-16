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

class MarbleCirle: CustomDebugStringConvertible {
    let amountPlayers: Int
    var playerScores: [Int]
    var currentPlayerIndex = -1
    
    init(_ amountPlayers: Int) {
        self.amountPlayers = amountPlayers
        self.playerScores = Array(repeating: 0, count: self.amountPlayers)
    }
    
    var debugDescription: String {
        var description = "[\(self.currentPlayerIndex + 1)]"
        for (index, element) in marbles.enumerated() {
            if(index == currentMarbleIndex) {
                description += " (\(element))"
            } else {
                description += " \(element)"
            }
        }
        return description
    }
    
    var marbles: [Int] = [0]
    var currentMarbleIndex = 0
    
    func insertMarble(_ marbleNumber: Int) -> () {
//        print("insert \(marbleNumber) at \(self.currentMarbleIndex + 2) % \(self.marbles.count + 1)")
        self.currentMarbleIndex = (self.currentMarbleIndex + 2) % (self.marbles.count)
        if(self.currentMarbleIndex == 0) {
            marbles.append(marbleNumber)
            self.currentMarbleIndex = self.marbles.count - 1
        } else {
            marbles.insert(marbleNumber, at: currentMarbleIndex)
        }
        
        self.currentPlayerIndex = (self.currentPlayerIndex + 1) % self.amountPlayers
    }
    
    func collectPoint(_ marbleNumber: Int) -> () {
        self.currentMarbleIndex = self.currentMarbleIndex - 7
        if(self.currentMarbleIndex < 0) {
            self.currentMarbleIndex = self.currentMarbleIndex + self.marbles.count
        }
//        print("collect points at \(self.currentMarbleIndex)")
        var additionalScore = self.marbles.remove(at: self.currentMarbleIndex)
        additionalScore += marbleNumber
        self.playerScores[self.currentPlayerIndex] = self.playerScores[self.currentPlayerIndex] + additionalScore
        
        self.currentPlayerIndex = (self.currentPlayerIndex + 1) % self.amountPlayers
    }
    
    func currentMarble() -> Int {
        return self.marbles[self.currentMarbleIndex]
    }
    
    func mostPoints() -> Int {
        return self.playerScores.max()!
    }
}

func main() -> () {
    let input = getInput(0).split(separator: " ")
    let numberOfPlayers: Int = Int(input[0])!
    let lastMarble: Int = Int(input[6])!
    
    var circle: MarbleCirle = MarbleCirle(numberOfPlayers)
    print(circle)
    for marble in 1..<(lastMarble + 1) {
        if(marble % 23 == 0) {
            circle.collectPoint(marble)
        } else {
            circle.insertMarble(marble)
        }
//        print(circle)
    }

    print(circle.mostPoints())
}

main()

