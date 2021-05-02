//
//  MeetingItemVC.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import UIKit

class MeetingItemVC: UIViewController {
    
    var minutesLogic: MinutesLogic?
    var minuteItem: MinuteItem?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Minutes Item"
        setupSaveButton()
        setupFields()
    }
    
    func setupFields() {
        if let item = minuteItem {
            titleTextField.text = item.title
            noteTextView.text = item.note
        }
    }
    
    func setupSaveButton() {
        if minuteItem != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveItem))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(newItem))
        }
    }
    
    @objc func saveItem() {
        if let title = titleTextField.text, title != "" {
            if let note = noteTextView.text, note != "" {
                minutesLogic?.saveItem(title: title, note: note, item: minuteItem)
                self.navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: "Notes is Empty!", message: "Are you sure you want to create an empty item?", preferredStyle: .alert)
                let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alert.addAction(no)
                let yes = UIAlertAction(title: "Yes", style: .default) { action in
                    self.minutesLogic?.saveItem(title: title, note: self.noteTextView.text, item: self.minuteItem)
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(yes)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Title is Empty!", message: "Item title can't be empty", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func newItem() {
        if let title = titleTextField.text, title != "" {
            if let note = noteTextView.text, note != "" {
                minutesLogic?.saveItem(title: title, note: note)
                self.navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: "Notes is Empty!", message: "Are you sure you want to create an empty item?", preferredStyle: .alert)
                let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alert.addAction(no)
                let yes = UIAlertAction(title: "Yes", style: .default) { action in
                    self.minutesLogic?.saveItem(title: title, note: self.noteTextView.text)
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(yes)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Title is Empty!", message: "Item title can't be empty", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension MeetingItemVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            return true
        }
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}

extension MeetingItemVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard range.location == 0 else { return true }
        
        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: .whitespacesAndNewlines).location != 0
    }
}