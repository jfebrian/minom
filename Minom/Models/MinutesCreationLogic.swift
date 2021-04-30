//
//  MinutesCreationLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 29/04/21.
//

import Foundation
class MinutesCreationLogic {
    
    var meeting = Meeting()
    var typeLogic = MeetingTypeLogic()
    var participantLogic = ParticipantLogic()
    
    var startTimeSelected = true

    var startDate = Date()
    var endDate = Date().addingTimeInterval(TimeInterval(30 * 60))
    
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    var selectedType: MeetingType?
    
    
    // MARK: - Init
    
    init() {
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
    
    func typeName(with indexPath: IndexPath) -> String {
        return typeLogic.getType(with: indexPath).name
    }
    
    func isSelected(with indexPath: IndexPath) -> Bool {
        return typeLogic.getType(with: indexPath) == selectedType
    }
    
    func selectType(with indexPath: IndexPath) {
        selectedType = typeLogic.getType(with: indexPath)
    }
    
    func addMeetingType(with name: String) {
        typeLogic.addMeetingType(with: name)
    }
    
    // MARK: - Set Participants Logic
    
    func participantName(with indexPath: IndexPath) -> String {
        return participantLogic.participant(with: indexPath).name
    }
    
    func numberOfParticipants() -> Int {
        return participantLogic.numberOfParticipants()
    }
    
    func addParticipant(with name: String) {
        participantLogic.addParticipant(with: name)
    }
    
    // MARK: - Set Agenda Logic
    
    func saveAgenda(with text: String) {
        meeting.agenda = text
    }
    
    func getAgenda() -> String {
        return meeting.agenda
    }
    
}
