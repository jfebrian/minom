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
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    var recentMeetings = [[Meeting]]()
    var meetingByMonths = [[Meeting]]()
    var filteredMeetingByMonths = [[Meeting]]()
    var recentDates = [Date]()
    
    var selectedRecent = 13
    
    init() {
        fetchDates()
        loadMeetings()
    }
    
    func fetchDates() {
        let calendar = Calendar.current
        var date = calendar.startOfDay(for: Date())
        recentDates = []
        for _ in 1 ... 14 {
            recentDates.append(date)
            date = calendar.date(byAdding: .day, value: -1, to: date)!
        }
        recentDates.reverse()
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
        loadMeetings()
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
    
    // MARK: - Fetch and Filter Meetings
    
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
        loadMeetingByMonths(meetings)
        loadRecentMeetings(meetings)
    }
    
    func loadRecentMeetings(_ meetings: Results<Meeting>) {
        recentMeetings = [[]]
        for _ in recentDates {
            let meetingArray = [Meeting]()
            recentMeetings.append(meetingArray)
        }
        let calendar = Calendar.current
        for meeting in meetings {
            dates: for date in recentDates {
                if calendar.isDate(meeting.startTime, inSameDayAs: date) {
                    recentMeetings[recentDates.firstIndex(of: date)!].append(meeting)
                    break dates
                }
            }
        }
    }
    
    func loadMeetingByMonths(_ meetings: Results<Meeting>) {
        meetingByMonths = [[]]
        if let start = meetings.first {
            let calendar = Calendar.current
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
    
    // MARK: - Other Functions
    
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
    
    func startTime(for meeting: Meeting) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH.mm"
        return timeFormatter.string(from: meeting.startTime)
    }
    
    func endTime(for meeting: Meeting) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH.mm"
        return timeFormatter.string(from: meeting.endTime)
    }
    
    func meetingTitle(at indexPath: IndexPath, _ isFiltering: Bool) -> String {
        return meeting(at: indexPath, isFiltering).title
    }
    
    func meetingType(at indexPath: IndexPath, _ isFiltering: Bool) -> String {
        let type = meeting(at: indexPath, isFiltering).type
        return type?.name ?? "No Meeting Type"
    }
    
    func recentDate(at indexPath: IndexPath) -> String {
        let date = recentDates[indexPath.row]
        return "\(Calendar.current.component(.day, from: date))"
    }
    
    func recentDay(at indexPath: IndexPath) -> String {
        let daysOfWeek = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        let date = recentDates[indexPath.row]
        let weekday = Calendar.current.component(.weekday, from: date)
        return daysOfWeek[weekday - 1]
    }
    
    func selectRecent(at index: Int) {
        selectedRecent = index
    }
    
    func isSelectedRecent(at indexPath: IndexPath) -> Bool {
        return selectedRecent == indexPath.row
    }
    
    func recentMeeting(at indexPath: IndexPath) -> Meeting {
        return recentMeetings[selectedRecent][indexPath.row]
    }
    
    func selectedRecentMeetings() -> [Meeting] {
        return recentMeetings[selectedRecent]
    }
    
    func selectedCount() -> Int {
        return recentMeetings[selectedRecent].count
    }
    
    func participantInfo(for meeting:Meeting) -> ([String], Int?) {
        var counter = 0
        var names = [String]()
        for participant in meeting.participants {
            guard counter < 6 else { break }
            names.append(participant.name)
            counter += 1
        }
        let left = meeting.participants.count - counter
        return (names, left > 0 ? left : nil)
    }
    
}
