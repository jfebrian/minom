//
//  MeetingTypeSelectionTableViewController.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import UIKit

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
        let alert = UIAlertController(title: "New Meeting Type", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let add = UIAlertAction(title: "Save", style: .default) { action in
            if let text = alert.textFields?.first?.text, let logic = self.logic {
                logic.addMeetingType(with: text)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        alert.addAction(add)
        alert.addTextField { textField in
            textField.placeholder = "Enter Type Name"
        }
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logic?.numberOfTypes() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return Custom.separator(width: tableView.frame.width)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

