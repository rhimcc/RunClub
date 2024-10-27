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
}
