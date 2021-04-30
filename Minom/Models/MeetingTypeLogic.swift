//
//  UserLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import Foundation
import RealmSwift

class MeetingTypeLogic {
    
    let realm = try! Realm()
    
    var types: Results<MeetingType>?
    
    // MARK: - Model Manipulation Methods
    
    func save(_ name: String) {
        do {
            try realm.write {
                let type = MeetingType()
                type.name = name
                realm.add(type)
            }
        } catch {
            print("Error saving meeting type, \(error.localizedDescription)")
        }
    }
    
    func delete(_ type: MeetingType) {
        do {
            try realm.write {
                realm.delete(type.meetings)
                realm.delete(type)
            }
        } catch {
            print("Error deleting meeting type, \(error.localizedDescription)")
        }
    }
    
    private func loadTypes() -> Results<MeetingType> {
        types = realm.objects(MeetingType.self)
        guard let type = types else { fatalError("Error getting meeting types from Realm") }
        return type
    }
    
    func numberOfTypes() -> Int {
        let types = self.types ?? loadTypes()
        return types.count
    }
    
    func getType(with indexPath: IndexPath) -> MeetingType {
        let types = self.types ?? loadTypes()
        return types[indexPath.row]
    }
    
    func addMeetingType(with name: String) {
        save(name)
        _ = loadTypes()
    }
}
