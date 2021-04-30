//
//  MinuteItemCell.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import UIKit

class MinuteItemCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCard()
    }
    
    func setupCard() {
        cardView.layer.cornerRadius = 10.0
        cardView.layer.borderWidth = 0.5
        cardView.layer.borderColor = Color.Grey.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
