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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = logic?.getAgenda()
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logic?.saveAgenda(with: textView.text)
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
