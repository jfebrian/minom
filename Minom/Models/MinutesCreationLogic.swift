//
//  MinutesCreationLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 29/04/21.
//

import Foundation
class MinutesCreationLogic {
    
    var startTimeSelected = true
    
    var startDate = Date()
    var endDate = Date().addingTimeInterval(TimeInterval(30 * 60))
    
    var meeting = Meeting()
    var participants = [Participant]()
    
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    var startDateString: String {
        return dateFormatter.string(from: startDate)
    }
    
    var startTime: String {
        return timeFormatter.string(from: startDate)
    }
    
    var endDateString: String {
        return dateFormatter.string(from: endDate)
    }
    
    var endTime: String {
        return timeFormatter.string(from: endDate)
    }
    
    init() {
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.doesRelativeDateFormatting = true
        timeFormatter.dateFormat = "HH.mm"
    }
    
    func updateDates(with date: Date) {
        let interval = endDate.timeIntervalSince(startDate)
        let pickerInterval = date.timeIntervalSince(startDate)
        if startTimeSelected {
            startDate = date
            endDate = startDate > endDate || abs(pickerInterval) >= 3600 * 24 ? startDate.addingTimeInterval(interval) : endDate
        } else {
            endDate = date
            startDate = startDate > endDate ? endDate.addingTimeInterval(-interval) : startDate
        }
    }
    
    func togglePicker(_ x: Int) {
        startTimeSelected = x == 1 ? true : false
    }
    
}
