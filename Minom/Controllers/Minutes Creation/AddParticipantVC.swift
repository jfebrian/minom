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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: SearchTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addButtonPressed))
        setupSuggestions()
    }
    
    func setupSuggestions() {
        var suggestions = [String]()
        for participant in participantLogic.getAllUnique() {
            suggestions.append(participant.name)
        }
        textField.filterStrings(suggestions)
        textField.comparisonOptions = [.caseInsensitive, .diacriticInsensitive]
        textField.theme = .darkTheme()
        textField.theme.font = Font.RobotoLight(16)
        textField.theme.fontColor = Color.LabelJungle
        textField.theme.bgColor = Color.BackgroundSecondary
        textField.theme.cellHeight = 48
        
    }
    
    @objc func addButtonPressed() {
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
}

// MARK: - Table View Data Source

extension AddParticipantVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
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
        
        return cell
    }
}

// MARK: - Table View Delegate

extension AddParticipantVC: UITableViewDelegate {
    
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
}
