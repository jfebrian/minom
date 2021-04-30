//
//  MinuteTitleCell.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import UIKit

class MinuteTitleCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
