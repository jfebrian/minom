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
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    var types: Results<MeetingType>?
    
    init() {
        loadTypes()
    }
    
    // MARK: - Model Manipulation Methods
    
    private func save(_ name: String) {
        do {
            try realm.write {
                let type = MeetingType()
                type.name = name
                realm.add(type)
            }
        } catch {
            print("Error saving meeting type to Realm, \(error.localizedDescription)")
        }
    }
    
    private func delete(_ type: MeetingType) {
        do {
            try realm.write {
                let meetings = realm.objects(Meeting.self)
                for meeting in meetings {
                    if meeting.type == type {
                        meeting.type = nil
                    }
                }
                realm.delete(type)
            }
        } catch {
            print("Error deleting meeting type from Realm, \(error.localizedDescription)")
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
    
    func setTypeName(as name: String, at indexPath: IndexPath) {
        do {
            try realm.write {
                getType(at: indexPath).name = name
            }
        } catch {
            print("Error renaming meeting type, \(error.localizedDescription)")
        }
    }
    
    func deleteType(at indexPath: IndexPath) {
        delete(getType(at: indexPath))
    }
}
