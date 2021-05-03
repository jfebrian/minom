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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        let vc = Storyboard.ID.AddParticipant as! AddParticipantVC
        vc.logic = logic
        vc.minutesLogic = minutesLogic
        navigationController?.pushViewController(vc, animated: true)
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
        let rows = logic?.numberOfParticipants() ?? 0
        if rows == 0 {
            let screen = UIScreen.main.bounds
            let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height))
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: screen.width * 0.75, height: screen.height))
            label.numberOfLines = 0
            label.center = emptyView.center
            label.textAlignment = .center
            label.font = Font.LexendDeca(24)
            label.textColor = Color.LabelJungle
            label.text = "This meeting has no participants."
            emptyView.addSubview(label)
            tableView.backgroundView = emptyView
        } else {
            tableView.backgroundView = nil
        }
        return rows
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
        self.minutesLogic?.toggleAttendance(at: indexPath) ?? self.logic?.toggleAttendance(at: indexPath)
        tableView.reloadData()
    }

}

// MARK: - Swipe Table View Cell Delegate

extension ParticipantsTableVC: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            let cell = self.tableView.cellForRow(at: indexPath) as! SwipeTableViewCell
            cell.hideSwipe(animated: true) { bool in
                if let minutesLogic = self.minutesLogic {
                    minutesLogic.deleteParticipant(at: indexPath)
                    self.logic?.reloadParticipants()
                } else {
                    self.logic?.deleteParticipant(at: indexPath)
                }
                
                self.tableView.reloadData()
            }
        }
        deleteAction.image = Image.Trash
        
        let editAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            self.alertInput(title: "Edit Participant", at: indexPath)
        }
        editAction.backgroundColor = Color.JungleGreen
        editAction.image = Image.Pencil

        return [deleteAction, editAction]
    }
}
