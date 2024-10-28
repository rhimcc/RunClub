//
//  DateFormatter.swift
//  RunClub
//
//  Created by Rhianna McCormack on 27/10/2024.
//

import Foundation

struct DateFormatterService {
    func getTimeString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short      // E.g., 5:30 PM
        formatter.timeZone = .current     // Adjusts to the user's time zone
        return formatter.string(from: date)
    }
    func getDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMMd") // set template after setting locale
        return (formatter.string(from: date)) // December 31
    }
    
    func getTimeFromSeconds(seconds: Float) -> String {
        let hours = Int((seconds / 60) / 60)
        let minutes = Int((seconds / 60).truncatingRemainder(dividingBy: 60))
        let seconds = Int(seconds.truncatingRemainder(dividingBy: 60).truncatingRemainder(dividingBy: 60))
        var hourString: String = getTimeString(unit: hours)
        var minuteString: String = getTimeString(unit: minutes)
        var secondString: String = getTimeString(unit: seconds)
        return "\(hourString):\(minuteString):\(secondString)"
    }
    
    func getTimeString(unit: Int) -> String {
        if String(abs(unit)).count == 0 {
            return "00"
        } else if String(abs(unit)).count == 1 {
            return "0\(unit)"
        } else {
            return "\(unit)"
        }
    }
}
