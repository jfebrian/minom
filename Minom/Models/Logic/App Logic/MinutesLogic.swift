//
//  MinutesLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import Foundation
import AVFoundation

class MinutesLogic {
    
    var meeting: Meeting
    var participants = [Participant]()
    let participantLogic = ParticipantLogic.standard
    let itemLogic = MinuteItemLogic.standard
    let meetingLogic = MeetingLogic.standard
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    var fileName: String {
        return meeting.id+".m4a"
    }
    
    var numberOfItems: Int {
        return meeting.items.count
    }
    
    init(for meeting: Meeting) {
        self.meeting = meeting
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateFormat = "d  MMM yy"
        timeFormatter.dateFormat = "HH.mm"
        
        for participant in meeting.participants {
            participants.append(participant)
        }
    }
    
    // MARK: - Meeting Title
    
    var title: String {
        return meeting.title
    }
    
    var type: String {
        return meeting.type?.name ?? "No Meeting Type"
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
    
    // MARK: - Minute Items
    
    func saveItem(title: String, note: String, item: MinuteItem? = nil) {
        itemLogic.save(title: title, note: note, meeting: meeting, item: item)
    }
    
    func item(at indexPath: IndexPath) -> MinuteItem {
        return meeting.items[indexPath.row-1]
    }
    
    func itemTitle(at indexPath: IndexPath) -> String {
        return meeting.items[indexPath.row-1].title
    }
    
    // MARK: - Participants
    
    func participant(at indexPath: IndexPath) -> Participant {
        return participants[indexPath.row]
    }
    
    func addParticipant(with participant: Participant) {
        participants.append(participant)
        participantLogic.save(participant, for: meeting)
    }
    
    func setParticipantName(as name: String, at indexPath: IndexPath) {
        participantLogic.rename(participant(at: indexPath), with: name)
    }
    
    func deleteParticipant(at indexPath: IndexPath) {
        let participant = participant(at: indexPath)
        participants.remove(at: indexPath.row)
        participantLogic.delete(participant)
    }
    
    func toggleAttendance(at indexPath: IndexPath) {
        participantLogic.toggleAttendance(participant(at: indexPath))
    }
    
    func finishRecording() {
        meetingLogic.toggleAudioExist(meeting)
    }
}
