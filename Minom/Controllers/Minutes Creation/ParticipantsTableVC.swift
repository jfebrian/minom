//
//  SetParticipantsTableViewController.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import UIKit
import SwipeCellKit

class ParticipantsTableVC: UITableViewController {
    
    var logic: MinutesCreationLogic?
    var minutesLogic: MinutesLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Participants"
        setupTableView()
        setupAddButton()
        setupLogic()
    }
    
    func setupLogic() {
        if let minutesLogic = self.minutesLogic {
            logic?.meeting = minutesLogic.meeting
            logic?.participants = minutesLogic.participants
            tableView.reloadData()
        }
    }
    
    // MARK: - Setup User Interface
    
    func setupTableView() {
        tableView.backgroundColor = Color.BackgroundSecondary
        tableView.separatorStyle = .none
    }
    
    func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }
    
    @objc func addButtonPressed() {
        alertInput(title: "New Participant")
    }
    
    func alertInput(title: String, at indexPath: IndexPath? = nil) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let add = UIAlertAction(title: "Save", style: .default) { action in
            if let text = alert.textFields?.first?.text, let logic = self.logic {
                if let index = indexPath {
                    self.minutesLogic?.setParticipantName(as: text, at: index) ?? logic.setParticipantName(as: text, at: index)
                    let cell = self.tableView.cellForRow(at: index) as! SwipeTableViewCell
                    cell.hideSwipe(animated: true) { bool in
                        self.tableView.reloadData()
                    }
                } else {
                    let participant = Participant()
                    participant.name = text
                    logic.addParticipant(with: participant)
                    self.minutesLogic?.addParticipant(with: participant)
                    self.tableView.reloadData()
                }
            }
        }
        
        alert.addAction(add)
        alert.addTextField { textField in
            textField.placeholder = "Enter Participant Name"
            if let index = indexPath, let logic = self.logic {
                textField.text = logic.participant(at: index).name
            }
        }
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logic?.numberOfParticipants() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return Custom.separator(width: tableView.frame.width)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SwipeTableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.delegate = self
        guard let logic = self.logic else { fatalError("Error accessing logic when setting participants") }
        
        cell.selectionStyle = .none
        cell.backgroundColor = Color.Background
        cell.textLabel?.text = logic.participantName(at: indexPath)
        cell.textLabel?.textColor = Color.LabelJungle
        cell.textLabel?.font = Font.LexendDeca(17)
        cell.addSubview(Custom.separator(width: tableView.frame.width))
        cell.tintColor = Color.LabelJungle
        cell.accessoryType = logic.participant(at: indexPath).attendance ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SwipeTableViewCell
        cell.showSwipe(orientation: .right)
    }

}

extension ParticipantsTableVC: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            self.minutesLogic?.deleteParticipant(at: indexPath)
            self.logic?.deleteParticipant(at: indexPath)
        }
        deleteAction.image = Image.Trash
        
        let editAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            self.alertInput(title: "Edit Participant", at: indexPath)
        }
        editAction.backgroundColor = Color.JungleGreen
        editAction.image = Image.Pencil
        
        let checkAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            self.minutesLogic?.toggleAttendance(at: indexPath) ?? self.logic?.toggleAttendance(at: indexPath)
            let cell = self.tableView.cellForRow(at: indexPath) as! SwipeTableViewCell
            cell.hideSwipe(animated: true) { bool in
                self.tableView.reloadData()
            }
            
        }
        checkAction.backgroundColor = Color.LabelJungle
        checkAction.image = Image.Checkmark

        return [deleteAction, editAction, checkAction]
    }
}
