//
//  MeetingType.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import Foundation
import RealmSwift

class MeetingType:Object {
    @objc dynamic var name: String = ""
    let meetings = List<Meeting>()
}
