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

let testFileUrl = playgroundSharedDataDirectory.appendingPathComponent("input_4_example.txt")

var fileContents: String?
do {
    fileContents = try String(contentsOf: testFileUrl)
} catch {
    print("Error reading contents: \(error)")
}

var lines: [String.SubSequence]?  = fileContents?.split(separator: "\n")

let dateFormat = "yyyy-MM-dd HH:mm"
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = dateFormat



// need to sort the lines first

var schedule: [String: Set<Date>] = [:]
var currentGuard: String = "no guard"
var lastSleep: Date?
for line in lines! {
    print(line)
    let stateChange = String(line).split( whereSeparator: {
        $0 == "[" || $0 == "]"
    })
    
    print(stateChange)
    let timestamp = dateFormatter.date(from: String(stateChange[0]))
    print(dateFormatter.string(from: timestamp!))

    let action = String(stateChange[1])
    if(action.range(of: "Guard") != nil) {
        currentGuard = action
        if(schedule[currentGuard] == nil) {
            schedule[currentGuard] = []
        }
    }
    print(currentGuard)
    
    if(action.range(of: "asleep") != nil) {
        lastSleep = timestamp!
    }
    
    if(action.range(of: "wakes up") != nil) {
        let wakeTime = timestamp!.addingTimeInterval(-60)
        for time in lastSleep!...wakeTime {
            print(dateFormatter.string(from: time))
            schedule[currentGuard]?.insert(time)
        }
    }
}
print(schedule)

var mostSleep = 0
var mostSleepGuard = ""
for g in schedule.keys {
    if (schedule[g]!.count > mostSleep) {
        mostSleep = schedule[g]!.count
        mostSleepGuard = g
    }
}
print(mostSleep)
print(mostSleepGuard)

// find the minute of the mostSleepGuard

let minuteFormatter = DateFormatter()
minuteFormatter.dateFormat = "mm"
var minutes: [String: Int] = [:]
for minute in schedule[mostSleepGuard]! {
    let currentMinute = minuteFormatter.string(from: minute)
    let count = minutes[currentMinute] ?? 0
    minutes[currentMinute] = count + 1
}

var mostSleepAtMinute = ""
var mostSleepAtMinuteCount = 0
for minute in minutes.keys {
    if(minutes[minute]! > mostSleepAtMinuteCount) {
        mostSleepAtMinuteCount = minutes[minute]!
        mostSleepAtMinute = minute
    }
}
print(mostSleepAtMinuteCount)
print(mostSleepAtMinute)
