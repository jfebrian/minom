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
    var filteredMeetingByMonths = [[Meeting]]()
    
    
    init() {
        loadMeetings()
    }
    
    // MARK: - Model Manipulation Methods
    
    func save(_ meeting: Meeting, participants: [Participant], type: MeetingType) {
        do {
            try realm.write {
                meeting.type = type
                realm.add(meeting)
                realm.add(participants)
                meeting.participants.append(objectsIn: participants)
            }
        } catch {
            print("Error saving meeting to Realm, \(error.localizedDescription)")
        }
        loadMeetings()
    }
    
    func setTime(start: Date, end: Date, meeting: Meeting) {
        do {
            try realm.write {
                meeting.startTime = start
                meeting.endTime = end
            }
        } catch {
            print("Error setting meeting time to Realm, \(error.localizedDescription)")
        }
        loadMeetings()
    }
    
    func setTitle(for meeting: Meeting, to title: String) {
        do {
            try realm.write {
                meeting.title = title
            }
        } catch {
            print("Error setting meeting title to Realm, \(error.localizedDescription)")
        }
        loadMeetings()
    }
    
    func setAgenda(for meeting: Meeting, to agenda: String) {
        do {
            try realm.write {
                meeting.agenda = agenda
            }
        } catch {
            print("Error setting meeting agenda to Realm, \(error.localizedDescription)")
        }
        loadMeetings()
    }
    
    func rename(_ participant: Participant, with name: String) {
        do {
            try realm.write {
                participant.name = name
            }
        } catch {
            print("Error renaming participant to Realm, \(error.localizedDescription)")
        }
        loadMeetings()
    }
    
    func toggleAttendance(for participant: Participant) {
        do {
            try realm.write {
                participant.attendance = !participant.attendance
            }
        } catch {
            print("Error toggling participant's attendance to Realm, \(error.localizedDescription)")
        }
        loadMeetings()
    }
    
    func add(_ participant: Participant, for meeting: Meeting) {
        do {
            try realm.write {
                realm.add(participant)
                meeting.participants.append(participant)
            }
        } catch {
            print("Error adding participant to Realm, \(error.localizedDescription)")
        }
        loadMeetings()
    }
    
    func remove(_ participant: Participant) {
        do {
            try realm.write {
                realm.delete(participant)
            }
        } catch {
            print("Error removing meeting to Realm, \(error.localizedDescription)")
        }
        loadMeetings()
    }
    
    func setType(for meeting:Meeting, with type: MeetingType) {
        do {
            try realm.write {
                meeting.type = type
            }
        } catch {
            print("Error setting meeting type to Realm, \(error.localizedDescription)")
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
    
    func toggleAudioExist(_ meeting: Meeting) {
        do {
            try realm.write {
                meeting.audioExist = true
            }
        } catch {
            print("Error toggling audio exist in Realm, \(error.localizedDescription)")
        }
    }
    
    func check(_ meeting: Meeting, for stringToSearch: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "eeee dd MMMM yyyy"
        let date = formatter.string(from: meeting.startTime).lowercased()
        let string = stringToSearch.lowercased()
        
        if meeting.title.lowercased().contains(string) || meeting.agenda.lowercased().contains(string) || date.contains(string) || meeting.type?.name.lowercased().contains(string) ?? "no meeting type".contains(string) {
            return true
        } else {
            for participant in meeting.participants {
                if participant.name.lowercased().contains(string) {
                    return true
                }
            }
            for item in meeting.items {
                if item.title.lowercased().contains(string) || item.note.lowercased().contains(string) {
                    return true
                }
            }
        }
        return false
    }
    
    func searchMeetings(for text: String) {
        filteredMeetingByMonths = [[]]
        for month in meetingByMonths {
            var lastMonth = [Meeting]()
            for meeting in month {
                if check(meeting, for: text) {
                    lastMonth.append(meeting)
                }
            }
            if !lastMonth.isEmpty {
                filteredMeetingByMonths.append(lastMonth)
            }
        }
    }
    
    func loadMeetings() {
        let meetings = realm.objects(Meeting.self).sorted(byKeyPath: "startTime", ascending: false)
        if let start = meetings.first {
            let calendar = Calendar.current
            meetingByMonths = [[]]
            var lastDate = start.startTime
            var lastMonth = [Meeting]()
            for meeting in meetings {
                let date = meeting.startTime
                let dateComp = calendar.dateComponents([.year, .month], from: date)
                let lastComp = calendar.dateComponents([.year, .month], from: lastDate)
                if dateComp.year! < lastComp.year! || dateComp.month! < lastComp.month! {
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
    
    func meeting(at indexPath: IndexPath, _ isFiltering: Bool) -> Meeting {
        return isFiltering ? filteredMeetingByMonths[indexPath.section][indexPath.row] : meetingByMonths[indexPath.section][indexPath.row]
    }
    
    func numberOfMonths(_ isFiltering: Bool) -> Int {
        return isFiltering ? filteredMeetingByMonths.count : meetingByMonths.count
    }
    
    func numberOfMeetingsInMonth(_ index: Int, _ isFiltering: Bool) -> Int {
        return isFiltering ? filteredMeetingByMonths[index].count : meetingByMonths[index].count
    }
    
    func monthName(with index: Int, _ isFiltering: Bool) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL yyyy"
        guard let meeting = isFiltering ? filteredMeetingByMonths[index].first : meetingByMonths[index].first else {
            fatalError("Error loading meetings!")
        }
        return formatter.string(from: meeting.startTime).uppercased()
    }
    
    func meetingTitle(at indexPath: IndexPath, _ isFiltering: Bool) -> String {
        return meeting(at: indexPath, isFiltering).title
    }
    
    func meetingType(at indexPath: IndexPath, _ isFiltering: Bool) -> String {
        let type = meeting(at: indexPath, isFiltering).type
        return type?.name ?? "No Meeting Type"
    }
    
}
