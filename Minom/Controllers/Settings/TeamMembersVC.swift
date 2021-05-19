//
//  TeamMembersVC.swift
//  Minom
//
//  Created by Joanda Febrian on 05/05/21.
//

import UIKit
import SearchTextField
import SwipeCellKit

class TeamMembersVC: UIViewController {
    
    @IBOutlet weak var nameTextField: SearchTextField!
    @IBOutlet weak var tableView: UITableView!
    
    var logic: TeamMembersLogic? // always make it private if not exposed to others
    let participantLogic = ParticipantLogic.standard
    let teamLogic = TeamLogic.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddButton()
        setupSuggestions()
        navigationItem.title = logic?.team?.name // create extention for UINavigationController that taking parameter you need, such as title, bar button item, background color, etc.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }
    
    func setupSuggestions() {
        var suggestions = [String]()
        for participant in participantLogic.getAllUnique() {
            suggestions.append(participant.name)
        }
        suggestions.append(contentsOf: teamLogic.getAllUnique())
        suggestions = suggestions.uniqued()
        
        // put everything related to UI to view, if you have to make a custom UIView then do it. Controller doesn't care what UI should be configured.
        nameTextField.filterStrings(suggestions)
        nameTextField.comparisonOptions = [.caseInsensitive, .diacriticInsensitive]
        nameTextField.theme = .darkTheme()
        nameTextField.theme.font = Font.RobotoLight(16)
        nameTextField.theme.fontColor = Color.LabelJungle
        nameTextField.theme.bgColor = Color.BackgroundSecondary
        nameTextField.theme.cellHeight = 48
        nameTextField.itemSelectionHandler = { suggestion, position in
            let name = suggestion[position].title
            self.nameTextField.text = name
            self.addMember()
        }
    }
    
    
    @objc func addButtonPressed() {
        addMember()
    }
    
    func addMember() {
        if let name = nameTextField.text, name != "" {
            if logic?.exist(name) ?? false {
                let alert = UIAlertController(title: "Member Already Exist!", message: "Members can't have the same name, try adding nicknames to differentiate them.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                logic?.addMember(with: name)
                tableView.reloadData()
                nameTextField.text = ""
            }
        } else {
            let alert = UIAlertController(title: "Name is Empty!", message: "Member name can't be empty", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

// MARK: - Table View Protocols

extension TeamMembersVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = logic?.numberOfMembers() ?? 0
        if rows == 0 {
            // I saw this in more than 1 controller, so create a custom view to return this empty configuration
            let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
            let label = UILabel(frame: CGRect(x: 0, y: 80, width: tableView.bounds.width, height: 80))
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = Font.LexendDeca(22)
            label.textColor = Color.LabelJungle
            label.text = "This team is still empty."
            emptyView.addSubview(label)
            tableView.backgroundView = emptyView
            tableView.separatorStyle = .none
            tableView.isScrollEnabled = false
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            tableView.isScrollEnabled = true
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        let label = UILabel(frame: CGRect(x: 20, y: 14, width: tableView.frame.size.width - 40, height: 20))
        view.backgroundColor = Color.BackgroundSecondary
        label.text = "TEAM MEMBERS"
        label.font = .systemFont(ofSize: 13)
        label.textColor = Color.LabelGrey
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SwipeTableViewCell(style: .default, reuseIdentifier: nil)
        cell.delegate = self
        cell.textLabel?.text = logic?.teamName(at: indexPath)
        cell.textLabel?.textColor = Color.LabelJungle
        cell.textLabel?.font = Font.LexendDeca(17)
        
        return cell
    }
    
}

// MARK: - Text Field Delegate

extension TeamMembersVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            return true
        }
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let field = textField as? SearchTextField {
            if field.filteredResults.count == 0 {
                addMember()
            }
        }
        return false
    }
}

// MARK: - Swipe Table View Cell Delegate

extension TeamMembersVC: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            let cell = self.tableView.cellForRow(at: indexPath) as! SwipeTableViewCell
            cell.hideSwipe(animated: true) { bool in
                self.logic?.delete(at: indexPath)
                self.tableView.reloadData()
            }
        }
        deleteAction.image = Image.Trash
        
        let editAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            let alert = UIAlertController(title: "Rename Member", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            let save = UIAlertAction(title: "Save", style: .default) { action in
                if let text = alert.textFields?.first?.text, text != "" {
                    self.logic?.rename(at: indexPath, with: text)
                    let cell = self.tableView.cellForRow(at: indexPath) as! SwipeTableViewCell
                    cell.hideSwipe(animated: true) { bool in
                        self.tableView.reloadData()
                    }
                }
            }
            alert.addAction(save)
            
            alert.addTextField { textField in
                textField.placeholder = "Enter Member Name"
                textField.text = self.logic?.memberName(at: indexPath)
            }
            self.present(alert, animated: true, completion: nil)

        }
        editAction.backgroundColor = Color.JungleGreen
        editAction.image = Image.Pencil
        
        return [deleteAction, editAction]
    }
}
