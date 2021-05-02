//
//  MinutesCreationLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 29/04/21.
//

import Foundation
class MinutesCreationLogic {
    
    var meeting = Meeting()
    var participants = [Participant]()
    var meetingLogic = MeetingLogic.standard
    var typeLogic = MeetingTypeLogic.standard
    
    var startTimeSelected = true
    var exist: Bool = false

    var startDate = Date()
    var endDate = Date().addingTimeInterval(TimeInterval(30 * 60))
    
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    var selectedType: MeetingType?
    
    
    // MARK: - Init
    
    init(with meeting: Meeting? = nil) {
        initFormatters()
        if let existMeeting = meeting {
            self.meeting = existMeeting
            for participant in existMeeting.participants {
                participants.append(participant)
            }
            startDate = existMeeting.startTime
            endDate = existMeeting.endTime
            selectedType = existMeeting.type
            exist = true
        }
    }
    
    func initFormatters() {
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.doesRelativeDateFormatting = true
        timeFormatter.dateFormat = "HH.mm"
    }
    
    // MARK: - Set Date Time Logic
    
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
    
    // MARK: - Set Meeting Type Logic
    
    func numberOfTypes() -> Int {
        return typeLogic.numberOfTypes()
    }
    
    func typeName(at indexPath: IndexPath) -> String {
        return typeLogic.getType(at: indexPath).name
    }
    
    func isSelected(at indexPath: IndexPath) -> Bool {
        return typeLogic.getType(at: indexPath).name == selectedType?.name
    }
    
    func selectType(at indexPath: IndexPath) {
        let selected = typeLogic.getType(at: indexPath)
        if exist {
            meetingLogic.setType(for: meeting, with: selected)
            selectedType = selected
        } else {
            if selectedType?.name == selected.name {
                selectedType = nil
            } else {
                selectedType = selected
            }
        }
    }
    
    func addMeetingType(with name: String) {
        typeLogic.addMeetingType(with: name)
    }
    
    func setTypeName(as name: String, at indexPath: IndexPath) {
        typeLogic.setTypeName(as: name, at: indexPath)
    }
    
    func deleteType(at indexPath: IndexPath) {
        if selectedType == typeLogic.getType(at: indexPath) {
            selectedType = nil
        }
        typeLogic.deleteType(at: indexPath)
        meetingLogic.loadMeetings()
    }
    
    // MARK: - Set Participants Logic
    
    func numberOfParticipants() -> Int {
        return participants.count
    }
    
    func addParticipant(with participant: Participant) {
        participants.append(participant)
        if exist {
            meetingLogic.add(participant, for: meeting)
        }
    }
    
    func participant(at indexPath: IndexPath) -> Participant {
        return participants[indexPath.row]
    }
    
    func setParticipantName(as name: String, at indexPath: IndexPath) {
        if exist {
            meetingLogic.rename(participant(at: indexPath), with: name)
        } else {
            participant(at: indexPath).name = name
        }
    }
    
    func participantName(at indexPath: IndexPath) -> String {
        return participant(at: indexPath).name
    }
    
    func deleteParticipant(at indexPath: IndexPath) {
        participants.remove(at: indexPath.row)
        if exist {
            meetingLogic.remove(participant(at: indexPath))
        }
        
    }
    
    func toggleAttendance(at indexPath: IndexPath) {
        let participant = participant(at: indexPath)
        if exist {
            meetingLogic.toggleAttendance(for: participant)
        } else {
            participant.attendance = !participant.attendance
        }
    }
    
    // MARK: - Set Title and Agenda Logic
    
    func setTitle(with title: String) {
        if exist {
            meetingLogic.setTitle(for: meeting, to: title)
        } else {
            meeting.title = title
        }
    }
    
    func saveAgenda(with agenda: String) {
        if exist {
            meetingLogic.setAgenda(for: meeting, to: agenda)
        } else {
            meeting.agenda = agenda
        }
    }
    
    func getAgenda() -> String {
        return meeting.agenda
    }
    
    // MARK: - Finish Minutes Creation
    
    func meetingValidation() -> (Bool, String, String) {
        if meeting.title == "" {
            return (false, "Title is Empty!", "Title can't be empty")
        } else if selectedType == nil {
            return (false, "Type is Empty!", "You must select a type")
        } else if participants.isEmpty {
            return (false, "Participants is Empty!", "You can't have a meeting with no participants")
        } else {
            return (true, "", "")
        }
    }
    
    func finishMeetingCreation() {
        if exist {
            meetingLogic.setTime(start: startDate, end: endDate, meeting: meeting)
        } else {
            meeting.startTime = startDate
            meeting.endTime = endDate
            meetingLogic.save(meeting, participants: participants, type: selectedType!)
        }
    }
    
}
