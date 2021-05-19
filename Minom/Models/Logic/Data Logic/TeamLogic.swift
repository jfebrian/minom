//
//  TeamLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 05/05/21.
//

import Foundation
import RealmSwift

class TeamLogic {
    
    static var standard = TeamLogic() // why you create a singleton for this? Since it's already use class, I don't see necessity to make it as singleton.
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    var teams = [Team]()
    
    init() {
        loadTeams()
    }
    
    // MARK: - Model Manipulation Methods
    
    func save(name: String, people: [String]) {
        do {
            try realm.write {
                let team = Team()
                team.name = name
                for person in people {
                    team.members.append(person)
                }
                realm.add(team)
            }
        } catch {
            print("Error saving team to Realm, \(error.localizedDescription)")
        }
        loadTeams()
    }
    
    func save(team: Team) {
        do {
            try realm.write {
                realm.add(team)
            }
        } catch {
            print("Error saving team to Realm, \(error.localizedDescription)")
        }
        loadTeams()
    }
    
    func append(_ team: Team, with person: String) {
        do {
            try realm.write {
                team.members.insert(person, at: 0)
            }
        } catch {
            print("Error saving team to Realm, \(error.localizedDescription)")
        }
        loadTeams()
    }
    
    func rename(_ team: Team, with name: String) {
        do {
            try realm.write {
                team.name = name
            }
        } catch {
            print("Error renaming team to Realm, \(error.localizedDescription)")
        }
        loadTeams()
    }
    
    func rename(at indexPath: IndexPath, with name: String, in team: Team) {
        do {
            try realm.write {
                team.members[indexPath.row] = name
            }
        } catch {
            print("Error renaming team member to Realm, \(error.localizedDescription)")
        }
        loadTeams()
    }
    
    func delete(_ team: Team) {
        do {
            try realm.write {
                realm.delete(team)
            }
        } catch {
            print("Error deleting team from Realm, \(error.localizedDescription)")
        }
        loadTeams()
    }
    
    func remove(_ index: Int, from team: Team) {
        do {
            try realm.write {
                team.members.remove(at: index)
            }
        } catch {
            print("Error deleting team from Realm, \(error.localizedDescription)")
        }
        loadTeams()
    }
    
    func loadTeams() {
        let fetch = realm.objects(Team.self)
        teams = []
        for team in fetch {
            teams.append(team)
        }
    }
    
    func numberOfTeams() -> Int {
        return teams.count
    }
    
    func teamName(at indexPath: IndexPath) -> String? {
        return teams[indexPath.row].name
    }
    
    func team(at indexPath: IndexPath) -> Team {
        return teams[indexPath.row]
    }
    
    func getAllUnique() -> [String] {
        var allMembers = [String]()
        for team in teams {
            for member in team.members {
                allMembers.append(member)
            }
        }
        return allMembers.uniqued()
    }
    
    func teamMembers(at indexPath: IndexPath) -> [String] {
        var members = [String]()
        for member in team(at: indexPath).members {
            members.append(member)
        }
        return members
    }
}
