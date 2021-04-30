//
//  Meeting.swift
//  Minom
//
//  Created by Joanda Febrian on 29/04/21.
//

import Foundation
import RealmSwift

class Meeting: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var agenda: String = ""
    @objc dynamic var type: MeetingType? {
        LinkingObjects(fromType: MeetingType.self, property: "items").first
    }
    @objc dynamic var date: Date = Date()
    let items = List<MinuteItem>()
    let participants = List<Participant>()
}
