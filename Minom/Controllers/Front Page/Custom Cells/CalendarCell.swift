//
//  CalendarCell.swift
//  Minom
//
//  Created by Joanda Febrian on 03/05/21.
//

import UIKit

class CalendarCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selected(false)
    }
    
    func selected(_ selected: Bool) {
        cardView.layer.cornerRadius = 5
        if selected {
            dayLabel.textColor = .white
            dateLabel.textColor = .white
            cardView.backgroundColor = Color.JungleGreen
        } else {
            dayLabel.textColor = Color.LabelGrey
            dateLabel.textColor = Color.MidnightGreen
            cardView.backgroundColor = .clear
        }
    }

}
