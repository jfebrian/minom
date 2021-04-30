//
//  MinutesLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import Foundation

class MinutesLogic {
    
    var meeting: Meeting
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    init(for meeting: Meeting) {
        self.meeting = meeting
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateFormat = "d  MMM yy"
        timeFormatter.dateFormat = "HH.mm"
    }
    
    var title: String {
        return meeting.title
    }
    
    var type: String {
        return meeting.type?.name ?? "Deleted Type"
    }
    
    var startTime: String {
        return timeFormatter.string(from: meeting.startTime)
    }
    
    var endTime: String {
        return timeFormatter.string(from: meeting.endTime)
    }
    
    var date: String {
        return dateFormatter.string(from: meeting.startTime)
    }
    
}
