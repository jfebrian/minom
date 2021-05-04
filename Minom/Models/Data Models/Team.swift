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
    
    let names = List<String>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
