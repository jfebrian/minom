//
//  MinuteItem.swift
//  Minom
//
//  Created by Joanda Febrian on 29/04/21.
//

import Foundation
import RealmSwift

class MinuteItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var note: String = ""
    @objc dynamic var meeting: Meeting? {
        LinkingObjects(fromType: Meeting.self, property: "items").first
    }
}
