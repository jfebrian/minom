//
//  Team.swift
//  Minom
//
//  Created by Joanda Febrian on 03/05/21.
//

import Foundation
import RealmSwift

class Team: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var name: String = ""
    let members = List<String>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
