//
//  Participant.swift
//  Minom
//
//  Created by Joanda Febrian on 29/04/21.
//

import Foundation
import RealmSwift

class Participant: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var attendance: Bool = false
    @objc dynamic var meeting: Meeting?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}
