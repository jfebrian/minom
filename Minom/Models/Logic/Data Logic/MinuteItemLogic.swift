//
//  MinuteItemLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import Foundation
import RealmSwift

class MinuteItemLogic {
    
    static var standard = MinuteItemLogic() // why you create a singleton for this? Since it's already use class, I don't see necessity to make it as singleton.
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    // MARK: - Model Manipulation Methods
    
    func save(title: String, note: String, meeting: Meeting, item: MinuteItem?) {
        do {
            try realm.write {
                if let minuteItem = item {
                    minuteItem.title = title
                    minuteItem.note = note
                } else {
                    let item = MinuteItem()
                    item.title = title
                    item.note = note
                    item.meeting = meeting
                    realm.add(item)
                    meeting.items.append(item)
                }
            }
        } catch {
            print("Error saving minutes item to Realm, \(error.localizedDescription)")
        }
    }
    
    private func delete(_ item: MinuteItem) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Error deleting minutes item from Realm, \(error.localizedDescription)")
        }
    }
}
