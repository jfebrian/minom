//
//  MeetingTypeSelectionTableViewController.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import UIKit
import SwipeCellKit

class SetMeetingTypeTableVC: UITableViewController {
    
    var logic: MinutesCreationLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Meeting Type"
        setupAddButton()
        setupTableView()
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
        alertInput(title: "New Meeting Type")
    }
    
    func alertInput(title: String, at indexPath: IndexPath? = nil) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let add = UIAlertAction(title: "Save", style: .default) { action in
            if let text = alert.textFields?.first?.text, let logic = self.logic {
                if let index = indexPath {
                    logic.setTypeName(as: text, at: index)
                    let cell = self.tableView.cellForRow(at: index) as! SwipeTableViewCell
                    cell.hideSwipe(animated: true) { bool in
                        self.tableView.reloadData()
                    }
                } else {
                    logic.addMeetingType(with: text)
                    self.tableView.reloadData()
                }
            }
        }
        alert.addAction(add)
        alert.addTextField { textField in
            textField.placeholder = "Enter Type Name"
            if let index = indexPath, let logic = self.logic {
                textField.text = logic.typeName(at: index)
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = logic?.numberOfTypes() ?? 0
        if rows == 0 {
            let screen = UIScreen.main.bounds
            let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height))
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: screen.width * 0.75, height: screen.height))
            label.numberOfLines = 0
            label.center = emptyView.center
            label.textAlignment = .center
            label.font = Font.LexendDeca(24)
            label.textColor = Color.LabelJungle
            label.text = "You have no meeting types."
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
        guard let logic = self.logic else { fatalError("Error accessing logic when setting types") }
        
        cell.selectionStyle = .none
        cell.backgroundColor = Color.Background
        cell.textLabel?.text = logic.typeName(at: indexPath)
        cell.textLabel?.textColor = Color.LabelJungle
        cell.textLabel?.font = Font.LexendDeca(17)
        cell.accessoryType = logic.isSelected(at: indexPath) ? .checkmark : .none
        cell.tintColor = Color.LabelJungle
        cell.addSubview(Custom.separator(width: tableView.frame.width))
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        logic?.selectType(at: indexPath)
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}

extension SetMeetingTypeTableVC: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            let alert = UIAlertController(title: "Are you sure?", message: "This type will be deleted and all minutes related to this type will have no meeting type.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { action in
                self.logic?.deleteType(at: indexPath)
                self.tableView.reloadData()
            }
            alert.addAction(delete)
            self.present(alert, animated: true, completion: nil)
        }
        deleteAction.image = Image.Trash
        
        let editAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            self.alertInput(title: "Rename Type", at: indexPath)
        }
        editAction.image = Image.Pencil
        
        return [deleteAction, editAction]
    }
}


