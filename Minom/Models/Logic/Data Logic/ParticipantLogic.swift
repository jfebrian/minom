//
//  ParticipantLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 01/05/21.
//

import Foundation
import RealmSwift

class ParticipantLogic {
    
    static var standard = ParticipantLogic()
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    // MARK: - Model Manipulation Methods
    
    func save(_ participant: Participant, for meeting: Meeting) {
        do {
            try realm.write {
                realm.add(participant)
                meeting.participants.append(participant)
            }
        } catch {
            print("Error saving participant to Realm, \(error.localizedDescription)")
        }
    }
    
    func save(name: String) {
        do {
            try realm.write {
                let participant = Participant()
                participant.name = name
                realm.add(participant)
            }
        } catch {
            print("Error saving participant to Realm, \(error.localizedDescription)")
        }
    }
    
    func toggleAttendance(_ participant: Participant) {
        do {
            try realm.write {
                participant.attendance = !participant.attendance
            }
        } catch {
            print("Error toggling participant attendance to Realm, \(error.localizedDescription)")
        }
    }
    
    func rename(_ participant: Participant, with name: String) {
        do {
            try realm.write {
                participant.name = name
            }
        } catch {
            print("Error renaming participant to Realm, \(error.localizedDescription)")
        }
    }
    
    func delete(_ participant: Participant) {
        do {
            try realm.write {
                realm.delete(participant)
            }
        } catch {
            print("Error deleting participant from Realm, \(error.localizedDescription)")
        }
    }
    
    func getAllUnique() -> Results<Participant> {
        return realm.objects(Participant.self).distinct(by: ["name"])
    }
}
