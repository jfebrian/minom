//
//  UserLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import Foundation
import RealmSwift

class MeetingTypeLogic {
    
    static var standard = MeetingTypeLogic()
    
    let realm = try! Realm()
    
    var types: Results<MeetingType>?
    
    init() {
        loadTypes()
    }
    
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
    
    private func loadTypes() {
        types = realm.objects(MeetingType.self)
    }
    
    func numberOfTypes() -> Int {
        guard let types = self.types else { fatalError() }
        return types.count
    }
    
    func getType(at indexPath: IndexPath) -> MeetingType {
        guard let types = self.types else { fatalError() }
        return types[indexPath.row]
    }
    
    func addMeetingType(with name: String) {
        save(name)
        loadTypes()
    }
}
