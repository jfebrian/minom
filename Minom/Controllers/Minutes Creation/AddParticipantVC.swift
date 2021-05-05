//
//  AddParticipantVC.swift
//  Minom
//
//  Created by Joanda Febrian on 02/05/21.
//

import UIKit
import SearchTextField

class AddParticipantVC: UIViewController {

    var logic: MinutesCreationLogic?
    var minutesLogic: MinutesLogic?
    let participantLogic = ParticipantLogic.standard
    let teamLogic = TeamLogic.standard
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: SearchTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addButtonPressed))
        setupSuggestions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func setupSuggestions() {
        var suggestions = [String]()
        for participant in participantLogic.getAllUnique() {
            suggestions.append(participant.name)
        }
        suggestions.append(contentsOf: teamLogic.getAllUnique())
        suggestions = suggestions.uniqued()
        
        textField.filterStrings(suggestions)
        textField.comparisonOptions = [.caseInsensitive, .diacriticInsensitive]
        textField.theme = .darkTheme()
        textField.theme.font = Font.RobotoLight(16)
        textField.theme.fontColor = Color.LabelJungle
        textField.theme.bgColor = Color.BackgroundSecondary
        textField.theme.cellHeight = 48
        textField.itemSelectionHandler = { name, position in
            self.textField.text = name[position].title
            self.saveAndQuit()
        }
    }
    
    @objc func addButtonPressed() {
        saveAndQuit()
    }
    
    func saveAndQuit() {
        if let text = textField.text, text != "" {
            let participant = Participant()
            participant.name = text
            logic?.addParticipant(with: participant)
            minutesLogic?.addParticipant(with: participant)
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Name is Empty!", message: "Participant name can't be empty", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func saveAndQuit(with members: [String]) {
        for member in members {
            let participant = Participant()
            participant.name = member
            logic?.addParticipant(with: participant)
            minutesLogic?.addParticipant(with: participant)
        }
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Table View Data Source

extension AddParticipantVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = teamLogic.numberOfTeams()
        if rows == 0 {
            let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
            let label = UILabel(frame: CGRect(x: 0, y: 80, width: tableView.bounds.width, height: 80))
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = Font.LexendDeca(22)
            label.textColor = Color.LabelJungle
            label.text = "You haven't made any teams yet."
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
        label.text = "TEAMS"
        label.font = .systemFont(ofSize: 13)
        label.textColor = Color.LabelGrey
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = teamLogic.teamName(at: indexPath)
        cell.textLabel?.textColor = Color.LabelJungle
        cell.textLabel?.font = Font.LexendDeca(17)
        cell.tintColor = Color.LabelJungle
        return cell
    }
}

// MARK: - Table View Delegate

extension AddParticipantVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let members = teamLogic.teamMembers(at: indexPath)
        saveAndQuit(with: members)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Text Field Delegate

extension AddParticipantVC: UITextFieldDelegate {
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
                
                saveAndQuit()
            }
        }
        return true
    }
}
