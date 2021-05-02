//
//  User.swift
//  Minom
//
//  Created by Joanda Febrian on 02/05/21.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var id = NSUUID().uuidString
}
