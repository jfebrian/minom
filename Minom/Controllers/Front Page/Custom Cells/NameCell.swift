//
//  NameCell.swift
//  Minom
//
//  Created by Joanda Febrian on 04/05/21.
//

import UIKit

class NameCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.font = Font.LexendDeca(17)
        nameTextField.textColor = Color.LabelJungle
        nameTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension NameCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = nameTextField.text {
            UserDefaults.standard.set(text, forKey: "UserName")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = nameTextField.text {
            UserDefaults.standard.set(text, forKey: "UserName")
        }
        nameTextField.resignFirstResponder()
        return false
    }
}
