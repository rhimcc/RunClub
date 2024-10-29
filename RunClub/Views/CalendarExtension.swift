//
//  CalendarExtension.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import Foundation

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components) ?? date
    }
}
