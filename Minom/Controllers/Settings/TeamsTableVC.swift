//
//  TeamsTableVC.swift
//  Minom
//
//  Created by Joanda Febrian on 04/05/21.
//

import UIKit
import SwipeCellKit

class TeamsTableVC: UITableViewController {
    
    let logic = TeamLogic.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Teams"
        setupAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - User Interface
    
    func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }
    
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "Add New Team", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        let add = UIAlertAction(title: "Add", style: .default) { action in
            if let text = alert.textFields?.first?.text, text != "" {
                let vc = Storyboard.ID.TeamMembers as! TeamMembersVC
                let team = Team()
                team.name = text
                vc.logic = TeamMembersLogic(with: team)
                self.tableView.reloadData()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        alert.addAction(add)
        alert.addTextField { textField in
            textField.placeholder = "Enter Team Name"
        }
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = logic.numberOfTeams()
        if rows == 0 {
            let screen = UIScreen.main.bounds
            let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height))
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: screen.width * 0.75, height: screen.height))
            label.numberOfLines = 0
            label.center = emptyView.center
            label.textAlignment = .center
            label.font = Font.LexendDeca(24)
            label.textColor = Color.LabelJungle
            label.text = "You have no teams."
            emptyView.addSubview(label)
            tableView.backgroundView = emptyView
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return rows

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SwipeTableViewCell(style: .default, reuseIdentifier: nil)
        cell.delegate = self
        cell.textLabel?.text = logic.teamName(at: indexPath)
        cell.textLabel?.textColor = Color.LabelJungle
        cell.textLabel?.font = Font.LexendDeca(17)
        let image = Image.RightChevron
        let disclosureIndicator  = UIImageView(frame:CGRect(x:0, y:0, width: image.size.width, height: image.size.height));
        disclosureIndicator.image = image
        cell.accessoryView = disclosureIndicator
        cell.tintColor = Color.LabelJungle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Storyboard.ID.TeamMembers as! TeamMembersVC
        vc.logic = TeamMembersLogic(at: indexPath)
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - Swipe Table View Cell Delegate

extension TeamsTableVC: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            let cell = self.tableView.cellForRow(at: indexPath) as! SwipeTableViewCell
            cell.hideSwipe(animated: true) { bool in
                let team = self.logic.team(at: indexPath)
                self.logic.delete(team)
                self.tableView.reloadData()
            }

        }
        deleteAction.image = Image.Trash
        
        let editAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            let alert = UIAlertController(title: "Rename Team", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            let save = UIAlertAction(title: "Save", style: .default) { action in
                if let text = alert.textFields?.first?.text, text != "" {
                    let team = self.logic.team(at: indexPath)
                    self.logic.rename(team, with: text)
                    let cell = self.tableView.cellForRow(at: indexPath) as! SwipeTableViewCell
                    cell.hideSwipe(animated: true) { bool in
                        self.tableView.reloadData()
                    }
                }
            }
            alert.addAction(save)
            
            alert.addTextField { textField in
                textField.placeholder = "Enter Team Name"
                textField.text = self.logic.teamName(at: indexPath)
            }
            self.present(alert, animated: true, completion: nil)
        }
        editAction.backgroundColor = Color.JungleGreen
        editAction.image = Image.Pencil

        return [deleteAction, editAction]
    }

}
