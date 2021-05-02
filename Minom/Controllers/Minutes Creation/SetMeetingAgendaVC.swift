//
//  SetMeetingAgendaVC.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import UIKit

class SetMeetingAgendaVC: UIViewController {
    
    var logic: MinutesCreationLogic?
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Meeting Agenda"
        textView.delegate = self
        setupSaveButton()
        setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = logic?.getAgenda()
        textView.becomeFirstResponder()
    }
    
    func setupBackButton() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func cancel() {
        if textView.text != logic?.getAgenda() {
            let alert = UIAlertController(title: nil, message: "Do you want to save your changes?", preferredStyle: .alert)
            let no = UIAlertAction(title: "No", style: .destructive) { action in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(no)
            let save = UIAlertAction(title: "Save", style: .default) { action in
                self.saveAgenda()
            }
            alert.addAction(save)
            present(alert, animated: true, completion: nil)
        }
        navigationController?.popViewController(animated: true)
    }

    func setupSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveAgenda))
    }
    
    @objc func saveAgenda() {
        logic?.saveAgenda(with: textView.text)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Text View Delegate

extension SetMeetingAgendaVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard range.location == 0 else { return true }

        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: .whitespacesAndNewlines).location != 0
    }
}
