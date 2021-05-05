//
//  TeamMembersLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 05/05/21.
//

import Foundation

class TeamMembersLogic {
    
    let logic = TeamLogic.standard
    var team: Team?
    
    init(with team: Team) {
        self.team = team
        logic.save(team: self.team!)
    }
    
    init(at indexPath: IndexPath) {
        self.team = logic.team(at: indexPath)
    }
    
    func addMember(with name: String) {
        if let team = self.team {
            logic.append(team, with: name)
        }
    }
    
    func delete(at indexPath: IndexPath) {
        if let team = self.team {
            logic.remove(indexPath.row, from: team)
        }
    }
    
    func numberOfMembers() -> Int {
        return team?.members.count ?? 0
    }
    
    func teamName(at indexPath: IndexPath) -> String? {
        return team?.members[indexPath.row]
    }
    
    func exist(_ name: String) -> Bool {
        if let members = team?.members {
            for member in members {
                if name == member {
                    return true
                }
            }
        }
        return false
    }
    
    func memberName(at indexPath: IndexPath) -> String? {
        return team?.members[indexPath.row]
    }
    
    func rename(at indexPath: IndexPath, with name: String) {
        if let team = self.team {
            logic.rename(at: indexPath, with: name, in: team)
        }
    }
}
