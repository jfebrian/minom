//
//  Meeting.swift
//  Minom
//
//  Created by Joanda Febrian on 29/04/21.
//

import Foundation
import RealmSwift

class Meeting: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var agenda: String = ""
    @objc dynamic var startTime: Date = Date()
    @objc dynamic var endTime: Date = Date()
    @objc dynamic var type: MeetingType?
    @objc dynamic var audioExist: Bool = false
    
    let items = List<MinuteItem>()
    let participants = List<Participant>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
