//
//  MinuteItem.swift
//  Minom
//
//  Created by Joanda Febrian on 29/04/21.
//

import Foundation
import RealmSwift

class MinuteItem: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var note: String = ""
    @objc dynamic var meeting: Meeting?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
