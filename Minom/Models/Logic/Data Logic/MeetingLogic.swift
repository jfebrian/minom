//
//  ModelLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 29/04/21.
//

import Foundation
import RealmSwift

class MeetingLogic {
    
    static var standard = MeetingLogic()
    
    let realm = try! Realm()
    var meetingByMonths = [[Meeting]]()
    
    init() {
        loadMeetings()
    }
    
    // MARK: - Model Manipulation Methods
    
    func save(_ meeting: Meeting, with participants: [Participant]) {
        do {
            try realm.write {
                realm.add(meeting)
                realm.add(participants)
                meeting.participants.append(objectsIn: participants)
            }
        } catch {
            print("Error saving meeting to Realm, \(error.localizedDescription)")
        }
        loadMeetings()
    }
    
    func delete(_ meeting: Meeting) {
        do {
            try realm.write {
                realm.delete(meeting.participants)
                realm.delete(meeting.items)
                realm.delete(meeting)
            }
        } catch {
            print("Error deleting meeting from Realm, \(error.localizedDescription)")
        }
    }
    
    private func loadMeetings() {
        let meetings = realm.objects(Meeting.self).sorted(byKeyPath: "startTime", ascending: false)
        if let start = meetings.first {
            let calendar = Calendar.current
            meetingByMonths = [[]]
            var lastDate = start.startTime
            var lastMonth = [Meeting]()
            for meeting in meetings {
                let date = meeting.startTime
                let difference = calendar.dateComponents([.year, .month], from: lastDate, to: date)
                if difference.year! > 0 || difference.month! > 0 {
                    lastDate = date
                    meetingByMonths.append(lastMonth)
                    lastMonth = [meeting]
                } else {
                    lastMonth.append(meeting)
                }
            }
            meetingByMonths.append(lastMonth)
        }
    }
    
    func meeting(with indexPath: IndexPath) -> Meeting {
        return meetingByMonths[indexPath.section][indexPath.row]
    }
    
    func numberOfMeetingsInMonth(_ index: Int) -> Int {
        return meetingByMonths[index].count
    }
    
    func numberOfMonths() -> Int {
        return meetingByMonths.count
    }
    
    func monthName(with index: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL yyyy"
        if let meeting = meetingByMonths[index].first {
            return formatter.string(from: meeting.startTime).uppercased()
        } else {
            return ""
        }
    }
    
    func meetingTitle(with indexPath: IndexPath) -> String {
        return meeting(with: indexPath).title
    }
    
    func meetingType(with indexPath: IndexPath) -> String {
        return meeting(with: indexPath).type?.name ?? ""
    }
    
}
