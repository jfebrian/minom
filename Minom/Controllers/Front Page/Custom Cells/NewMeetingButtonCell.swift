//
//  NewMeetingButtonCell.swift
//  Minom
//
//  Created by Joanda Febrian on 03/05/21.
//

import UIKit

class NewMeetingButtonCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    var action: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCard()
    }
    
    func setupCard() {
        cardView.layer.cornerRadius = 10.0
        cardView.layer.borderWidth = 0.5
        cardView.layer.borderColor = Color.Grey.cgColor
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        action?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
