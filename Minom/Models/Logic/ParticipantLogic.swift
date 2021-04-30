//
//  ParticipantLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import Foundation
import RealmSwift

class ParticipantLogic {
    
    let realm = try! Realm()
    
    var participants = [Participant]()
    
    func numberOfParticipants() -> Int {
        return participants.count
    }
    
    func addParticipant(with name: String) {
        let participant = Participant()
        participant.name = name
        participants.append(participant)
    }
    
    func participant(with indexPath: IndexPath) -> Participant {
        return participants[indexPath.row]
    }
    
}
