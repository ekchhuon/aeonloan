//
//  TimeInterval.swift
//  AEON Loan
//
//  Created by aeon on 8/26/20.
//

import Foundation

extension TimeInterval {
    static let milisecond: TimeInterval = second / 1000
    static let second: TimeInterval = 1
    static let minute: TimeInterval = second * 60
    static let hour: TimeInterval = minute * 60
    static let day: TimeInterval = hour * 24
    static let year: TimeInterval = day * 365

    static func miliseconds(_ count: Int) -> TimeInterval { return TimeInterval(count) * milisecond }
    static func seconds(_ count: Int) -> TimeInterval { return TimeInterval(count) * second }
    static func minutes(_ count: Int) -> TimeInterval { return TimeInterval(count) * minute }
    static func hours(_ count: Int) -> TimeInterval { return TimeInterval(count) * hour }
    static func days(_ count: Int) -> TimeInterval { return TimeInterval(count) * day }
    static func years(_ count: Int) -> TimeInterval { return TimeInterval(count) * year }

    var miliseconds: Int {
        return Int(self / TimeInterval.milisecond)
    }

    var seconds: Int {
        return Int(self / TimeInterval.second)
    }

    var minutes: Int {
        return Int(self / TimeInterval.minute)
    }

    var hours: Int {
        return Int(self / TimeInterval.hour)
    }

    var days: Int {
        return Int(self / TimeInterval.day)
    }
    
    var years: Int {
        return Int(self / TimeInterval.year)
    }
}

extension Int {
    var miliseconds: TimeInterval {
        return TimeInterval.miliseconds(self)
    }

    var seconds: TimeInterval {
        return TimeInterval.seconds(self)
    }

    var minutes: TimeInterval {
        return TimeInterval.minutes(self)
    }

    var hours: TimeInterval {
        return TimeInterval.hours(self)
    }

    var days: TimeInterval {
        return TimeInterval.days(self)
    }
    
    var years: TimeInterval {
        return TimeInterval.years(self)
    }
}
