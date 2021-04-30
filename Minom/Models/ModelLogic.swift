//
//  ModelLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 29/04/21.
//

import UIKit
import RealmSwift

class ModelLogic {
    
    let realm = try! Realm()
    var meetingByMonths = [[Meeting]]()
    
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
        let meetings = realm.objects(Meeting.self).sorted(byKeyPath: "date", ascending: false)
        if let start = meetings.first {
            let calendar = Calendar.current
            meetingByMonths = [[]]
            var lastDate = start.date
            var lastMonth = [Meeting]()
            for meeting in meetings {
                let date = meeting.date
                let difference = calendar.dateComponents([.year, .month], from: lastDate, to: date)
                if difference.year! > 0 || difference.month! > 0 {
                    lastDate = date
                    meetingByMonths.append(lastMonth)
                    lastMonth = [meeting]
                } else {
                    lastMonth.append(meeting)
                }
            }
        }
    }
    
    func getMeeting(with indexPath: IndexPath) -> Meeting? {
        return nil
    }
    
    func numberOfMeetingsInMonth(_ index: Int) -> Int {
        return meetingByMonths[index].count
    }
    
    func numberOfMonths() -> Int {
        return meetingByMonths.count
    }
    
    func monthName(with index: Int) -> String {
        return ""
    }
    
    func meetingTitle(with indexPath: IndexPath) -> String {
        return ""
    }
    
    func meetingType(with indexPath: IndexPath) -> String {
        return ""
    }
    
}
