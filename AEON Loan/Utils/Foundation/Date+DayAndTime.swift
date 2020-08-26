//
//  Date+DayAndTime.swift
//  AEON Loan
//
//  Created by aeon on 8/26/20.
//

import Foundation

struct Day: Equatable {
    let value: Date
    init(_ date: Date) {
        self.value = date.removingTime()
    }
}

struct Time: Equatable {
    let value: Date
    init(_ date: Date) {
        self.value = date.removingDate()
    }
}

extension Date {

    func removingTime() -> Date {
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let new = calendar.date(from: dateComponents)
        return new ?? self
    }

    func removingDate() -> Date {
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: self)
        return calendar.date(from: dateComponents) ?? self
    }

    init(day: Day, time: Time) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: day.value)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time.value)
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year
        mergedComponments.month = dateComponents.month
        mergedComponments.day = dateComponents.day
        mergedComponments.hour = timeComponents.hour
        mergedComponments.minute = timeComponents.minute
        mergedComponments.second = timeComponents.second

        self = calendar.date(from: mergedComponments) ?? day.value
    }
}

extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        return formatter.string(from: `self`)
    }
}
