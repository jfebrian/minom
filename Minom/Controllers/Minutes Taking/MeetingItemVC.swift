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
        setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    
    func setupBackButton() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func cancel() {
        if let item = minuteItem {
            if titleTextField.text != item.title || noteTextView.text != item.note {
                let alert = UIAlertController(title: nil, message: "Do you want to save your changes?", preferredStyle: .alert)
                let no = UIAlertAction(title: "No", style: .destructive) { action in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(no)
                let save = UIAlertAction(title: "Save", style: .default) { action in
                    if self.minuteItem != nil {
                        self.saveItem()
                    } else {
                        self.newItem()
                    }
                }
                alert.addAction(save)
                present(alert, animated: true, completion: nil)
            }
        } else if titleTextField.text != "" || (noteTextView.text != "" && noteTextView.textColor != Color.Placeholder) {
            let alert = UIAlertController(title: nil, message: "Do you want to save your changes?", preferredStyle: .alert)
            let no = UIAlertAction(title: "No", style: .destructive) { action in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(no)
            let save = UIAlertAction(title: "Save", style: .default) { action in
                if self.minuteItem != nil {
                    self.saveItem()
                } else {
                    self.newItem()
                }
            }
            alert.addAction(save)
            present(alert, animated: true, completion: nil)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func setupFields() {
        if let item = minuteItem {
            titleTextField.text = item.title
            noteTextView.text = item.note
        } else {
            noteTextView.text = "Type your notes here..."
            noteTextView.textColor = Color.Placeholder
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
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                let Create = UIAlertAction(title: "Create", style: .default) { action in
                    self.minutesLogic?.saveItem(title: title, note: self.noteTextView.text, item: self.minuteItem)
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(Create)
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
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                let create = UIAlertAction(title: "Create", style: .default) { action in
                    self.minutesLogic?.saveItem(title: title, note: self.noteTextView.text)
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(create)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        noteTextView.becomeFirstResponder()
        noteTextView.selectedTextRange = noteTextView.textRange(from: noteTextView.beginningOfDocument, to: noteTextView.beginningOfDocument)
        return false
    }
    
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
        if newString.rangeOfCharacter(from: .whitespacesAndNewlines).location == 0 {
            return false
        } else {
            let currentText:String = textView.text
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
            
            if updatedText.isEmpty {
                
                textView.text = "Type your notes here..."
                textView.textColor = Color.Placeholder
                
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            } else if textView.textColor == Color.Placeholder && !text.isEmpty {
                textView.textColor = Color.LabelJungle
                textView.text = text
            } else {
                return true
            }
            return false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == Color.Placeholder {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == Color.Placeholder {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
